Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:62121 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbYKMHGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 02:06:44 -0500
Subject: Re: iwlagn driver segfault in 2.6.28-rc3
From: reinette chatre <reinette.chatre@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20081111143410.GA4401@ics.muni.cz>
References: <20081111143410.GA4401@ics.muni.cz>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 23:07:21 -0800
Message-Id: <1226560041.1115.945.camel@rc-desk> (sfid-20081113_080649_263056_E7E9C463)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-11-11 at 06:34 -0800, Lukas Hejtmanek wrote:
> Hello,
> 
> I accidentaly got the following oops:
> 
> [54644.622141] wlan0: association with AP 00:13:80:43:9d:d0 timed out
> [54655.006025] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [54655.006444] iwlagn 0000:03:00.0: irq 40 for MSI/MSI-X
> [54655.006715] general protection fault: 0000 [#1] SMP 
> [54655.006723] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.1/host3/target3:0:0/3:0:0:0/block/sr0/stat
> [54655.006728] Dumping ftrace buffer:
> [54655.006733]    (ftrace buffer empty)
> [54655.006737] CPU 0 
> [54655.006740] Modules linked in: aes_x86_64 aes_generic arc4 ecb iwlagn iwlcore mac80211 cfg80211 i915 drm rfcomm bri
> dge stp llc bnep sco l2cap tp_smapi thinkpad_ec btusb bluetooth fuse thinkpad_acpi rfkill e1000e wmi intel_agp snd_hda_intel [last unloaded: ehci_hcd]
> [54655.006785] Pid: 13515, comm: wpa_supplicant Not tainted 2.6.28-rc3 #27
> [54655.006789] RIP: 0010:[<ffffffffa0149db7>]  [<ffffffffa0149db7>] iwl_eeprom_query16+0x7/0x20 [iwlcore]
> 

I do not know why the eeprom will not be available at this point. Could you please try the patch below and let us know if you hit the error?

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index db31a52..307b77e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2585,6 +2585,10 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 
 	IWL_DEBUG_MAC80211("enter\n");
 
+	if (!priv->eeprom) {
+		IWL_ERROR("EEPROM not initialized.\n");
+		return -EIO;
+	}
 	if (pci_enable_device(priv->pci_dev)) {
 		IWL_ERROR("Fail to pci_enable_device\n");
 		return -ENODEV;


