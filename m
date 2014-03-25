Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:21724 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbaCYUpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 16:45:23 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Daniel Kim <dekim@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH] brcmfmac: use mfp if required from user-space
Date: Tue, 25 Mar 2014 21:45:09 +0100
Message-ID: <1395780309-28896-1-git-send-email-arend@broadcom.com> (sfid-20140325_214605_117943_C296BA0E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Kim <dekim@broadcom.com>

The struct cfg80211_connect_params indicate whether the connection
should use management frame protection (mfp). If required set the
MFP_CAPABLE flag in the firmware command. This is supported from
user-space by wpa_supplicant since v2.1.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

I had this patch lingering but with the merge window sliding a bit I
figured I could just as well submit it.

The patch is for 3.15 and applies to the master branch of the
wireless-next repository.

Regards,
Arend
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 15 ++++++++++-----
 drivers/net/wireless/brcm80211/include/brcmu_wifi.h   |  3 +++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index e0e649a..afb3d15 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1354,13 +1354,14 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 }
 
 static s32
-brcmf_set_set_cipher(struct net_device *ndev,
-		     struct cfg80211_connect_params *sme)
+brcmf_set_wsec_mode(struct net_device *ndev,
+		     struct cfg80211_connect_params *sme, bool mfp)
 {
 	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 pval = 0;
 	s32 gval = 0;
+	s32 wsec;
 	s32 err = 0;
 
 	if (sme->crypto.n_ciphers_pairwise) {
@@ -1412,7 +1413,12 @@ brcmf_set_set_cipher(struct net_device *ndev,
 	if (brcmf_find_wpsie(sme->ie, sme->ie_len) && !pval && !gval &&
 	    sme->privacy)
 		pval = AES_ENABLED;
-	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "wsec", pval | gval);
+
+	if (mfp)
+		wsec = pval | gval | MFP_CAPABLE;
+	else
+		wsec = pval | gval;
+	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "wsec", wsec);
 	if (err) {
 		brcmf_err("error (%d)\n", err);
 		return err;
@@ -1582,7 +1588,6 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	u32 ie_len;
 	struct brcmf_ext_join_params_le *ext_join_params;
 	u16 chanspec;
-
 	s32 err = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -1651,7 +1656,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		goto done;
 	}
 
-	err = brcmf_set_set_cipher(ndev, sme);
+	err = brcmf_set_wsec_mode(ndev, sme, sme->mfp == NL80211_MFP_REQUIRED);
 	if (err) {
 		brcmf_err("wl_set_set_cipher failed (%d)\n", err);
 		goto done;
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
index 7ca2aa1..74419d4 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
@@ -217,6 +217,9 @@ static inline bool ac_bitmap_tst(u8 bitmap, int prec)
 #define WSEC_SWFLAG		0x0008
 /* to go into transition mode without setting wep */
 #define SES_OW_ENABLED		0x0040
+/* MFP */
+#define MFP_CAPABLE		0x0200
+#define MFP_REQUIRED		0x0400
 
 /* WPA authentication mode bitvec */
 #define WPA_AUTH_DISABLED	0x0000	/* Legacy (i.e., non-WPA) */
-- 
1.8.1.3

