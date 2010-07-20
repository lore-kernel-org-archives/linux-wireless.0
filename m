Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35505 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab0GTSaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 14:30:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libipw: correct sparse warnings and mark some variables static
Date: Tue, 20 Jul 2010 14:17:52 -0400
Message-Id: <1279649872-6998-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   drivers/net/wireless/ipw2x00/libipw_module.c
drivers/net/wireless/ipw2x00/libipw_module.c:65:21: warning: symbol 'libipw_config_ops' was not declared. Should it be static?
drivers/net/wireless/ipw2x00/libipw_module.c:66:6: warning: symbol 'libipw_wiphy_privid' was not declared. Should it be static?
  CHECK   drivers/net/wireless/ipw2x00/libipw_wx.c
drivers/net/wireless/ipw2x00/libipw_wx.c:415:17: warning: symbol 'ssid' shadows an earlier one
drivers/net/wireless/ipw2x00/libipw_wx.c:324:9: originally declared here

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ipw2x00/libipw_module.c |    4 ++--
 drivers/net/wireless/ipw2x00/libipw_wx.c     |    4 ----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/libipw_module.c b/drivers/net/wireless/ipw2x00/libipw_module.c
index 5596540..32dee2c 100644
--- a/drivers/net/wireless/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -62,8 +62,8 @@ MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
 MODULE_LICENSE("GPL");
 
-struct cfg80211_ops libipw_config_ops = { };
-void *libipw_wiphy_privid = &libipw_wiphy_privid;
+static struct cfg80211_ops libipw_config_ops = { };
+static void *libipw_wiphy_privid = &libipw_wiphy_privid;
 
 static int libipw_networks_allocate(struct libipw_device *ieee)
 {
diff --git a/drivers/net/wireless/ipw2x00/libipw_wx.c b/drivers/net/wireless/ipw2x00/libipw_wx.c
index 3633c66..8a4bae4 100644
--- a/drivers/net/wireless/ipw2x00/libipw_wx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_wx.c
@@ -411,10 +411,6 @@ int libipw_wx_set_encode(struct libipw_device *ieee,
 
 	/* If a new key was provided, set it up */
 	if (erq->length > 0) {
-#ifdef CONFIG_LIBIPW_DEBUG
-		DECLARE_SSID_BUF(ssid);
-#endif
-
 		len = erq->length <= 5 ? 5 : 13;
 		memcpy(sec.keys[key], keybuf, erq->length);
 		if (len > erq->length)
-- 
1.7.1.1

