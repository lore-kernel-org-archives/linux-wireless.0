Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58846 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab0ALMtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:49:42 -0500
Date: Tue, 12 Jan 2010 13:49:41 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 12/17] mwl8k: use firmware capability field to decide which bands to register
Message-ID: <20100112124941.GB1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the decision about whether to register the 2.4 and 5 GHz bands
with mac80211 by looking at the capability field in GET_HW_SPEC (STA
firmware only for now).  This enables 5 GHz STA operation.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 6e8c126..382ef43 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1666,11 +1666,14 @@ struct mwl8k_cmd_get_hw_spec_sta {
 #define MWL8K_CAP_DELAY_BA		0x00003000
 #define MWL8K_CAP_MIMO			0x00000200
 #define MWL8K_CAP_40MHZ			0x00000100
+#define MWL8K_CAP_BAND_MASK		0x00000007
+#define MWL8K_CAP_5GHZ			0x00000004
+#define MWL8K_CAP_2GHZ4			0x00000001
 
-static void mwl8k_set_ht_caps(struct ieee80211_hw *hw, u32 cap)
+static void
+mwl8k_set_ht_caps(struct ieee80211_hw *hw,
+		  struct ieee80211_supported_band *band, u32 cap)
 {
-	struct mwl8k_priv *priv = hw->priv;
-	struct ieee80211_supported_band *band = &priv->band_24;
 	int rx_streams;
 	int tx_streams;
 
@@ -1716,6 +1719,24 @@ static void mwl8k_set_ht_caps(struct ieee80211_hw *hw, u32 cap)
 	}
 }
 
+static void
+mwl8k_set_caps(struct ieee80211_hw *hw, u32 caps)
+{
+	struct mwl8k_priv *priv = hw->priv;
+
+	if ((caps & MWL8K_CAP_2GHZ4) || !(caps & MWL8K_CAP_BAND_MASK)) {
+		mwl8k_setup_2ghz_band(hw);
+		if (caps & MWL8K_CAP_MIMO)
+			mwl8k_set_ht_caps(hw, &priv->band_24, caps);
+	}
+
+	if (caps & MWL8K_CAP_5GHZ) {
+		mwl8k_setup_5ghz_band(hw);
+		if (caps & MWL8K_CAP_MIMO)
+			mwl8k_set_ht_caps(hw, &priv->band_50, caps);
+	}
+}
+
 static int mwl8k_cmd_get_hw_spec_sta(struct ieee80211_hw *hw)
 {
 	struct mwl8k_priv *priv = hw->priv;
@@ -1746,9 +1767,7 @@ static int mwl8k_cmd_get_hw_spec_sta(struct ieee80211_hw *hw)
 		priv->num_mcaddrs = le16_to_cpu(cmd->num_mcaddrs);
 		priv->fw_rev = le32_to_cpu(cmd->fw_rev);
 		priv->hw_rev = cmd->hw_rev;
-		mwl8k_setup_2ghz_band(hw);
-		if (cmd->caps & cpu_to_le32(MWL8K_CAP_MIMO))
-			mwl8k_set_ht_caps(hw, le32_to_cpu(cmd->caps));
+		mwl8k_set_caps(hw, le32_to_cpu(cmd->caps));
 	}
 
 	kfree(cmd);
-- 
1.5.6.4
