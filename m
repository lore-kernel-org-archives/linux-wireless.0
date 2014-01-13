Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:50261 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaAMUWL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:11 -0500
Received: by mail-ee0-f53.google.com with SMTP id t10so415274eei.26
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:10 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/18] iwlwifi: pcie: enable oscillator for L1 exit
Date: Mon, 13 Jan 2014 22:21:45 +0200
Message-Id: <1389644517-22807-6-git-send-email-egrumbach@gmail.com> (sfid-20140113_213436_915365_61AF30D1)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Enabling the oscillator consumes slightly more power (100uA)
but allows to make sure that we exit from L1 on time.

Not doing so might lead to a PCIe specification violation
since we might wake up from L1 at the wrong time.
This issue has been identified on 3160 and 7260 only.
On older NICs L1 off is not enabled, on newer NICs (7265),
the issue is fixed.

When the bug occurs the user sees that the NIC has
disappeared from the PCI bridge, any access to the device
returns 0xff.

This fixes:
	https://bugzilla.kernel.org/show_bug.cgi?id=64541

and has been extensively discussed here:
	http://markmail.org/thread/mfmpzqt3r333n4bo

Cc: stable@vger.kernel.org [3.10+]
Fixes: 99cd47142399 ("iwlwifi: add 7000 series device configuration")
Reported-and-tested-by: wzyboy <wzyboy@wzyboy.org>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h   |    4 ++++
 drivers/net/wireless/iwlwifi/pcie/trans.c |   22 ++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index d69b0fb..100bd0d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -277,4 +277,8 @@ static inline unsigned int SCD_QUEUE_STATUS_BITS(unsigned int chnl)
 
 /*********************** END TX SCHEDULER *************************************/
 
+/* Oscillator clock */
+#define OSC_CLK				(0xa04068)
+#define OSC_CLK_FORCE_CONTROL		(0x8)
+
 #endif				/* __iwl_prph_h__ */
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 16f66c1..f950780 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -178,6 +178,28 @@ static int iwl_pcie_apm_init(struct iwl_trans *trans)
 		goto out;
 	}
 
+	if (trans->cfg->host_interrupt_operation_mode) {
+		/*
+		 * This is a bit of an abuse - This is needed for 7260 / 3160
+		 * only check host_interrupt_operation_mode even if this is
+		 * not related to host_interrupt_operation_mode.
+		 *
+		 * Enable the oscillator to count wake up time for L1 exit. This
+		 * consumes slightly more power (100uA) - but allows to be sure
+		 * that we wake up from L1 on time.
+		 *
+		 * This looks weird: read twice the same register, discard the
+		 * value, set a bit, and yet again, read that same register
+		 * just to discard the value. But that's the way the hardware
+		 * seems to like it.
+		 */
+		iwl_read_prph(trans, OSC_CLK);
+		iwl_read_prph(trans, OSC_CLK);
+		iwl_set_bits_prph(trans, OSC_CLK, OSC_CLK_FORCE_CONTROL);
+		iwl_read_prph(trans, OSC_CLK);
+		iwl_read_prph(trans, OSC_CLK);
+	}
+
 	/*
 	 * Enable DMA clock and wait for it to stabilize.
 	 *
-- 
1.7.9.5

