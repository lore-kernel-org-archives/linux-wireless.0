Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20116 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab2CDUnK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:10 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 081/101] iwlwifi: always check if got h/w access before write
Date: Sun,  4 Mar 2012 11:29:35 -0800
Message-Id: <1330889395-533-82-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214408_712450_8D4E95D4)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>

Before we write to the device registers always check if
iwl_grap_nic_access() was successful.

On the way change return type of grab_nic_access() to bool, and add
likely()/unlikely() statement.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.c            |   53 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-io.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    4 +-
 6 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 7712c55..9a12b70 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -189,7 +189,7 @@ static void iwl_tt_check_exit_ct_kill(unsigned long data)
 		}
 		iwl_read32(trans(priv), CSR_UCODE_DRV_GP1);
 		spin_lock_irqsave(&trans(priv)->reg_lock, flags);
-		if (!iwl_grab_nic_access(trans(priv)))
+		if (likely(iwl_grab_nic_access(trans(priv))))
 			iwl_release_nic_access(trans(priv));
 		spin_unlock_irqrestore(&trans(priv)->reg_lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5f390f8..ce9ebeb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -327,7 +327,7 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 
 	/* Make sure device is powered up for SRAM reads */
 	spin_lock_irqsave(&trans(priv)->reg_lock, reg_flags);
-	if (iwl_grab_nic_access(trans(priv))) {
+	if (unlikely(!iwl_grab_nic_access(trans(priv)))) {
 		spin_unlock_irqrestore(&trans(priv)->reg_lock, reg_flags);
 		return;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index fc36535..fa69845 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -118,16 +118,17 @@ int iwl_grab_nic_access_silent(struct iwl_trans *trans)
 	return 0;
 }
 
-int iwl_grab_nic_access(struct iwl_trans *trans)
+bool iwl_grab_nic_access(struct iwl_trans *trans)
 {
 	int ret = iwl_grab_nic_access_silent(trans);
 	if (unlikely(ret)) {
 		u32 val = iwl_read32(trans, CSR_GP_CNTRL);
 		WARN_ONCE(1, "Timeout waiting for hardware access "
 			     "(CSR_GP_CNTRL 0x%08x)\n", val);
+		return false;
 	}
 
-	return ret;
+	return true;
 }
 
 void iwl_release_nic_access(struct iwl_trans *trans)
@@ -156,7 +157,7 @@ void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (!iwl_grab_nic_access(trans)) {
+	if (likely(iwl_grab_nic_access(trans))) {
 		iwl_write32(trans, reg, value);
 		iwl_release_nic_access(trans);
 	}
@@ -211,7 +212,7 @@ void iwl_write_prph(struct iwl_trans *trans, u32 addr, u32 val)
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (!iwl_grab_nic_access(trans)) {
+	if (likely(iwl_grab_nic_access(trans))) {
 		__iwl_write_prph(trans, addr, val);
 		iwl_release_nic_access(trans);
 	}
@@ -223,9 +224,11 @@ void iwl_set_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask)
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	iwl_grab_nic_access(trans);
-	__iwl_write_prph(trans, reg, __iwl_read_prph(trans, reg) | mask);
-	iwl_release_nic_access(trans);
+	if (likely(iwl_grab_nic_access(trans))) {
+		__iwl_write_prph(trans, reg,
+				 __iwl_read_prph(trans, reg) | mask);
+		iwl_release_nic_access(trans);
+	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 
@@ -235,10 +238,11 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 reg,
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	iwl_grab_nic_access(trans);
-	__iwl_write_prph(trans, reg,
-			 (__iwl_read_prph(trans, reg) & mask) | bits);
-	iwl_release_nic_access(trans);
+	if (likely(iwl_grab_nic_access(trans))) {
+		__iwl_write_prph(trans, reg,
+				 (__iwl_read_prph(trans, reg) & mask) | bits);
+		iwl_release_nic_access(trans);
+	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 
@@ -248,10 +252,11 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask)
 	u32 val;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	iwl_grab_nic_access(trans);
-	val = __iwl_read_prph(trans, reg);
-	__iwl_write_prph(trans, reg, (val & ~mask));
-	iwl_release_nic_access(trans);
+	if (likely(iwl_grab_nic_access(trans))) {
+		val = __iwl_read_prph(trans, reg);
+		__iwl_write_prph(trans, reg, (val & ~mask));
+		iwl_release_nic_access(trans);
+	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 
@@ -263,15 +268,13 @@ void _iwl_read_targ_mem_words(struct iwl_trans *trans, u32 addr,
 	u32 *vals = buf;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	iwl_grab_nic_access(trans);
-
-	iwl_write32(trans, HBUS_TARG_MEM_RADDR, addr);
-	rmb();
-
-	for (offs = 0; offs < words; offs++)
-		vals[offs] = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
-
-	iwl_release_nic_access(trans);
+	if (likely(iwl_grab_nic_access(trans))) {
+		iwl_write32(trans, HBUS_TARG_MEM_RADDR, addr);
+		rmb();
+		for (offs = 0; offs < words; offs++)
+			vals[offs] = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
+		iwl_release_nic_access(trans);
+	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 
@@ -292,7 +295,7 @@ int _iwl_write_targ_mem_words(struct iwl_trans *trans, u32 addr,
 	u32 *vals = buf;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (!iwl_grab_nic_access(trans)) {
+	if (likely(iwl_grab_nic_access(trans))) {
 		iwl_write32(trans, HBUS_TARG_MEM_WADDR, addr);
 		wmb();
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 1136dc1..09b8567 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -61,7 +61,7 @@ int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
 			int timeout);
 
 int iwl_grab_nic_access_silent(struct iwl_trans *trans);
-int iwl_grab_nic_access(struct iwl_trans *trans);
+bool iwl_grab_nic_access(struct iwl_trans *trans);
 void iwl_release_nic_access(struct iwl_trans *trans);
 
 u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg);
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index bdcbbd0..91a42c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -445,7 +445,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
 		spin_lock_irqsave(&trans(priv)->reg_lock, flags);
 		ret = iwl_grab_nic_access_silent(trans(priv));
-		if (ret == 0) {
+		if (likely(ret == 0)) {
 			iwl_write32(trans(priv), HBUS_TARG_MEM_RADDR, base);
 			status = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
 			iwl_release_nic_access(trans(priv));
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 088354f..25e2f93 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -745,7 +745,8 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 
 	/* Make sure device is powered up for SRAM reads */
 	spin_lock_irqsave(&trans->reg_lock, reg_flags);
-	iwl_grab_nic_access(trans);
+	if (unlikely(!iwl_grab_nic_access(trans)))
+		goto out_unlock;
 
 	/* Set starting address; reads will auto-increment */
 	iwl_write32(trans, HBUS_TARG_MEM_RADDR, ptr);
@@ -785,6 +786,7 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 
 	/* Allow device to power down */
 	iwl_release_nic_access(trans);
+out_unlock:
 	spin_unlock_irqrestore(&trans->reg_lock, reg_flags);
 	return pos;
 }
-- 
1.7.0.4

