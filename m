Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:39183 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946Ab3G2Xc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 19:32:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.11 1/3] mwifiex: check for bss_role instead of bss_mode for STA operations
Date: Mon, 29 Jul 2013 16:32:37 -0700
Message-ID: <1375140759-29767-1-git-send-email-bzhao@marvell.com> (sfid-20130730_013303_094421_BF7E5113)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch fixes an issue wherein association would fail on P2P
interfaces. This happened because we are checking priv->mode
against NL80211_IFTYPE_STATION. While this check is correct for
infrastructure stations, it would fail P2P clients for which mode
is NL80211_IFTYPE_P2P_CLIENT.

Better check would be bss_role which has only 2 values: STA/AP.

Cc: <stable@vger.kernel.org> # 3.10.y
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 4 ++--
 drivers/net/wireless/mwifiex/join.c     | 6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index cc334d5..d1e4816 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1727,9 +1727,9 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	int ret;
 
-	if (priv->bss_mode != NL80211_IFTYPE_STATION) {
+	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_STA) {
 		wiphy_err(wiphy,
-			  "%s: reject infra assoc request in non-STA mode\n",
+			  "%s: reject infra assoc request in non-STA role\n",
 			  dev->name);
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index ba043ca..9d7c0e6 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1291,8 +1291,10 @@ int mwifiex_associate(struct mwifiex_private *priv,
 {
 	u8 current_bssid[ETH_ALEN];
 
-	/* Return error if the adapter or table entry is not marked as infra */
-	if ((priv->bss_mode != NL80211_IFTYPE_STATION) ||
+	/* Return error if the adapter is not STA role or table entry
+	 * is not marked as infra.
+	 */
+	if ((GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_STA) ||
 	    (bss_desc->bss_mode != NL80211_IFTYPE_STATION))
 		return -1;
 
-- 
1.8.2.3

