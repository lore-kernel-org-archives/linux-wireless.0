Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4915 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab2I0MSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:18:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/11] brcmfmac: use brcmf_cfg80211_priv to interface
 with wl_cfg80211 code
Date: Thu, 27 Sep 2012 14:17:52 +0200
Message-ID: <1348748277-21460-7-git-send-email-arend@broadcom.com> (sfid-20120927_141831_534140_0ECAB9D6)
In-Reply-To: <1348748277-21460-1-git-send-email-arend@broadcom.com>
References: <1348748277-21460-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The low-level driver part interfaces with wl_cfg80211 part using
brcmf_cfg80211_dev structure as handle. As brcmf_cfg80211_priv
is defined in interface it is more efficient to use that as handle
in function calls.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   48 ++++----------------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   12 ++---
 3 files changed, 15 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 9bb23b3..fc4bc6d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -585,7 +585,7 @@ struct brcmf_pub {
 	/* Linkage ponters */
 	struct brcmf_bus *bus_if;
 	struct brcmf_proto *prot;
-	struct brcmf_cfg80211_dev *config;
+	struct brcmf_cfg80211_priv *config;
 	struct device *dev;		/* fullmac dongle device pointer */
 
 	/* Internal brcmf items */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 63dbb2a..7be3ec5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -57,27 +57,6 @@ static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 
 static u32 brcmf_dbg_level = WL_DBG_ERR;
 
-static void brcmf_set_drvdata(struct brcmf_cfg80211_dev *dev, void *data)
-{
-	dev->driver_data = data;
-}
-
-static void *brcmf_get_drvdata(struct brcmf_cfg80211_dev *dev)
-{
-	void *data = NULL;
-
-	if (dev)
-		data = dev->driver_data;
-	return data;
-}
-
-static
-struct brcmf_cfg80211_priv *brcmf_priv_get(struct brcmf_cfg80211_dev *cfg_dev)
-{
-	struct brcmf_cfg80211_iface *ci = brcmf_get_drvdata(cfg_dev);
-	return ci->cfg_priv;
-}
-
 static bool check_sys_up(struct wiphy *wiphy)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
@@ -4340,9 +4319,9 @@ static void wl_deinit_priv(struct brcmf_cfg80211_priv *cfg_priv)
 	brcmf_deinit_priv_mem(cfg_priv);
 }
 
-struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
-						 struct device *busdev,
-						 struct brcmf_pub *drvr)
+struct brcmf_cfg80211_priv *brcmf_cfg80211_attach(struct net_device *ndev,
+						  struct device *busdev,
+						  struct brcmf_pub *drvr)
 {
 	struct wireless_dev *wdev;
 	struct brcmf_cfg80211_priv *cfg_priv;
@@ -4378,9 +4357,8 @@ struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
 		WL_ERR("Failed to init iwm_priv (%d)\n", err);
 		goto cfg80211_attach_out;
 	}
-	brcmf_set_drvdata(cfg_dev, ci);
-
-	return cfg_dev;
+	kfree(cfg_dev);
+	return cfg_priv;
 
 cfg80211_attach_out:
 	brcmf_free_wdev(cfg_priv);
@@ -4388,16 +4366,10 @@ cfg80211_attach_out:
 	return NULL;
 }
 
-void brcmf_cfg80211_detach(struct brcmf_cfg80211_dev *cfg_dev)
+void brcmf_cfg80211_detach(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct brcmf_cfg80211_priv *cfg_priv;
-
-	cfg_priv = brcmf_priv_get(cfg_dev);
-
 	wl_deinit_priv(cfg_priv);
 	brcmf_free_wdev(cfg_priv);
-	brcmf_set_drvdata(cfg_dev, NULL);
-	kfree(cfg_dev);
 }
 
 void
@@ -4756,12 +4728,10 @@ static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv)
 	return 0;
 }
 
-s32 brcmf_cfg80211_up(struct brcmf_cfg80211_dev *cfg_dev)
+s32 brcmf_cfg80211_up(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct brcmf_cfg80211_priv *cfg_priv;
 	s32 err = 0;
 
-	cfg_priv = brcmf_priv_get(cfg_dev);
 	mutex_lock(&cfg_priv->usr_sync);
 	err = __brcmf_cfg80211_up(cfg_priv);
 	mutex_unlock(&cfg_priv->usr_sync);
@@ -4769,12 +4739,10 @@ s32 brcmf_cfg80211_up(struct brcmf_cfg80211_dev *cfg_dev)
 	return err;
 }
 
-s32 brcmf_cfg80211_down(struct brcmf_cfg80211_dev *cfg_dev)
+s32 brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct brcmf_cfg80211_priv *cfg_priv;
 	s32 err = 0;
 
-	cfg_priv = brcmf_priv_get(cfg_dev);
 	mutex_lock(&cfg_priv->usr_sync);
 	err = __brcmf_cfg80211_down(cfg_priv);
 	mutex_unlock(&cfg_priv->usr_sync);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 9e478e0..618a600 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -497,15 +497,15 @@ brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_priv *cfg)
 	return &cfg->conn_info;
 }
 
-struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
-						 struct device *busdev,
-						 struct brcmf_pub *drvr);
-void brcmf_cfg80211_detach(struct brcmf_cfg80211_dev *cfg);
+struct brcmf_cfg80211_priv *brcmf_cfg80211_attach(struct net_device *ndev,
+						  struct device *busdev,
+						  struct brcmf_pub *drvr);
+void brcmf_cfg80211_detach(struct brcmf_cfg80211_priv *cfg_priv);
 
 /* event handler from dongle */
 void brcmf_cfg80211_event(struct net_device *ndev,
 			  const struct brcmf_event_msg *e, void *data);
-s32 brcmf_cfg80211_up(struct brcmf_cfg80211_dev *cfg_dev);
-s32 brcmf_cfg80211_down(struct brcmf_cfg80211_dev *cfg_dev);
+s32 brcmf_cfg80211_up(struct brcmf_cfg80211_priv *cfg_priv);
+s32 brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv);
 
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.9.5


