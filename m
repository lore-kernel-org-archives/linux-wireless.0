Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:33254 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZH1K2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 06:28:18 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [RFC PATCH 07/10] rndis_wlan: remove unneeded SIOCSIWCOMMIT
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Aug 2009 13:28:19 +0300
Message-ID: <20090828102819.15684.90095.stgit@fate.lan>
In-Reply-To: <20090828102742.15684.10566.stgit@fate.lan>
References: <20090828102742.15684.10566.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 919b268..6919c54 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2179,13 +2179,6 @@ static int rndis_dump_station(struct wiphy *wiphy, struct net_device *dev,
  * wireless extension handlers
  */
 
-static int rndis_iw_commit(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	/* dummy op */
-	return 0;
-}
-
 #if 0
 /* Commented code out instead of removing to have more sane patch for review.
  * Will be removed later in the set.
@@ -2558,7 +2551,6 @@ static struct iw_statistics *rndis_get_wireless_stats(struct net_device *dev)
 #define IW_IOCTL(x) [(x) - SIOCSIWCOMMIT]
 static const iw_handler rndis_iw_handler[] =
 {
-	IW_IOCTL(SIOCSIWCOMMIT)    = rndis_iw_commit,
 	IW_IOCTL(SIOCGIWNAME)      = (iw_handler) cfg80211_wext_giwname,
 	IW_IOCTL(SIOCSIWFREQ)      = (iw_handler) cfg80211_wext_siwfreq,
 	IW_IOCTL(SIOCGIWFREQ)      = (iw_handler) cfg80211_wext_giwfreq,

