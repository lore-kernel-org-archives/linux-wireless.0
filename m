Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4910 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab2I0MSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:18:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/11] brcmfmac: remove two obsolete structure
 definitions
Date: Thu, 27 Sep 2012 14:17:53 +0200
Message-ID: <1348748277-21460-8-git-send-email-arend@broadcom.com> (sfid-20120927_141840_317338_55E348C1)
In-Reply-To: <1348748277-21460-1-git-send-email-arend@broadcom.com>
References: <1348748277-21460-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The structures brcmf_cfg80211_dev and brcmf_cfg80211_iface are only
adding complexity and provide no additional value. These have been
removed in this patch.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   21 +++++---------------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   19 +++---------------
 2 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 7be3ec5..e25430d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3648,8 +3648,7 @@ static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 #endif
 }
 
-static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
-					  struct device *ndev)
+static struct wireless_dev *brcmf_alloc_wdev(struct device *ndev)
 {
 	struct wireless_dev *wdev;
 	s32 err = 0;
@@ -3658,9 +3657,8 @@ static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
 	if (!wdev)
 		return ERR_PTR(-ENOMEM);
 
-	wdev->wiphy =
-	    wiphy_new(&wl_cfg80211_ops,
-		      sizeof(struct brcmf_cfg80211_priv) + sizeof_iface);
+	wdev->wiphy = wiphy_new(&wl_cfg80211_ops,
+				sizeof(struct brcmf_cfg80211_priv));
 	if (!wdev->wiphy) {
 		WL_ERR("Could not allocate wiphy device\n");
 		err = -ENOMEM;
@@ -4325,21 +4323,15 @@ struct brcmf_cfg80211_priv *brcmf_cfg80211_attach(struct net_device *ndev,
 {
 	struct wireless_dev *wdev;
 	struct brcmf_cfg80211_priv *cfg_priv;
-	struct brcmf_cfg80211_iface *ci;
-	struct brcmf_cfg80211_dev *cfg_dev;
 	s32 err = 0;
 
 	if (!ndev) {
 		WL_ERR("ndev is invalid\n");
 		return NULL;
 	}
-	cfg_dev = kzalloc(sizeof(struct brcmf_cfg80211_dev), GFP_KERNEL);
-	if (!cfg_dev)
-		return NULL;
 
-	wdev = brcmf_alloc_wdev(sizeof(struct brcmf_cfg80211_iface), busdev);
+	wdev = brcmf_alloc_wdev(busdev);
 	if (IS_ERR(wdev)) {
-		kfree(cfg_dev);
 		return NULL;
 	}
 
@@ -4347,8 +4339,6 @@ struct brcmf_cfg80211_priv *brcmf_cfg80211_attach(struct net_device *ndev,
 	cfg_priv = wdev_to_cfg(wdev);
 	cfg_priv->wdev = wdev;
 	cfg_priv->pub = drvr;
-	ci = (struct brcmf_cfg80211_iface *)&cfg_priv->ci;
-	ci->cfg_priv = cfg_priv;
 	ndev->ieee80211_ptr = wdev;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
@@ -4357,12 +4347,11 @@ struct brcmf_cfg80211_priv *brcmf_cfg80211_attach(struct net_device *ndev,
 		WL_ERR("Failed to init iwm_priv (%d)\n", err);
 		goto cfg80211_attach_out;
 	}
-	kfree(cfg_dev);
+
 	return cfg_priv;
 
 cfg80211_attach_out:
 	brcmf_free_wdev(cfg_priv);
-	kfree(cfg_dev);
 	return NULL;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 618a600..97f36d3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -17,12 +17,6 @@
 #ifndef _wl_cfg80211_h_
 #define _wl_cfg80211_h_
 
-struct brcmf_cfg80211_conf;
-struct brcmf_cfg80211_iface;
-struct brcmf_cfg80211_priv;
-struct brcmf_cfg80211_security;
-struct brcmf_cfg80211_ibss;
-
 #define WL_DBG_NONE		0
 #define WL_DBG_CONN		(1 << 5)
 #define WL_DBG_SCAN		(1 << 4)
@@ -178,6 +172,9 @@ struct brcmf_cfg80211_conf {
 	struct ieee80211_channel channel;
 };
 
+/* forward declaration */
+struct brcmf_cfg80211_priv;
+
 /* cfg80211 main event loop */
 struct brcmf_cfg80211_event_loop {
 	s32(*handler[BRCMF_E_LAST]) (struct brcmf_cfg80211_priv *cfg_priv,
@@ -186,15 +183,6 @@ struct brcmf_cfg80211_event_loop {
 				     void *data);
 };
 
-/* representing interface of cfg80211 plane */
-struct brcmf_cfg80211_iface {
-	struct brcmf_cfg80211_priv *cfg_priv;
-};
-
-struct brcmf_cfg80211_dev {
-	void *driver_data;	/* to store cfg80211 object information */
-};
-
 /* basic structure of scan request */
 struct brcmf_cfg80211_scan_req {
 	struct brcmf_ssid_le ssid_le;
@@ -460,7 +448,6 @@ struct brcmf_cfg80211_priv {
 	struct timer_list escan_timeout;
 	struct work_struct escan_timeout_work;
 	u8 *escan_ioctl_buf;
-	u8 ci[0] __aligned(NETDEV_ALIGN);
 };
 
 static inline struct wiphy *cfg_to_wiphy(struct brcmf_cfg80211_priv *w)
-- 
1.7.9.5


