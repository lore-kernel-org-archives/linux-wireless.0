Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:34122 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605Ab2IZD3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:29:22 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 08/15] mwifiex: append each IE into a seperate IE buffer
Date: Tue, 25 Sep 2012 20:23:38 -0700
Message-Id: <1348629825-12001-9-git-send-email-bzhao@marvell.com> (sfid-20120926_052924_959826_183FD628)
In-Reply-To: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
References: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

When scan is triggered from cfg80211, the request contains some IEs
and we should parse all the IEs and append each IE into a seperate
IE buffer.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 261d7c5..1f4bd67 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1704,8 +1704,9 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 {
 	struct net_device *dev = request->wdev->netdev;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	int i;
+	int i, offset;
 	struct ieee80211_channel *chan;
+	struct ieee_types_header *ie;
 
 	wiphy_dbg(wiphy, "info: received scan request on %s\n", dev->name);
 
@@ -1728,13 +1729,17 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 	priv->user_scan_cfg->ssid_list = request->ssids;
 
 	if (request->ie && request->ie_len) {
+		offset = 0;
 		for (i = 0; i < MWIFIEX_MAX_VSIE_NUM; i++) {
 			if (priv->vs_ie[i].mask != MWIFIEX_VSIE_MASK_CLEAR)
 				continue;
 			priv->vs_ie[i].mask = MWIFIEX_VSIE_MASK_SCAN;
-			memcpy(&priv->vs_ie[i].ie, request->ie,
-			       request->ie_len);
-			break;
+			ie = (struct ieee_types_header *)(request->ie + offset);
+			memcpy(&priv->vs_ie[i].ie, ie, sizeof(*ie) + ie->len);
+			offset += sizeof(*ie) + ie->len;
+
+			if (offset >= request->ie_len)
+				break;
 		}
 	}
 
-- 
1.7.0.2

