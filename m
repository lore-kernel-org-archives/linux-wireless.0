Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:34001 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754528Ab2ECHXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:23:43 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	harvey yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 10/18] mwifiex: handle interface type changes correctly
Date: Thu,  3 May 2012 00:22:32 -0700
Message-Id: <1336029760-22565-11-git-send-email-bzhao@marvell.com> (sfid-20120503_092904_400693_5827C3F1)
In-Reply-To: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
References: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

mlan0: managed or ibss
The iftype can be changed from STATION to ADHOC, and vice versa.

uap0: AP only
The iftype cannot be changed.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   64 ++++++++++++++++++++++---------
 1 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 38ece48..ff34fc6 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -497,31 +497,59 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 	int ret;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
-	if (priv->bss_mode == type) {
-		wiphy_warn(wiphy, "already set to required type\n");
-		return 0;
-	}
-
-	priv->bss_mode = type;
-
-	switch (type) {
+	switch (dev->ieee80211_ptr->iftype) {
 	case NL80211_IFTYPE_ADHOC:
-		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_ADHOC;
-		wiphy_dbg(wiphy, "info: setting interface type to adhoc\n");
+		switch (type) {
+		case NL80211_IFTYPE_STATION:
+			break;
+		case NL80211_IFTYPE_UNSPECIFIED:
+			wiphy_warn(wiphy, "%s: kept type as IBSS\n", dev->name);
+		case NL80211_IFTYPE_ADHOC:	/* This shouldn't happen */
+			return 0;
+		case NL80211_IFTYPE_AP:
+		default:
+			wiphy_err(wiphy, "%s: changing to %d not supported\n",
+				  dev->name, type);
+			return -EOPNOTSUPP;
+		}
 		break;
 	case NL80211_IFTYPE_STATION:
-		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_STATION;
-		wiphy_dbg(wiphy, "info: setting interface type to managed\n");
+		switch (type) {
+		case NL80211_IFTYPE_ADHOC:
+			break;
+		case NL80211_IFTYPE_UNSPECIFIED:
+			wiphy_warn(wiphy, "%s: kept type as STA\n", dev->name);
+		case NL80211_IFTYPE_STATION:	/* This shouldn't happen */
+			return 0;
+		case NL80211_IFTYPE_AP:
+		default:
+			wiphy_err(wiphy, "%s: changing to %d not supported\n",
+				  dev->name, type);
+			return -EOPNOTSUPP;
+		}
+		break;
+	case NL80211_IFTYPE_AP:
+		switch (type) {
+		case NL80211_IFTYPE_UNSPECIFIED:
+			wiphy_warn(wiphy, "%s: kept type as AP\n", dev->name);
+		case NL80211_IFTYPE_AP:		/* This shouldn't happen */
+			return 0;
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_STATION:
+		default:
+			wiphy_err(wiphy, "%s: changing to %d not supported\n",
+				  dev->name, type);
+			return -EOPNOTSUPP;
+		}
 		break;
-	case NL80211_IFTYPE_UNSPECIFIED:
-		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_STATION;
-		wiphy_dbg(wiphy, "info: setting interface type to auto\n");
-		return 0;
 	default:
-		wiphy_err(wiphy, "unknown interface type: %d\n", type);
-		return -EINVAL;
+		wiphy_err(wiphy, "%s: unknown iftype: %d\n",
+			  dev->name, dev->ieee80211_ptr->iftype);
+		return -EOPNOTSUPP;
 	}
 
+	dev->ieee80211_ptr->iftype = type;
+	priv->bss_mode = type;
 	mwifiex_deauthenticate(priv, NULL);
 
 	priv->sec_info.authentication_mode = NL80211_AUTHTYPE_OPEN_SYSTEM;
-- 
1.7.0.2

