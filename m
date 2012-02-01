Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:54344 "HELO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756144Ab2BAKze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 05:55:34 -0500
Date: Wed, 1 Feb 2012 16:19:54 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Remove BSSID from the firmware when the
 corresponding BSS is stopped
Message-ID: <20120201104938.GA6932@hertz.marvell.com> (sfid-20120201_115538_170527_7757DECA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using command DEL_MAC_ADDR, remove the mac address of the BSS
when it is stopped i.e the corresponding vif is removed. Without
this, the stale bss entry will still be maintained in the firmware
which causes issues when the BSS's are recreated.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   38 +++++++++++++++++++++++++++++---------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index fd12547..ac7c983 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -402,6 +402,7 @@ static const struct ieee80211_rate mwl8k_rates_50[] = {
 #define MWL8K_CMD_SET_MAC_ADDR		0x0202		/* per-vif */
 #define MWL8K_CMD_SET_RATEADAPT_MODE	0x0203
 #define MWL8K_CMD_GET_WATCHDOG_BITMAP	0x0205
+#define MWL8K_CMD_DEL_MAC_ADDR		0x0206		/* per-vif */
 #define MWL8K_CMD_BSS_START		0x1100		/* per-vif */
 #define MWL8K_CMD_SET_NEW_STN		0x1111		/* per-vif */
 #define MWL8K_CMD_UPDATE_ENCRYPTION	0x1122		/* per-vif */
@@ -3430,10 +3431,7 @@ static int mwl8k_cmd_enable_sniffer(struct ieee80211_hw *hw, bool enable)
 	return rc;
 }
 
-/*
- * CMD_SET_MAC_ADDR.
- */
-struct mwl8k_cmd_set_mac_addr {
+struct mwl8k_cmd_update_mac_addr {
 	struct mwl8k_cmd_pkt header;
 	union {
 		struct {
@@ -3449,12 +3447,12 @@ struct mwl8k_cmd_set_mac_addr {
 #define MWL8K_MAC_TYPE_PRIMARY_AP		2
 #define MWL8K_MAC_TYPE_SECONDARY_AP		3
 
-static int mwl8k_cmd_set_mac_addr(struct ieee80211_hw *hw,
-				  struct ieee80211_vif *vif, u8 *mac)
+static int mwl8k_cmd_update_mac_addr(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif, u8 *mac, bool set)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_vif *mwl8k_vif = MWL8K_VIF(vif);
-	struct mwl8k_cmd_set_mac_addr *cmd;
+	struct mwl8k_cmd_update_mac_addr *cmd;
 	int mac_type;
 	int rc;
 
@@ -3475,7 +3473,11 @@ static int mwl8k_cmd_set_mac_addr(struct ieee80211_hw *hw,
 	if (cmd == NULL)
 		return -ENOMEM;
 
-	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_MAC_ADDR);
+	if (set)
+		cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_MAC_ADDR);
+	else
+		cmd->header.code = cpu_to_le16(MWL8K_CMD_DEL_MAC_ADDR);
+
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	if (priv->ap_fw) {
 		cmd->mbss.mac_type = cpu_to_le16(mac_type);
@@ -3491,6 +3493,24 @@ static int mwl8k_cmd_set_mac_addr(struct ieee80211_hw *hw,
 }
 
 /*
+ * MWL8K_CMD_SET_MAC_ADDR.
+ */
+static inline int mwl8k_cmd_set_mac_addr(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif, u8 *mac)
+{
+	return mwl8k_cmd_update_mac_addr(hw, vif, mac, true);
+}
+
+/*
+ * MWL8K_CMD_DEL_MAC_ADDR.
+ */
+static inline int mwl8k_cmd_del_mac_addr(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif, u8 *mac)
+{
+	return mwl8k_cmd_update_mac_addr(hw, vif, mac, false);
+}
+
+/*
  * CMD_SET_RATEADAPT_MODE.
  */
 struct mwl8k_cmd_set_rate_adapt_mode {
@@ -4542,7 +4562,7 @@ static void mwl8k_remove_interface(struct ieee80211_hw *hw,
 	if (priv->ap_fw)
 		mwl8k_cmd_set_new_stn_del(hw, vif, vif->addr);
 
-	mwl8k_cmd_set_mac_addr(hw, vif, "\x00\x00\x00\x00\x00\x00");
+	mwl8k_cmd_del_mac_addr(hw, vif, vif->addr);
 
 	mwl8k_remove_vif(priv, mwl8k_vif);
 }
-- 
1.7.5.4

