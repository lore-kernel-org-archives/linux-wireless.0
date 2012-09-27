Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4908 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab2I0MSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:18:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/11] brcmfmac: get rid of extern keyword in
 wl_cfg80211.h
Date: Thu, 27 Sep 2012 14:17:51 +0200
Message-ID: <1348748277-21460-6-git-send-email-arend@broadcom.com> (sfid-20120927_141823_805140_22CF4C0D)
In-Reply-To: <1348748277-21460-1-git-send-email-arend@broadcom.com>
References: <1348748277-21460-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function declarations in wl_cfg80211.h used the extern keyword
but it is redundant as that is implicit so they were removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index f2069e8..9e478e0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -497,15 +497,15 @@ brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_priv *cfg)
 	return &cfg->conn_info;
 }
 
-extern struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
-							struct device *busdev,
-							struct brcmf_pub *drvr);
-extern void brcmf_cfg80211_detach(struct brcmf_cfg80211_dev *cfg);
+struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
+						 struct device *busdev,
+						 struct brcmf_pub *drvr);
+void brcmf_cfg80211_detach(struct brcmf_cfg80211_dev *cfg);
 
 /* event handler from dongle */
-extern void brcmf_cfg80211_event(struct net_device *ndev,
-				 const struct brcmf_event_msg *e, void *data);
-extern s32 brcmf_cfg80211_up(struct brcmf_cfg80211_dev *cfg_dev);
-extern s32 brcmf_cfg80211_down(struct brcmf_cfg80211_dev *cfg_dev);
+void brcmf_cfg80211_event(struct net_device *ndev,
+			  const struct brcmf_event_msg *e, void *data);
+s32 brcmf_cfg80211_up(struct brcmf_cfg80211_dev *cfg_dev);
+s32 brcmf_cfg80211_down(struct brcmf_cfg80211_dev *cfg_dev);
 
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.9.5


