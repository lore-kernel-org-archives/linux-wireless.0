Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:1558 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYLAMLo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 07:11:44 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1273215nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 04:11:42 -0800 (PST)
To: linux-wireless@vger.kernel.org
Subject: iwlwifi - rfkill only works if the interface is up
Date: Mon, 1 Dec 2008 13:11:17 +0100
Cc: tomas.winkler@intel.com, yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812011311.17346.helmut.schaa@gmail.com> (sfid-20081201_131150_825506_52088550)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Since the patch "iwlwifi: delay firmware loading from pci_probe to network
interface open" was merged, the driver's killswitch does not work anymore
when the interface is down. The patch comment contains two arguments for 
that behaviour:

1) ... Because kernel initializes network devices subsystem before hard disk
and SATA subsystem, it is impossible to get the firmware image from hard disk
in the PCI probe handler. ...

2) For better power saving ...

The current driver behavior is as follows:

- iwl_pci_probe initializes the driver but disables the device, at this point
  changing the killswitch state will not be noticed by the driver and thus
  the killswitch state in sysfs will not reflect the real state

- iwl_mac_start (which is called when at least one interface goes up) starts
  the device and loads the firmware if the killswitch is disabled. Otherwise
  the driver will just enable the interrupts and allows the interface to go
  up.

However, if the device fires the interrupt CSR_INT_BIT_RF_KILL the code in
iwl_irq_tasklet will _not_ restart the card, although the driver already
allowed the interface to go up. That should easily be fixable with a patch
similar to the following (the comment should be changed too):

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b935e9d..e2f160b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1504,8 +1504,11 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		 * the driver as well won't allow loading if RFKILL is set
 		 * therefore no need to restart the driver from this handler
 		 */
-		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status))
+		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status)) {
 			clear_bit(STATUS_RF_KILL_HW, &priv->status);
+			if (priv->is_open)
+				queue_work(priv->workqueue, &priv->restart);
+		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
 	}

Nevertheless, I'm wondering if the current behaviour (even with the patch above)
makes much sense. I mean, the user space cannot rely on the rfkill state
unless an appropriate interface is up. As the device is able to report the
killswitch state without firmware being loaded the following approach could
be feasible:

- iwl_pci_probe enables the device and enables the interrupts
- iwl_mac_start just loads the firmware
- iwl_mac_stop just releases the firmware but leaves the interrupts enabled

Thanks,
Helmut
