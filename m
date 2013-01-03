Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3ACOti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:49:38 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/12] iwlwifi: always check that grab_nic_access succeeds
Date: Thu,  3 Jan 2013 15:46:16 +0100
Message-Id: <1357224376-27803-12-git-send-email-johannes@sipsolutions.net> (sfid-20130103_154941_873927_38294A08)
In-Reply-To: <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
References: <1357224324.9741.20.camel@jlt4.sipsolutions.net>
 <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This allows to let sparse check that the NIC access is
always released.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c   |  4 +--
 drivers/net/wireless/iwlwifi/dvm/tt.c     |  2 +-
 drivers/net/wireless/iwlwifi/iwl-io.c     | 28 +++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-test.c   | 44 ++++++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-trans.h  | 12 ++++-----
 drivers/net/wireless/iwlwifi/pcie/trans.c |  4 +--
 6 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 517d7ae..a64f361 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -354,7 +354,7 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 
 	/* Make sure device is powered up for SRAM reads */
 	spin_lock_irqsave(&priv->trans->reg_lock, reg_flags);
-	if (unlikely(!iwl_trans_grab_nic_access(priv->trans, false))) {
+	if (!iwl_trans_grab_nic_access(priv->trans, false)) {
 		spin_unlock_irqrestore(&priv->trans->reg_lock, reg_flags);
 		return;
 	}
@@ -1718,7 +1718,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 
 	/* Make sure device is powered up for SRAM reads */
 	spin_lock_irqsave(&trans->reg_lock, reg_flags);
-	if (unlikely(!iwl_trans_grab_nic_access(trans, false)))
+	if (!iwl_trans_grab_nic_access(trans, false))
 		goto out_unlock;
 
 	/* Set starting address; reads will auto-increment */
diff --git a/drivers/net/wireless/iwlwifi/dvm/tt.c b/drivers/net/wireless/iwlwifi/dvm/tt.c
index a8ae513..b28cfc8 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tt.c
@@ -186,7 +186,7 @@ static void iwl_tt_check_exit_ct_kill(unsigned long data)
 		}
 		iwl_read32(priv->trans, CSR_UCODE_DRV_GP1);
 		spin_lock_irqsave(&priv->trans->reg_lock, flags);
-		if (likely(iwl_trans_grab_nic_access(priv->trans, false)))
+		if (iwl_trans_grab_nic_access(priv->trans, false))
 			iwl_trans_release_nic_access(priv->trans);
 		spin_unlock_irqrestore(&priv->trans->reg_lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 2bd84ad..bff3ac9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -101,13 +101,14 @@ EXPORT_SYMBOL_GPL(iwl_poll_bit);
 
 u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg)
 {
-	u32 value;
+	u32 value = 0x5a5a5a5a;
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	iwl_trans_grab_nic_access(trans, false);
-	value = iwl_read32(trans, reg);
-	iwl_trans_release_nic_access(trans);
+	if (iwl_trans_grab_nic_access(trans, false)) {
+		value = iwl_read32(trans, reg);
+		iwl_trans_release_nic_access(trans);
+	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 
 	return value;
@@ -119,7 +120,7 @@ void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_trans_grab_nic_access(trans, false))) {
+	if (iwl_trans_grab_nic_access(trans, false)) {
 		iwl_write32(trans, reg, value);
 		iwl_trans_release_nic_access(trans);
 	}
@@ -159,12 +160,13 @@ static inline void __iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs)
 {
 	unsigned long flags;
-	u32 val;
+	u32 val = 0x5a5a5a5a;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	iwl_trans_grab_nic_access(trans, false);
-	val = __iwl_read_prph(trans, ofs);
-	iwl_trans_release_nic_access(trans);
+	if (iwl_trans_grab_nic_access(trans, false)) {
+		val = __iwl_read_prph(trans, ofs);
+		iwl_trans_release_nic_access(trans);
+	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 	return val;
 }
@@ -175,7 +177,7 @@ void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_trans_grab_nic_access(trans, false))) {
+	if (iwl_trans_grab_nic_access(trans, false)) {
 		__iwl_write_prph(trans, ofs, val);
 		iwl_trans_release_nic_access(trans);
 	}
@@ -188,7 +190,7 @@ void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_trans_grab_nic_access(trans, false))) {
+	if (iwl_trans_grab_nic_access(trans, false)) {
 		__iwl_write_prph(trans, ofs,
 				 __iwl_read_prph(trans, ofs) | mask);
 		iwl_trans_release_nic_access(trans);
@@ -203,7 +205,7 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_trans_grab_nic_access(trans, false))) {
+	if (iwl_trans_grab_nic_access(trans, false)) {
 		__iwl_write_prph(trans, ofs,
 				 (__iwl_read_prph(trans, ofs) & mask) | bits);
 		iwl_trans_release_nic_access(trans);
@@ -218,7 +220,7 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 	u32 val;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_trans_grab_nic_access(trans, false))) {
+	if (iwl_trans_grab_nic_access(trans, false)) {
 		val = __iwl_read_prph(trans, ofs);
 		__iwl_write_prph(trans, ofs, (val & ~mask));
 		iwl_trans_release_nic_access(trans);
diff --git a/drivers/net/wireless/iwlwifi/iwl-test.c b/drivers/net/wireless/iwlwifi/iwl-test.c
index f8d8df8..1a22611 100644
--- a/drivers/net/wireless/iwlwifi/iwl-test.c
+++ b/drivers/net/wireless/iwlwifi/iwl-test.c
@@ -467,7 +467,10 @@ static int iwl_test_indirect_read(struct iwl_test *tst, u32 addr, u32 size)
 	if (IWL_ABS_PRPH_START <= addr &&
 	    addr < IWL_ABS_PRPH_START + PRPH_END) {
 			spin_lock_irqsave(&trans->reg_lock, flags);
-			iwl_trans_grab_nic_access(trans, false);
+			if (!iwl_trans_grab_nic_access(trans, false)) {
+				spin_unlock_irqrestore(&trans->reg_lock, flags);
+				return -EIO;
+			}
 			iwl_write32(trans, HBUS_TARG_PRPH_RADDR,
 				    addr | (3 << 24));
 			for (i = 0; i < size; i += 4)
@@ -500,26 +503,29 @@ static int iwl_test_indirect_write(struct iwl_test *tst, u32 addr,
 
 	if (IWL_ABS_PRPH_START <= addr &&
 	    addr < IWL_ABS_PRPH_START + PRPH_END) {
-			/* Periphery writes can be 1-3 bytes long, or DWORDs */
-			if (size < 4) {
-				memcpy(&val, buf, size);
-				spin_lock_irqsave(&trans->reg_lock, flags);
-				iwl_trans_grab_nic_access(trans, false);
-				iwl_write32(trans, HBUS_TARG_PRPH_WADDR,
-					    (addr & 0x0000FFFF) |
-					    ((size - 1) << 24));
-				iwl_write32(trans, HBUS_TARG_PRPH_WDAT, val);
-				iwl_trans_release_nic_access(trans);
-				/* needed after consecutive writes w/o read */
-				mmiowb();
+		/* Periphery writes can be 1-3 bytes long, or DWORDs */
+		if (size < 4) {
+			memcpy(&val, buf, size);
+			spin_lock_irqsave(&trans->reg_lock, flags);
+			if (!iwl_trans_grab_nic_access(trans, false)) {
 				spin_unlock_irqrestore(&trans->reg_lock, flags);
-			} else {
-				if (size % 4)
-					return -EINVAL;
-				for (i = 0; i < size; i += 4)
-					iwl_write_prph(trans, addr+i,
-						       *(u32 *)(buf+i));
+					return -EIO;
 			}
+			iwl_write32(trans, HBUS_TARG_PRPH_WADDR,
+				    (addr & 0x0000FFFF) |
+				    ((size - 1) << 24));
+			iwl_write32(trans, HBUS_TARG_PRPH_WDAT, val);
+			iwl_trans_release_nic_access(trans);
+			/* needed after consecutive writes w/o read */
+			mmiowb();
+			spin_unlock_irqrestore(&trans->reg_lock, flags);
+		} else {
+			if (size % 4)
+				return -EINVAL;
+			for (i = 0; i < size; i += 4)
+				iwl_write_prph(trans, addr+i,
+					       *(u32 *)(buf+i));
+		}
 	} else if (iwl_test_valid_hw_addr(tst, addr)) {
 		iwl_trans_write_mem(trans, addr, buf, size / 4);
 	} else {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 7584d55..b0d5c71 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -734,15 +734,15 @@ static inline void iwl_trans_set_pmi(struct iwl_trans *trans, bool state)
 	trans->ops->set_pmi(trans, state);
 }
 
-static inline bool iwl_trans_grab_nic_access(struct iwl_trans *trans,
-					     bool silent)
-{
-	return trans->ops->grab_nic_access(trans, silent);
-}
+#define iwl_trans_grab_nic_access(trans, silent)	\
+	__cond_lock(nic_access,				\
+		    likely((trans)->ops->grab_nic_access(trans, silent)))
 
-static inline void iwl_trans_release_nic_access(struct iwl_trans *trans)
+static inline void __releases(nic_access)
+iwl_trans_release_nic_access(struct iwl_trans *trans)
 {
 	trans->ops->release_nic_access(trans);
+	__release(nic_access);
 }
 
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index bca6203..db3b055 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -795,7 +795,7 @@ static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 	u32 *vals = buf;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_trans_grab_nic_access(trans, false))) {
+	if (iwl_trans_grab_nic_access(trans, false)) {
 		iwl_write32(trans, HBUS_TARG_MEM_RADDR, addr);
 		for (offs = 0; offs < dwords; offs++)
 			vals[offs] = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
@@ -815,7 +815,7 @@ static int iwl_trans_pcie_write_mem(struct iwl_trans *trans, u32 addr,
 	u32 *vals = buf;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_trans_grab_nic_access(trans, false))) {
+	if (iwl_trans_grab_nic_access(trans, false)) {
 		iwl_write32(trans, HBUS_TARG_MEM_WADDR, addr);
 		for (offs = 0; offs < dwords; offs++)
 			iwl_write32(trans, HBUS_TARG_MEM_WDAT, vals[offs]);
-- 
1.8.0

