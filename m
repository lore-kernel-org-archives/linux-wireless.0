Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:20084 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaCTJSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 05:18:10 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/4] brcmfmac: fallback to mimo_bw_cap for older firmwares
Date: Thu, 20 Mar 2014 10:18:03 +0100
Message-ID: <1395307083-31523-5-git-send-email-arend@broadcom.com> (sfid-20140320_101820_353642_7BB6972A)
In-Reply-To: <1395307083-31523-1-git-send-email-arend@broadcom.com>
References: <1395307083-31523-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to support the driver behaviour introduced by:

   commit d0575a5a703978c43e25128421158c78534ba100
   Author: Daniel Kim <dekim@broadcom.com>
   Date:   Wed Mar 12 18:12:14 2014 -0700

       brcmfmac: Enable 40MHz bandwidth in 2GHz band and OBSS scanning

in devices that do not support bwcap firmware command a fallback
is added.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   26 ++++++++++++++------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 428b4cb..e0e649a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4930,16 +4930,27 @@ static void init_vif_event(struct brcmf_cfg80211_vif_event *event)
 	mutex_init(&event->vif_event_lock);
 }
 
-static int brcmf_set_bwcap(struct brcmf_if *ifp, u32 band, u32 bw_cap)
+static int brcmf_enable_bw40_2g(struct brcmf_if *ifp)
 {
 	struct brcmf_fil_bwcap_le band_bwcap;
+	u32 val;
 	int err;
 
-	band_bwcap.band = cpu_to_le32(band);
-	band_bwcap.bw_cap = cpu_to_le32(bw_cap);
-	err = brcmf_fil_iovar_data_set(ifp, "bw_cap", &band_bwcap,
-				       sizeof(band_bwcap));
+	/* verify support for bw_cap command */
+	val = WLC_BAND_5G;
+	err = brcmf_fil_iovar_int_get(ifp, "bw_cap", &val);
 
+	if (!err) {
+		/* only set 2G bandwidth using bw_cap command */
+		band_bwcap.band = cpu_to_le32(WLC_BAND_2G);
+		band_bwcap.bw_cap = cpu_to_le32(WLC_BW_40MHZ_BIT);
+		err = brcmf_fil_iovar_data_set(ifp, "bw_cap", &band_bwcap,
+					       sizeof(band_bwcap));
+	} else {
+		brcmf_dbg(INFO, "fallback to mimo_bw_cap\n");
+		val = WLC_N_BW_40ALL;
+		err = brcmf_fil_iovar_int_set(ifp, "mimo_bw_cap", val);
+	}
 	return err;
 }
 
@@ -5005,11 +5016,10 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	 */
 	if (wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.cap &
 	    IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
-		err = brcmf_set_bwcap(ifp, WLC_BAND_2G, WLC_BW_CAP_40MHZ);
-		if (!err) {
+		err = brcmf_enable_bw40_2g(ifp);
+		if (!err)
 			err = brcmf_fil_iovar_int_set(ifp, "obss_coex",
 						      BRCMF_OBSS_COEX_AUTO);
-		}
 	}
 
 	err = brcmf_fil_iovar_int_set(ifp, "tdls_enable", 1);
-- 
1.7.9.5

