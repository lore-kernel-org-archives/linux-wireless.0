Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:29319
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161113AbcBQK11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 05:27:27 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 16/21] brcmfmac: keep ARP and ND offload enabled during WOWL
Date: Wed, 17 Feb 2016 11:27:05 +0100
Message-Id: <1455704830-10088-17-git-send-email-arend@broadcom.com> (sfid-20160217_112835_197073_2B762ABE)
In-Reply-To: <1455704830-10088-1-git-send-email-arend@broadcom.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Currently ARP and ND (IPv6 Neigbor Discovery) offload get disabled
on entering suspend. However when firmwares support the wowl_cap
iovar then these offload routines can be kept enabled as they
will work during WOWL as well.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 6 ++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c  | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h  | 4 +++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 6d849bb..5609a79 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3556,7 +3556,8 @@ static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 		brcmf_report_wowl_wakeind(wiphy, ifp);
 		brcmf_fil_iovar_int_set(ifp, "wowl_clear", 0);
 		brcmf_config_wowl_pattern(ifp, "clr", NULL, 0, NULL, 0);
-		brcmf_configure_arp_nd_offload(ifp, true);
+		if (!brcmf_feat_is_enabled(ifp, BRCMF_FEAT_WOWL_ARP_ND))
+			brcmf_configure_arp_nd_offload(ifp, true);
 		brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM,
 				      cfg->wowl.pre_pmmode);
 		cfg->wowl.active = false;
@@ -3580,7 +3581,8 @@ static void brcmf_configure_wowl(struct brcmf_cfg80211_info *cfg,
 
 	brcmf_dbg(TRACE, "Suspend, wowl config.\n");
 
-	brcmf_configure_arp_nd_offload(ifp, false);
+	if (!brcmf_feat_is_enabled(ifp, BRCMF_FEAT_WOWL_ARP_ND))
+		brcmf_configure_arp_nd_offload(ifp, false);
 	brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_PM, &cfg->wowl.pre_pmmode);
 	brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM, PM_MAX);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 098732a..bfa19bb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -147,6 +147,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_WOWL)) {
 		err = brcmf_fil_iovar_int_get(ifp, "wowl_cap", &wowl_cap);
 		if (!err) {
+			ifp->drvr->feat_flags |= BIT(BRCMF_FEAT_WOWL_ARP_ND);
 			if (wowl_cap & BRCMF_WOWL_PFN_FOUND)
 				ifp->drvr->feat_flags |=
 					BIT(BRCMF_FEAT_WOWL_ND);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index f940c29..a3efa35 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -29,6 +29,7 @@
  * SCAN_RANDOM_MAC: Random MAC during (net detect) scheduled scan.
  * WOWL_ND: WOWL net detect (PNO)
  * WOWL_GTK: (WOWL) GTK rekeying offload
+ * WOWL_ARP_ND: ARP and Neighbor Discovery offload support during WOWL.
  */
 #define BRCMF_FEAT_LIST \
 	BRCMF_FEAT_DEF(MBSS) \
@@ -40,7 +41,8 @@
 	BRCMF_FEAT_DEF(TDLS) \
 	BRCMF_FEAT_DEF(SCAN_RANDOM_MAC) \
 	BRCMF_FEAT_DEF(WOWL_ND) \
-	BRCMF_FEAT_DEF(WOWL_GTK)
+	BRCMF_FEAT_DEF(WOWL_GTK) \
+	BRCMF_FEAT_DEF(WOWL_ARP_ND)
 
 /*
  * Quirks:
-- 
1.9.1

