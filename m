Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57146 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1KWQIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 11:08:46 -0500
Received: by vcbfk14 with SMTP id fk14so475925vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 08:08:45 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Bing Zhao <bzhao@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [RFC 5/5] mwifiex: fix usage of set tx power
Date: Wed, 23 Nov 2011 11:08:41 -0500
Message-Id: <1322064521-16540-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111123_170849_539007_E0DD4638)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mBm is passed but dBm was assumed...

Cc: Bing Zhao <bzhao@marvell.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>
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

