Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:38053 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbbFJWMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 18:12:32 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 6/7] brcmfmac: move p2p attach/detach functions
Date: Thu, 11 Jun 2015 00:12:22 +0200
Message-ID: <1433974343-16982-7-git-send-email-arend@broadcom.com> (sfid-20150611_001255_504367_992EA014)
In-Reply-To: <1433974343-16982-1-git-send-email-arend@broadcom.com>
References: <1433974343-16982-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving two functions in p2p.c as is so next change will be
easier to review.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c | 198 +++++++++++++-------------
 1 file changed, 99 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index abcaa77..920fcd9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1908,105 +1908,6 @@ s32 brcmf_p2p_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
 
 
 /**
- * brcmf_p2p_attach() - attach for P2P.
- *
- * @cfg: driver private data for cfg80211 interface.
- */
-s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg)
-{
-	struct brcmf_if *pri_ifp;
-	struct brcmf_if *p2p_ifp;
-	struct brcmf_cfg80211_vif *p2p_vif;
-	struct brcmf_p2p_info *p2p;
-	struct brcmf_pub *drvr;
-	s32 bssidx;
-	s32 err = 0;
-
-	p2p = &cfg->p2p;
-	p2p->cfg = cfg;
-
-	drvr = cfg->pub;
-
-	pri_ifp = drvr->iflist[0];
-	p2p_ifp = drvr->iflist[1];
-
-	p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif = pri_ifp->vif;
-
-	if (p2p_ifp) {
-		p2p_vif = brcmf_alloc_vif(cfg, NL80211_IFTYPE_P2P_DEVICE,
-					  false);
-		if (IS_ERR(p2p_vif)) {
-			brcmf_err("could not create discovery vif\n");
-			err = -ENOMEM;
-			goto exit;
-		}
-
-		p2p_vif->ifp = p2p_ifp;
-		p2p_ifp->vif = p2p_vif;
-		p2p_vif->wdev.netdev = p2p_ifp->ndev;
-		p2p_ifp->ndev->ieee80211_ptr = &p2p_vif->wdev;
-		SET_NETDEV_DEV(p2p_ifp->ndev, wiphy_dev(cfg->wiphy));
-
-		p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = p2p_vif;
-
-		brcmf_p2p_generate_bss_mac(p2p, NULL);
-		memcpy(p2p_ifp->mac_addr, p2p->dev_addr, ETH_ALEN);
-		brcmf_p2p_set_firmware(pri_ifp, p2p->dev_addr);
-
-		/* Initialize P2P Discovery in the firmware */
-		err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
-		if (err < 0) {
-			brcmf_err("set p2p_disc error\n");
-			brcmf_free_vif(p2p_vif);
-			goto exit;
-		}
-		/* obtain bsscfg index for P2P discovery */
-		err = brcmf_fil_iovar_int_get(pri_ifp, "p2p_dev", &bssidx);
-		if (err < 0) {
-			brcmf_err("retrieving discover bsscfg index failed\n");
-			brcmf_free_vif(p2p_vif);
-			goto exit;
-		}
-		/* Verify that firmware uses same bssidx as driver !! */
-		if (p2p_ifp->bssidx != bssidx) {
-			brcmf_err("Incorrect bssidx=%d, compared to p2p_ifp->bssidx=%d\n",
-				  bssidx, p2p_ifp->bssidx);
-			brcmf_free_vif(p2p_vif);
-			goto exit;
-		}
-
-		init_completion(&p2p->send_af_done);
-		INIT_WORK(&p2p->afx_hdl.afx_work, brcmf_p2p_afx_handler);
-		init_completion(&p2p->afx_hdl.act_frm_scan);
-		init_completion(&p2p->wait_next_af);
-	}
-exit:
-	return err;
-}
-
-
-/**
- * brcmf_p2p_detach() - detach P2P.
- *
- * @p2p: P2P specific data.
- */
-void brcmf_p2p_detach(struct brcmf_p2p_info *p2p)
-{
-	struct brcmf_cfg80211_vif *vif;
-
-	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
-	if (vif != NULL) {
-		brcmf_p2p_cancel_remain_on_channel(vif->ifp);
-		brcmf_p2p_deinit_discovery(p2p);
-		/* remove discovery interface */
-		brcmf_free_vif(vif);
-		p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
-	}
-	/* just set it all to zero */
-	memset(p2p, 0, sizeof(*p2p));
-}
-
-/**
  * brcmf_p2p_get_current_chanspec() - Get current operation channel.
  *
  * @p2p: P2P specific data.
@@ -2428,3 +2329,102 @@ void brcmf_p2p_stop_device(struct wiphy *wiphy, struct wireless_dev *wdev)
 	clear_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state);
 	mutex_unlock(&cfg->usr_sync);
 }
+
+/**
+ * brcmf_p2p_attach() - attach for P2P.
+ *
+ * @cfg: driver private data for cfg80211 interface.
+ */
+s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg)
+{
+	struct brcmf_if *pri_ifp;
+	struct brcmf_if *p2p_ifp;
+	struct brcmf_cfg80211_vif *p2p_vif;
+	struct brcmf_p2p_info *p2p;
+	struct brcmf_pub *drvr;
+	s32 bssidx;
+	s32 err = 0;
+
+	p2p = &cfg->p2p;
+	p2p->cfg = cfg;
+
+	drvr = cfg->pub;
+
+	pri_ifp = drvr->iflist[0];
+	p2p_ifp = drvr->iflist[1];
+
+	p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif = pri_ifp->vif;
+
+	if (p2p_ifp) {
+		p2p_vif = brcmf_alloc_vif(cfg, NL80211_IFTYPE_P2P_DEVICE,
+					  false);
+		if (IS_ERR(p2p_vif)) {
+			brcmf_err("could not create discovery vif\n");
+			err = -ENOMEM;
+			goto exit;
+		}
+
+		p2p_vif->ifp = p2p_ifp;
+		p2p_ifp->vif = p2p_vif;
+		p2p_vif->wdev.netdev = p2p_ifp->ndev;
+		p2p_ifp->ndev->ieee80211_ptr = &p2p_vif->wdev;
+		SET_NETDEV_DEV(p2p_ifp->ndev, wiphy_dev(cfg->wiphy));
+
+		p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = p2p_vif;
+
+		brcmf_p2p_generate_bss_mac(p2p, NULL);
+		memcpy(p2p_ifp->mac_addr, p2p->dev_addr, ETH_ALEN);
+		brcmf_p2p_set_firmware(pri_ifp, p2p->dev_addr);
+
+		/* Initialize P2P Discovery in the firmware */
+		err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
+		if (err < 0) {
+			brcmf_err("set p2p_disc error\n");
+			brcmf_free_vif(p2p_vif);
+			goto exit;
+		}
+		/* obtain bsscfg index for P2P discovery */
+		err = brcmf_fil_iovar_int_get(pri_ifp, "p2p_dev", &bssidx);
+		if (err < 0) {
+			brcmf_err("retrieving discover bsscfg index failed\n");
+			brcmf_free_vif(p2p_vif);
+			goto exit;
+		}
+		/* Verify that firmware uses same bssidx as driver !! */
+		if (p2p_ifp->bssidx != bssidx) {
+			brcmf_err("Incorrect bssidx=%d, compared to p2p_ifp->bssidx=%d\n",
+				  bssidx, p2p_ifp->bssidx);
+			brcmf_free_vif(p2p_vif);
+			goto exit;
+		}
+
+		init_completion(&p2p->send_af_done);
+		INIT_WORK(&p2p->afx_hdl.afx_work, brcmf_p2p_afx_handler);
+		init_completion(&p2p->afx_hdl.act_frm_scan);
+		init_completion(&p2p->wait_next_af);
+	}
+exit:
+	return err;
+}
+
+/**
+ * brcmf_p2p_detach() - detach P2P.
+ *
+ * @p2p: P2P specific data.
+ */
+void brcmf_p2p_detach(struct brcmf_p2p_info *p2p)
+{
+	struct brcmf_cfg80211_vif *vif;
+
+	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+	if (vif != NULL) {
+		brcmf_p2p_cancel_remain_on_channel(vif->ifp);
+		brcmf_p2p_deinit_discovery(p2p);
+		/* remove discovery interface */
+		brcmf_free_vif(vif);
+		p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
+	}
+	/* just set it all to zero */
+	memset(p2p, 0, sizeof(*p2p));
+}
+
-- 
1.9.1

