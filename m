Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56725 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab2DWVXD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:23:03 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	stable@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.4] iwlwifi: fix hardware queue programming
Date: Mon, 23 Apr 2012 14:17:50 -0700
Message-Id: <1335215870-9898-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_232308_557959_A6FB7238)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Newer devices have 20 (5000 series) or 30 (6000 series)
hardware queues, rather than the 16 that 4965 had. This
was added to the driver a long time ago, but improperly:
the queue registers for the higher queues aren't just
continuations of the registers for the first 16 queues,
they are in other places. Therefore, the hardware would
lock up when trying to activate queue 16 or above and
the device would have to be restarted.

Thanks goes to Emmanuel who identified this and told me
how the queue programming should be done.

Note that we don't use queues 20 and higher today and
doing so needs more work than this.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch will be also available from wireless branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-fh.h   |   22 ++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-prph.h |   27 ++++++++++++++++++++++++---
 2 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 9020809..74bce97 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -104,15 +104,29 @@
  * (see struct iwl_tfd_frame).  These 16 pointer registers are offset by 0x04
  * bytes from one another.  Each TFD circular buffer in DRAM must be 256-byte
  * aligned (address bits 0-7 must be 0).
+ * Later devices have 20 (5000 series) or 30 (higher) queues, but the registers
+ * for them are in different places.
  *
  * Bit fields in each pointer register:
  *  27-0: TFD CB physical base address [35:8], must be 256-byte aligned
  */
-#define FH_MEM_CBBC_LOWER_BOUND          (FH_MEM_LOWER_BOUND + 0x9D0)
-#define FH_MEM_CBBC_UPPER_BOUND          (FH_MEM_LOWER_BOUND + 0xA10)
-
-/* Find TFD CB base pointer for given queue (range 0-15). */
-#define FH_MEM_CBBC_QUEUE(x)  (FH_MEM_CBBC_LOWER_BOUND + (x) * 0x4)
+#define FH_MEM_CBBC_0_15_LOWER_BOUND		(FH_MEM_LOWER_BOUND + 0x9D0)
+#define FH_MEM_CBBC_0_15_UPPER_BOUND		(FH_MEM_LOWER_BOUND + 0xA10)
+#define FH_MEM_CBBC_16_19_LOWER_BOUND		(FH_MEM_LOWER_BOUND + 0xBF0)
+#define FH_MEM_CBBC_16_19_UPPER_BOUND		(FH_MEM_LOWER_BOUND + 0xC00)
+#define FH_MEM_CBBC_20_31_LOWER_BOUND		(FH_MEM_LOWER_BOUND + 0xB20)
+#define FH_MEM_CBBC_20_31_UPPER_BOUND		(FH_MEM_LOWER_BOUND + 0xB80)
+
+/* Find TFD CB base pointer for given queue */
+static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
+{
+	if (chnl < 16)
+		return FH_MEM_CBBC_0_15_LOWER_BOUND + 4 * chnl;
+	if (chnl < 20)
+		return FH_MEM_CBBC_16_19_LOWER_BOUND + 4 * (chnl - 16);
+	WARN_ON_ONCE(chnl >= 32);
+	return FH_MEM_CBBC_20_31_LOWER_BOUND + 4 * (chnl - 20);
+}
 
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 75dc20b..3b10692 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -223,12 +223,33 @@
 #define SCD_AIT			(SCD_BASE + 0x0c)
 #define SCD_TXFACT		(SCD_BASE + 0x10)
 #define SCD_ACTIVE		(SCD_BASE + 0x14)
-#define SCD_QUEUE_WRPTR(x)	(SCD_BASE + 0x18 + (x) * 4)
-#define SCD_QUEUE_RDPTR(x)	(SCD_BASE + 0x68 + (x) * 4)
 #define SCD_QUEUECHAIN_SEL	(SCD_BASE + 0xe8)
 #define SCD_AGGR_SEL		(SCD_BASE + 0x248)
 #define SCD_INTERRUPT_MASK	(SCD_BASE + 0x108)
-#define SCD_QUEUE_STATUS_BITS(x)	(SCD_BASE + 0x10c + (x) * 4)
+
+static inline unsigned int SCD_QUEUE_WRPTR(unsigned int chnl)
+{
+	if (chnl < 20)
+		return SCD_BASE + 0x18 + chnl * 4;
+	WARN_ON_ONCE(chnl >= 32);
+	return SCD_BASE + 0x284 + (chnl - 20) * 4;
+}
+
+static inline unsigned int SCD_QUEUE_RDPTR(unsigned int chnl)
+{
+	if (chnl < 20)
+		return SCD_BASE + 0x68 + chnl * 4;
+	WARN_ON_ONCE(chnl >= 32);
+	return SCD_BASE + 0x2B4 + (chnl - 20) * 4;
+}
+
+static inline unsigned int SCD_QUEUE_STATUS_BITS(unsigned int chnl)
+{
+	if (chnl < 20)
+		return SCD_BASE + 0x10c + chnl * 4;
+	WARN_ON_ONCE(chnl >= 32);
+	return SCD_BASE + 0x384 + (chnl - 20) * 4;
+}
 
 /*********************** END TX SCHEDULER *************************************/
 
-- 
1.7.0.4

