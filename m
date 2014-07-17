Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21405 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752406AbaGQSuY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 14:50:24 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: do not re-associate when already connected
Date: Thu, 17 Jul 2014 11:49:55 -0700
Message-ID: <1405622995-26271-1-git-send-email-bzhao@marvell.com> (sfid-20140717_205027_139374_ECC251BA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ujjal Roy <royujjal@gmail.com>

In managed mode if the driver is getting a re-associate command
from cfg80211, driver deauthenticates with the AP internally and
sends a disconnected event to cfg80211 before completion of its
association process. The disconnected event then modifies the
SSID length as wdev->ssid_len = 0. So, upon receiving the connect
result event from driver, cfg80211 is unable to get that BSS from
the device's BSS list and generates the following WARN_ON message.

WARNING: CPU: 0 PID: 857 at net/wireless/sme.c:658
         __cfg80211_connect_result+0x3a6/0x3e0 [cfg80211]()

Avoid re-association while the device is already associated to a
network. Also remove the internal deauthentication from the
association path.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |  8 +++++---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 10 ----------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 6af135f..a738cc9 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1604,9 +1604,6 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len,
 		return -EINVAL;
 	}
 
-	/* disconnect before try to associate */
-	mwifiex_deauthenticate(priv, NULL);
-
 	/* As this is new association, clear locally stored
 	 * keys and security related flags */
 	priv->sec_info.wpa_enabled = false;
@@ -1744,6 +1741,11 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		return -EINVAL;
 	}
 
+	if (priv->wdev && priv->wdev->current_bss) {
+		wiphy_warn(wiphy, "%s: already connected\n", dev->name);
+		return -EALREADY;
+	}
+
 	wiphy_dbg(wiphy, "info: Trying to associate to %s and bssid %pM\n",
 		  (char *) sme->ssid, sme->bssid);
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 1a03d4d..caae973 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -283,10 +283,6 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 	    priv->bss_mode == NL80211_IFTYPE_P2P_CLIENT) {
 		u8 config_bands;
 
-		ret = mwifiex_deauthenticate(priv, NULL);
-		if (ret)
-			goto done;
-
 		if (!bss_desc)
 			return -1;
 
@@ -345,12 +341,6 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 			goto done;
 		}
 
-		/* Exit Adhoc mode first */
-		dev_dbg(adapter->dev, "info: Sending Adhoc Stop\n");
-		ret = mwifiex_deauthenticate(priv, NULL);
-		if (ret)
-			goto done;
-
 		priv->adhoc_is_link_sensed = false;
 
 		ret = mwifiex_check_network_compatibility(priv, bss_desc);
-- 
1.8.2.3

