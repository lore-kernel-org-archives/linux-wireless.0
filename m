Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7705 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712AbaLaKiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 05:38:46 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 8/9] mwifiex: Move code for wowlan magic-packet and patterns to a function
Date: Wed, 31 Dec 2014 02:36:45 -0800
Message-ID: <1420022206-11435-9-git-send-email-akarwar@marvell.com> (sfid-20141231_113849_209000_DB80484E)
In-Reply-To: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
References: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maithili Hinge <maithili@marvell.com>

This patch moves code for wowlan magic-packet and patterns to a function
mwifiex_set_mef_filter.

Signed-off-by: Maithili Hinge <maithili@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 78 ++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index f8b1ce0..2be2dc5 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2425,30 +2425,16 @@ mwifiex_is_pattern_supported(struct cfg80211_pkt_pattern *pat, s8 *byte_seq,
 }
 
 #ifdef CONFIG_PM
-static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
-				    struct cfg80211_wowlan *wowlan)
+static int mwifiex_set_mef_filter(struct mwifiex_private *priv,
+				  struct cfg80211_wowlan *wowlan)
 {
-	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
-	struct mwifiex_ds_mef_cfg mef_cfg;
-	struct mwifiex_mef_entry *mef_entry;
-	int i, filt_num = 0, ret;
+	int i, filt_num = 0, ret = 0;
 	bool first_pat = true;
 	u8 byte_seq[MWIFIEX_MEF_MAX_BYTESEQ + 1];
 	const u8 ipv4_mc_mac[] = {0x33, 0x33};
 	const u8 ipv6_mc_mac[] = {0x01, 0x00, 0x5e};
-	struct mwifiex_private *priv =
-			mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
-
-	if (!wowlan) {
-		dev_warn(adapter->dev, "None of the WOWLAN triggers enabled\n");
-		return 0;
-	}
-
-	if (!priv->media_connected) {
-		dev_warn(adapter->dev,
-			 "Can not configure WOWLAN in disconnected state\n");
-		return 0;
-	}
+	struct mwifiex_ds_mef_cfg mef_cfg;
+	struct mwifiex_mef_entry *mef_entry;
 
 	mef_entry = kzalloc(sizeof(*mef_entry), GFP_KERNEL);
 	if (!mef_entry)
@@ -2463,9 +2449,9 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 	for (i = 0; i < wowlan->n_patterns; i++) {
 		memset(byte_seq, 0, sizeof(byte_seq));
 		if (!mwifiex_is_pattern_supported(&wowlan->patterns[i],
-						  byte_seq,
-						  MWIFIEX_MEF_MAX_BYTESEQ)) {
-			wiphy_err(wiphy, "Pattern not supported\n");
+					byte_seq,
+					MWIFIEX_MEF_MAX_BYTESEQ)) {
+			dev_err(priv->adapter->dev, "Pattern not supported\n");
 			kfree(mef_entry);
 			return -EOPNOTSUPP;
 		}
@@ -2489,9 +2475,9 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 
 		mef_entry->filter[filt_num].repeat = 1;
 		mef_entry->filter[filt_num].offset =
-						wowlan->patterns[i].pkt_offset;
+			wowlan->patterns[i].pkt_offset;
 		memcpy(mef_entry->filter[filt_num].byte_seq, byte_seq,
-		       sizeof(byte_seq));
+				sizeof(byte_seq));
 		mef_entry->filter[filt_num].filt_type = TYPE_EQ;
 
 		if (first_pat)
@@ -2506,9 +2492,9 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 		mef_cfg.criteria |= MWIFIEX_CRITERIA_UNICAST;
 		mef_entry->filter[filt_num].repeat = 16;
 		memcpy(mef_entry->filter[filt_num].byte_seq, priv->curr_addr,
-		       ETH_ALEN);
+				ETH_ALEN);
 		mef_entry->filter[filt_num].byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] =
-								ETH_ALEN;
+			ETH_ALEN;
 		mef_entry->filter[filt_num].offset = 28;
 		mef_entry->filter[filt_num].filt_type = TYPE_EQ;
 		if (filt_num)
@@ -2517,9 +2503,9 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 		filt_num++;
 		mef_entry->filter[filt_num].repeat = 16;
 		memcpy(mef_entry->filter[filt_num].byte_seq, priv->curr_addr,
-		       ETH_ALEN);
+				ETH_ALEN);
 		mef_entry->filter[filt_num].byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] =
-								ETH_ALEN;
+			ETH_ALEN;
 		mef_entry->filter[filt_num].offset = 56;
 		mef_entry->filter[filt_num].filt_type = TYPE_EQ;
 		mef_entry->filter[filt_num].filt_action = TYPE_OR;
@@ -2527,16 +2513,46 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 
 	if (!mef_cfg.criteria)
 		mef_cfg.criteria = MWIFIEX_CRITERIA_BROADCAST |
-				   MWIFIEX_CRITERIA_UNICAST |
-				   MWIFIEX_CRITERIA_MULTICAST;
+			MWIFIEX_CRITERIA_UNICAST |
+			MWIFIEX_CRITERIA_MULTICAST;
 
 	ret = mwifiex_send_cmd(priv, HostCmd_CMD_MEF_CFG,
-			       HostCmd_ACT_GEN_SET, 0, &mef_cfg, true);
+			HostCmd_ACT_GEN_SET, 0, &mef_cfg, true);
 
 	kfree(mef_entry);
 	return ret;
 }
 
+static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
+				    struct cfg80211_wowlan *wowlan)
+{
+	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
+	int ret = 0;
+	struct mwifiex_private *priv =
+			mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
+
+	if (!wowlan) {
+		dev_warn(adapter->dev, "None of the WOWLAN triggers enabled\n");
+		return 0;
+	}
+
+	if (!priv->media_connected) {
+		dev_warn(adapter->dev,
+			 "Can not configure WOWLAN in disconnected state\n");
+		return 0;
+	}
+
+	if (wowlan->n_patterns || wowlan->magic_pkt) {
+		ret = mwifiex_set_mef_filter(priv, wowlan);
+		if (ret) {
+			dev_err(adapter->dev, "Failed to set MEF filter\n");
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
 static int mwifiex_cfg80211_resume(struct wiphy *wiphy)
 {
 	return 0;
-- 
1.8.1.4

