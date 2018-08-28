Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44258 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbeH1I0p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 04:26:45 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 1/2] ath10k: Introduce CE_ATTR_POLL attribute for polling pipe
Date: Tue, 28 Aug 2018 10:06:41 +0530
Message-Id: <20180828043642.14890-2-govinds@codeaurora.org> (sfid-20180828_063707_046771_3048A67D)
In-Reply-To: <20180828043642.14890-1-govinds@codeaurora.org>
References: <20180828043642.14890-1-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Existing copy engine interrupt enable logic assumes that last
CE is using polling mode and due to this interrupt for last copy engine
are always disabled. WCN3990 uses last CE for pktlog and
interrupt remains disabled with existing logic.

To mitigate this issue, introduce CE_ATTR_POLL flag and control
the interrupt based on the flag which can be set in ce_attr.

Testing:
    Tested on WCN3990 and QCA6174 HW.
    Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1,
               WLAN.RM.4.4.1-00109-QCARMSWPZ-1

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/ce.c  | 18 ++++++++++++++----
 drivers/net/wireless/ath/ath10k/ce.h  | 11 +++++++----
 drivers/net/wireless/ath/ath10k/pci.c |  2 +-
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 18c709c484e7..77bff557ef0d 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1280,10 +1280,17 @@ static void ath10k_ce_per_engine_handler_adjust(struct ath10k_ce_pipe *ce_state)
 
 int ath10k_ce_disable_interrupts(struct ath10k *ar)
 {
+	struct ath10k_ce *ce = ath10k_ce_priv(ar);
+	struct ath10k_ce_pipe *ce_state;
+	u32 ctrl_addr;
 	int ce_id;
 
 	for (ce_id = 0; ce_id < CE_COUNT; ce_id++) {
-		u32 ctrl_addr = ath10k_ce_base_address(ar, ce_id);
+		ce_state  = &ce->ce_states[ce_id];
+		if (ce_state->attr_flags & CE_ATTR_POLL)
+			continue;
+
+		ctrl_addr = ath10k_ce_base_address(ar, ce_id);
 
 		ath10k_ce_copy_complete_intr_disable(ar, ctrl_addr);
 		ath10k_ce_error_intr_disable(ar, ctrl_addr);
@@ -1300,11 +1307,14 @@ void ath10k_ce_enable_interrupts(struct ath10k *ar)
 	int ce_id;
 	struct ath10k_ce_pipe *ce_state;
 
-	/* Skip the last copy engine, CE7 the diagnostic window, as that
-	 * uses polling and isn't initialized for interrupts.
+	/* Enable interrupts for copy engine that
+	 * are not using polling mode.
 	 */
-	for (ce_id = 0; ce_id < CE_COUNT - 1; ce_id++) {
+	for (ce_id = 0; ce_id < CE_COUNT; ce_id++) {
 		ce_state  = &ce->ce_states[ce_id];
+		if (ce_state->attr_flags & CE_ATTR_POLL)
+			continue;
+
 		ath10k_ce_per_engine_handler_adjust(ce_state);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index b8fb5382dede..ead9987c3259 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -275,16 +275,19 @@ void ath10k_ce_free_rri(struct ath10k *ar);
 
 /* ce_attr.flags values */
 /* Use NonSnooping PCIe accesses? */
-#define CE_ATTR_NO_SNOOP		1
+#define CE_ATTR_NO_SNOOP		BIT(0)
 
 /* Byte swap data words */
-#define CE_ATTR_BYTE_SWAP_DATA		2
+#define CE_ATTR_BYTE_SWAP_DATA		BIT(1)
 
 /* Swizzle descriptors? */
-#define CE_ATTR_SWIZZLE_DESCRIPTORS	4
+#define CE_ATTR_SWIZZLE_DESCRIPTORS	BIT(2)
 
 /* no interrupt on copy completion */
-#define CE_ATTR_DIS_INTR		8
+#define CE_ATTR_DIS_INTR		BIT(3)
+
+/* no interrupt, only polling */
+#define CE_ATTR_POLL			BIT(4)
 
 /* Attributes of an instance of a Copy Engine */
 struct ce_attr {
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index af2cf55c4c1e..62fb16a4fa63 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -192,7 +192,7 @@ static struct ce_attr host_ce_config_wlan[] = {
 
 	/* CE7: ce_diag, the Diagnostic Window */
 	{
-		.flags = CE_ATTR_FLAGS,
+		.flags = CE_ATTR_FLAGS | CE_ATTR_POLL,
 		.src_nentries = 2,
 		.src_sz_max = DIAG_TRANSFER_LIMIT,
 		.dest_nentries = 2,
-- 
2.17.0
