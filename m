Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:47062 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170Ab2JFDWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 23:22:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.7 3/4] mwifiex: update cfg80211 with correct reason code when association fails
Date: Fri,  5 Oct 2012 20:21:42 -0700
Message-Id: <1349493703-1169-4-git-send-email-bzhao@marvell.com> (sfid-20121006_052222_293038_B6D914DD)
In-Reply-To: <1349493703-1169-1-git-send-email-bzhao@marvell.com>
References: <1349493703-1169-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This patch adds support to send correct reason code got from
firmware when association attempt fails. Also, the error message
displayed for association failure due to network incompatibility
is modified. Current message "cannot find ssid.." misleads user.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   17 ++++++++++++++---
 drivers/net/wireless/mwifiex/scan.c     |    4 ++--
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 675247b..0679458 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1596,8 +1596,9 @@ done:
 		}
 	}
 
-	if (mwifiex_bss_start(priv, bss, &req_ssid))
-		return -EFAULT;
+	ret = mwifiex_bss_start(priv, bss, &req_ssid);
+	if (ret)
+		return ret;
 
 	if (mode == NL80211_IFTYPE_ADHOC) {
 		/* Inform the BSS information to kernel, otherwise
@@ -1652,9 +1653,19 @@ done:
 			"info: association to bssid %pM failed\n",
 			priv->cfg_bssid);
 		memset(priv->cfg_bssid, 0, ETH_ALEN);
+
+		if (ret > 0)
+			cfg80211_connect_result(priv->netdev, priv->cfg_bssid,
+						NULL, 0, NULL, 0, ret,
+						GFP_KERNEL);
+		else
+			cfg80211_connect_result(priv->netdev, priv->cfg_bssid,
+						NULL, 0, NULL, 0,
+						WLAN_STATUS_UNSPECIFIED_FAILURE,
+						GFP_KERNEL);
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index d9295fd..00b658d 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1434,8 +1434,8 @@ int mwifiex_check_network_compatibility(struct mwifiex_private *priv,
 			ret = mwifiex_is_network_compatible(priv, bss_desc,
 							    priv->bss_mode);
 			if (ret)
-				dev_err(priv->adapter->dev, "cannot find ssid "
-					"%s\n", bss_desc->ssid.ssid);
+				dev_err(priv->adapter->dev,
+					"Incompatible network settings\n");
 			break;
 		default:
 			ret = 0;
-- 
1.7.0.2

