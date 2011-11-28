Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52889 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab1K1VjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 16:39:08 -0500
Received: by mail-vx0-f174.google.com with SMTP id fk14so4064537vcb.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 13:39:07 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 5/5] mwifiex: fix usage of set tx power
Date: Mon, 28 Nov 2011 16:38:50 -0500
Message-Id: <1322516330-4007-6-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111128_223911_376668_BD0AD881)
In-Reply-To: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mBm is passed but dBm was assumed...

Acked-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e9ab9a3..0db97cc 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -120,10 +120,11 @@ mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 static int
 mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
 			      enum nl80211_tx_power_setting type,
-			      int dbm)
+			      int mbm)
 {
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	struct mwifiex_power_cfg power_cfg;
+	int dbm = MBM_TO_DBM(mbm);
 
 	if (type == NL80211_TX_POWER_FIXED) {
 		power_cfg.is_power_auto = 0;
-- 
1.7.4.15.g7811d

