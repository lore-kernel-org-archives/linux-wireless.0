Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3066 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab2ISUVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/13] brcmfmac: get rid of void pointer in struct
 brcmf_cfg80211_priv
Date: Wed, 19 Sep 2012 22:21:18 +0200
Message-ID: <1348086078-19183-14-git-send-email-arend@broadcom.com> (sfid-20120919_222147_809062_6B779970)
In-Reply-To: <1348086078-19183-1-git-send-email-arend@broadcom.com>
References: <1348086078-19183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Field 'pub' in struct brcmf_cfg80211_priv was types as void pointer
and filled with parameter passed in brcmf_cfg80211_attach(). This
patch makes the type specific, ie. struct brcmf_pub.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    4 ++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index e01ac96..af396e4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4268,7 +4268,7 @@ static void wl_deinit_priv(struct brcmf_cfg80211_priv *cfg_priv)
 
 struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
 						 struct device *busdev,
-						 void *data)
+						 struct brcmf_pub *drvr)
 {
 	struct wireless_dev *wdev;
 	struct brcmf_cfg80211_priv *cfg_priv;
@@ -4293,7 +4293,7 @@ struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
 	wdev->iftype = brcmf_mode_to_nl80211_iftype(WL_MODE_BSS);
 	cfg_priv = wdev_to_cfg(wdev);
 	cfg_priv->wdev = wdev;
-	cfg_priv->pub = data;
+	cfg_priv->pub = drvr;
 	ci = (struct brcmf_cfg80211_iface *)&cfg_priv->ci;
 	ci->cfg_priv = cfg_priv;
 	ndev->ieee80211_ptr = wdev;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index a2138c1..52e408e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -438,7 +438,7 @@ struct brcmf_cfg80211_priv {
 	struct brcmf_cfg80211_pmk_list *pmk_list;
 	struct work_struct event_work;
 	unsigned long status;
-	void *pub;
+	struct brcmf_pub *pub;
 	u32 channel;
 	bool iscan_on;
 	bool iscan_kickstart;
@@ -497,7 +497,7 @@ brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_priv *cfg)
 
 extern struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
 							struct device *busdev,
-							void *data);
+							struct brcmf_pub *drvr);
 extern void brcmf_cfg80211_detach(struct brcmf_cfg80211_dev *cfg);
 
 /* event handler from dongle */
-- 
1.7.9.5


