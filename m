Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:59604 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbbIRUIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 16:08:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 05/16] brcmfmac: Inform p2p module about p2pon through API
Date: Fri, 18 Sep 2015 22:08:08 +0200
Message-ID: <1442606899-31872-6-git-send-email-arend@broadcom.com> (sfid-20150918_221654_168334_0001ACD4)
In-Reply-To: <1442606899-31872-1-git-send-email-arend@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When the p2pon module param is used then p2p attach will initialize
p2p device iface in the firmware, but it is doing that by checking
data. It is cleaner to pass the p2pon information to p2p by API.
This information is also needed for other patch.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |  5 +++--
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h |  3 ++-
 drivers/net/wireless/brcm80211/brcmfmac/core.c     |  3 ++-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      | 12 ++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h      |  4 +++-
 5 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 0a97e61..3e1c8fc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -6127,7 +6127,8 @@ static void brcmf_free_wiphy(struct wiphy *wiphy)
 }
 
 struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
-						  struct device *busdev)
+						  struct device *busdev,
+						  bool p2pdev_forced)
 {
 	struct net_device *ndev = brcmf_get_ifp(drvr, 0)->ndev;
 	struct brcmf_cfg80211_info *cfg;
@@ -6219,7 +6220,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 			*cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 	}
 
-	err = brcmf_p2p_attach(cfg);
+	err = brcmf_p2p_attach(cfg, p2pdev_forced);
 	if (err) {
 		brcmf_err("P2P initilisation failed (%d)\n", err);
 		goto wiphy_unreg_out;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
index d9e6d01..3f5e550 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
@@ -469,7 +469,8 @@ brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_info *cfg)
 }
 
 struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
-						  struct device *busdev);
+						  struct device *busdev,
+						  bool p2pdev_forced);
 void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg);
 s32 brcmf_cfg80211_up(struct net_device *ndev);
 s32 brcmf_cfg80211_down(struct net_device *ndev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 571c305..3b169f5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -1044,7 +1044,8 @@ int brcmf_bus_start(struct device *dev)
 
 	brcmf_fws_add_interface(ifp);
 
-	drvr->config = brcmf_cfg80211_attach(drvr, bus_if->dev);
+	drvr->config = brcmf_cfg80211_attach(drvr, bus_if->dev,
+					     brcmf_p2p_enable);
 	if (drvr->config == NULL) {
 		ret = -ENOMEM;
 		goto fail;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 6a70c06..1e09cd2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -2336,7 +2336,7 @@ void brcmf_p2p_stop_device(struct wiphy *wiphy, struct wireless_dev *wdev)
  *
  * @cfg: driver private data for cfg80211 interface.
  */
-s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg)
+s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg, bool p2pdev_forced)
 {
 	struct brcmf_if *pri_ifp;
 	struct brcmf_if *p2p_ifp;
@@ -2351,11 +2351,15 @@ s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg)
 
 	drvr = cfg->pub;
 
-	pri_ifp = drvr->iflist[0];
-	p2p_ifp = drvr->iflist[1];
-
+	pri_ifp = brcmf_get_ifp(drvr, 0);
 	p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif = pri_ifp->vif;
 
+	if (p2pdev_forced) {
+		p2p_ifp = drvr->iflist[1];
+	} else {
+		p2p_ifp = NULL;
+		p2p->p2pdev_dynamically = true;
+	}
 	if (p2p_ifp) {
 		p2p_vif = brcmf_alloc_vif(cfg, NL80211_IFTYPE_P2P_DEVICE,
 					  false);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
index 872f382..d82287d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
@@ -124,6 +124,7 @@ struct afx_hdl {
  * @wait_next_af: thread synchronizing struct.
  * @gon_req_action: about to send go negotiation requets frame.
  * @block_gon_req_tx: drop tx go negotiation requets frame.
+ * @p2pdev_dynamically: is p2p device if created by module param or supplicant.
  */
 struct brcmf_p2p_info {
 	struct brcmf_cfg80211_info *cfg;
@@ -144,9 +145,10 @@ struct brcmf_p2p_info {
 	struct completion wait_next_af;
 	bool gon_req_action;
 	bool block_gon_req_tx;
+	bool p2pdev_dynamically;
 };
 
-s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg);
+s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg, bool p2pdev_forced);
 void brcmf_p2p_detach(struct brcmf_p2p_info *p2p);
 struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 				       unsigned char name_assign_type,
-- 
1.9.1

