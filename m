Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4643 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760208Ab3BHO4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:43 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/27] brcmfmac: update escan for multiple bss and
 simplify.
Date: Fri, 8 Feb 2013 15:53:42 +0100
Message-ID: <1360335242-12608-8-git-send-email-arend@broadcom.com> (sfid-20130208_160231_501152_3BAA0DBD)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Add support for scanning on non primary netdev (p2p) and
simplify the p2p scanning preparation.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   92 +++-----------------
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h      |    3 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    8 +-
 3 files changed, 19 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index fff5722..aef0287 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -91,11 +91,6 @@ struct brcmf_p2p_scan_le {
 	};
 };
 
-static struct brcmf_cfg80211_vif *p2p_discover_vif(struct brcmf_p2p_info *p2p)
-{
-	return p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
-}
-
 /**
  * brcmf_p2p_set_firmware() - prepare firmware for peer-to-peer operation.
  *
@@ -195,34 +190,6 @@ static s32 brcmf_p2p_set_discover_state(struct brcmf_if *ifp, u8 state,
 }
 
 /**
- * brcmf_p2p_discover_disable_search() - reset discover state.
- *
- * @p2p: P2P specific data.
- *
- * Reset the discover state to @WL_P2P_DISC_ST_SCAN. Returns 0 on success.
- */
-static s32 brcmf_p2p_discover_disable_search(struct brcmf_p2p_info *p2p)
-{
-	struct brcmf_cfg80211_vif *vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
-	struct brcmf_p2p_disc_st_le discovery_mode;
-	int ret;
-
-	/*
-	 * vif presence indicates discovery is initialized.
-	 */
-	if (!vif)
-		return -ENODEV;
-
-	ret = brcmf_fil_bsscfg_data_get(vif->ifp, "p2p_state",
-					&discovery_mode,
-					sizeof(discovery_mode));
-	if (!ret && discovery_mode.state != WL_P2P_DISC_ST_SCAN)
-		ret = brcmf_p2p_set_discover_state(vif->ifp,
-						  WL_P2P_DISC_ST_SCAN, 0, 0);
-	return ret;
-}
-
-/**
  * brcmf_p2p_init_discovery() - enable discovery in the firmware.
  *
  * @p2p: P2P specific data.
@@ -376,32 +343,6 @@ exit:
 }
 
 /**
- * brcmf_p2p_configure_probereq() - Configure probe request data.
- *
- * @p2p: P2P specific data.
- * @ie: buffer containing information elements.
- * @ie_len: length of @ie buffer.
- *
- */
-static int brcmf_p2p_configure_probereq(struct brcmf_p2p_info *p2p,
-					const u8 *ie, u32 ie_len)
-{
-	struct brcmf_cfg80211_vif *vif;
-	s32 err = 0;
-
-	brcmf_dbg(TRACE, "enter\n");
-	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
-
-	err = brcmf_vif_set_mgmt_ie(vif, BRCMF_VNDR_IE_PRBREQ_FLAG,
-				    ie, ie_len);
-
-	if (err < 0)
-		brcmf_err("set probreq ie occurs error %d\n", err);
-
-	return err;
-}
-
-/*
  * brcmf_p2p_escan() - initiate a P2P scan.
  *
  * @p2p: P2P specific data.
@@ -621,12 +562,14 @@ exit:
  *
  * @wiphy: wiphy device.
  * @request: scan request from cfg80211.
+ * @vif: vif on which scan request is to be executed.
  *
  * Prepare the scan appropriately for type of scan requested. Overrides the
  * escan .run() callback for peer-to-peer scanning.
  */
 int brcmf_p2p_scan_prep(struct wiphy *wiphy,
-			struct cfg80211_scan_request *request)
+			struct cfg80211_scan_request *request,
+			struct brcmf_cfg80211_vif *vif)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
@@ -644,31 +587,16 @@ int brcmf_p2p_scan_prep(struct wiphy *wiphy,
 		brcmf_dbg(INFO, "P2P: GO_NEG_PHASE status cleared\n");
 
 		err = brcmf_p2p_enable_discovery(p2p);
-		if (err == 0)
-			err = brcmf_p2p_configure_probereq(p2p, request->ie,
-							   request->ie_len);
+		if (err)
+			return err;
 
-		/*
-		 * override .run_escan() callback.
-		 */
-		cfg->escan_info.run = brcmf_p2p_run_escan;
-	} else {
-		/*
-		 * legacy scan trigger
-		 * So, we have to disable p2p discovery if p2p discovery is on
-		 */
-		(void)brcmf_p2p_discover_disable_search(p2p);
+		vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
 
-		/*
-		 * clear p2p vendor ies for probe request set by
-		 * previous p2p related scan(s).
-		 */
-		if (p2p_discover_vif(p2p))
-			err = brcmf_vif_set_mgmt_ie(p2p_discover_vif(p2p),
-						    BRCMF_VNDR_IE_PRBREQ_FLAG,
-						    request->ie,
-						    request->ie_len);
+		/* override .run_escan() callback. */
+		cfg->escan_info.run = brcmf_p2p_run_escan;
 	}
+	err = brcmf_vif_set_mgmt_ie(vif, BRCMF_VNDR_IE_PRBREQ_FLAG,
+				    request->ie, request->ie_len);
 	return err;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
index df93272..1f97afd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
@@ -111,7 +111,8 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev);
 int brcmf_p2p_start_device(struct wiphy *wiphy, struct wireless_dev *wdev);
 void brcmf_p2p_stop_device(struct wiphy *wiphy, struct wireless_dev *wdev);
 int brcmf_p2p_scan_prep(struct wiphy *wiphy,
-			struct cfg80211_scan_request *request);
+			struct cfg80211_scan_request *request,
+			struct brcmf_cfg80211_vif *vif);
 int brcmf_p2p_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 				struct ieee80211_channel *channel,
 				unsigned int duration, u64 *cookie);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d792c3b..c57c1db 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -805,6 +805,12 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 		return -EAGAIN;
 	}
 
+	/* If scan req comes for p2p0, send it over primary I/F */
+	if (ifp->vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif) {
+		ifp = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
+		ndev = ifp->ndev;
+	}
+
 	/* Arm scan timeout timer */
 	mod_timer(&cfg->escan_timeout, jiffies +
 			WL_ESCAN_TIMER_INTERVAL_MS * HZ / 1000);
@@ -824,7 +830,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 	set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 	if (escan_req) {
 		cfg->escan_info.run = brcmf_run_escan;
-		err = brcmf_p2p_scan_prep(wiphy, request);
+		err = brcmf_p2p_scan_prep(wiphy, request, ifp->vif);
 		if (err)
 			goto scan_out;
 
-- 
1.7.10.4


