Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12979 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbcF0IsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 04:48:08 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/3] mwifiex: code rearrangement in suspend handler
Date: Mon, 27 Jun 2016 14:16:27 +0530
Message-ID: <1467017189-26917-1-git-send-email-akarwar@marvell.com> (sfid-20160627_104812_387740_DB7B56F8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We will derive sta_priv at the beginning of suspend handler.
This will be useful for next patch in this series.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 81ff8bb..31f7b79 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3311,6 +3311,8 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 	struct mwifiex_ds_hs_cfg hs_cfg;
 	int i, ret = 0, retry_num = 10;
 	struct mwifiex_private *priv;
+	struct mwifiex_private *sta_priv =
+			mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
 
 	for (i = 0; i < adapter->priv_num; i++) {
 		priv = adapter->priv[i];
@@ -3343,15 +3345,13 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 		return 0;
 	}
 
-	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
-
-	if (!priv->media_connected && !wowlan->nd_config) {
+	if (!sta_priv->media_connected && !wowlan->nd_config) {
 		mwifiex_dbg(adapter, ERROR,
 			    "Can not configure WOWLAN in disconnected state\n");
 		return 0;
 	}
 
-	ret = mwifiex_set_mef_filter(priv, wowlan);
+	ret = mwifiex_set_mef_filter(sta_priv, wowlan);
 	if (ret) {
 		mwifiex_dbg(adapter, ERROR, "Failed to set MEF filter\n");
 		return ret;
@@ -3363,19 +3363,19 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 	if (wowlan->nd_config) {
 		mwifiex_dbg(adapter, INFO, "Wake on net detect\n");
 		hs_cfg.conditions |= HS_CFG_COND_MAC_EVENT;
-		mwifiex_cfg80211_sched_scan_start(wiphy, priv->netdev,
+		mwifiex_cfg80211_sched_scan_start(wiphy, sta_priv->netdev,
 						  wowlan->nd_config);
 	}
 
 	if (wowlan->disconnect) {
 		hs_cfg.conditions |= HS_CFG_COND_MAC_EVENT;
-		mwifiex_dbg(priv->adapter, INFO, "Wake on device disconnect\n");
+		mwifiex_dbg(sta_priv->adapter, INFO, "Wake on device disconnect\n");
 	}
 
 	hs_cfg.is_invoke_hostcmd = false;
 	hs_cfg.gpio = adapter->hs_cfg.gpio;
 	hs_cfg.gap = adapter->hs_cfg.gap;
-	ret = mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_SET,
+	ret = mwifiex_set_hs_params(sta_priv, HostCmd_ACT_GEN_SET,
 				    MWIFIEX_SYNC_CMD, &hs_cfg);
 	if (ret) {
 		mwifiex_dbg(adapter, ERROR,
-- 
1.9.1

