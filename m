Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18503 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958Ab3LNCdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 21:33:25 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/4] mwifiex: send regulatory domain info to firmware only if alpha2 changed
Date: Fri, 13 Dec 2013 18:32:59 -0800
Message-ID: <1386988382-30023-1-git-send-email-bzhao@marvell.com> (sfid-20131214_033343_834157_97B4C849)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On cfg80211 regulatory domain change, drivers gets alpha2 country
code or "00" in driver's notification handler.

In most cases, the pattern will be US, 00, US, 00, US, 00, US, ...
There is no need to send domain info to firmware in case of "00" or
with the same alpha2 country code.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  | 19 +++++++++++++------
 drivers/net/wireless/mwifiex/sta_ioctl.c |  8 ++++++++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b2f271e..611fbcf 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -542,19 +542,26 @@ static void mwifiex_reg_notifier(struct wiphy *wiphy,
 	wiphy_dbg(wiphy, "info: cfg80211 regulatory domain callback for %c%c\n",
 		  request->alpha2[0], request->alpha2[1]);
 
-	memcpy(adapter->country_code, request->alpha2, sizeof(request->alpha2));
-
 	switch (request->initiator) {
 	case NL80211_REGDOM_SET_BY_DRIVER:
 	case NL80211_REGDOM_SET_BY_CORE:
 	case NL80211_REGDOM_SET_BY_USER:
-		break;
-		/* Todo: apply driver specific changes in channel flags based
-		   on the request initiator if necessary. */
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		break;
+	default:
+		wiphy_err(wiphy, "unknown regdom initiator: %d\n",
+			  request->initiator);
+		return;
+	}
+
+	/* Don't send world or same regdom info to firmware */
+	if (strncmp(request->alpha2, "00", 2) &&
+	    strncmp(request->alpha2, adapter->country_code,
+		    sizeof(request->alpha2))) {
+		memcpy(adapter->country_code, request->alpha2,
+		       sizeof(request->alpha2));
+		mwifiex_send_domain_info_cmd_fw(wiphy);
 	}
-	mwifiex_send_domain_info_cmd_fw(wiphy);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 1c67dfe..3259e00 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -205,6 +205,14 @@ static int mwifiex_process_country_ie(struct mwifiex_private *priv,
 		return 0;
 	}
 
+	if (!strncmp(priv->adapter->country_code, &country_ie[2], 2)) {
+		rcu_read_unlock();
+		wiphy_dbg(priv->wdev->wiphy,
+			  "11D: skip setting domain info in FW\n");
+		return 0;
+	}
+	memcpy(priv->adapter->country_code, &country_ie[2], 2);
+
 	domain_info->country_code[0] = country_ie[2];
 	domain_info->country_code[1] = country_ie[3];
 	domain_info->country_code[2] = ' ';
-- 
1.8.2.3

