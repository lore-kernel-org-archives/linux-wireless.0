Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:58663 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab1CKCyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:54:04 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: remove unnecessary mwifiex_get_assoc_status()
Date: Thu, 10 Mar 2011 18:57:08 -0800
Message-Id: <1299812229-27370-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function just returns priv->media_connected

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index d34c622..f19a7cf 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -147,15 +147,6 @@ mwifiex_get_mwifiex_cipher(u32 cipher, int *wpa_enabled)
 }
 
 /*
- * This function returns the association status.
- */
-static int
-mwifiex_get_assoc_status(struct mwifiex_private *priv)
-{
-	return priv->media_connected;
-}
-
-/*
  * This function retrieves the private structure from kernel wiphy structure.
  */
 static void *mwifiex_cfg80211_get_priv(struct wiphy *wiphy)
@@ -460,7 +451,7 @@ mwifiex_cfg80211_set_channel(struct wiphy *wiphy, struct net_device *dev,
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
 
-	if (mwifiex_get_assoc_status(priv)) {
+	if (priv->media_connected) {
 		wiphy_err(wiphy, "This setting is valid only when station "
 				"is not connected\n");
 		return -EINVAL;
-- 
1.7.0.2

