Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58855 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0ALMvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:51:31 -0500
Date: Tue, 12 Jan 2010 13:51:30 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 16/17] mwl8k: enable multi-BSS AP operation
Message-ID: <20100112125130.GF1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As follows:
- GET_HW_SPEC is now responsible for setting
  priv->{ap,sta}_macids_supported, which are bitmasks of supported
  macids for AP and STA mode.  (Typically, STA firmware images will
  support only one macid, #0, in STA mode, and AP firmware images
  will support macids #0-7, in AP mode.)
- Our wiphy ->interfaces_modes is now set based on the non-zero-ness
  of these two bitmasks.
- We main priv->macids_used, a bitmask of which macids are currently
  in use.  ->add_interface() will assign the lowest free macid for
  this interface type as it is created, or bail out if there are no
  more free macids to assign.  ->delete_interface() will mark the
  macid as being free again.

This enables the multi-BSS code added in the previous commits.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   70 +++++++++++++++++++++++++++++++++--------
 1 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index d8cf438..06dc7a0 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -147,6 +147,8 @@ struct mwl8k_priv {
 	struct ieee80211_supported_band band_50;
 	struct ieee80211_channel channels_50[4];
 	struct ieee80211_rate rates_50[9];
+	u32 ap_macids_supported;
+	u32 sta_macids_supported;
 
 	/* firmware access */
 	struct mutex fw_mutex;
@@ -161,6 +163,7 @@ struct mwl8k_priv {
 	struct completion *tx_wait;
 
 	/* List of interfaces.  */
+	u32 macids_used;
 	struct list_head vif_list;
 
 	/* power management status cookie from firmware */
@@ -1786,6 +1789,8 @@ static int mwl8k_cmd_get_hw_spec_sta(struct ieee80211_hw *hw)
 		priv->fw_rev = le32_to_cpu(cmd->fw_rev);
 		priv->hw_rev = cmd->hw_rev;
 		mwl8k_set_caps(hw, le32_to_cpu(cmd->caps));
+		priv->ap_macids_supported = 0x00000000;
+		priv->sta_macids_supported = 0x00000001;
 	}
 
 	kfree(cmd);
@@ -1840,6 +1845,8 @@ static int mwl8k_cmd_get_hw_spec_ap(struct ieee80211_hw *hw)
 		priv->fw_rev = le32_to_cpu(cmd->fw_rev);
 		priv->hw_rev = cmd->hw_rev;
 		mwl8k_setup_2ghz_band(hw);
+		priv->ap_macids_supported = 0x000000ff;
+		priv->sta_macids_supported = 0x00000000;
 
 		off = le32_to_cpu(cmd->wcbbase0) & 0xffff;
 		iowrite32(cpu_to_le32(priv->txq[0].txd_dma), priv->sram + off);
@@ -2759,16 +2766,33 @@ struct mwl8k_cmd_set_mac_addr {
 	};
 } __attribute__((packed));
 
-#define MWL8K_MAC_TYPE_PRIMARY_CLIENT	0
-#define MWL8K_MAC_TYPE_PRIMARY_AP	2
+#define MWL8K_MAC_TYPE_PRIMARY_CLIENT		0
+#define MWL8K_MAC_TYPE_SECONDARY_CLIENT		1
+#define MWL8K_MAC_TYPE_PRIMARY_AP		2
+#define MWL8K_MAC_TYPE_SECONDARY_AP		3
 
 static int mwl8k_cmd_set_mac_addr(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif, u8 *mac)
 {
 	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_vif *mwl8k_vif = MWL8K_VIF(vif);
 	struct mwl8k_cmd_set_mac_addr *cmd;
+	int mac_type;
 	int rc;
 
+	mac_type = MWL8K_MAC_TYPE_PRIMARY_AP;
+	if (vif != NULL && vif->type == NL80211_IFTYPE_STATION) {
+		if (mwl8k_vif->macid + 1 == ffs(priv->sta_macids_supported))
+			mac_type = MWL8K_MAC_TYPE_PRIMARY_CLIENT;
+		else
+			mac_type = MWL8K_MAC_TYPE_SECONDARY_CLIENT;
+	} else if (vif != NULL && vif->type == NL80211_IFTYPE_AP) {
+		if (mwl8k_vif->macid + 1 == ffs(priv->ap_macids_supported))
+			mac_type = MWL8K_MAC_TYPE_PRIMARY_AP;
+		else
+			mac_type = MWL8K_MAC_TYPE_SECONDARY_AP;
+	}
+
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
@@ -2776,7 +2800,7 @@ static int mwl8k_cmd_set_mac_addr(struct ieee80211_hw *hw,
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_MAC_ADDR);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	if (priv->ap_fw) {
-		cmd->mbss.mac_type = cpu_to_le16(MWL8K_MAC_TYPE_PRIMARY_AP);
+		cmd->mbss.mac_type = cpu_to_le16(mac_type);
 		memcpy(cmd->mbss.mac_addr, mac, ETH_ALEN);
 	} else {
 		memcpy(cmd->mac_addr, mac, ETH_ALEN);
@@ -3271,12 +3295,8 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_vif *mwl8k_vif;
-
-	/*
-	 * We only support one active interface at a time.
-	 */
-	if (!list_empty(&priv->vif_list))
-		return -EBUSY;
+	u32 macids_supported;
+	int macid;
 
 	/*
 	 * Reject interface creation if sniffer mode is active, as
@@ -3290,11 +3310,27 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 		return -EINVAL;
 	}
 
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_AP:
+		macids_supported = priv->ap_macids_supported;
+		break;
+	case NL80211_IFTYPE_STATION:
+		macids_supported = priv->sta_macids_supported;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	macid = ffs(macids_supported & ~priv->macids_used);
+	if (!macid--)
+		return -EBUSY;
+
 	/* Setup driver private area. */
 	mwl8k_vif = MWL8K_VIF(vif);
 	memset(mwl8k_vif, 0, sizeof(*mwl8k_vif));
 	mwl8k_vif->vif = vif;
-	mwl8k_vif->macid = 0;
+	mwl8k_vif->macid = macid;
 	mwl8k_vif->seqno = 0;
 
 	/* Set the mac address.  */
@@ -3303,6 +3339,7 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	if (priv->ap_fw)
 		mwl8k_cmd_set_new_stn_add_self(hw, vif);
 
+	priv->macids_used |= 1 << mwl8k_vif->macid;
 	list_add_tail(&mwl8k_vif->list, &priv->vif_list);
 
 	return 0;
@@ -3319,6 +3356,7 @@ static void mwl8k_remove_interface(struct ieee80211_hw *hw,
 
 	mwl8k_cmd_set_mac_addr(hw, vif, "\x00\x00\x00\x00\x00\x00");
 
+	priv->macids_used &= ~(1 << mwl8k_vif->macid);
 	list_del(&mwl8k_vif->list);
 }
 
@@ -4023,6 +4061,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	hw->vif_data_size = sizeof(struct mwl8k_vif);
 	hw->sta_data_size = sizeof(struct mwl8k_sta);
 
+	priv->macids_used = 0;
 	INIT_LIST_HEAD(&priv->vif_list);
 
 	/* Set default radio state and preamble */
@@ -4094,12 +4133,8 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		rc = mwl8k_cmd_get_hw_spec_ap(hw);
 		if (!rc)
 			rc = mwl8k_cmd_set_hw_spec(hw);
-
-		hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_AP);
 	} else {
 		rc = mwl8k_cmd_get_hw_spec_sta(hw);
-
-		hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	}
 	if (rc) {
 		printk(KERN_ERR "%s: Cannot initialise firmware\n",
@@ -4107,6 +4142,13 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		goto err_free_irq;
 	}
 
+	hw->wiphy->interface_modes = 0;
+	if (priv->ap_macids_supported)
+		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP);
+	if (priv->sta_macids_supported)
+		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_STATION);
+
+
 	/* Turn radio off */
 	rc = mwl8k_cmd_radio_disable(hw);
 	if (rc) {
-- 
1.5.6.4
