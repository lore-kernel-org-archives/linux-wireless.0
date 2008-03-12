Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51370 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbYCMAEG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 20:04:06 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/5] iwlwifi: rename struct iwl4965_priv to struct iwl_priv
Date: Wed, 12 Mar 2008 16:58:50 -0700
Message-Id: <1205366332-12652-4-git-send-email-reinette.chatre@intel.com> (sfid-20080313_000424_105992_DF669C6D)
In-Reply-To: <1205366332-12652-3-git-send-email-reinette.chatre@intel.com>
References: <1205366332-12652-1-git-send-email-reinette.chatre@intel.com>
 <1205366332-12652-2-git-send-email-reinette.chatre@intel.com>
 <1205366332-12652-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch renames iwl4965_priv to iwl_priv. iwl_priv  will
be shared by more hw.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-io.h  |   58 ++--
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |   42 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  178 ++++++------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |  128 +++++-----
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   10 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |   18 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  396 +++++++++++++-------------
 7 files changed, 415 insertions(+), 415 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-io.h b/drivers/net/wireless/iwlwifi/iwl-4965-io.h
index 3accdfb..fba7d03 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-io.h
@@ -61,7 +61,7 @@
 
 #define _iwl4965_write32(priv, ofs, val) writel((val), (priv)->hw_base + (ofs))
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl4965_write32(const char *f, u32 l, struct iwl4965_priv *priv,
+static inline void __iwl4965_write32(const char *f, u32 l, struct iwl_priv *priv,
 				 u32 ofs, u32 val)
 {
 	IWL_DEBUG_IO("write32(0x%08X, 0x%08X) - %s %d\n", ofs, val, f, l);
@@ -75,7 +75,7 @@ static inline void __iwl4965_write32(const char *f, u32 l, struct iwl4965_priv *
 
 #define _iwl4965_read32(priv, ofs) readl((priv)->hw_base + (ofs))
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline u32 __iwl4965_read32(char *f, u32 l, struct iwl4965_priv *priv, u32 ofs)
+static inline u32 __iwl4965_read32(char *f, u32 l, struct iwl_priv *priv, u32 ofs)
 {
 	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
 	return _iwl4965_read32(priv, ofs);
@@ -85,7 +85,7 @@ static inline u32 __iwl4965_read32(char *f, u32 l, struct iwl4965_priv *priv, u3
 #define iwl4965_read32(p, o) _iwl4965_read32(p, o)
 #endif
 
-static inline int _iwl4965_poll_bit(struct iwl4965_priv *priv, u32 addr,
+static inline int _iwl4965_poll_bit(struct iwl_priv *priv, u32 addr,
 				u32 bits, u32 mask, int timeout)
 {
 	int i = 0;
@@ -101,7 +101,7 @@ static inline int _iwl4965_poll_bit(struct iwl4965_priv *priv, u32 addr,
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline int __iwl4965_poll_bit(const char *f, u32 l,
-				 struct iwl4965_priv *priv, u32 addr,
+				 struct iwl_priv *priv, u32 addr,
 				 u32 bits, u32 mask, int timeout)
 {
 	int ret = _iwl4965_poll_bit(priv, addr, bits, mask, timeout);
@@ -116,13 +116,13 @@ static inline int __iwl4965_poll_bit(const char *f, u32 l,
 #define iwl4965_poll_bit(p, a, b, m, t) _iwl4965_poll_bit(p, a, b, m, t)
 #endif
 
-static inline void _iwl4965_set_bit(struct iwl4965_priv *priv, u32 reg, u32 mask)
+static inline void _iwl4965_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
 {
 	_iwl4965_write32(priv, reg, _iwl4965_read32(priv, reg) | mask);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl4965_set_bit(const char *f, u32 l,
-				 struct iwl4965_priv *priv, u32 reg, u32 mask)
+				 struct iwl_priv *priv, u32 reg, u32 mask)
 {
 	u32 val = _iwl4965_read32(priv, reg) | mask;
 	IWL_DEBUG_IO("set_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
@@ -133,13 +133,13 @@ static inline void __iwl4965_set_bit(const char *f, u32 l,
 #define iwl4965_set_bit(p, r, m) _iwl4965_set_bit(p, r, m)
 #endif
 
-static inline void _iwl4965_clear_bit(struct iwl4965_priv *priv, u32 reg, u32 mask)
+static inline void _iwl4965_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
 {
 	_iwl4965_write32(priv, reg, _iwl4965_read32(priv, reg) & ~mask);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl4965_clear_bit(const char *f, u32 l,
-				   struct iwl4965_priv *priv, u32 reg, u32 mask)
+				   struct iwl_priv *priv, u32 reg, u32 mask)
 {
 	u32 val = _iwl4965_read32(priv, reg) & ~mask;
 	IWL_DEBUG_IO("clear_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
@@ -150,7 +150,7 @@ static inline void __iwl4965_clear_bit(const char *f, u32 l,
 #define iwl4965_clear_bit(p, r, m) _iwl4965_clear_bit(p, r, m)
 #endif
 
-static inline int _iwl4965_grab_nic_access(struct iwl4965_priv *priv)
+static inline int _iwl4965_grab_nic_access(struct iwl_priv *priv)
 {
 	int ret;
 	u32 gp_ctl;
@@ -194,7 +194,7 @@ static inline int _iwl4965_grab_nic_access(struct iwl4965_priv *priv)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline int __iwl4965_grab_nic_access(const char *f, u32 l,
-					       struct iwl4965_priv *priv)
+					       struct iwl_priv *priv)
 {
 	if (atomic_read(&priv->restrict_refcnt))
 		IWL_DEBUG_INFO("Grabbing access while already held at "
@@ -210,7 +210,7 @@ static inline int __iwl4965_grab_nic_access(const char *f, u32 l,
 	_iwl4965_grab_nic_access(priv)
 #endif
 
-static inline void _iwl4965_release_nic_access(struct iwl4965_priv *priv)
+static inline void _iwl4965_release_nic_access(struct iwl_priv *priv)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (atomic_dec_and_test(&priv->restrict_refcnt))
@@ -220,7 +220,7 @@ static inline void _iwl4965_release_nic_access(struct iwl4965_priv *priv)
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl4965_release_nic_access(const char *f, u32 l,
-					    struct iwl4965_priv *priv)
+					    struct iwl_priv *priv)
 {
 	if (atomic_read(&priv->restrict_refcnt) <= 0)
 		IWL_ERROR("Release unheld nic access at line %d.\n", l);
@@ -235,13 +235,13 @@ static inline void __iwl4965_release_nic_access(const char *f, u32 l,
 	_iwl4965_release_nic_access(priv)
 #endif
 
-static inline u32 _iwl4965_read_direct32(struct iwl4965_priv *priv, u32 reg)
+static inline u32 _iwl4965_read_direct32(struct iwl_priv *priv, u32 reg)
 {
 	return _iwl4965_read32(priv, reg);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline u32 __iwl4965_read_direct32(const char *f, u32 l,
-					struct iwl4965_priv *priv, u32 reg)
+					struct iwl_priv *priv, u32 reg)
 {
 	u32 value = _iwl4965_read_direct32(priv, reg);
 	if (!atomic_read(&priv->restrict_refcnt))
@@ -256,14 +256,14 @@ static inline u32 __iwl4965_read_direct32(const char *f, u32 l,
 #define iwl4965_read_direct32 _iwl4965_read_direct32
 #endif
 
-static inline void _iwl4965_write_direct32(struct iwl4965_priv *priv,
+static inline void _iwl4965_write_direct32(struct iwl_priv *priv,
 					 u32 reg, u32 value)
 {
 	_iwl4965_write32(priv, reg, value);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
 static void __iwl4965_write_direct32(u32 line,
-				   struct iwl4965_priv *priv, u32 reg, u32 value)
+				   struct iwl_priv *priv, u32 reg, u32 value)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Nic access not held from line %d\n", line);
@@ -275,7 +275,7 @@ static void __iwl4965_write_direct32(u32 line,
 #define iwl4965_write_direct32 _iwl4965_write_direct32
 #endif
 
-static inline void iwl4965_write_reg_buf(struct iwl4965_priv *priv,
+static inline void iwl4965_write_reg_buf(struct iwl_priv *priv,
 					       u32 reg, u32 len, u32 *values)
 {
 	u32 count = sizeof(u32);
@@ -286,7 +286,7 @@ static inline void iwl4965_write_reg_buf(struct iwl4965_priv *priv,
 	}
 }
 
-static inline int _iwl4965_poll_direct_bit(struct iwl4965_priv *priv,
+static inline int _iwl4965_poll_direct_bit(struct iwl_priv *priv,
 					   u32 addr, u32 mask, int timeout)
 {
 	int i = 0;
@@ -303,7 +303,7 @@ static inline int _iwl4965_poll_direct_bit(struct iwl4965_priv *priv,
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline int __iwl4965_poll_direct_bit(const char *f, u32 l,
-					    struct iwl4965_priv *priv,
+					    struct iwl_priv *priv,
 					    u32 addr, u32 mask, int timeout)
 {
 	int ret  = _iwl4965_poll_direct_bit(priv, addr, mask, timeout);
@@ -322,13 +322,13 @@ static inline int __iwl4965_poll_direct_bit(const char *f, u32 l,
 #define iwl4965_poll_direct_bit _iwl4965_poll_direct_bit
 #endif
 
-static inline u32 _iwl4965_read_prph(struct iwl4965_priv *priv, u32 reg)
+static inline u32 _iwl4965_read_prph(struct iwl_priv *priv, u32 reg)
 {
 	_iwl4965_write_direct32(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
 	return _iwl4965_read_direct32(priv, HBUS_TARG_PRPH_RDAT);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline u32 __iwl4965_read_prph(u32 line, struct iwl4965_priv *priv, u32 reg)
+static inline u32 __iwl4965_read_prph(u32 line, struct iwl_priv *priv, u32 reg)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Nic access not held from line %d\n", line);
@@ -341,7 +341,7 @@ static inline u32 __iwl4965_read_prph(u32 line, struct iwl4965_priv *priv, u32 r
 #define iwl4965_read_prph _iwl4965_read_prph
 #endif
 
-static inline void _iwl4965_write_prph(struct iwl4965_priv *priv,
+static inline void _iwl4965_write_prph(struct iwl_priv *priv,
 					     u32 addr, u32 val)
 {
 	_iwl4965_write_direct32(priv, HBUS_TARG_PRPH_WADDR,
@@ -349,7 +349,7 @@ static inline void _iwl4965_write_prph(struct iwl4965_priv *priv,
 	_iwl4965_write_direct32(priv, HBUS_TARG_PRPH_WDAT, val);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl4965_write_prph(u32 line, struct iwl4965_priv *priv,
+static inline void __iwl4965_write_prph(u32 line, struct iwl_priv *priv,
 					      u32 addr, u32 val)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
@@ -366,7 +366,7 @@ static inline void __iwl4965_write_prph(u32 line, struct iwl4965_priv *priv,
 #define _iwl4965_set_bits_prph(priv, reg, mask) \
 	_iwl4965_write_prph(priv, reg, (_iwl4965_read_prph(priv, reg) | mask))
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl4965_set_bits_prph(u32 line, struct iwl4965_priv *priv,
+static inline void __iwl4965_set_bits_prph(u32 line, struct iwl_priv *priv,
 					u32 reg, u32 mask)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
@@ -385,7 +385,7 @@ static inline void __iwl4965_set_bits_prph(u32 line, struct iwl4965_priv *priv,
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl4965_set_bits_mask_prph(u32 line,
-		struct iwl4965_priv *priv, u32 reg, u32 bits, u32 mask)
+		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Nic access not held from line %d\n", line);
@@ -397,26 +397,26 @@ static inline void __iwl4965_set_bits_mask_prph(u32 line,
 #define iwl4965_set_bits_mask_prph _iwl4965_set_bits_mask_prph
 #endif
 
-static inline void iwl4965_clear_bits_prph(struct iwl4965_priv
+static inline void iwl4965_clear_bits_prph(struct iwl_priv
 						 *priv, u32 reg, u32 mask)
 {
 	u32 val = _iwl4965_read_prph(priv, reg);
 	_iwl4965_write_prph(priv, reg, (val & ~mask));
 }
 
-static inline u32 iwl4965_read_targ_mem(struct iwl4965_priv *priv, u32 addr)
+static inline u32 iwl4965_read_targ_mem(struct iwl_priv *priv, u32 addr)
 {
 	iwl4965_write_direct32(priv, HBUS_TARG_MEM_RADDR, addr);
 	return iwl4965_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 }
 
-static inline void iwl4965_write_targ_mem(struct iwl4965_priv *priv, u32 addr, u32 val)
+static inline void iwl4965_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val)
 {
 	iwl4965_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
 	iwl4965_write_direct32(priv, HBUS_TARG_MEM_WDAT, val);
 }
 
-static inline void iwl4965_write_targ_mem_buf(struct iwl4965_priv *priv, u32 addr,
+static inline void iwl4965_write_targ_mem_buf(struct iwl_priv *priv, u32 addr,
 					  u32 len, u32 *values)
 {
 	iwl4965_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 7733b23..02990ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -162,11 +162,11 @@ struct iwl4965_lq_sta {
 	struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
 #endif
 	struct iwl4965_rate dbg_fixed;
-	struct iwl4965_priv *drv;
+	struct iwl_priv *drv;
 #endif
 };
 
-static void rs_rate_scale_perform(struct iwl4965_priv *priv,
+static void rs_rate_scale_perform(struct iwl_priv *priv,
 				   struct net_device *dev,
 				   struct ieee80211_hdr *hdr,
 				   struct sta_info *sta);
@@ -229,7 +229,7 @@ static s32 expected_tpt_mimo40MHzSGI[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 131, 131, 191, 222, 242, 270, 284, 289, 293
 };
 
-static int iwl4965_lq_sync_callback(struct iwl4965_priv *priv,
+static int iwl4965_lq_sync_callback(struct iwl_priv *priv,
 				struct iwl4965_cmd *cmd, struct sk_buff *skb)
 {
 	/*We didn't cache the SKB; let the caller free it */
@@ -241,7 +241,7 @@ static inline u8 iwl4965_rate_get_rate(u32 rate_n_flags)
 	return (u8)(rate_n_flags & 0xFF);
 }
 
-static int rs_send_lq_cmd(struct iwl4965_priv *priv,
+static int rs_send_lq_cmd(struct iwl_priv *priv,
 			  struct iwl4965_link_quality_cmd *lq, u8 flags)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -388,7 +388,7 @@ static u32 rs_tl_get_load(struct iwl4965_lq_sta *lq_data, u8 tid)
 	return tl->total;
 }
 
-static void rs_tl_turn_on_agg_for_tid(struct iwl4965_priv *priv,
+static void rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 				struct iwl4965_lq_sta *lq_data, u8 tid,
 				struct sta_info *sta)
 {
@@ -407,7 +407,7 @@ static void rs_tl_turn_on_agg_for_tid(struct iwl4965_priv *priv,
 	}
 }
 
-static void rs_tl_turn_on_agg(struct iwl4965_priv *priv, u8 tid,
+static void rs_tl_turn_on_agg(struct iwl_priv *priv, u8 tid,
 				struct iwl4965_lq_sta *lq_data,
 				struct sta_info *sta)
 {
@@ -658,7 +658,7 @@ static inline void rs_toggle_antenna(struct iwl4965_rate *new_rate,
 	}
 }
 
-static inline u8 rs_use_green(struct iwl4965_priv *priv,
+static inline u8 rs_use_green(struct iwl_priv *priv,
 			      struct ieee80211_conf *conf)
 {
 #ifdef CONFIG_IWL4965_HT
@@ -821,7 +821,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	struct iwl4965_link_quality_cmd *table;
 	struct sta_info *sta;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)priv_rate;
+	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = local_to_hw(local);
 	struct iwl4965_rate_scale_data *window = NULL;
@@ -1128,7 +1128,7 @@ static void rs_get_expected_tpt_table(struct iwl4965_lq_sta *lq_sta,
  * to decrease to match "active" throughput.  When moving from MIMO to SISO,
  * bit rate will typically need to increase, but not if performance was bad.
  */
-static s32 rs_get_best_rate(struct iwl4965_priv *priv,
+static s32 rs_get_best_rate(struct iwl_priv *priv,
 			    struct iwl4965_lq_sta *lq_sta,
 			    struct iwl4965_scale_tbl_info *tbl,	/* "search" */
 			    u16 rate_mask, s8 index, s8 rate)
@@ -1226,7 +1226,7 @@ static inline u8 rs_is_both_ant_supp(u8 valid_antenna)
 /*
  * Set up search table for MIMO
  */
-static int rs_switch_to_mimo(struct iwl4965_priv *priv,
+static int rs_switch_to_mimo(struct iwl_priv *priv,
 			     struct iwl4965_lq_sta *lq_sta,
 			     struct ieee80211_conf *conf,
 			     struct sta_info *sta,
@@ -1291,7 +1291,7 @@ static int rs_switch_to_mimo(struct iwl4965_priv *priv,
 /*
  * Set up search table for SISO
  */
-static int rs_switch_to_siso(struct iwl4965_priv *priv,
+static int rs_switch_to_siso(struct iwl_priv *priv,
 			     struct iwl4965_lq_sta *lq_sta,
 			     struct ieee80211_conf *conf,
 			     struct sta_info *sta,
@@ -1354,7 +1354,7 @@ static int rs_switch_to_siso(struct iwl4965_priv *priv,
 /*
  * Try to switch to new modulation mode from legacy
  */
-static int rs_move_legacy_other(struct iwl4965_priv *priv,
+static int rs_move_legacy_other(struct iwl_priv *priv,
 				struct iwl4965_lq_sta *lq_sta,
 				struct ieee80211_conf *conf,
 				struct sta_info *sta,
@@ -1452,7 +1452,7 @@ static int rs_move_legacy_other(struct iwl4965_priv *priv,
 /*
  * Try to switch to new modulation mode from SISO
  */
-static int rs_move_siso_to_other(struct iwl4965_priv *priv,
+static int rs_move_siso_to_other(struct iwl_priv *priv,
 				 struct iwl4965_lq_sta *lq_sta,
 				 struct ieee80211_conf *conf,
 				 struct sta_info *sta,
@@ -1548,7 +1548,7 @@ static int rs_move_siso_to_other(struct iwl4965_priv *priv,
 /*
  * Try to switch to new modulation mode from MIMO
  */
-static int rs_move_mimo_to_other(struct iwl4965_priv *priv,
+static int rs_move_mimo_to_other(struct iwl_priv *priv,
 				 struct iwl4965_lq_sta *lq_sta,
 				 struct ieee80211_conf *conf,
 				 struct sta_info *sta,
@@ -1728,7 +1728,7 @@ static void rs_stay_in_table(struct iwl4965_lq_sta *lq_sta)
 /*
  * Do rate scaling and search for new modulation mode.
  */
-static void rs_rate_scale_perform(struct iwl4965_priv *priv,
+static void rs_rate_scale_perform(struct iwl_priv *priv,
 				  struct net_device *dev,
 				  struct ieee80211_hdr *hdr,
 				  struct sta_info *sta)
@@ -2148,7 +2148,7 @@ out:
 }
 
 
-static void rs_initialize_lq(struct iwl4965_priv *priv,
+static void rs_initialize_lq(struct iwl_priv *priv,
 			     struct ieee80211_conf *conf,
 			     struct sta_info *sta)
 {
@@ -2213,7 +2213,7 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct sta_info *sta;
 	u16 fc;
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)priv_rate;
+	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
 	struct iwl4965_lq_sta *lq_sta;
 
 	IWL_DEBUG_RATE_LIMIT("rate scale calculate new rate for skb\n");
@@ -2294,7 +2294,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	int i, j;
 	struct ieee80211_conf *conf = &local->hw.conf;
 	struct ieee80211_supported_band *sband;
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)priv_rate;
+	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
 	struct iwl4965_lq_sta *lq_sta = priv_sta;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
@@ -2516,7 +2516,7 @@ static void rs_free(void *priv_rate)
 
 static void rs_clear(void *priv_rate)
 {
-	struct iwl4965_priv *priv = (struct iwl4965_priv *) priv_rate;
+	struct iwl_priv *priv = (struct iwl_priv *) priv_rate;
 
 	IWL_DEBUG_RATE("enter\n");
 
@@ -2726,7 +2726,7 @@ static struct rate_control_ops rs_ops = {
 int iwl4965_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	struct iwl4965_lq_sta *lq_sta;
 	struct sta_info *sta;
 	int cnt = 0, i;
@@ -2816,7 +2816,7 @@ int iwl4965_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 
 void iwl4965_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 
 	priv->lq_mngr.lq_ready = 1;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 2896af2..7b0ad72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -43,7 +43,7 @@
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
 
-static void iwl4965_hw_card_show_info(struct iwl4965_priv *priv);
+static void iwl4965_hw_card_show_info(struct iwl_priv *priv);
 
 #define IWL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
 	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,      \
@@ -111,7 +111,7 @@ static int is_fat_channel(__le32 rxon_flags)
 		(rxon_flags & RXON_FLG_CHANNEL_MODE_MIXED_MSK);
 }
 
-static u8 is_single_stream(struct iwl4965_priv *priv)
+static u8 is_single_stream(struct iwl_priv *priv)
 {
 #ifdef CONFIG_IWL4965_HT
 	if (!priv->current_ht_config.is_ht ||
@@ -155,7 +155,7 @@ int iwl4965_hwrate_to_plcp_idx(u32 rate_n_flags)
 /**
  * translate ucode response to mac80211 tx status control values
  */
-void iwl4965_hwrate_to_tx_control(struct iwl4965_priv *priv, u32 rate_n_flags,
+void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 				  struct ieee80211_tx_control *control)
 {
 	int rate_index;
@@ -188,7 +188,7 @@ void iwl4965_hwrate_to_tx_control(struct iwl4965_priv *priv, u32 rate_n_flags,
  * MIMO (dual stream) requires at least 2, but works better with 3.
  * This does not determine *which* chains to use, just how many.
  */
-static int iwl4965_get_rx_chain_counter(struct iwl4965_priv *priv,
+static int iwl4965_get_rx_chain_counter(struct iwl_priv *priv,
 					u8 *idle_state, u8 *rx_state)
 {
 	u8 is_single = is_single_stream(priv);
@@ -217,7 +217,7 @@ static int iwl4965_get_rx_chain_counter(struct iwl4965_priv *priv,
 	return 0;
 }
 
-int iwl4965_hw_rxq_stop(struct iwl4965_priv *priv)
+int iwl4965_hw_rxq_stop(struct iwl_priv *priv)
 {
 	int rc;
 	unsigned long flags;
@@ -242,7 +242,7 @@ int iwl4965_hw_rxq_stop(struct iwl4965_priv *priv)
 	return 0;
 }
 
-u8 iwl4965_hw_find_station(struct iwl4965_priv *priv, const u8 *addr)
+u8 iwl4965_hw_find_station(struct iwl_priv *priv, const u8 *addr)
 {
 	int i;
 	int start = 0;
@@ -274,7 +274,7 @@ u8 iwl4965_hw_find_station(struct iwl4965_priv *priv, const u8 *addr)
 	return ret;
 }
 
-static int iwl4965_nic_set_pwr_src(struct iwl4965_priv *priv, int pwr_max)
+static int iwl4965_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 {
 	int ret;
 	unsigned long flags;
@@ -307,7 +307,7 @@ static int iwl4965_nic_set_pwr_src(struct iwl4965_priv *priv, int pwr_max)
 	return ret;
 }
 
-static int iwl4965_rx_init(struct iwl4965_priv *priv, struct iwl4965_rx_queue *rxq)
+static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl4965_rx_queue *rxq)
 {
 	int rc;
 	unsigned long flags;
@@ -360,7 +360,7 @@ static int iwl4965_rx_init(struct iwl4965_priv *priv, struct iwl4965_rx_queue *r
 }
 
 /* Tell 4965 where to find the "keep warm" buffer */
-static int iwl4965_kw_init(struct iwl4965_priv *priv)
+static int iwl4965_kw_init(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	int rc;
@@ -378,7 +378,7 @@ out:
 	return rc;
 }
 
-static int iwl4965_kw_alloc(struct iwl4965_priv *priv)
+static int iwl4965_kw_alloc(struct iwl_priv *priv)
 {
 	struct pci_dev *dev = priv->pci_dev;
 	struct iwl4965_kw *kw = &priv->kw;
@@ -399,7 +399,7 @@ static int iwl4965_kw_alloc(struct iwl4965_priv *priv)
  *
  * Does not set up a command, or touch hardware.
  */
-int iwl4965_set_fat_chan_info(struct iwl4965_priv *priv,
+int iwl4965_set_fat_chan_info(struct iwl_priv *priv,
 			      enum ieee80211_band band, u16 channel,
 			      const struct iwl4965_eeprom_channel *eeprom_ch,
 			      u8 fat_extension_channel)
@@ -443,7 +443,7 @@ int iwl4965_set_fat_chan_info(struct iwl4965_priv *priv,
 /**
  * iwl4965_kw_free - Free the "keep warm" buffer
  */
-static void iwl4965_kw_free(struct iwl4965_priv *priv)
+static void iwl4965_kw_free(struct iwl_priv *priv)
 {
 	struct pci_dev *dev = priv->pci_dev;
 	struct iwl4965_kw *kw = &priv->kw;
@@ -461,7 +461,7 @@ static void iwl4965_kw_free(struct iwl4965_priv *priv)
  * @param priv
  * @return error code
  */
-static int iwl4965_txq_ctx_reset(struct iwl4965_priv *priv)
+static int iwl4965_txq_ctx_reset(struct iwl_priv *priv)
 {
 	int rc = 0;
 	int txq_id, slots_num;
@@ -523,7 +523,7 @@ static int iwl4965_txq_ctx_reset(struct iwl4965_priv *priv)
 	return rc;
 }
 
-int iwl4965_hw_nic_init(struct iwl4965_priv *priv)
+int iwl4965_hw_nic_init(struct iwl_priv *priv)
 {
 	int rc;
 	unsigned long flags;
@@ -668,7 +668,7 @@ int iwl4965_hw_nic_init(struct iwl4965_priv *priv)
 	return 0;
 }
 
-int iwl4965_hw_nic_stop_master(struct iwl4965_priv *priv)
+int iwl4965_hw_nic_stop_master(struct iwl_priv *priv)
 {
 	int rc = 0;
 	u32 reg_val;
@@ -704,7 +704,7 @@ int iwl4965_hw_nic_stop_master(struct iwl4965_priv *priv)
 /**
  * iwl4965_hw_txq_ctx_stop - Stop all Tx DMA channels, free Tx queue memory
  */
-void iwl4965_hw_txq_ctx_stop(struct iwl4965_priv *priv)
+void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv)
 {
 
 	int txq_id;
@@ -732,7 +732,7 @@ void iwl4965_hw_txq_ctx_stop(struct iwl4965_priv *priv)
 	iwl4965_hw_txq_ctx_free(priv);
 }
 
-int iwl4965_hw_nic_reset(struct iwl4965_priv *priv)
+int iwl4965_hw_nic_reset(struct iwl_priv *priv)
 {
 	int rc = 0;
 	unsigned long flags;
@@ -793,7 +793,7 @@ int iwl4965_hw_nic_reset(struct iwl4965_priv *priv)
  */
 static void iwl4965_bg_statistics_periodic(unsigned long data)
 {
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)data;
+	struct iwl_priv *priv = (struct iwl_priv *)data;
 
 	queue_work(priv->workqueue, &priv->statistics_work);
 }
@@ -805,7 +805,7 @@ static void iwl4965_bg_statistics_periodic(unsigned long data)
  */
 static void iwl4965_bg_statistics_work(struct work_struct *work)
 {
-	struct iwl4965_priv *priv = container_of(work, struct iwl4965_priv,
+	struct iwl_priv *priv = container_of(work, struct iwl_priv,
 					     statistics_work);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
@@ -819,7 +819,7 @@ static void iwl4965_bg_statistics_work(struct work_struct *work)
 #define CT_LIMIT_CONST		259
 #define TM_CT_KILL_THRESHOLD	110
 
-void iwl4965_rf_kill_ct_config(struct iwl4965_priv *priv)
+void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
 {
 	struct iwl4965_ct_kill_config cmd;
 	u32 R1, R2, R3;
@@ -865,7 +865,7 @@ void iwl4965_rf_kill_ct_config(struct iwl4965_priv *priv)
  *   enough to receive all of our own network traffic, but not so
  *   high that our DSP gets too busy trying to lock onto non-network
  *   activity/noise. */
-static int iwl4965_sens_energy_cck(struct iwl4965_priv *priv,
+static int iwl4965_sens_energy_cck(struct iwl_priv *priv,
 				   u32 norm_fa,
 				   u32 rx_enable_time,
 				   struct statistics_general_data *rx_info)
@@ -1056,7 +1056,7 @@ static int iwl4965_sens_energy_cck(struct iwl4965_priv *priv,
 }
 
 
-static int iwl4965_sens_auto_corr_ofdm(struct iwl4965_priv *priv,
+static int iwl4965_sens_auto_corr_ofdm(struct iwl_priv *priv,
 				       u32 norm_fa,
 				       u32 rx_enable_time)
 {
@@ -1121,7 +1121,7 @@ static int iwl4965_sens_auto_corr_ofdm(struct iwl4965_priv *priv,
 	return 0;
 }
 
-static int iwl4965_sensitivity_callback(struct iwl4965_priv *priv,
+static int iwl4965_sensitivity_callback(struct iwl_priv *priv,
 				    struct iwl4965_cmd *cmd, struct sk_buff *skb)
 {
 	/* We didn't cache the SKB; let the caller free it */
@@ -1129,7 +1129,7 @@ static int iwl4965_sensitivity_callback(struct iwl4965_priv *priv,
 }
 
 /* Prepare a SENSITIVITY_CMD, send to uCode if values have changed */
-static int iwl4965_sensitivity_write(struct iwl4965_priv *priv, u8 flags)
+static int iwl4965_sensitivity_write(struct iwl_priv *priv, u8 flags)
 {
 	int rc = 0;
 	struct iwl4965_sensitivity_cmd cmd ;
@@ -1206,7 +1206,7 @@ static int iwl4965_sensitivity_write(struct iwl4965_priv *priv, u8 flags)
 	return 0;
 }
 
-void iwl4965_init_sensitivity(struct iwl4965_priv *priv, u8 flags, u8 force)
+void iwl4965_init_sensitivity(struct iwl_priv *priv, u8 flags, u8 force)
 {
 	int rc = 0;
 	int i;
@@ -1264,7 +1264,7 @@ void iwl4965_init_sensitivity(struct iwl4965_priv *priv, u8 flags, u8 force)
 /* Reset differential Rx gains in NIC to prepare for chain noise calibration.
  * Called after every association, but this runs only once!
  *  ... once chain noise is calibrated the first time, it's good forever.  */
-void iwl4965_chain_noise_reset(struct iwl4965_priv *priv)
+void iwl4965_chain_noise_reset(struct iwl_priv *priv)
 {
 	struct iwl4965_chain_noise_data *data = NULL;
 	int rc = 0;
@@ -1293,7 +1293,7 @@ void iwl4965_chain_noise_reset(struct iwl4965_priv *priv)
  * 1)  Which antennas are connected.
  * 2)  Differential rx gain settings to balance the 3 receivers.
  */
-static void iwl4965_noise_calibration(struct iwl4965_priv *priv,
+static void iwl4965_noise_calibration(struct iwl_priv *priv,
 				      struct iwl4965_notif_statistics *stat_resp)
 {
 	struct iwl4965_chain_noise_data *data = NULL;
@@ -1526,7 +1526,7 @@ static void iwl4965_noise_calibration(struct iwl4965_priv *priv,
 	return;
 }
 
-static void iwl4965_sensitivity_calibration(struct iwl4965_priv *priv,
+static void iwl4965_sensitivity_calibration(struct iwl_priv *priv,
 					    struct iwl4965_notif_statistics *resp)
 {
 	int rc = 0;
@@ -1633,7 +1633,7 @@ static void iwl4965_sensitivity_calibration(struct iwl4965_priv *priv,
 
 static void iwl4965_bg_sensitivity_work(struct work_struct *work)
 {
-	struct iwl4965_priv *priv = container_of(work, struct iwl4965_priv,
+	struct iwl_priv *priv = container_of(work, struct iwl_priv,
 			sensitivity_work);
 
 	mutex_lock(&priv->mutex);
@@ -1663,7 +1663,7 @@ static void iwl4965_bg_sensitivity_work(struct work_struct *work)
 
 static void iwl4965_bg_txpower_work(struct work_struct *work)
 {
-	struct iwl4965_priv *priv = container_of(work, struct iwl4965_priv,
+	struct iwl_priv *priv = container_of(work, struct iwl_priv,
 			txpower_work);
 
 	/* If a scan happened to start before we got here
@@ -1691,7 +1691,7 @@ static void iwl4965_bg_txpower_work(struct work_struct *work)
 /*
  * Acquire priv->lock before calling this function !
  */
-static void iwl4965_set_wr_ptrs(struct iwl4965_priv *priv, int txq_id, u32 index)
+static void iwl4965_set_wr_ptrs(struct iwl_priv *priv, int txq_id, u32 index)
 {
 	iwl4965_write_direct32(priv, HBUS_TARG_WRPTR,
 			     (index & 0xff) | (txq_id << 8));
@@ -1705,7 +1705,7 @@ static void iwl4965_set_wr_ptrs(struct iwl4965_priv *priv, int txq_id, u32 index
  *
  * NOTE:  Acquire priv->lock before calling this function !
  */
-static void iwl4965_tx_queue_set_status(struct iwl4965_priv *priv,
+static void iwl4965_tx_queue_set_status(struct iwl_priv *priv,
 					struct iwl4965_tx_queue *txq,
 					int tx_fifo_id, int scd_retry)
 {
@@ -1739,17 +1739,17 @@ static const u16 default_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_HCCA_2
 };
 
-static inline void iwl4965_txq_ctx_activate(struct iwl4965_priv *priv, int txq_id)
+static inline void iwl4965_txq_ctx_activate(struct iwl_priv *priv, int txq_id)
 {
 	set_bit(txq_id, &priv->txq_ctx_active_msk);
 }
 
-static inline void iwl4965_txq_ctx_deactivate(struct iwl4965_priv *priv, int txq_id)
+static inline void iwl4965_txq_ctx_deactivate(struct iwl_priv *priv, int txq_id)
 {
 	clear_bit(txq_id, &priv->txq_ctx_active_msk);
 }
 
-int iwl4965_alive_notify(struct iwl4965_priv *priv)
+int iwl4965_alive_notify(struct iwl_priv *priv)
 {
 	u32 a;
 	int i = 0;
@@ -1841,7 +1841,7 @@ int iwl4965_alive_notify(struct iwl4965_priv *priv)
  *
  * Called when initializing driver
  */
-int iwl4965_hw_set_hw_setting(struct iwl4965_priv *priv)
+int iwl4965_hw_set_hw_setting(struct iwl_priv *priv)
 {
 	/* Allocate area for Tx byte count tables and Rx queue status */
 	priv->hw_setting.shared_virt =
@@ -1876,7 +1876,7 @@ int iwl4965_hw_set_hw_setting(struct iwl4965_priv *priv)
  *
  * Destroy all TX DMA queues and structures
  */
-void iwl4965_hw_txq_ctx_free(struct iwl4965_priv *priv)
+void iwl4965_hw_txq_ctx_free(struct iwl_priv *priv)
 {
 	int txq_id;
 
@@ -1894,7 +1894,7 @@ void iwl4965_hw_txq_ctx_free(struct iwl4965_priv *priv)
  * Does NOT advance any TFD circular buffer read/write indexes
  * Does NOT free the TFD itself (which is within circular buffer)
  */
-int iwl4965_hw_txq_free_tfd(struct iwl4965_priv *priv, struct iwl4965_tx_queue *txq)
+int iwl4965_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl4965_tx_queue *txq)
 {
 	struct iwl4965_tfd_frame *bd_tmp = (struct iwl4965_tfd_frame *)&txq->bd[0];
 	struct iwl4965_tfd_frame *bd = &bd_tmp[txq->q.read_ptr];
@@ -1947,7 +1947,7 @@ int iwl4965_hw_txq_free_tfd(struct iwl4965_priv *priv, struct iwl4965_tx_queue *
 	return 0;
 }
 
-int iwl4965_hw_reg_set_txpower(struct iwl4965_priv *priv, s8 power)
+int iwl4965_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
 {
 	IWL_ERROR("TODO: Implement iwl4965_hw_reg_set_txpower!\n");
 	return -EINVAL;
@@ -2003,7 +2003,7 @@ static s32 iwl4965_get_voltage_compensation(s32 eeprom_voltage,
 }
 
 static const struct iwl4965_channel_info *
-iwl4965_get_channel_txpower_info(struct iwl4965_priv *priv,
+iwl4965_get_channel_txpower_info(struct iwl_priv *priv,
 				 enum ieee80211_band band, u16 channel)
 {
 	const struct iwl4965_channel_info *ch_info;
@@ -2042,7 +2042,7 @@ static s32 iwl4965_get_tx_atten_grp(u16 channel)
 	return -1;
 }
 
-static u32 iwl4965_get_sub_band(const struct iwl4965_priv *priv, u32 channel)
+static u32 iwl4965_get_sub_band(const struct iwl_priv *priv, u32 channel)
 {
 	s32 b = -1;
 
@@ -2078,7 +2078,7 @@ static s32 iwl4965_interpolate_value(s32 x, s32 x1, s32 y1, s32 x2, s32 y2)
  * differences in channel frequencies, which is proportional to differences
  * in channel number.
  */
-static int iwl4965_interpolate_chan(struct iwl4965_priv *priv, u32 channel,
+static int iwl4965_interpolate_chan(struct iwl_priv *priv, u32 channel,
 				    struct iwl4965_eeprom_calib_ch_info *chan_info)
 {
 	s32 s = -1;
@@ -2411,7 +2411,7 @@ static const struct gain_entry gain_table[2][108] = {
 	 }
 };
 
-static int iwl4965_fill_txpower_tbl(struct iwl4965_priv *priv, u8 band, u16 channel,
+static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 				    u8 is_fat, u8 ctrl_chan_high,
 				    struct iwl4965_tx_power_db *tx_power_tbl)
 {
@@ -2668,7 +2668,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl4965_priv *priv, u8 band, u16 chan
  * Uses the active RXON for channel, band, and characteristics (fat, high)
  * The power limit is taken from priv->user_txpower_limit.
  */
-int iwl4965_hw_reg_send_txpower(struct iwl4965_priv *priv)
+int iwl4965_hw_reg_send_txpower(struct iwl_priv *priv)
 {
 	struct iwl4965_txpowertable_cmd cmd = { 0 };
 	int rc = 0;
@@ -2705,7 +2705,7 @@ int iwl4965_hw_reg_send_txpower(struct iwl4965_priv *priv)
 	return rc;
 }
 
-int iwl4965_hw_channel_switch(struct iwl4965_priv *priv, u16 channel)
+int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 {
 	int rc;
 	u8 band = 0;
@@ -2749,7 +2749,7 @@ int iwl4965_hw_channel_switch(struct iwl4965_priv *priv, u16 channel)
 #define RTS_HCCA_RETRY_LIMIT		3
 #define RTS_DFAULT_RETRY_LIMIT		60
 
-void iwl4965_hw_build_tx_cmd_rate(struct iwl4965_priv *priv,
+void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 			      struct iwl4965_cmd *cmd,
 			      struct ieee80211_tx_control *ctrl,
 			      struct ieee80211_hdr *hdr, int sta_id,
@@ -2816,19 +2816,19 @@ void iwl4965_hw_build_tx_cmd_rate(struct iwl4965_priv *priv,
 	tx->rate_n_flags = iwl4965_hw_set_rate_n_flags(rate_plcp, rate_flags);
 }
 
-int iwl4965_hw_get_rx_read(struct iwl4965_priv *priv)
+int iwl4965_hw_get_rx_read(struct iwl_priv *priv)
 {
 	struct iwl4965_shared *shared_data = priv->hw_setting.shared_virt;
 
 	return IWL_GET_BITS(*shared_data, rb_closed_stts_rb_num);
 }
 
-int iwl4965_hw_get_temperature(struct iwl4965_priv *priv)
+int iwl4965_hw_get_temperature(struct iwl_priv *priv)
 {
 	return priv->temperature;
 }
 
-unsigned int iwl4965_hw_get_beacon_cmd(struct iwl4965_priv *priv,
+unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 			  struct iwl4965_frame *frame, u8 rate)
 {
 	struct iwl4965_tx_beacon_cmd *tx_beacon_cmd;
@@ -2867,7 +2867,7 @@ unsigned int iwl4965_hw_get_beacon_cmd(struct iwl4965_priv *priv,
  * 4965 supports up to 16 Tx queues in DRAM, mapped to up to 8 Tx DMA
  * channels supported in hardware.
  */
-int iwl4965_hw_tx_queue_init(struct iwl4965_priv *priv, struct iwl4965_tx_queue *txq)
+int iwl4965_hw_tx_queue_init(struct iwl_priv *priv, struct iwl4965_tx_queue *txq)
 {
 	int rc;
 	unsigned long flags;
@@ -2895,7 +2895,7 @@ int iwl4965_hw_tx_queue_init(struct iwl4965_priv *priv, struct iwl4965_tx_queue
 	return 0;
 }
 
-int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl4965_priv *priv, void *ptr,
+int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 				 dma_addr_t addr, u16 len)
 {
 	int index, is_odd;
@@ -2929,7 +2929,7 @@ int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl4965_priv *priv, void *ptr,
 	return 0;
 }
 
-static void iwl4965_hw_card_show_info(struct iwl4965_priv *priv)
+static void iwl4965_hw_card_show_info(struct iwl_priv *priv)
 {
 	u16 hw_version = priv->eeprom.board_revision_4965;
 
@@ -2947,7 +2947,7 @@ static void iwl4965_hw_card_show_info(struct iwl4965_priv *priv)
 /**
  * iwl4965_tx_queue_update_wr_ptr - Set up entry in Tx byte-count array
  */
-int iwl4965_tx_queue_update_wr_ptr(struct iwl4965_priv *priv,
+int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
 				   struct iwl4965_tx_queue *txq, u16 byte_cnt)
 {
 	int len;
@@ -2978,7 +2978,7 @@ int iwl4965_tx_queue_update_wr_ptr(struct iwl4965_priv *priv,
  * Selects how many and which Rx receivers/antennas/chains to use.
  * This should not be used for scan command ... it puts data in wrong place.
  */
-void iwl4965_set_rxon_chain(struct iwl4965_priv *priv)
+void iwl4965_set_rxon_chain(struct iwl_priv *priv)
 {
 	u8 is_single = is_single_stream(priv);
 	u8 idle_state, rx_state;
@@ -3031,7 +3031,7 @@ static s32 sign_extend(u32 oper, int index)
  *
  * A return of <0 indicates bogus data in the statistics
  */
-int iwl4965_get_temperature(const struct iwl4965_priv *priv)
+int iwl4965_get_temperature(const struct iwl_priv *priv)
 {
 	s32 temperature;
 	s32 vt;
@@ -3099,7 +3099,7 @@ int iwl4965_get_temperature(const struct iwl4965_priv *priv)
  * Assumes caller will replace priv->last_temperature once calibration
  * executed.
  */
-static int iwl4965_is_temp_calib_needed(struct iwl4965_priv *priv)
+static int iwl4965_is_temp_calib_needed(struct iwl_priv *priv)
 {
 	int temp_diff;
 
@@ -3132,7 +3132,7 @@ static int iwl4965_is_temp_calib_needed(struct iwl4965_priv *priv)
 /* Calculate noise level, based on measurements during network silence just
  *   before arriving beacon.  This measurement can be done only if we know
  *   exactly when to expect beacons, therefore only when we're associated. */
-static void iwl4965_rx_calc_noise(struct iwl4965_priv *priv)
+static void iwl4965_rx_calc_noise(struct iwl_priv *priv)
 {
 	struct statistics_rx_non_phy *rx_info
 				= &(priv->statistics.rx.general);
@@ -3169,7 +3169,7 @@ static void iwl4965_rx_calc_noise(struct iwl4965_priv *priv)
 			priv->last_rx_noise);
 }
 
-void iwl4965_hw_rx_statistics(struct iwl4965_priv *priv, struct iwl4965_rx_mem_buffer *rxb)
+void iwl4965_hw_rx_statistics(struct iwl_priv *priv, struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	int change;
@@ -3233,7 +3233,7 @@ void iwl4965_hw_rx_statistics(struct iwl4965_priv *priv, struct iwl4965_rx_mem_b
 		queue_work(priv->workqueue, &priv->txpower_work);
 }
 
-static void iwl4965_add_radiotap(struct iwl4965_priv *priv,
+static void iwl4965_add_radiotap(struct iwl_priv *priv,
 				 struct sk_buff *skb,
 				 struct iwl4965_rx_phy_res *rx_start,
 				 struct ieee80211_rx_status *stats,
@@ -3337,7 +3337,7 @@ static void iwl4965_add_radiotap(struct iwl4965_priv *priv,
 	stats->flag |= RX_FLAG_RADIOTAP;
 }
 
-static void iwl4965_handle_data_packet(struct iwl4965_priv *priv, int is_data,
+static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 				       int include_phy,
 				       struct iwl4965_rx_mem_buffer *rxb,
 				       struct ieee80211_rx_status *stats)
@@ -3552,7 +3552,7 @@ void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
 }
 #endif /* CONFIG_IWL4965_HT */
 
-static void iwl4965_sta_modify_ps_wake(struct iwl4965_priv *priv, int sta_id)
+static void iwl4965_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 {
 	unsigned long flags;
 
@@ -3566,7 +3566,7 @@ static void iwl4965_sta_modify_ps_wake(struct iwl4965_priv *priv, int sta_id)
 	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
 
-static void iwl4965_update_ps_mode(struct iwl4965_priv *priv, u16 ps_bit, u8 *addr)
+static void iwl4965_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr)
 {
 	/* FIXME: need locking over ps_status ??? */
 	u8 sta_id = iwl4965_hw_find_station(priv, addr);
@@ -3595,7 +3595,7 @@ static void iwl4965_update_ps_mode(struct iwl4965_priv *priv, u16 ps_bit, u8 *ad
  * TODO:  This was originally written for 3945, need to audit for
  *        proper operation with 4965.
  */
-static void iwl4965_dbg_report_frame(struct iwl4965_priv *priv,
+static void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 		      struct iwl4965_rx_packet *pkt,
 		      struct ieee80211_hdr *header, int group100)
 {
@@ -3729,7 +3729,7 @@ static void iwl4965_dbg_report_frame(struct iwl4965_priv *priv,
 		iwl_print_hex_dump(IWL_DL_RX, data, length);
 }
 #else
-static inline void iwl4965_dbg_report_frame(struct iwl4965_priv *priv,
+static inline void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 					    struct iwl4965_rx_packet *pkt,
 					    struct ieee80211_hdr *header,
 					    int group100)
@@ -3742,7 +3742,7 @@ static inline void iwl4965_dbg_report_frame(struct iwl4965_priv *priv,
 
 /* Called for REPLY_4965_RX (legacy ABG frames), or
  * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
-static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
+static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 				struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct ieee80211_hdr *header;
@@ -4004,7 +4004,7 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
 
 /* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
  * This will be used later in iwl4965_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
-static void iwl4965_rx_reply_rx_phy(struct iwl4965_priv *priv,
+static void iwl4965_rx_reply_rx_phy(struct iwl_priv *priv,
 				    struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -4013,7 +4013,7 @@ static void iwl4965_rx_reply_rx_phy(struct iwl4965_priv *priv,
 	       sizeof(struct iwl4965_rx_phy_res));
 }
 
-static void iwl4965_rx_missed_beacon_notif(struct iwl4965_priv *priv,
+static void iwl4965_rx_missed_beacon_notif(struct iwl_priv *priv,
 					   struct iwl4965_rx_mem_buffer *rxb)
 
 {
@@ -4040,7 +4040,7 @@ static void iwl4965_rx_missed_beacon_notif(struct iwl4965_priv *priv,
 /**
  * iwl4965_sta_modify_enable_tid_tx - Enable Tx for this TID in station table
  */
-static void iwl4965_sta_modify_enable_tid_tx(struct iwl4965_priv *priv,
+static void iwl4965_sta_modify_enable_tid_tx(struct iwl_priv *priv,
 					 int sta_id, int tid)
 {
 	unsigned long flags;
@@ -4061,7 +4061,7 @@ static void iwl4965_sta_modify_enable_tid_tx(struct iwl4965_priv *priv,
  * Go through block-ack's bitmap of ACK'd frames, update driver's record of
  * ACK vs. not.  This gets sent to mac80211, then to rate scaling algo.
  */
-static int iwl4965_tx_status_reply_compressed_ba(struct iwl4965_priv *priv,
+static int iwl4965_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 						 struct iwl4965_ht_agg *agg,
 						 struct iwl4965_compressed_ba_resp*
 						 ba_resp)
@@ -4126,7 +4126,7 @@ static int iwl4965_tx_status_reply_compressed_ba(struct iwl4965_priv *priv,
 /**
  * iwl4965_tx_queue_stop_scheduler - Stop queue, but keep configuration
  */
-static void iwl4965_tx_queue_stop_scheduler(struct iwl4965_priv *priv,
+static void iwl4965_tx_queue_stop_scheduler(struct iwl_priv *priv,
 					    u16 txq_id)
 {
 	/* Simply stop the queue, but don't change any configuration;
@@ -4141,7 +4141,7 @@ static void iwl4965_tx_queue_stop_scheduler(struct iwl4965_priv *priv,
  * txq_id must be greater than IWL_BACK_QUEUE_FIRST_ID
  * priv->lock must be held by the caller
  */
-static int iwl4965_tx_queue_agg_disable(struct iwl4965_priv *priv, u16 txq_id,
+static int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
 					u16 ssn_idx, u8 tx_fifo)
 {
 	int ret = 0;
@@ -4174,7 +4174,7 @@ static int iwl4965_tx_queue_agg_disable(struct iwl4965_priv *priv, u16 txq_id,
 	return 0;
 }
 
-int iwl4965_check_empty_hw_queue(struct iwl4965_priv *priv, int sta_id,
+int iwl4965_check_empty_hw_queue(struct iwl_priv *priv, int sta_id,
 					 u8 tid, int txq_id)
 {
 	struct iwl4965_queue *q = &priv->txq[txq_id].q;
@@ -4224,7 +4224,7 @@ static inline int iwl4965_queue_dec_wrap(int index, int n_bd)
  * Handles block-acknowledge notification from device, which reports success
  * of frames sent via aggregation.
  */
-static void iwl4965_rx_reply_compressed_ba(struct iwl4965_priv *priv,
+static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 					   struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -4292,7 +4292,7 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl4965_priv *priv,
 /**
  * iwl4965_tx_queue_set_q2ratid - Map unique receiver/tid combination to a queue
  */
-static int iwl4965_tx_queue_set_q2ratid(struct iwl4965_priv *priv, u16 ra_tid,
+static int iwl4965_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
 					u16 txq_id)
 {
 	u32 tbl_dw_addr;
@@ -4323,7 +4323,7 @@ static int iwl4965_tx_queue_set_q2ratid(struct iwl4965_priv *priv, u16 ra_tid,
  * NOTE:  txq_id must be greater than IWL_BACK_QUEUE_FIRST_ID,
  *        i.e. it must be one of the higher queues used for aggregation
  */
-static int iwl4965_tx_queue_agg_enable(struct iwl4965_priv *priv, int txq_id,
+static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 				       int tx_fifo, int sta_id, int tid,
 				       u16 ssn_idx)
 {
@@ -4400,7 +4400,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl4965_priv *priv, int txq_id,
  *       calling this function (which runs REPLY_TX_LINK_QUALITY_CMD,
  *       which requires station table entry to exist).
  */
-void iwl4965_add_station(struct iwl4965_priv *priv, const u8 *addr, int is_ap)
+void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 {
 	int i, r;
 	struct iwl4965_link_quality_cmd link_cmd = {
@@ -4445,7 +4445,7 @@ void iwl4965_add_station(struct iwl4965_priv *priv, const u8 *addr, int is_ap)
 
 #ifdef CONFIG_IWL4965_HT
 
-static u8 iwl4965_is_channel_extension(struct iwl4965_priv *priv,
+static u8 iwl4965_is_channel_extension(struct iwl_priv *priv,
 				       enum ieee80211_band band,
 				       u16 channel, u8 extension_chan_offset)
 {
@@ -4465,7 +4465,7 @@ static u8 iwl4965_is_channel_extension(struct iwl4965_priv *priv,
 	return 0;
 }
 
-static u8 iwl4965_is_fat_tx_allowed(struct iwl4965_priv *priv,
+static u8 iwl4965_is_fat_tx_allowed(struct iwl_priv *priv,
 				struct ieee80211_ht_info *sta_ht_inf)
 {
 	struct iwl_ht_info *iwl_ht_conf = &priv->current_ht_config;
@@ -4486,7 +4486,7 @@ static u8 iwl4965_is_fat_tx_allowed(struct iwl4965_priv *priv,
 					 iwl_ht_conf->extension_chan_offset));
 }
 
-void iwl4965_set_rxon_ht(struct iwl4965_priv *priv, struct iwl_ht_info *ht_info)
+void iwl4965_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 {
 	struct iwl4965_rxon_cmd *rxon = &priv->staging_rxon;
 	u32 val;
@@ -4540,7 +4540,7 @@ void iwl4965_set_rxon_ht(struct iwl4965_priv *priv, struct iwl_ht_info *ht_info)
 	return;
 }
 
-void iwl4965_set_ht_add_station(struct iwl4965_priv *priv, u8 index,
+void iwl4965_set_ht_add_station(struct iwl_priv *priv, u8 index,
 				struct ieee80211_ht_info *sta_ht_inf)
 {
 	__le32 sta_flags;
@@ -4585,7 +4585,7 @@ void iwl4965_set_ht_add_station(struct iwl4965_priv *priv, u8 index,
 	return;
 }
 
-static void iwl4965_sta_modify_add_ba_tid(struct iwl4965_priv *priv,
+static void iwl4965_sta_modify_add_ba_tid(struct iwl_priv *priv,
 					  int sta_id, int tid, u16 ssn)
 {
 	unsigned long flags;
@@ -4601,7 +4601,7 @@ static void iwl4965_sta_modify_add_ba_tid(struct iwl4965_priv *priv,
 	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
 
-static void iwl4965_sta_modify_del_ba_tid(struct iwl4965_priv *priv,
+static void iwl4965_sta_modify_del_ba_tid(struct iwl_priv *priv,
 					  int sta_id, int tid)
 {
 	unsigned long flags;
@@ -4622,7 +4622,7 @@ static void iwl4965_sta_modify_del_ba_tid(struct iwl4965_priv *priv,
  * Should never return anything < 7, because they should already
  * be in use as EDCA AC (0-3), Command (4), HCCA (5, 6).
  */
-static int iwl4965_txq_ctx_activate_free(struct iwl4965_priv *priv)
+static int iwl4965_txq_ctx_activate_free(struct iwl_priv *priv)
 {
 	int txq_id;
 
@@ -4635,7 +4635,7 @@ static int iwl4965_txq_ctx_activate_free(struct iwl4965_priv *priv)
 static int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, const u8 *da,
 				       u16 tid, u16 *start_seq_num)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	int sta_id;
 	int tx_fifo;
 	int txq_id;
@@ -4695,7 +4695,7 @@ static int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, const u8 *da,
 				      u16 tid)
 {
 
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	int tx_fifo_id, txq_id, sta_id, ssn = -1;
 	struct iwl4965_tid_data *tid_data;
 	int ret, write_ptr, read_ptr;
@@ -4756,7 +4756,7 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 			     enum ieee80211_ampdu_mlme_action action,
 			     const u8 *addr, u16 tid, u16 *ssn)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	int sta_id;
 	DECLARE_MAC_BUF(mac);
 
@@ -4789,7 +4789,7 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 #endif /* CONFIG_IWL4965_HT */
 
 /* Set up 4965-specific Rx frame reply handlers */
-void iwl4965_hw_rx_handler_setup(struct iwl4965_priv *priv)
+void iwl4965_hw_rx_handler_setup(struct iwl_priv *priv)
 {
 	/* Legacy Rx frames */
 	priv->rx_handlers[REPLY_4965_RX] = iwl4965_rx_reply_rx;
@@ -4806,7 +4806,7 @@ void iwl4965_hw_rx_handler_setup(struct iwl4965_priv *priv)
 #endif /* CONFIG_IWL4965_HT */
 }
 
-void iwl4965_hw_setup_deferred_work(struct iwl4965_priv *priv)
+void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv)
 {
 	INIT_WORK(&priv->txpower_work, iwl4965_bg_txpower_work);
 	INIT_WORK(&priv->statistics_work, iwl4965_bg_statistics_work);
@@ -4818,7 +4818,7 @@ void iwl4965_hw_setup_deferred_work(struct iwl4965_priv *priv)
 	priv->statistics_periodic.function = iwl4965_bg_statistics_periodic;
 }
 
-void iwl4965_hw_cancel_deferred_work(struct iwl4965_priv *priv)
+void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv)
 {
 	del_timer_sync(&priv->statistics_periodic);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 4426d0f..60353b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -315,13 +315,13 @@ enum {
 };
 
 struct iwl4965_cmd;
-struct iwl4965_priv;
+struct iwl_priv;
 
 struct iwl4965_cmd_meta {
 	struct iwl4965_cmd_meta *source;
 	union {
 		struct sk_buff *skb;
-		int (*callback)(struct iwl4965_priv *priv,
+		int (*callback)(struct iwl_priv *priv,
 				struct iwl4965_cmd *cmd, struct sk_buff *skb);
 	} __attribute__ ((packed)) u;
 
@@ -634,40 +634,40 @@ struct iwl4965_driver_hw_info {
  *
  *****************************************************************************/
 struct iwl4965_addsta_cmd;
-extern int iwl4965_send_add_station(struct iwl4965_priv *priv,
+extern int iwl4965_send_add_station(struct iwl_priv *priv,
 				struct iwl4965_addsta_cmd *sta, u8 flags);
-extern u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr,
+extern u8 iwl4965_add_station_flags(struct iwl_priv *priv, const u8 *addr,
 			  int is_ap, u8 flags, void *ht_data);
-extern int iwl4965_is_network_packet(struct iwl4965_priv *priv,
+extern int iwl4965_is_network_packet(struct iwl_priv *priv,
 				 struct ieee80211_hdr *header);
-extern int iwl4965_power_init_handle(struct iwl4965_priv *priv);
-extern void iwl4965_handle_data_packet_monitor(struct iwl4965_priv *priv,
+extern int iwl4965_power_init_handle(struct iwl_priv *priv);
+extern void iwl4965_handle_data_packet_monitor(struct iwl_priv *priv,
 					   struct iwl4965_rx_mem_buffer *rxb,
 					   void *data, short len,
 					   struct ieee80211_rx_status *stats,
 					   u16 phy_flags);
-extern int iwl4965_is_duplicate_packet(struct iwl4965_priv *priv,
+extern int iwl4965_is_duplicate_packet(struct iwl_priv *priv,
 				       struct ieee80211_hdr *header);
-extern int iwl4965_rx_queue_alloc(struct iwl4965_priv *priv);
-extern void iwl4965_rx_queue_reset(struct iwl4965_priv *priv,
+extern int iwl4965_rx_queue_alloc(struct iwl_priv *priv);
+extern void iwl4965_rx_queue_reset(struct iwl_priv *priv,
 			       struct iwl4965_rx_queue *rxq);
 extern int iwl4965_calc_db_from_ratio(int sig_ratio);
 extern int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm);
-extern int iwl4965_tx_queue_init(struct iwl4965_priv *priv,
+extern int iwl4965_tx_queue_init(struct iwl_priv *priv,
 			     struct iwl4965_tx_queue *txq, int count, u32 id);
 extern void iwl4965_rx_replenish(void *data);
-extern void iwl4965_tx_queue_free(struct iwl4965_priv *priv, struct iwl4965_tx_queue *txq);
-extern int iwl4965_send_cmd_pdu(struct iwl4965_priv *priv, u8 id, u16 len,
+extern void iwl4965_tx_queue_free(struct iwl_priv *priv, struct iwl4965_tx_queue *txq);
+extern int iwl4965_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
 			    const void *data);
-extern int __must_check iwl4965_send_cmd(struct iwl4965_priv *priv,
+extern int __must_check iwl4965_send_cmd(struct iwl_priv *priv,
 		struct iwl4965_host_cmd *cmd);
-extern unsigned int iwl4965_fill_beacon_frame(struct iwl4965_priv *priv,
+extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,
 					const u8 *dest, int left);
-extern int iwl4965_rx_queue_update_write_ptr(struct iwl4965_priv *priv,
+extern int iwl4965_rx_queue_update_write_ptr(struct iwl_priv *priv,
 					 struct iwl4965_rx_queue *q);
-extern int iwl4965_send_statistics_request(struct iwl4965_priv *priv);
-extern void iwl4965_set_decrypted_flag(struct iwl4965_priv *priv, struct sk_buff *skb,
+extern int iwl4965_send_statistics_request(struct iwl_priv *priv);
+extern void iwl4965_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
 				   u32 decrypt_res,
 				   struct ieee80211_rx_status *stats);
 extern __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr);
@@ -678,7 +678,7 @@ extern const u8 iwl4965_broadcast_addr[ETH_ALEN];
  * Currently used by iwl-3945-rs... look at restructuring so that it doesn't
  * call this... todo... fix that.
 */
-extern u8 iwl4965_sync_station(struct iwl4965_priv *priv, int sta_id,
+extern u8 iwl4965_sync_station(struct iwl_priv *priv, int sta_id,
 			   u16 tx_rate, u8 flags);
 
 /******************************************************************************
@@ -697,36 +697,36 @@ extern u8 iwl4965_sync_station(struct iwl4965_priv *priv, int sta_id,
  * iwl4965_mac_     <-- mac80211 callback
  *
  ****************************************************************************/
-extern void iwl4965_hw_rx_handler_setup(struct iwl4965_priv *priv);
-extern void iwl4965_hw_setup_deferred_work(struct iwl4965_priv *priv);
-extern void iwl4965_hw_cancel_deferred_work(struct iwl4965_priv *priv);
-extern int iwl4965_hw_rxq_stop(struct iwl4965_priv *priv);
-extern int iwl4965_hw_set_hw_setting(struct iwl4965_priv *priv);
-extern int iwl4965_hw_nic_init(struct iwl4965_priv *priv);
-extern int iwl4965_hw_nic_stop_master(struct iwl4965_priv *priv);
-extern void iwl4965_hw_txq_ctx_free(struct iwl4965_priv *priv);
-extern void iwl4965_hw_txq_ctx_stop(struct iwl4965_priv *priv);
-extern int iwl4965_hw_nic_reset(struct iwl4965_priv *priv);
-extern int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl4965_priv *priv, void *tfd,
+extern void iwl4965_hw_rx_handler_setup(struct iwl_priv *priv);
+extern void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv);
+extern void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv);
+extern int iwl4965_hw_rxq_stop(struct iwl_priv *priv);
+extern int iwl4965_hw_set_hw_setting(struct iwl_priv *priv);
+extern int iwl4965_hw_nic_init(struct iwl_priv *priv);
+extern int iwl4965_hw_nic_stop_master(struct iwl_priv *priv);
+extern void iwl4965_hw_txq_ctx_free(struct iwl_priv *priv);
+extern void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv);
+extern int iwl4965_hw_nic_reset(struct iwl_priv *priv);
+extern int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
 					dma_addr_t addr, u16 len);
-extern int iwl4965_hw_txq_free_tfd(struct iwl4965_priv *priv, struct iwl4965_tx_queue *txq);
-extern int iwl4965_hw_get_temperature(struct iwl4965_priv *priv);
-extern int iwl4965_hw_tx_queue_init(struct iwl4965_priv *priv,
+extern int iwl4965_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl4965_tx_queue *txq);
+extern int iwl4965_hw_get_temperature(struct iwl_priv *priv);
+extern int iwl4965_hw_tx_queue_init(struct iwl_priv *priv,
 				struct iwl4965_tx_queue *txq);
-extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl4965_priv *priv,
+extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl4965_frame *frame, u8 rate);
-extern int iwl4965_hw_get_rx_read(struct iwl4965_priv *priv);
-extern void iwl4965_hw_build_tx_cmd_rate(struct iwl4965_priv *priv,
+extern int iwl4965_hw_get_rx_read(struct iwl_priv *priv);
+extern void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 				     struct iwl4965_cmd *cmd,
 				     struct ieee80211_tx_control *ctrl,
 				     struct ieee80211_hdr *hdr,
 				     int sta_id, int tx_id);
-extern int iwl4965_hw_reg_send_txpower(struct iwl4965_priv *priv);
-extern int iwl4965_hw_reg_set_txpower(struct iwl4965_priv *priv, s8 power);
-extern void iwl4965_hw_rx_statistics(struct iwl4965_priv *priv,
+extern int iwl4965_hw_reg_send_txpower(struct iwl_priv *priv);
+extern int iwl4965_hw_reg_set_txpower(struct iwl_priv *priv, s8 power);
+extern void iwl4965_hw_rx_statistics(struct iwl_priv *priv,
 				 struct iwl4965_rx_mem_buffer *rxb);
-extern void iwl4965_disable_events(struct iwl4965_priv *priv);
-extern int iwl4965_get_temperature(const struct iwl4965_priv *priv);
+extern void iwl4965_disable_events(struct iwl_priv *priv);
+extern int iwl4965_get_temperature(const struct iwl_priv *priv);
 
 /**
  * iwl4965_hw_find_station - Find station id for a given BSSID
@@ -736,48 +736,48 @@ extern int iwl4965_get_temperature(const struct iwl4965_priv *priv);
  * not yet been merged into a single common layer for managing the
  * station tables.
  */
-extern u8 iwl4965_hw_find_station(struct iwl4965_priv *priv, const u8 *bssid);
+extern u8 iwl4965_hw_find_station(struct iwl_priv *priv, const u8 *bssid);
 
-extern int iwl4965_hw_channel_switch(struct iwl4965_priv *priv, u16 channel);
-extern int iwl4965_tx_queue_reclaim(struct iwl4965_priv *priv, int txq_id, int index);
+extern int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel);
+extern int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
 extern int iwl4965_queue_space(const struct iwl4965_queue *q);
-struct iwl4965_priv;
+struct iwl_priv;
 
 /*
  * Forward declare iwl-4965.c functions for iwl-base.c
  */
-extern int iwl4965_tx_queue_update_wr_ptr(struct iwl4965_priv *priv,
+extern int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
 					  struct iwl4965_tx_queue *txq,
 					  u16 byte_cnt);
-extern void iwl4965_add_station(struct iwl4965_priv *priv, const u8 *addr,
+extern void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr,
 				int is_ap);
-extern void iwl4965_set_rxon_chain(struct iwl4965_priv *priv);
-extern int iwl4965_alive_notify(struct iwl4965_priv *priv);
-extern void iwl4965_update_rate_scaling(struct iwl4965_priv *priv, u8 mode);
-extern void iwl4965_chain_noise_reset(struct iwl4965_priv *priv);
-extern void iwl4965_init_sensitivity(struct iwl4965_priv *priv, u8 flags,
+extern void iwl4965_set_rxon_chain(struct iwl_priv *priv);
+extern int iwl4965_alive_notify(struct iwl_priv *priv);
+extern void iwl4965_update_rate_scaling(struct iwl_priv *priv, u8 mode);
+extern void iwl4965_chain_noise_reset(struct iwl_priv *priv);
+extern void iwl4965_init_sensitivity(struct iwl_priv *priv, u8 flags,
 				     u8 force);
-extern int iwl4965_set_fat_chan_info(struct iwl4965_priv *priv,
+extern int iwl4965_set_fat_chan_info(struct iwl_priv *priv,
 				enum ieee80211_band band,
 				u16 channel,
 				const struct iwl4965_eeprom_channel *eeprom_ch,
 				u8 fat_extension_channel);
-extern void iwl4965_rf_kill_ct_config(struct iwl4965_priv *priv);
-extern void iwl4965_hwrate_to_tx_control(struct iwl4965_priv *priv,
+extern void iwl4965_rf_kill_ct_config(struct iwl_priv *priv);
+extern void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv,
 					 u32 rate_n_flags,
 					 struct ieee80211_tx_control *control);
 
 #ifdef CONFIG_IWL4965_HT
 void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
 			      enum ieee80211_band band);
-void iwl4965_set_rxon_ht(struct iwl4965_priv *priv,
+void iwl4965_set_rxon_ht(struct iwl_priv *priv,
 			 struct iwl_ht_info *ht_info);
-void iwl4965_set_ht_add_station(struct iwl4965_priv *priv, u8 index,
+void iwl4965_set_ht_add_station(struct iwl_priv *priv, u8 index,
 				struct ieee80211_ht_info *sta_ht_inf);
 int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 				    enum ieee80211_ampdu_mlme_action action,
 				    const u8 *addr, u16 tid, u16 *ssn);
-int iwl4965_check_empty_hw_queue(struct iwl4965_priv *priv, int sta_id,
+int iwl4965_check_empty_hw_queue(struct iwl_priv *priv, int sta_id,
 					u8 tid, int txq_id);
 #else
 static inline void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
@@ -966,7 +966,7 @@ enum {
 
 #endif
 
-struct iwl4965_priv {
+struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
 	struct ieee80211_hw *hw;
@@ -982,7 +982,7 @@ struct iwl4965_priv {
 	int alloc_rxb_skb;
 	bool add_radiotap;
 
-	void (*rx_handlers[REPLY_MAX])(struct iwl4965_priv *priv,
+	void (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
 				       struct iwl4965_rx_mem_buffer *rxb);
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
@@ -1214,9 +1214,9 @@ struct iwl4965_priv {
 #endif
 	struct work_struct statistics_work;
 	struct timer_list statistics_periodic;
-}; /*iwl4965_priv */
+}; /*iwl_priv */
 
-static inline int iwl4965_is_associated(struct iwl4965_priv *priv)
+static inline int iwl4965_is_associated(struct iwl_priv *priv)
 {
 	return (priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
 }
@@ -1259,9 +1259,9 @@ static inline int is_channel_ibss(const struct iwl4965_channel_info *ch)
 }
 
 extern const struct iwl4965_channel_info *iwl4965_get_channel_info(
-	const struct iwl4965_priv *priv, enum ieee80211_band band, u16 channel);
+	const struct iwl_priv *priv, enum ieee80211_band band, u16 channel);
 
-/* Requires full declaration of iwl4965_priv before including */
+/* Requires full declaration of iwl_priv before including */
 #include "iwl-4965-io.h"
 
 #endif				/* __iwl4965_4965_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 4fd1b36..ccacd48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -81,7 +81,7 @@
  *
 ******************************************************************************/
 
-int iwlcore_eeprom_verify_signature(struct iwl4965_priv *priv)
+int iwlcore_eeprom_verify_signature(struct iwl_priv *priv)
 {
 	u32 gp = iwl4965_read32(priv, CSR_EEPROM_GP);
 	if ((gp & CSR_EEPROM_GP_VALID_MSK) == CSR_EEPROM_GP_BAD_SIGNATURE) {
@@ -98,7 +98,7 @@ EXPORT_SYMBOL(iwlcore_eeprom_verify_signature);
  * EEPROM chip, not a single event, so even reads could conflict if they
  * weren't arbitrated by the semaphore.
  */
-int iwlcore_eeprom_acquire_semaphore(struct iwl4965_priv *priv)
+int iwlcore_eeprom_acquire_semaphore(struct iwl_priv *priv)
 {
 	u16 count;
 	int ret;
@@ -124,7 +124,7 @@ int iwlcore_eeprom_acquire_semaphore(struct iwl4965_priv *priv)
 }
 EXPORT_SYMBOL(iwlcore_eeprom_acquire_semaphore);
 
-void iwlcore_eeprom_release_semaphore(struct iwl4965_priv *priv)
+void iwlcore_eeprom_release_semaphore(struct iwl_priv *priv)
 {
 	iwl4965_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
 		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
@@ -140,7 +140,7 @@ EXPORT_SYMBOL(iwlcore_eeprom_release_semaphore);
  *
  * NOTE:  This routine uses the non-debug IO access functions.
  */
-int iwl_eeprom_init(struct iwl4965_priv *priv)
+int iwl_eeprom_init(struct iwl_priv *priv)
 {
 	u16 *e = (u16 *)&priv->eeprom;
 	u32 gp = iwl4965_read32(priv, CSR_EEPROM_GP);
@@ -197,7 +197,7 @@ done:
 EXPORT_SYMBOL(iwl_eeprom_init);
 
 
-void iwl_eeprom_get_mac(const struct iwl4965_priv *priv, u8 *mac)
+void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac)
 {
 	memcpy(mac, priv->eeprom.mac_address, 6);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 7827566..ad486fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -63,7 +63,7 @@
 #ifndef __iwl_eeprom_h__
 #define __iwl_eeprom_h__
 
-struct iwl4965_priv;
+struct iwl_priv;
 
 /*
  * EEPROM access time values:
@@ -383,17 +383,17 @@ struct iwl4965_eeprom {
 /* End of EEPROM */
 
 struct iwl_eeprom_ops {
-	int (*verify_signature) (struct iwl4965_priv *priv);
-	int (*acquire_semaphore) (struct iwl4965_priv *priv);
-	void (*release_semaphore) (struct iwl4965_priv *priv);
+	int (*verify_signature) (struct iwl_priv *priv);
+	int (*acquire_semaphore) (struct iwl_priv *priv);
+	void (*release_semaphore) (struct iwl_priv *priv);
 };
 
 
-void iwl_eeprom_get_mac(const struct iwl4965_priv *priv, u8 *mac);
-int iwl_eeprom_init(struct iwl4965_priv *priv);
+void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac);
+int iwl_eeprom_init(struct iwl_priv *priv);
 
-int iwlcore_eeprom_verify_signature(struct iwl4965_priv *priv);
-int iwlcore_eeprom_acquire_semaphore(struct iwl4965_priv *priv);
-void iwlcore_eeprom_release_semaphore(struct iwl4965_priv *priv);
+int iwlcore_eeprom_verify_signature(struct iwl_priv *priv);
+int iwlcore_eeprom_acquire_semaphore(struct iwl_priv *priv);
+void iwlcore_eeprom_release_semaphore(struct iwl_priv *priv);
 
 #endif  /* __iwl_eeprom_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index e05bc90..4e899ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -50,7 +50,7 @@
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
 
-static int iwl4965_tx_queue_update_write_ptr(struct iwl4965_priv *priv,
+static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl4965_tx_queue *txq);
 
 /******************************************************************************
@@ -107,7 +107,7 @@ __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr)
 }
 
 static const struct ieee80211_supported_band *iwl4965_get_hw_mode(
-		struct iwl4965_priv *priv, enum ieee80211_band band)
+		struct iwl_priv *priv, enum ieee80211_band band)
 {
 	return priv->hw->wiphy->bands[band];
 }
@@ -216,7 +216,7 @@ static inline u8 get_cmd_index(struct iwl4965_queue *q, u32 index, int is_huge)
 /**
  * iwl4965_queue_init - Initialize queue's high/low-water and read/write indexes
  */
-static int iwl4965_queue_init(struct iwl4965_priv *priv, struct iwl4965_queue *q,
+static int iwl4965_queue_init(struct iwl_priv *priv, struct iwl4965_queue *q,
 			  int count, int slots_num, u32 id)
 {
 	q->n_bd = count;
@@ -247,7 +247,7 @@ static int iwl4965_queue_init(struct iwl4965_priv *priv, struct iwl4965_queue *q
 /**
  * iwl4965_tx_queue_alloc - Alloc driver data and TFD CB for one Tx/cmd queue
  */
-static int iwl4965_tx_queue_alloc(struct iwl4965_priv *priv,
+static int iwl4965_tx_queue_alloc(struct iwl_priv *priv,
 			      struct iwl4965_tx_queue *txq, u32 id)
 {
 	struct pci_dev *dev = priv->pci_dev;
@@ -292,7 +292,7 @@ static int iwl4965_tx_queue_alloc(struct iwl4965_priv *priv,
 /**
  * iwl4965_tx_queue_init - Allocate and initialize one tx/cmd queue
  */
-int iwl4965_tx_queue_init(struct iwl4965_priv *priv,
+int iwl4965_tx_queue_init(struct iwl_priv *priv,
 		      struct iwl4965_tx_queue *txq, int slots_num, u32 txq_id)
 {
 	struct pci_dev *dev = priv->pci_dev;
@@ -344,7 +344,7 @@ int iwl4965_tx_queue_init(struct iwl4965_priv *priv,
  * Free all buffers.
  * 0-fill, but do not free "txq" descriptor structure.
  */
-void iwl4965_tx_queue_free(struct iwl4965_priv *priv, struct iwl4965_tx_queue *txq)
+void iwl4965_tx_queue_free(struct iwl_priv *priv, struct iwl4965_tx_queue *txq)
 {
 	struct iwl4965_queue *q = &txq->q;
 	struct pci_dev *dev = priv->pci_dev;
@@ -395,7 +395,7 @@ const u8 iwl4965_broadcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
  *
  * NOTE:  This does not remove station from device's station table.
  */
-static u8 iwl4965_remove_station(struct iwl4965_priv *priv, const u8 *addr, int is_ap)
+static u8 iwl4965_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 {
 	int index = IWL_INVALID_STATION;
 	int i;
@@ -437,7 +437,7 @@ out:
  *
  * NOTE:  This does not clear or otherwise alter the device's station table.
  */
-static void iwl4965_clear_stations_table(struct iwl4965_priv *priv)
+static void iwl4965_clear_stations_table(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
@@ -452,7 +452,7 @@ static void iwl4965_clear_stations_table(struct iwl4965_priv *priv)
 /**
  * iwl4965_add_station_flags - Add station to tables in driver and device
  */
-u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr,
+u8 iwl4965_add_station_flags(struct iwl_priv *priv, const u8 *addr,
 				int is_ap, u8 flags, void *ht_data)
 {
 	int i;
@@ -524,7 +524,7 @@ u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr,
 
 /*************** DRIVER STATUS FUNCTIONS   *****/
 
-static inline int iwl4965_is_ready(struct iwl4965_priv *priv)
+static inline int iwl4965_is_ready(struct iwl_priv *priv)
 {
 	/* The adapter is 'ready' if READY and GEO_CONFIGURED bits are
 	 * set but EXIT_PENDING is not */
@@ -533,23 +533,23 @@ static inline int iwl4965_is_ready(struct iwl4965_priv *priv)
 	       !test_bit(STATUS_EXIT_PENDING, &priv->status);
 }
 
-static inline int iwl4965_is_alive(struct iwl4965_priv *priv)
+static inline int iwl4965_is_alive(struct iwl_priv *priv)
 {
 	return test_bit(STATUS_ALIVE, &priv->status);
 }
 
-static inline int iwl4965_is_init(struct iwl4965_priv *priv)
+static inline int iwl4965_is_init(struct iwl_priv *priv)
 {
 	return test_bit(STATUS_INIT, &priv->status);
 }
 
-static inline int iwl4965_is_rfkill(struct iwl4965_priv *priv)
+static inline int iwl4965_is_rfkill(struct iwl_priv *priv)
 {
 	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
 	       test_bit(STATUS_RF_KILL_SW, &priv->status);
 }
 
-static inline int iwl4965_is_ready_rf(struct iwl4965_priv *priv)
+static inline int iwl4965_is_ready_rf(struct iwl_priv *priv)
 {
 
 	if (iwl4965_is_rfkill(priv))
@@ -628,7 +628,7 @@ static const char *get_cmd_string(u8 cmd)
  * failed. On success, it turns the index (> 0) of command in the
  * command queue.
  */
-static int iwl4965_enqueue_hcmd(struct iwl4965_priv *priv, struct iwl4965_host_cmd *cmd)
+static int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl4965_host_cmd *cmd)
 {
 	struct iwl4965_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 	struct iwl4965_queue *q = &txq->q;
@@ -703,7 +703,7 @@ static int iwl4965_enqueue_hcmd(struct iwl4965_priv *priv, struct iwl4965_host_c
 	return ret ? ret : idx;
 }
 
-static int iwl4965_send_cmd_async(struct iwl4965_priv *priv, struct iwl4965_host_cmd *cmd)
+static int iwl4965_send_cmd_async(struct iwl_priv *priv, struct iwl4965_host_cmd *cmd)
 {
 	int ret;
 
@@ -727,7 +727,7 @@ static int iwl4965_send_cmd_async(struct iwl4965_priv *priv, struct iwl4965_host
 	return 0;
 }
 
-static int iwl4965_send_cmd_sync(struct iwl4965_priv *priv, struct iwl4965_host_cmd *cmd)
+static int iwl4965_send_cmd_sync(struct iwl_priv *priv, struct iwl4965_host_cmd *cmd)
 {
 	int cmd_idx;
 	int ret;
@@ -815,7 +815,7 @@ out:
 	return ret;
 }
 
-int iwl4965_send_cmd(struct iwl4965_priv *priv, struct iwl4965_host_cmd *cmd)
+int iwl4965_send_cmd(struct iwl_priv *priv, struct iwl4965_host_cmd *cmd)
 {
 	if (cmd->meta.flags & CMD_ASYNC)
 		return iwl4965_send_cmd_async(priv, cmd);
@@ -823,7 +823,7 @@ int iwl4965_send_cmd(struct iwl4965_priv *priv, struct iwl4965_host_cmd *cmd)
 	return iwl4965_send_cmd_sync(priv, cmd);
 }
 
-int iwl4965_send_cmd_pdu(struct iwl4965_priv *priv, u8 id, u16 len, const void *data)
+int iwl4965_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len, const void *data)
 {
 	struct iwl4965_host_cmd cmd = {
 		.id = id,
@@ -834,7 +834,7 @@ int iwl4965_send_cmd_pdu(struct iwl4965_priv *priv, u8 id, u16 len, const void *
 	return iwl4965_send_cmd_sync(priv, &cmd);
 }
 
-static int __must_check iwl4965_send_cmd_u32(struct iwl4965_priv *priv, u8 id, u32 val)
+static int __must_check iwl4965_send_cmd_u32(struct iwl_priv *priv, u8 id, u32 val)
 {
 	struct iwl4965_host_cmd cmd = {
 		.id = id,
@@ -845,7 +845,7 @@ static int __must_check iwl4965_send_cmd_u32(struct iwl4965_priv *priv, u8 id, u
 	return iwl4965_send_cmd_sync(priv, &cmd);
 }
 
-int iwl4965_send_statistics_request(struct iwl4965_priv *priv)
+int iwl4965_send_statistics_request(struct iwl_priv *priv)
 {
 	return iwl4965_send_cmd_u32(priv, REPLY_STATISTICS_CMD, 0);
 }
@@ -856,7 +856,7 @@ int iwl4965_send_statistics_request(struct iwl4965_priv *priv)
  * there is only one AP station with id= IWL_AP_ID
  * NOTE: mutex must be held before calling this fnction
  */
-static int iwl4965_rxon_add_station(struct iwl4965_priv *priv,
+static int iwl4965_rxon_add_station(struct iwl_priv *priv,
 				const u8 *addr, int is_ap)
 {
 	u8 sta_id;
@@ -892,7 +892,7 @@ static int iwl4965_rxon_add_station(struct iwl4965_priv *priv,
  * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
  * in the staging RXON flag structure based on the phymode
  */
-static int iwl4965_set_rxon_channel(struct iwl4965_priv *priv,
+static int iwl4965_set_rxon_channel(struct iwl_priv *priv,
 				    enum ieee80211_band band,
 				 u16 channel)
 {
@@ -1000,7 +1000,7 @@ static int iwl4965_check_rxon_cmd(struct iwl4965_rxon_cmd *rxon)
  * or is clearing the RXON_FILTER_ASSOC_MSK, then return 1 to indicate that
  * a new tune (full RXON command, rather than RXON_ASSOC cmd) is required.
  */
-static int iwl4965_full_rxon_required(struct iwl4965_priv *priv)
+static int iwl4965_full_rxon_required(struct iwl_priv *priv)
 {
 
 	/* These items are only settable from the full RXON command */
@@ -1040,7 +1040,7 @@ static int iwl4965_full_rxon_required(struct iwl4965_priv *priv)
 	return 0;
 }
 
-static int iwl4965_send_rxon_assoc(struct iwl4965_priv *priv)
+static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
 {
 	int rc = 0;
 	struct iwl4965_rx_packet *res = NULL;
@@ -1102,7 +1102,7 @@ static int iwl4965_send_rxon_assoc(struct iwl4965_priv *priv)
  * function correctly transitions out of the RXON_ASSOC_MSK state if
  * a HW tune is required based on the RXON structure changes.
  */
-static int iwl4965_commit_rxon(struct iwl4965_priv *priv)
+static int iwl4965_commit_rxon(struct iwl_priv *priv)
 {
 	/* cast away the const for active_rxon in this function */
 	struct iwl4965_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
@@ -1230,7 +1230,7 @@ static int iwl4965_commit_rxon(struct iwl4965_priv *priv)
 	return 0;
 }
 
-static int iwl4965_send_bt_config(struct iwl4965_priv *priv)
+static int iwl4965_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl4965_bt_cmd bt_cmd = {
 		.flags = 3,
@@ -1244,7 +1244,7 @@ static int iwl4965_send_bt_config(struct iwl4965_priv *priv)
 				sizeof(struct iwl4965_bt_cmd), &bt_cmd);
 }
 
-static int iwl4965_send_scan_abort(struct iwl4965_priv *priv)
+static int iwl4965_send_scan_abort(struct iwl_priv *priv)
 {
 	int rc = 0;
 	struct iwl4965_rx_packet *res;
@@ -1285,7 +1285,7 @@ static int iwl4965_send_scan_abort(struct iwl4965_priv *priv)
 	return rc;
 }
 
-static int iwl4965_card_state_sync_callback(struct iwl4965_priv *priv,
+static int iwl4965_card_state_sync_callback(struct iwl_priv *priv,
 					struct iwl4965_cmd *cmd,
 					struct sk_buff *skb)
 {
@@ -1302,7 +1302,7 @@ static int iwl4965_card_state_sync_callback(struct iwl4965_priv *priv,
  * When in the 'halt' state, the card is shut down and must be fully
  * restarted to come back on.
  */
-static int iwl4965_send_card_state(struct iwl4965_priv *priv, u32 flags, u8 meta_flag)
+static int iwl4965_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_flag)
 {
 	struct iwl4965_host_cmd cmd = {
 		.id = REPLY_CARD_STATE_CMD,
@@ -1317,7 +1317,7 @@ static int iwl4965_send_card_state(struct iwl4965_priv *priv, u32 flags, u8 meta
 	return iwl4965_send_cmd(priv, &cmd);
 }
 
-static int iwl4965_add_sta_sync_callback(struct iwl4965_priv *priv,
+static int iwl4965_add_sta_sync_callback(struct iwl_priv *priv,
 				     struct iwl4965_cmd *cmd, struct sk_buff *skb)
 {
 	struct iwl4965_rx_packet *res = NULL;
@@ -1345,7 +1345,7 @@ static int iwl4965_add_sta_sync_callback(struct iwl4965_priv *priv,
 	return 1;
 }
 
-int iwl4965_send_add_station(struct iwl4965_priv *priv,
+int iwl4965_send_add_station(struct iwl_priv *priv,
 			 struct iwl4965_addsta_cmd *sta, u8 flags)
 {
 	struct iwl4965_rx_packet *res = NULL;
@@ -1392,7 +1392,7 @@ int iwl4965_send_add_station(struct iwl4965_priv *priv,
 	return rc;
 }
 
-static int iwl4965_update_sta_key_info(struct iwl4965_priv *priv,
+static int iwl4965_update_sta_key_info(struct iwl_priv *priv,
 				   struct ieee80211_key_conf *keyconf,
 				   u8 sta_id)
 {
@@ -1430,7 +1430,7 @@ static int iwl4965_update_sta_key_info(struct iwl4965_priv *priv,
 	return 0;
 }
 
-static int iwl4965_clear_sta_key_info(struct iwl4965_priv *priv, u8 sta_id)
+static int iwl4965_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
 {
 	unsigned long flags;
 
@@ -1447,7 +1447,7 @@ static int iwl4965_clear_sta_key_info(struct iwl4965_priv *priv, u8 sta_id)
 	return 0;
 }
 
-static void iwl4965_clear_free_frames(struct iwl4965_priv *priv)
+static void iwl4965_clear_free_frames(struct iwl_priv *priv)
 {
 	struct list_head *element;
 
@@ -1468,7 +1468,7 @@ static void iwl4965_clear_free_frames(struct iwl4965_priv *priv)
 	}
 }
 
-static struct iwl4965_frame *iwl4965_get_free_frame(struct iwl4965_priv *priv)
+static struct iwl4965_frame *iwl4965_get_free_frame(struct iwl_priv *priv)
 {
 	struct iwl4965_frame *frame;
 	struct list_head *element;
@@ -1488,13 +1488,13 @@ static struct iwl4965_frame *iwl4965_get_free_frame(struct iwl4965_priv *priv)
 	return list_entry(element, struct iwl4965_frame, list);
 }
 
-static void iwl4965_free_frame(struct iwl4965_priv *priv, struct iwl4965_frame *frame)
+static void iwl4965_free_frame(struct iwl_priv *priv, struct iwl4965_frame *frame)
 {
 	memset(frame, 0, sizeof(*frame));
 	list_add(&frame->list, &priv->free_frames);
 }
 
-unsigned int iwl4965_fill_beacon_frame(struct iwl4965_priv *priv,
+unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 				struct ieee80211_hdr *hdr,
 				const u8 *dest, int left)
 {
@@ -1525,7 +1525,7 @@ static u8 iwl4965_rate_get_lowest_plcp(int rate_mask)
 	return IWL_RATE_INVALID;
 }
 
-static int iwl4965_send_beacon_cmd(struct iwl4965_priv *priv)
+static int iwl4965_send_beacon_cmd(struct iwl_priv *priv)
 {
 	struct iwl4965_frame *frame;
 	unsigned int frame_size;
@@ -1567,7 +1567,7 @@ static int iwl4965_send_beacon_cmd(struct iwl4965_priv *priv)
  *
  ******************************************************************************/
 
-static void iwl4965_unset_hw_setting(struct iwl4965_priv *priv)
+static void iwl4965_unset_hw_setting(struct iwl_priv *priv)
 {
 	if (priv->hw_setting.shared_virt)
 		pci_free_consistent(priv->pci_dev,
@@ -1608,7 +1608,7 @@ static u16 iwl4965_supported_rate_to_ie(u8 *ie, u16 supported_rate,
 /**
  * iwl4965_fill_probe_req - fill in all required fields and IE for probe request
  */
-static u16 iwl4965_fill_probe_req(struct iwl4965_priv *priv,
+static u16 iwl4965_fill_probe_req(struct iwl_priv *priv,
 				  enum ieee80211_band band,
 				  struct ieee80211_mgmt *frame,
 				  int left, int is_direct)
@@ -1726,7 +1726,7 @@ static u16 iwl4965_fill_probe_req(struct iwl4965_priv *priv,
 /*
  * QoS  support
 */
-static int iwl4965_send_qos_params_command(struct iwl4965_priv *priv,
+static int iwl4965_send_qos_params_command(struct iwl_priv *priv,
 				       struct iwl4965_qosparam_cmd *qos)
 {
 
@@ -1734,7 +1734,7 @@ static int iwl4965_send_qos_params_command(struct iwl4965_priv *priv,
 				sizeof(struct iwl4965_qosparam_cmd), qos);
 }
 
-static void iwl4965_reset_qos(struct iwl4965_priv *priv)
+static void iwl4965_reset_qos(struct iwl_priv *priv)
 {
 	u16 cw_min = 15;
 	u16 cw_max = 1023;
@@ -1821,7 +1821,7 @@ static void iwl4965_reset_qos(struct iwl4965_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static void iwl4965_activate_qos(struct iwl4965_priv *priv, u8 force)
+static void iwl4965_activate_qos(struct iwl_priv *priv, u8 force)
 {
 	unsigned long flags;
 
@@ -1899,7 +1899,7 @@ static struct iwl4965_power_vec_entry range_1[IWL_POWER_AC] = {
 		 SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
 };
 
-int iwl4965_power_init_handle(struct iwl4965_priv *priv)
+int iwl4965_power_init_handle(struct iwl_priv *priv)
 {
 	int rc = 0, i;
 	struct iwl4965_power_mgr *pow_data;
@@ -1938,7 +1938,7 @@ int iwl4965_power_init_handle(struct iwl4965_priv *priv)
 	return rc;
 }
 
-static int iwl4965_update_power_cmd(struct iwl4965_priv *priv,
+static int iwl4965_update_power_cmd(struct iwl_priv *priv,
 				struct iwl4965_powertable_cmd *cmd, u32 mode)
 {
 	int rc = 0, i;
@@ -2002,7 +2002,7 @@ static int iwl4965_update_power_cmd(struct iwl4965_priv *priv,
 	return rc;
 }
 
-static int iwl4965_send_power_mode(struct iwl4965_priv *priv, u32 mode)
+static int iwl4965_send_power_mode(struct iwl_priv *priv, u32 mode)
 {
 	u32 uninitialized_var(final_mode);
 	int rc;
@@ -2037,7 +2037,7 @@ static int iwl4965_send_power_mode(struct iwl4965_priv *priv, u32 mode)
 	return rc;
 }
 
-int iwl4965_is_network_packet(struct iwl4965_priv *priv, struct ieee80211_hdr *header)
+int iwl4965_is_network_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
 {
 	/* Filter incoming packets to determine if they are targeted toward
 	 * this network, discarding packets coming from ourselves */
@@ -2098,7 +2098,7 @@ static const char *iwl4965_get_tx_fail_reason(u32 status)
  *
  * NOTE: priv->mutex is not required before calling this function
  */
-static int iwl4965_scan_cancel(struct iwl4965_priv *priv)
+static int iwl4965_scan_cancel(struct iwl_priv *priv)
 {
 	if (!test_bit(STATUS_SCAN_HW, &priv->status)) {
 		clear_bit(STATUS_SCANNING, &priv->status);
@@ -2126,7 +2126,7 @@ static int iwl4965_scan_cancel(struct iwl4965_priv *priv)
  *
  * NOTE: priv->mutex must be held before calling this function
  */
-static int iwl4965_scan_cancel_timeout(struct iwl4965_priv *priv, unsigned long ms)
+static int iwl4965_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 {
 	unsigned long now = jiffies;
 	int ret;
@@ -2145,7 +2145,7 @@ static int iwl4965_scan_cancel_timeout(struct iwl4965_priv *priv, unsigned long
 	return ret;
 }
 
-static void iwl4965_sequence_reset(struct iwl4965_priv *priv)
+static void iwl4965_sequence_reset(struct iwl_priv *priv)
 {
 	/* Reset ieee stats */
 
@@ -2175,7 +2175,7 @@ static __le16 iwl4965_adjust_beacon_interval(u16 beacon_val)
 	return cpu_to_le16(new_val);
 }
 
-static void iwl4965_setup_rxon_timing(struct iwl4965_priv *priv)
+static void iwl4965_setup_rxon_timing(struct iwl_priv *priv)
 {
 	u64 interval_tm_unit;
 	u64 tsf, result;
@@ -2231,7 +2231,7 @@ static void iwl4965_setup_rxon_timing(struct iwl4965_priv *priv)
 		le16_to_cpu(priv->rxon_timing.atim_window));
 }
 
-static int iwl4965_scan_initiate(struct iwl4965_priv *priv)
+static int iwl4965_scan_initiate(struct iwl_priv *priv)
 {
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
 		IWL_ERROR("APs don't scan.\n");
@@ -2265,7 +2265,7 @@ static int iwl4965_scan_initiate(struct iwl4965_priv *priv)
 	return 0;
 }
 
-static int iwl4965_set_rxon_hwcrypto(struct iwl4965_priv *priv, int hw_decrypt)
+static int iwl4965_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
 {
 	struct iwl4965_rxon_cmd *rxon = &priv->staging_rxon;
 
@@ -2277,7 +2277,7 @@ static int iwl4965_set_rxon_hwcrypto(struct iwl4965_priv *priv, int hw_decrypt)
 	return 0;
 }
 
-static void iwl4965_set_flags_for_phymode(struct iwl4965_priv *priv,
+static void iwl4965_set_flags_for_phymode(struct iwl_priv *priv,
 					  enum ieee80211_band band)
 {
 	if (band == IEEE80211_BAND_5GHZ) {
@@ -2304,7 +2304,7 @@ static void iwl4965_set_flags_for_phymode(struct iwl4965_priv *priv,
 /*
  * initialize rxon structure with default values from eeprom
  */
-static void iwl4965_connection_init_rx_config(struct iwl4965_priv *priv)
+static void iwl4965_connection_init_rx_config(struct iwl_priv *priv)
 {
 	const struct iwl4965_channel_info *ch_info;
 
@@ -2376,7 +2376,7 @@ static void iwl4965_connection_init_rx_config(struct iwl4965_priv *priv)
 	iwl4965_set_rxon_chain(priv);
 }
 
-static int iwl4965_set_mode(struct iwl4965_priv *priv, int mode)
+static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
 {
 	if (mode == IEEE80211_IF_TYPE_IBSS) {
 		const struct iwl4965_channel_info *ch_info;
@@ -2415,7 +2415,7 @@ static int iwl4965_set_mode(struct iwl4965_priv *priv, int mode)
 	return 0;
 }
 
-static void iwl4965_build_tx_cmd_hwcrypto(struct iwl4965_priv *priv,
+static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      struct ieee80211_tx_control *ctl,
 				      struct iwl4965_cmd *cmd,
 				      struct sk_buff *skb_frag,
@@ -2466,7 +2466,7 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iwl4965_priv *priv,
 /*
  * handle build REPLY_TX command notification.
  */
-static void iwl4965_build_tx_cmd_basic(struct iwl4965_priv *priv,
+static void iwl4965_build_tx_cmd_basic(struct iwl_priv *priv,
 				  struct iwl4965_cmd *cmd,
 				  struct ieee80211_tx_control *ctrl,
 				  struct ieee80211_hdr *hdr,
@@ -2535,7 +2535,7 @@ static void iwl4965_build_tx_cmd_basic(struct iwl4965_priv *priv,
  *
  * If new IBSS station, create new entry in station table
  */
-static int iwl4965_get_sta_id(struct iwl4965_priv *priv,
+static int iwl4965_get_sta_id(struct iwl_priv *priv,
 				struct ieee80211_hdr *hdr)
 {
 	int sta_id;
@@ -2590,7 +2590,7 @@ static int iwl4965_get_sta_id(struct iwl4965_priv *priv,
 /*
  * start REPLY_TX command process
  */
-static int iwl4965_tx_skb(struct iwl4965_priv *priv,
+static int iwl4965_tx_skb(struct iwl_priv *priv,
 		      struct sk_buff *skb, struct ieee80211_tx_control *ctl)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -2829,7 +2829,7 @@ drop:
 	return -1;
 }
 
-static void iwl4965_set_rate(struct iwl4965_priv *priv)
+static void iwl4965_set_rate(struct iwl_priv *priv)
 {
 	const struct ieee80211_supported_band *hw = NULL;
 	struct ieee80211_rate *rate;
@@ -2876,7 +2876,7 @@ static void iwl4965_set_rate(struct iwl4965_priv *priv)
 		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
 }
 
-static void iwl4965_radio_kill_sw(struct iwl4965_priv *priv, int disable_radio)
+static void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 {
 	unsigned long flags;
 
@@ -2925,7 +2925,7 @@ static void iwl4965_radio_kill_sw(struct iwl4965_priv *priv, int disable_radio)
 	return;
 }
 
-void iwl4965_set_decrypted_flag(struct iwl4965_priv *priv, struct sk_buff *skb,
+void iwl4965_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
 			    u32 decrypt_res, struct ieee80211_rx_status *stats)
 {
 	u16 fc =
@@ -2960,7 +2960,7 @@ void iwl4965_set_decrypted_flag(struct iwl4965_priv *priv, struct sk_buff *skb,
 
 #define IWL_PACKET_RETRY_TIME HZ
 
-int iwl4965_is_duplicate_packet(struct iwl4965_priv *priv, struct ieee80211_hdr *header)
+int iwl4965_is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
 {
 	u16 sc = le16_to_cpu(header->seq_ctrl);
 	u16 seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
@@ -3077,7 +3077,7 @@ static __le32 iwl4965_add_beacon_time(u32 base, u32 addon, u32 beacon_interval)
 	return cpu_to_le32(res);
 }
 
-static int iwl4965_get_measurement(struct iwl4965_priv *priv,
+static int iwl4965_get_measurement(struct iwl_priv *priv,
 			       struct ieee80211_measurement_params *params,
 			       u8 type)
 {
@@ -3157,7 +3157,7 @@ static int iwl4965_get_measurement(struct iwl4965_priv *priv,
 }
 #endif
 
-static void iwl4965_txstatus_to_ieee(struct iwl4965_priv *priv,
+static void iwl4965_txstatus_to_ieee(struct iwl_priv *priv,
 				 struct iwl4965_tx_info *tx_sta)
 {
 
@@ -3183,7 +3183,7 @@ static void iwl4965_txstatus_to_ieee(struct iwl4965_priv *priv,
  * need to be reclaimed. As result, some free space forms.  If there is
  * enough free space (> low mark), wake the stack that feeds us.
  */
-int iwl4965_tx_queue_reclaim(struct iwl4965_priv *priv, int txq_id, int index)
+int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 {
 	struct iwl4965_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl4965_queue *q = &txq->q;
@@ -3234,7 +3234,7 @@ static int iwl4965_is_tx_success(u32 status)
  ******************************************************************************/
 #ifdef CONFIG_IWL4965_HT
 
-static inline int iwl4965_get_ra_sta_id(struct iwl4965_priv *priv,
+static inline int iwl4965_get_ra_sta_id(struct iwl_priv *priv,
 				    struct ieee80211_hdr *hdr)
 {
 	if (priv->iw_mode == IEEE80211_IF_TYPE_STA)
@@ -3246,7 +3246,7 @@ static inline int iwl4965_get_ra_sta_id(struct iwl4965_priv *priv,
 }
 
 static struct ieee80211_hdr *iwl4965_tx_queue_get_hdr(
-	struct iwl4965_priv *priv, int txq_id, int idx)
+	struct iwl_priv *priv, int txq_id, int idx)
 {
 	if (priv->txq[txq_id].txb[idx].skb[0])
 		return (struct ieee80211_hdr *)priv->txq[txq_id].
@@ -3265,7 +3265,7 @@ static inline u32 iwl4965_get_scd_ssn(struct iwl4965_tx_resp *tx_resp)
 /**
  * iwl4965_tx_status_reply_tx - Handle Tx rspnse for frames in aggregation queue
  */
-static int iwl4965_tx_status_reply_tx(struct iwl4965_priv *priv,
+static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 				      struct iwl4965_ht_agg *agg,
 				      struct iwl4965_tx_resp_agg *tx_resp,
 				      u16 start_idx)
@@ -3386,7 +3386,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl4965_priv *priv,
 /**
  * iwl4965_rx_reply_tx - Handle standard (non-aggregation) Tx response
  */
-static void iwl4965_rx_reply_tx(struct iwl4965_priv *priv,
+static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			    struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3497,7 +3497,7 @@ static void iwl4965_rx_reply_tx(struct iwl4965_priv *priv,
 }
 
 
-static void iwl4965_rx_reply_alive(struct iwl4965_priv *priv,
+static void iwl4965_rx_reply_alive(struct iwl_priv *priv,
 			       struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3533,7 +3533,7 @@ static void iwl4965_rx_reply_alive(struct iwl4965_priv *priv,
 		IWL_WARNING("uCode did not respond OK.\n");
 }
 
-static void iwl4965_rx_reply_add_sta(struct iwl4965_priv *priv,
+static void iwl4965_rx_reply_add_sta(struct iwl_priv *priv,
 				 struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3542,7 +3542,7 @@ static void iwl4965_rx_reply_add_sta(struct iwl4965_priv *priv,
 	return;
 }
 
-static void iwl4965_rx_reply_error(struct iwl4965_priv *priv,
+static void iwl4965_rx_reply_error(struct iwl_priv *priv,
 			       struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3558,7 +3558,7 @@ static void iwl4965_rx_reply_error(struct iwl4965_priv *priv,
 
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
-static void iwl4965_rx_csa(struct iwl4965_priv *priv, struct iwl4965_rx_mem_buffer *rxb)
+static void iwl4965_rx_csa(struct iwl_priv *priv, struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl4965_rxon_cmd *rxon = (void *)&priv->active_rxon;
@@ -3569,7 +3569,7 @@ static void iwl4965_rx_csa(struct iwl4965_priv *priv, struct iwl4965_rx_mem_buff
 	priv->staging_rxon.channel = csa->channel;
 }
 
-static void iwl4965_rx_spectrum_measure_notif(struct iwl4965_priv *priv,
+static void iwl4965_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl4965_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
@@ -3587,7 +3587,7 @@ static void iwl4965_rx_spectrum_measure_notif(struct iwl4965_priv *priv,
 #endif
 }
 
-static void iwl4965_rx_pm_sleep_notif(struct iwl4965_priv *priv,
+static void iwl4965_rx_pm_sleep_notif(struct iwl_priv *priv,
 				  struct iwl4965_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -3598,7 +3598,7 @@ static void iwl4965_rx_pm_sleep_notif(struct iwl4965_priv *priv,
 #endif
 }
 
-static void iwl4965_rx_pm_debug_statistics_notif(struct iwl4965_priv *priv,
+static void iwl4965_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 					     struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3610,8 +3610,8 @@ static void iwl4965_rx_pm_debug_statistics_notif(struct iwl4965_priv *priv,
 
 static void iwl4965_bg_beacon_update(struct work_struct *work)
 {
-	struct iwl4965_priv *priv =
-		container_of(work, struct iwl4965_priv, beacon_update);
+	struct iwl_priv *priv =
+		container_of(work, struct iwl_priv, beacon_update);
 	struct sk_buff *beacon;
 
 	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
@@ -3633,7 +3633,7 @@ static void iwl4965_bg_beacon_update(struct work_struct *work)
 	iwl4965_send_beacon_cmd(priv);
 }
 
-static void iwl4965_rx_beacon_notif(struct iwl4965_priv *priv,
+static void iwl4965_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl4965_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -3656,7 +3656,7 @@ static void iwl4965_rx_beacon_notif(struct iwl4965_priv *priv,
 }
 
 /* Service response to REPLY_SCAN_CMD (0x80) */
-static void iwl4965_rx_reply_scan(struct iwl4965_priv *priv,
+static void iwl4965_rx_reply_scan(struct iwl_priv *priv,
 			      struct iwl4965_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -3669,7 +3669,7 @@ static void iwl4965_rx_reply_scan(struct iwl4965_priv *priv,
 }
 
 /* Service SCAN_START_NOTIFICATION (0x82) */
-static void iwl4965_rx_scan_start_notif(struct iwl4965_priv *priv,
+static void iwl4965_rx_scan_start_notif(struct iwl_priv *priv,
 				    struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3686,7 +3686,7 @@ static void iwl4965_rx_scan_start_notif(struct iwl4965_priv *priv,
 }
 
 /* Service SCAN_RESULTS_NOTIFICATION (0x83) */
-static void iwl4965_rx_scan_results_notif(struct iwl4965_priv *priv,
+static void iwl4965_rx_scan_results_notif(struct iwl_priv *priv,
 				      struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3711,7 +3711,7 @@ static void iwl4965_rx_scan_results_notif(struct iwl4965_priv *priv,
 }
 
 /* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
-static void iwl4965_rx_scan_complete_notif(struct iwl4965_priv *priv,
+static void iwl4965_rx_scan_complete_notif(struct iwl_priv *priv,
 				       struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3769,7 +3769,7 @@ reschedule:
 
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
-static void iwl4965_rx_card_state_notif(struct iwl4965_priv *priv,
+static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
 				    struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3847,7 +3847,7 @@ static void iwl4965_rx_card_state_notif(struct iwl4965_priv *priv,
  * This function chains into the hardware specific files for them to setup
  * any hardware specific handlers as well.
  */
-static void iwl4965_setup_rx_handlers(struct iwl4965_priv *priv)
+static void iwl4965_setup_rx_handlers(struct iwl_priv *priv)
 {
 	priv->rx_handlers[REPLY_ALIVE] = iwl4965_rx_reply_alive;
 	priv->rx_handlers[REPLY_ADD_STA] = iwl4965_rx_reply_add_sta;
@@ -3889,7 +3889,7 @@ static void iwl4965_setup_rx_handlers(struct iwl4965_priv *priv)
  * will be executed.  The attached skb (if present) will only be freed
  * if the callback returns 1
  */
-static void iwl4965_tx_cmd_complete(struct iwl4965_priv *priv,
+static void iwl4965_tx_cmd_complete(struct iwl_priv *priv,
 				struct iwl4965_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (struct iwl4965_rx_packet *)rxb->skb->data;
@@ -4012,7 +4012,7 @@ static int iwl4965_rx_queue_space(const struct iwl4965_rx_queue *q)
 /**
  * iwl4965_rx_queue_update_write_ptr - Update the write pointer for the RX queue
  */
-int iwl4965_rx_queue_update_write_ptr(struct iwl4965_priv *priv, struct iwl4965_rx_queue *q)
+int iwl4965_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl4965_rx_queue *q)
 {
 	u32 reg = 0;
 	int rc = 0;
@@ -4058,7 +4058,7 @@ int iwl4965_rx_queue_update_write_ptr(struct iwl4965_priv *priv, struct iwl4965_
 /**
  * iwl4965_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
  */
-static inline __le32 iwl4965_dma_addr2rbd_ptr(struct iwl4965_priv *priv,
+static inline __le32 iwl4965_dma_addr2rbd_ptr(struct iwl_priv *priv,
 					  dma_addr_t dma_addr)
 {
 	return cpu_to_le32((u32)(dma_addr >> 8));
@@ -4076,7 +4076,7 @@ static inline __le32 iwl4965_dma_addr2rbd_ptr(struct iwl4965_priv *priv,
  * also updates the memory address in the firmware to reference the new
  * target buffer.
  */
-static int iwl4965_rx_queue_restock(struct iwl4965_priv *priv)
+static int iwl4965_rx_queue_restock(struct iwl_priv *priv)
 {
 	struct iwl4965_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
@@ -4128,7 +4128,7 @@ static int iwl4965_rx_queue_restock(struct iwl4965_priv *priv)
  * Also restock the Rx queue via iwl4965_rx_queue_restock.
  * This is called as a scheduled work item (except for during initialization)
  */
-static void iwl4965_rx_allocate(struct iwl4965_priv *priv)
+static void iwl4965_rx_allocate(struct iwl_priv *priv)
 {
 	struct iwl4965_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
@@ -4170,7 +4170,7 @@ static void iwl4965_rx_allocate(struct iwl4965_priv *priv)
 */
 static void __iwl4965_rx_replenish(void *data)
 {
-	struct iwl4965_priv *priv = data;
+	struct iwl_priv *priv = data;
 
 	iwl4965_rx_allocate(priv);
 	iwl4965_rx_queue_restock(priv);
@@ -4179,7 +4179,7 @@ static void __iwl4965_rx_replenish(void *data)
 
 void iwl4965_rx_replenish(void *data)
 {
-	struct iwl4965_priv *priv = data;
+	struct iwl_priv *priv = data;
 	unsigned long flags;
 
 	iwl4965_rx_allocate(priv);
@@ -4194,7 +4194,7 @@ void iwl4965_rx_replenish(void *data)
  * This free routine walks the list of POOL entries and if SKB is set to
  * non NULL it is unmapped and freed
  */
-static void iwl4965_rx_queue_free(struct iwl4965_priv *priv, struct iwl4965_rx_queue *rxq)
+static void iwl4965_rx_queue_free(struct iwl_priv *priv, struct iwl4965_rx_queue *rxq)
 {
 	int i;
 	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
@@ -4212,7 +4212,7 @@ static void iwl4965_rx_queue_free(struct iwl4965_priv *priv, struct iwl4965_rx_q
 	rxq->bd = NULL;
 }
 
-int iwl4965_rx_queue_alloc(struct iwl4965_priv *priv)
+int iwl4965_rx_queue_alloc(struct iwl_priv *priv)
 {
 	struct iwl4965_rx_queue *rxq = &priv->rxq;
 	struct pci_dev *dev = priv->pci_dev;
@@ -4239,7 +4239,7 @@ int iwl4965_rx_queue_alloc(struct iwl4965_priv *priv)
 	return 0;
 }
 
-void iwl4965_rx_queue_reset(struct iwl4965_priv *priv, struct iwl4965_rx_queue *rxq)
+void iwl4965_rx_queue_reset(struct iwl_priv *priv, struct iwl4965_rx_queue *rxq)
 {
 	unsigned long flags;
 	int i;
@@ -4354,7 +4354,7 @@ int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm)
  * the appropriate handlers, including command responses,
  * frame-received notifications, and other notifications.
  */
-static void iwl4965_rx_handle(struct iwl4965_priv *priv)
+static void iwl4965_rx_handle(struct iwl_priv *priv)
 {
 	struct iwl4965_rx_mem_buffer *rxb;
 	struct iwl4965_rx_packet *pkt;
@@ -4467,7 +4467,7 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
 /**
  * iwl4965_tx_queue_update_write_ptr - Send new write index to hardware
  */
-static int iwl4965_tx_queue_update_write_ptr(struct iwl4965_priv *priv,
+static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl4965_tx_queue *txq)
 {
 	u32 reg = 0;
@@ -4533,14 +4533,14 @@ static void iwl4965_print_rx_config_cmd(struct iwl4965_rxon_cmd *rxon)
 }
 #endif
 
-static void iwl4965_enable_interrupts(struct iwl4965_priv *priv)
+static void iwl4965_enable_interrupts(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR("Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &priv->status);
 	iwl4965_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
 }
 
-static inline void iwl4965_disable_interrupts(struct iwl4965_priv *priv)
+static inline void iwl4965_disable_interrupts(struct iwl_priv *priv)
 {
 	clear_bit(STATUS_INT_ENABLED, &priv->status);
 
@@ -4577,7 +4577,7 @@ static const char *desc_lookup(int i)
 #define ERROR_START_OFFSET  (1 * sizeof(u32))
 #define ERROR_ELEM_SIZE     (7 * sizeof(u32))
 
-static void iwl4965_dump_nic_error_log(struct iwl4965_priv *priv)
+static void iwl4965_dump_nic_error_log(struct iwl_priv *priv)
 {
 	u32 data2, line;
 	u32 desc, time, count, base, data1;
@@ -4632,7 +4632,7 @@ static void iwl4965_dump_nic_error_log(struct iwl4965_priv *priv)
  *
  * NOTE: Must be called with iwl4965_grab_nic_access() already obtained!
  */
-static void iwl4965_print_event_log(struct iwl4965_priv *priv, u32 start_idx,
+static void iwl4965_print_event_log(struct iwl_priv *priv, u32 start_idx,
 				u32 num_events, u32 mode)
 {
 	u32 i;
@@ -4670,7 +4670,7 @@ static void iwl4965_print_event_log(struct iwl4965_priv *priv, u32 start_idx,
 	}
 }
 
-static void iwl4965_dump_nic_event_log(struct iwl4965_priv *priv)
+static void iwl4965_dump_nic_event_log(struct iwl_priv *priv)
 {
 	int rc;
 	u32 base;       /* SRAM byte address of event log header */
@@ -4725,7 +4725,7 @@ static void iwl4965_dump_nic_event_log(struct iwl4965_priv *priv)
 /**
  * iwl4965_irq_handle_error - called for HW or SW error interrupt from card
  */
-static void iwl4965_irq_handle_error(struct iwl4965_priv *priv)
+static void iwl4965_irq_handle_error(struct iwl_priv *priv)
 {
 	/* Set the FW error flag -- cleared on iwl4965_down */
 	set_bit(STATUS_FW_ERROR, &priv->status);
@@ -4760,7 +4760,7 @@ static void iwl4965_irq_handle_error(struct iwl4965_priv *priv)
 	}
 }
 
-static void iwl4965_error_recovery(struct iwl4965_priv *priv)
+static void iwl4965_error_recovery(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
@@ -4777,7 +4777,7 @@ static void iwl4965_error_recovery(struct iwl4965_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static void iwl4965_irq_tasklet(struct iwl4965_priv *priv)
+static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 {
 	u32 inta, handled = 0;
 	u32 inta_fh;
@@ -4939,7 +4939,7 @@ static void iwl4965_irq_tasklet(struct iwl4965_priv *priv)
 
 static irqreturn_t iwl4965_isr(int irq, void *data)
 {
-	struct iwl4965_priv *priv = data;
+	struct iwl_priv *priv = data;
 	u32 inta, inta_mask;
 	u32 inta_fh;
 	if (!priv)
@@ -4999,7 +4999,7 @@ static irqreturn_t iwl4965_isr(int irq, void *data)
  * EEPROM contents to the specific channel number supported for each
  * band.
  *
- * For example, iwl4965_priv->eeprom.band_3_channels[4] from the band_3
+ * For example, iwl_priv->eeprom.band_3_channels[4] from the band_3
  * definition below maps to physical channel 42 in the 5.2GHz spectrum.
  * The specific geography and calibration information for that channel
  * is contained in the eeprom map itself.
@@ -5054,7 +5054,7 @@ static u8 iwl4965_eeprom_band_7[] = {       /* 5.2 FAT channel */
 	36, 44, 52, 60, 100, 108, 116, 124, 132, 149, 157
 };
 
-static void iwl4965_init_band_reference(const struct iwl4965_priv *priv,
+static void iwl4965_init_band_reference(const struct iwl_priv *priv,
 				    int band,
 				    int *eeprom_ch_count,
 				    const struct iwl4965_eeprom_channel
@@ -5108,7 +5108,7 @@ static void iwl4965_init_band_reference(const struct iwl4965_priv *priv,
  *
  * Based on band and channel number.
  */
-const struct iwl4965_channel_info *iwl4965_get_channel_info(const struct iwl4965_priv *priv,
+const struct iwl4965_channel_info *iwl4965_get_channel_info(const struct iwl_priv *priv,
 						    enum ieee80211_band band, u16 channel)
 {
 	int i;
@@ -5137,7 +5137,7 @@ const struct iwl4965_channel_info *iwl4965_get_channel_info(const struct iwl4965
 /**
  * iwl4965_init_channel_map - Set up driver's info for all possible channels
  */
-static int iwl4965_init_channel_map(struct iwl4965_priv *priv)
+static int iwl4965_init_channel_map(struct iwl_priv *priv)
 {
 	int eeprom_ch_count = 0;
 	const u8 *eeprom_ch_index = NULL;
@@ -5289,7 +5289,7 @@ static int iwl4965_init_channel_map(struct iwl4965_priv *priv)
 /*
  * iwl4965_free_channel_map - undo allocations in iwl4965_init_channel_map
  */
-static void iwl4965_free_channel_map(struct iwl4965_priv *priv)
+static void iwl4965_free_channel_map(struct iwl_priv *priv)
 {
 	kfree(priv->channel_info);
 	priv->channel_count = 0;
@@ -5318,7 +5318,7 @@ static void iwl4965_free_channel_map(struct iwl4965_priv *priv)
 #define IWL_PASSIVE_DWELL_BASE      (100)
 #define IWL_CHANNEL_TUNE_TIME       5
 
-static inline u16 iwl4965_get_active_dwell_time(struct iwl4965_priv *priv,
+static inline u16 iwl4965_get_active_dwell_time(struct iwl_priv *priv,
 						enum ieee80211_band band)
 {
 	if (band == IEEE80211_BAND_5GHZ)
@@ -5327,7 +5327,7 @@ static inline u16 iwl4965_get_active_dwell_time(struct iwl4965_priv *priv,
 		return IWL_ACTIVE_DWELL_TIME_24;
 }
 
-static u16 iwl4965_get_passive_dwell_time(struct iwl4965_priv *priv,
+static u16 iwl4965_get_passive_dwell_time(struct iwl_priv *priv,
 					  enum ieee80211_band band)
 {
 	u16 active = iwl4965_get_active_dwell_time(priv, band);
@@ -5351,7 +5351,7 @@ static u16 iwl4965_get_passive_dwell_time(struct iwl4965_priv *priv,
 	return passive;
 }
 
-static int iwl4965_get_channels_for_scan(struct iwl4965_priv *priv,
+static int iwl4965_get_channels_for_scan(struct iwl_priv *priv,
 					 enum ieee80211_band band,
 				     u8 is_active, u8 direct_mask,
 				     struct iwl4965_scan_channel *scan_ch)
@@ -5438,7 +5438,7 @@ static int iwl4965_get_channels_for_scan(struct iwl4965_priv *priv,
 	return added;
 }
 
-static void iwl4965_init_hw_rates(struct iwl4965_priv *priv,
+static void iwl4965_init_hw_rates(struct iwl_priv *priv,
 			      struct ieee80211_rate *rates)
 {
 	int i;
@@ -5462,7 +5462,7 @@ static void iwl4965_init_hw_rates(struct iwl4965_priv *priv,
 /**
  * iwl4965_init_geos - Initialize mac80211's geo/channel info based from eeprom
  */
-static int iwl4965_init_geos(struct iwl4965_priv *priv)
+static int iwl4965_init_geos(struct iwl_priv *priv)
 {
 	struct iwl4965_channel_info *ch;
 	struct ieee80211_supported_band *sband;
@@ -5584,7 +5584,7 @@ static int iwl4965_init_geos(struct iwl4965_priv *priv)
 /*
  * iwl4965_free_geos - undo allocations in iwl4965_init_geos
  */
-static void iwl4965_free_geos(struct iwl4965_priv *priv)
+static void iwl4965_free_geos(struct iwl_priv *priv)
 {
 	kfree(priv->ieee_channels);
 	kfree(priv->ieee_rates);
@@ -5597,7 +5597,7 @@ static void iwl4965_free_geos(struct iwl4965_priv *priv)
  *
  ******************************************************************************/
 
-static void iwl4965_dealloc_ucode_pci(struct iwl4965_priv *priv)
+static void iwl4965_dealloc_ucode_pci(struct iwl_priv *priv)
 {
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_code);
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_data);
@@ -5611,7 +5611,7 @@ static void iwl4965_dealloc_ucode_pci(struct iwl4965_priv *priv)
  * iwl4965_verify_inst_full - verify runtime uCode image in card vs. host,
  *     looking at all data.
  */
-static int iwl4965_verify_inst_full(struct iwl4965_priv *priv, __le32 *image,
+static int iwl4965_verify_inst_full(struct iwl_priv *priv, __le32 *image,
 				 u32 len)
 {
 	u32 val;
@@ -5659,7 +5659,7 @@ static int iwl4965_verify_inst_full(struct iwl4965_priv *priv, __le32 *image,
  *   using sample data 100 bytes apart.  If these sample points are good,
  *   it's a pretty good bet that everything between them is good, too.
  */
-static int iwl4965_verify_inst_sparse(struct iwl4965_priv *priv, __le32 *image, u32 len)
+static int iwl4965_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
 {
 	u32 val;
 	int rc = 0;
@@ -5702,7 +5702,7 @@ static int iwl4965_verify_inst_sparse(struct iwl4965_priv *priv, __le32 *image,
  * iwl4965_verify_ucode - determine which instruction image is in SRAM,
  *    and verify its contents
  */
-static int iwl4965_verify_ucode(struct iwl4965_priv *priv)
+static int iwl4965_verify_ucode(struct iwl_priv *priv)
 {
 	__le32 *image;
 	u32 len;
@@ -5749,7 +5749,7 @@ static int iwl4965_verify_ucode(struct iwl4965_priv *priv)
 
 
 /* check contents of special bootstrap uCode SRAM */
-static int iwl4965_verify_bsm(struct iwl4965_priv *priv)
+static int iwl4965_verify_bsm(struct iwl_priv *priv)
 {
 	__le32 *image = priv->ucode_boot.v_addr;
 	u32 len = priv->ucode_boot.len;
@@ -5811,7 +5811,7 @@ static int iwl4965_verify_bsm(struct iwl4965_priv *priv)
  * the runtime uCode instructions and the backup data cache into SRAM,
  * and re-launches the runtime uCode from where it left off.
  */
-static int iwl4965_load_bsm(struct iwl4965_priv *priv)
+static int iwl4965_load_bsm(struct iwl_priv *priv)
 {
 	__le32 *image = priv->ucode_boot.v_addr;
 	u32 len = priv->ucode_boot.len;
@@ -5897,7 +5897,7 @@ static int iwl4965_load_bsm(struct iwl4965_priv *priv)
 	return 0;
 }
 
-static void iwl4965_nic_start(struct iwl4965_priv *priv)
+static void iwl4965_nic_start(struct iwl_priv *priv)
 {
 	/* Remove all resets to allow NIC to operate */
 	iwl4965_write32(priv, CSR_RESET, 0);
@@ -5909,7 +5909,7 @@ static void iwl4965_nic_start(struct iwl4965_priv *priv)
  *
  * Copy into buffers for card to fetch via bus-mastering
  */
-static int iwl4965_read_ucode(struct iwl4965_priv *priv)
+static int iwl4965_read_ucode(struct iwl_priv *priv)
 {
 	struct iwl4965_ucode *ucode;
 	int ret;
@@ -6110,7 +6110,7 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
  * We need to replace them to load runtime uCode inst and data,
  * and to save runtime data when powering down.
  */
-static int iwl4965_set_ucode_ptrs(struct iwl4965_priv *priv)
+static int iwl4965_set_ucode_ptrs(struct iwl_priv *priv)
 {
 	dma_addr_t pinst;
 	dma_addr_t pdata;
@@ -6159,7 +6159,7 @@ static int iwl4965_set_ucode_ptrs(struct iwl4965_priv *priv)
  *
  * Tell "initialize" uCode to go ahead and load the runtime uCode.
 */
-static void iwl4965_init_alive_start(struct iwl4965_priv *priv)
+static void iwl4965_init_alive_start(struct iwl_priv *priv)
 {
 	/* Check alive response for "valid" sign from uCode */
 	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
@@ -6204,7 +6204,7 @@ static void iwl4965_init_alive_start(struct iwl4965_priv *priv)
  *                   from protocol/runtime uCode (initialization uCode's
  *                   Alive gets handled by iwl4965_init_alive_start()).
  */
-static void iwl4965_alive_start(struct iwl4965_priv *priv)
+static void iwl4965_alive_start(struct iwl_priv *priv)
 {
 	int rc = 0;
 
@@ -6289,9 +6289,9 @@ static void iwl4965_alive_start(struct iwl4965_priv *priv)
 	queue_work(priv->workqueue, &priv->restart);
 }
 
-static void iwl4965_cancel_deferred_work(struct iwl4965_priv *priv);
+static void iwl4965_cancel_deferred_work(struct iwl_priv *priv);
 
-static void __iwl4965_down(struct iwl4965_priv *priv)
+static void __iwl4965_down(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
@@ -6383,7 +6383,7 @@ static void __iwl4965_down(struct iwl4965_priv *priv)
 	iwl4965_clear_free_frames(priv);
 }
 
-static void iwl4965_down(struct iwl4965_priv *priv)
+static void iwl4965_down(struct iwl_priv *priv)
 {
 	mutex_lock(&priv->mutex);
 	__iwl4965_down(priv);
@@ -6394,7 +6394,7 @@ static void iwl4965_down(struct iwl4965_priv *priv)
 
 #define MAX_HW_RESTARTS 5
 
-static int __iwl4965_up(struct iwl4965_priv *priv)
+static int __iwl4965_up(struct iwl_priv *priv)
 {
 	int rc, i;
 
@@ -6497,8 +6497,8 @@ static int __iwl4965_up(struct iwl4965_priv *priv)
 
 static void iwl4965_bg_init_alive_start(struct work_struct *data)
 {
-	struct iwl4965_priv *priv =
-	    container_of(data, struct iwl4965_priv, init_alive_start.work);
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, init_alive_start.work);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -6510,8 +6510,8 @@ static void iwl4965_bg_init_alive_start(struct work_struct *data)
 
 static void iwl4965_bg_alive_start(struct work_struct *data)
 {
-	struct iwl4965_priv *priv =
-	    container_of(data, struct iwl4965_priv, alive_start.work);
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, alive_start.work);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -6523,7 +6523,7 @@ static void iwl4965_bg_alive_start(struct work_struct *data)
 
 static void iwl4965_bg_rf_kill(struct work_struct *work)
 {
-	struct iwl4965_priv *priv = container_of(work, struct iwl4965_priv, rf_kill);
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, rf_kill);
 
 	wake_up_interruptible(&priv->wait_command_queue);
 
@@ -6555,8 +6555,8 @@ static void iwl4965_bg_rf_kill(struct work_struct *work)
 
 static void iwl4965_bg_scan_check(struct work_struct *data)
 {
-	struct iwl4965_priv *priv =
-	    container_of(data, struct iwl4965_priv, scan_check.work);
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, scan_check.work);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -6576,8 +6576,8 @@ static void iwl4965_bg_scan_check(struct work_struct *data)
 
 static void iwl4965_bg_request_scan(struct work_struct *data)
 {
-	struct iwl4965_priv *priv =
-	    container_of(data, struct iwl4965_priv, request_scan);
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, request_scan);
 	struct iwl4965_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
 		.len = sizeof(struct iwl4965_scan_cmd),
@@ -6788,7 +6788,7 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 
 static void iwl4965_bg_up(struct work_struct *data)
 {
-	struct iwl4965_priv *priv = container_of(data, struct iwl4965_priv, up);
+	struct iwl_priv *priv = container_of(data, struct iwl_priv, up);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -6800,7 +6800,7 @@ static void iwl4965_bg_up(struct work_struct *data)
 
 static void iwl4965_bg_restart(struct work_struct *data)
 {
-	struct iwl4965_priv *priv = container_of(data, struct iwl4965_priv, restart);
+	struct iwl_priv *priv = container_of(data, struct iwl_priv, restart);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -6811,8 +6811,8 @@ static void iwl4965_bg_restart(struct work_struct *data)
 
 static void iwl4965_bg_rx_replenish(struct work_struct *data)
 {
-	struct iwl4965_priv *priv =
-	    container_of(data, struct iwl4965_priv, rx_replenish);
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, rx_replenish);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -6826,7 +6826,7 @@ static void iwl4965_bg_rx_replenish(struct work_struct *data)
 
 static void iwl4965_bg_post_associate(struct work_struct *data)
 {
-	struct iwl4965_priv *priv = container_of(data, struct iwl4965_priv,
+	struct iwl_priv *priv = container_of(data, struct iwl_priv,
 					     post_associate.work);
 
 	int rc = 0;
@@ -6940,7 +6940,7 @@ static void iwl4965_bg_post_associate(struct work_struct *data)
 
 static void iwl4965_bg_abort_scan(struct work_struct *work)
 {
-	struct iwl4965_priv *priv = container_of(work, struct iwl4965_priv, abort_scan);
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
 	if (!iwl4965_is_ready(priv))
 		return;
@@ -6957,8 +6957,8 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 
 static void iwl4965_bg_scan_completed(struct work_struct *work)
 {
-	struct iwl4965_priv *priv =
-	    container_of(work, struct iwl4965_priv, scan_completed);
+	struct iwl_priv *priv =
+	    container_of(work, struct iwl_priv, scan_completed);
 
 	IWL_DEBUG(IWL_DL_INFO | IWL_DL_SCAN, "SCAN complete scan\n");
 
@@ -6987,7 +6987,7 @@ static void iwl4965_bg_scan_completed(struct work_struct *work)
 
 static int iwl4965_mac_start(struct ieee80211_hw *hw)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	int ret;
 
 	IWL_DEBUG_MAC80211("enter\n");
@@ -7064,7 +7064,7 @@ out_disable_msi:
 
 static void iwl4965_mac_stop(struct ieee80211_hw *hw)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -7099,7 +7099,7 @@ static void iwl4965_mac_stop(struct ieee80211_hw *hw)
 static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		      struct ieee80211_tx_control *ctl)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -7121,7 +7121,7 @@ static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 static int iwl4965_mac_add_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_if_init_conf *conf)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
@@ -7162,7 +7162,7 @@ static int iwl4965_mac_add_interface(struct ieee80211_hw *hw,
  */
 static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	const struct iwl4965_channel_info *ch_info;
 	unsigned long flags;
 	int ret = 0;
@@ -7257,7 +7257,7 @@ out:
 	return ret;
 }
 
-static void iwl4965_config_ap(struct iwl4965_priv *priv)
+static void iwl4965_config_ap(struct iwl_priv *priv)
 {
 	int rc = 0;
 
@@ -7321,7 +7321,7 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
 				    struct ieee80211_if_conf *conf)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	DECLARE_MAC_BUF(mac);
 	unsigned long flags;
 	int rc;
@@ -7439,7 +7439,7 @@ static void iwl4965_configure_filter(struct ieee80211_hw *hw,
 static void iwl4965_mac_remove_interface(struct ieee80211_hw *hw,
 				     struct ieee80211_if_init_conf *conf)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -7468,7 +7468,7 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_bss_conf *bss_conf,
 				     u32 changes)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 
 	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
 		if (bss_conf->use_short_preamble)
@@ -7499,7 +7499,7 @@ static int iwl4965_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 {
 	int rc = 0;
 	unsigned long flags;
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -7556,7 +7556,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   const u8 *local_addr, const u8 *addr,
 			   struct ieee80211_key_conf *key)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	DECLARE_MAC_BUF(mac);
 	int rc = 0;
 	u8 sta_id;
@@ -7615,7 +7615,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
 	int q;
 
@@ -7666,7 +7666,7 @@ static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 static int iwl4965_mac_get_tx_stats(struct ieee80211_hw *hw,
 				struct ieee80211_tx_queue_stats *stats)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	int i, avail;
 	struct iwl4965_tx_queue *txq;
 	struct iwl4965_queue *q;
@@ -7717,7 +7717,7 @@ static u64 iwl4965_mac_get_tsf(struct ieee80211_hw *hw)
 
 static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
 
 	mutex_lock(&priv->mutex);
@@ -7789,7 +7789,7 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 				 struct ieee80211_tx_control *control)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
 
 	mutex_lock(&priv->mutex);
@@ -7831,7 +7831,7 @@ static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 #ifdef CONFIG_IWL4965_HT
 
 static void iwl4965_ht_info_fill(struct ieee80211_conf *conf,
-				 struct iwl4965_priv *priv)
+				 struct iwl_priv *priv)
 {
 	struct iwl_ht_info *iwl_conf = &priv->current_ht_config;
 	struct ieee80211_ht_info *ht_conf = &conf->ht_conf;
@@ -7885,7 +7885,7 @@ static void iwl4965_ht_info_fill(struct ieee80211_conf *conf,
 static int iwl4965_mac_conf_ht(struct ieee80211_hw *hw,
 			       struct ieee80211_conf *conf)
 {
-	struct iwl4965_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter: \n");
 
@@ -7960,7 +7960,7 @@ static ssize_t show_rf_kill(struct device *d,
 	 * 2 - HW based RF kill active
 	 * 3 - Both HW and SW based RF kill active
 	 */
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 	int val = (test_bit(STATUS_RF_KILL_SW, &priv->status) ? 0x1 : 0x0) |
 		  (test_bit(STATUS_RF_KILL_HW, &priv->status) ? 0x2 : 0x0);
 
@@ -7971,7 +7971,7 @@ static ssize_t store_rf_kill(struct device *d,
 			     struct device_attribute *attr,
 			     const char *buf, size_t count)
 {
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 
 	mutex_lock(&priv->mutex);
 	iwl4965_radio_kill_sw(priv, buf[0] == '1');
@@ -7985,7 +7985,7 @@ static DEVICE_ATTR(rf_kill, S_IWUSR | S_IRUGO, show_rf_kill, store_rf_kill);
 static ssize_t show_temperature(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 
 	if (!iwl4965_is_alive(priv))
 		return -EAGAIN;
@@ -7999,7 +7999,7 @@ static ssize_t show_rs_window(struct device *d,
 			      struct device_attribute *attr,
 			      char *buf)
 {
-	struct iwl4965_priv *priv = d->driver_data;
+	struct iwl_priv *priv = d->driver_data;
 	return iwl4965_fill_rs_info(priv->hw, buf, IWL_AP_ID);
 }
 static DEVICE_ATTR(rs_window, S_IRUGO, show_rs_window, NULL);
@@ -8007,7 +8007,7 @@ static DEVICE_ATTR(rs_window, S_IRUGO, show_rs_window, NULL);
 static ssize_t show_tx_power(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 	return sprintf(buf, "%d\n", priv->user_txpower_limit);
 }
 
@@ -8015,7 +8015,7 @@ static ssize_t store_tx_power(struct device *d,
 			      struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 	char *p = (char *)buf;
 	u32 val;
 
@@ -8034,7 +8034,7 @@ static DEVICE_ATTR(tx_power, S_IWUSR | S_IRUGO, show_tx_power, store_tx_power);
 static ssize_t show_flags(struct device *d,
 			  struct device_attribute *attr, char *buf)
 {
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 
 	return sprintf(buf, "0x%04X\n", priv->active_rxon.flags);
 }
@@ -8043,7 +8043,7 @@ static ssize_t store_flags(struct device *d,
 			   struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 	u32 flags = simple_strtoul(buf, NULL, 0);
 
 	mutex_lock(&priv->mutex);
@@ -8068,7 +8068,7 @@ static DEVICE_ATTR(flags, S_IWUSR | S_IRUGO, show_flags, store_flags);
 static ssize_t show_filter_flags(struct device *d,
 				 struct device_attribute *attr, char *buf)
 {
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 
 	return sprintf(buf, "0x%04X\n",
 		le32_to_cpu(priv->active_rxon.filter_flags));
@@ -8078,7 +8078,7 @@ static ssize_t store_filter_flags(struct device *d,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 	u32 filter_flags = simple_strtoul(buf, NULL, 0);
 
 	mutex_lock(&priv->mutex);
@@ -8107,7 +8107,7 @@ static DEVICE_ATTR(filter_flags, S_IWUSR | S_IRUGO, show_filter_flags,
 static ssize_t show_measurement(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl4965_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 	struct iwl4965_spectrum_notification measure_report;
 	u32 size = sizeof(measure_report), len = 0, ofs = 0;
 	u8 *data = (u8 *) & measure_report;
@@ -8140,7 +8140,7 @@ static ssize_t store_measurement(struct device *d,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
-	struct iwl4965_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 	struct ieee80211_measurement_params params = {
 		.channel = le16_to_cpu(priv->active_rxon.channel),
 		.start_time = cpu_to_le64(priv->last_tsf),
@@ -8179,7 +8179,7 @@ static ssize_t store_retry_rate(struct device *d,
 				struct device_attribute *attr,
 				const char *buf, size_t count)
 {
-	struct iwl4965_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 
 	priv->retry_rate = simple_strtoul(buf, NULL, 0);
 	if (priv->retry_rate <= 0)
@@ -8191,7 +8191,7 @@ static ssize_t store_retry_rate(struct device *d,
 static ssize_t show_retry_rate(struct device *d,
 			       struct device_attribute *attr, char *buf)
 {
-	struct iwl4965_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 	return sprintf(buf, "%d", priv->retry_rate);
 }
 
@@ -8202,7 +8202,7 @@ static ssize_t store_power_level(struct device *d,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
-	struct iwl4965_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 	int rc;
 	int mode;
 
@@ -8256,7 +8256,7 @@ static const s32 period_duration[] = {
 static ssize_t show_power_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl4965_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 	int level = IWL_POWER_LEVEL(priv->power_mode);
 	char *p = buf;
 
@@ -8300,7 +8300,7 @@ static DEVICE_ATTR(channels, S_IRUSR, show_channels, NULL);
 static ssize_t show_statistics(struct device *d,
 			       struct device_attribute *attr, char *buf)
 {
-	struct iwl4965_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 	u32 size = sizeof(struct iwl4965_notif_statistics);
 	u32 len = 0, ofs = 0;
 	u8 *data = (u8 *) & priv->statistics;
@@ -8338,7 +8338,7 @@ static DEVICE_ATTR(statistics, S_IRUGO, show_statistics, NULL);
 static ssize_t show_antenna(struct device *d,
 			    struct device_attribute *attr, char *buf)
 {
-	struct iwl4965_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 
 	if (!iwl4965_is_alive(priv))
 		return -EAGAIN;
@@ -8351,7 +8351,7 @@ static ssize_t store_antenna(struct device *d,
 			     const char *buf, size_t count)
 {
 	int ant;
-	struct iwl4965_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 
 	if (count == 0)
 		return 0;
@@ -8376,7 +8376,7 @@ static DEVICE_ATTR(antenna, S_IWUSR | S_IRUGO, show_antenna, store_antenna);
 static ssize_t show_status(struct device *d,
 			   struct device_attribute *attr, char *buf)
 {
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 	if (!iwl4965_is_alive(priv))
 		return -EAGAIN;
 	return sprintf(buf, "0x%08x\n", (int)priv->status);
@@ -8391,7 +8391,7 @@ static ssize_t dump_error_log(struct device *d,
 	char *p = (char *)buf;
 
 	if (p[0] == '1')
-		iwl4965_dump_nic_error_log((struct iwl4965_priv *)d->driver_data);
+		iwl4965_dump_nic_error_log((struct iwl_priv *)d->driver_data);
 
 	return strnlen(buf, count);
 }
@@ -8405,7 +8405,7 @@ static ssize_t dump_event_log(struct device *d,
 	char *p = (char *)buf;
 
 	if (p[0] == '1')
-		iwl4965_dump_nic_event_log((struct iwl4965_priv *)d->driver_data);
+		iwl4965_dump_nic_event_log((struct iwl_priv *)d->driver_data);
 
 	return strnlen(buf, count);
 }
@@ -8418,7 +8418,7 @@ static DEVICE_ATTR(dump_events, S_IWUSR, NULL, dump_event_log);
  *
  *****************************************************************************/
 
-static void iwl4965_setup_deferred_work(struct iwl4965_priv *priv)
+static void iwl4965_setup_deferred_work(struct iwl_priv *priv)
 {
 	priv->workqueue = create_workqueue(DRV_NAME);
 
@@ -8443,7 +8443,7 @@ static void iwl4965_setup_deferred_work(struct iwl4965_priv *priv)
 		     iwl4965_irq_tasklet, (unsigned long)priv);
 }
 
-static void iwl4965_cancel_deferred_work(struct iwl4965_priv *priv)
+static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
 {
 	iwl4965_hw_cancel_deferred_work(priv);
 
@@ -8508,7 +8508,7 @@ static struct ieee80211_ops iwl4965_hw_ops = {
 static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int err = 0;
-	struct iwl4965_priv *priv;
+	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	int i;
@@ -8531,7 +8531,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	/* mac80211 allocates memory for this device instance, including
 	 *   space for this driver's private structure */
-	hw = ieee80211_alloc_hw(sizeof(struct iwl4965_priv), &iwl4965_hw_ops);
+	hw = ieee80211_alloc_hw(sizeof(struct iwl_priv), &iwl4965_hw_ops);
 	if (hw == NULL) {
 		IWL_ERROR("Can not allocate network device\n");
 		err = -ENOMEM;
@@ -8758,7 +8758,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 static void iwl4965_pci_remove(struct pci_dev *pdev)
 {
-	struct iwl4965_priv *priv = pci_get_drvdata(pdev);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
 	struct list_head *p, *q;
 	int i;
 
@@ -8822,7 +8822,7 @@ static void iwl4965_pci_remove(struct pci_dev *pdev)
 
 static int iwl4965_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
-	struct iwl4965_priv *priv = pci_get_drvdata(pdev);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
 	if (priv->is_open) {
 		set_bit(STATUS_IN_SUSPEND, &priv->status);
@@ -8837,7 +8837,7 @@ static int iwl4965_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 
 static int iwl4965_pci_resume(struct pci_dev *pdev)
 {
-	struct iwl4965_priv *priv = pci_get_drvdata(pdev);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
 	pci_set_power_state(pdev, PCI_D0);
 
-- 
1.5.3.4

