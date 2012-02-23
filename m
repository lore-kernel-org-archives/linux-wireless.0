Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab2BWKQS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 05:16:18 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/6] iwlwifi: cleanup/fix memory barriers
Date: Thu, 23 Feb 2012 11:16:05 +0100
Message-Id: <1329992168-19990-3-git-send-email-sgruszka@redhat.com> (sfid-20120223_111622_464410_98E63752)
In-Reply-To: <1329992168-19990-1-git-send-email-sgruszka@redhat.com>
References: <1329992168-19990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    1 -
 drivers/net/wireless/iwlwifi/iwl-io.c            |   12 +++++++-----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    1 -
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 925fb71..ad8dfb9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -336,7 +336,6 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 
 	/* Set starting address; reads will auto-increment */
 	iwl_write32(trans(priv), HBUS_TARG_MEM_RADDR, ptr);
-	rmb();
 
 	/*
 	 * Refuse to read more than would have fit into the log from
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 829531a..493c434 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -136,6 +136,13 @@ void iwl_release_nic_access(struct iwl_trans *trans)
 	lockdep_assert_held(&trans->reg_lock);
 	__iwl_clear_bit(trans, CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	/*
+	 * In above we are reading CSR_GP_CNTRL register, what will flush any
+	 * previous writes, but still want write, which clear MAC_ACCESS_REQ
+	 * bit, be performed on PCI bus before any other writes scheduled on
+	 * different CPUs (after we drop reg_lock).
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
 
@@ -269,7 +274,6 @@ void _iwl_read_targ_mem_words(struct iwl_trans *trans, u32 addr,
 	spin_lock_irqsave(&trans->reg_lock, flags);
 	if (likely(iwl_grab_nic_access(trans))) {
 		iwl_write32(trans, HBUS_TARG_MEM_RADDR, addr);
-		rmb();
 		for (offs = 0; offs < words; offs++)
 			vals[offs] = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
 		iwl_release_nic_access(trans);
@@ -296,8 +300,6 @@ int _iwl_write_targ_mem_words(struct iwl_trans *trans, u32 addr,
 	spin_lock_irqsave(&trans->reg_lock, flags);
 	if (likely(iwl_grab_nic_access(trans))) {
 		iwl_write32(trans, HBUS_TARG_MEM_WADDR, addr);
-		wmb();
-
 		for (offs = 0; offs < words; offs++)
 			iwl_write32(trans, HBUS_TARG_MEM_WDAT, vals[offs]);
 		iwl_release_nic_access(trans);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index ea60584..a38a5b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -751,7 +751,6 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 
 	/* Set starting address; reads will auto-increment */
 	iwl_write32(trans, HBUS_TARG_MEM_RADDR, ptr);
-	rmb();
 
 	/* "time" is actually "data" for mode 0 (no timestamp).
 	* place event id # at far right for easier visual parsing. */
-- 
1.7.1

