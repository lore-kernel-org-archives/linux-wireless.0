Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48759 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758076Ab2CGTGd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:33 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 16/35] iwlwifi: cleanup/fix memory barriers
Date: Wed,  7 Mar 2012 09:52:25 -0800
Message-Id: <1331142764-5750-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200725_551426_FAE94BA1)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>

wmb(), rmb() are not needed when writel(), readl() are used as
accessors for MMIO. We use them indirectly via iowrite32(),
ioread32().

What is needed mmiowb(), for synchronizing writes coming from
different CPUs on PCIe bridge (see in patch comments). This
fortunately is not needed on x86, where mmiowb() is just
defined as compiler barrier. As iwlwifi devices are most likely
not used on anything other than x86, this is not so important
fix.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    1 -
 drivers/net/wireless/iwlwifi/iwl-io.c            |   12 +++++++-----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    1 -
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ce9ebeb..64bc285 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -334,7 +334,6 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 
 	/* Set starting address; reads will auto-increment */
 	iwl_write32(trans(priv), HBUS_TARG_MEM_RADDR, ptr);
-	rmb();
 
 	/*
 	 * Refuse to read more than would have fit into the log from
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index fa69845..081dd34 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -136,6 +136,13 @@ void iwl_release_nic_access(struct iwl_trans *trans)
 	lockdep_assert_held(&trans->reg_lock);
 	__iwl_clear_bit(trans, CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	/*
+	 * Above we read the CSR_GP_CNTRL register, which will flush
+	 * any previous writes, but we need the write that clears the
+	 * MAC_ACCESS_REQ bit to be performed before any other writes
+	 * scheduled on different CPUs (after we drop reg_lock).
+	 */
+	mmiowb();
 }
 
 u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg)
@@ -182,7 +189,6 @@ int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
 static inline u32 __iwl_read_prph(struct iwl_trans *trans, u32 reg)
 {
 	iwl_write32(trans, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
-	rmb();
 	return iwl_read32(trans, HBUS_TARG_PRPH_RDAT);
 }
 
@@ -190,7 +196,6 @@ static inline void __iwl_write_prph(struct iwl_trans *trans, u32 addr, u32 val)
 {
 	iwl_write32(trans, HBUS_TARG_PRPH_WADDR,
 		    ((addr & 0x0000FFFF) | (3 << 24)));
-	wmb();
 	iwl_write32(trans, HBUS_TARG_PRPH_WDAT, val);
 }
 
@@ -270,7 +275,6 @@ void _iwl_read_targ_mem_words(struct iwl_trans *trans, u32 addr,
 	spin_lock_irqsave(&trans->reg_lock, flags);
 	if (likely(iwl_grab_nic_access(trans))) {
 		iwl_write32(trans, HBUS_TARG_MEM_RADDR, addr);
-		rmb();
 		for (offs = 0; offs < words; offs++)
 			vals[offs] = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
 		iwl_release_nic_access(trans);
@@ -297,8 +301,6 @@ int _iwl_write_targ_mem_words(struct iwl_trans *trans, u32 addr,
 	spin_lock_irqsave(&trans->reg_lock, flags);
 	if (likely(iwl_grab_nic_access(trans))) {
 		iwl_write32(trans, HBUS_TARG_MEM_WADDR, addr);
-		wmb();
-
 		for (offs = 0; offs < words; offs++)
 			iwl_write32(trans, HBUS_TARG_MEM_WDAT, vals[offs]);
 		iwl_release_nic_access(trans);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 25e2f93..5b2e47a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -750,7 +750,6 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 
 	/* Set starting address; reads will auto-increment */
 	iwl_write32(trans, HBUS_TARG_MEM_RADDR, ptr);
-	rmb();
 
 	/* "time" is actually "data" for mode 0 (no timestamp).
 	* place event id # at far right for easier visual parsing. */
-- 
1.7.0.4

