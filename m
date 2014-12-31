Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9265 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722AbaLaKir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 05:38:47 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 9/9] mwifiex: Add support for wowlan disconnect
Date: Wed, 31 Dec 2014 02:36:46 -0800
Message-ID: <1420022206-11435-10-git-send-email-akarwar@marvell.com> (sfid-20141231_113851_396096_A0BEE4CB)
In-Reply-To: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
References: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maithili Hinge <maithili@marvell.com>

This patch adds support for wowlan disconnect.

Signed-off-by: Maithili Hinge <maithili@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 2be2dc5..93ab36f 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2527,6 +2527,7 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 				    struct cfg80211_wowlan *wowlan)
 {
 	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
+	struct mwifiex_ds_hs_cfg hs_cfg;
 	int ret = 0;
 	struct mwifiex_private *priv =
 			mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
@@ -2550,6 +2551,20 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 		}
 	}
 
+	if (wowlan->disconnect) {
+		memset(&hs_cfg, 0, sizeof(hs_cfg));
+		hs_cfg.is_invoke_hostcmd = false;
+		hs_cfg.conditions = HS_CFG_COND_MAC_EVENT;
+		hs_cfg.gpio = HS_CFG_GPIO_DEF;
+		hs_cfg.gap = HS_CFG_GAP_DEF;
+		ret = mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_SET,
+					    MWIFIEX_SYNC_CMD, &hs_cfg);
+		if (ret) {
+			dev_err(adapter->dev, "Failed to set HS params\n");
+			return ret;
+		}
+	}
+
 	return ret;
 }
 
@@ -2890,7 +2905,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 
 #ifdef CONFIG_PM
 static const struct wiphy_wowlan_support mwifiex_wowlan_support = {
-	.flags = WIPHY_WOWLAN_MAGIC_PKT,
+	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT,
 	.n_patterns = MWIFIEX_MEF_MAX_FILTERS,
 	.pattern_min_len = 1,
 	.pattern_max_len = MWIFIEX_MAX_PATTERN_LEN,
-- 
1.8.1.4

