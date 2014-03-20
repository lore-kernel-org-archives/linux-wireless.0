Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:31428 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaCTJSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 05:18:10 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Daniel Kim <dekim@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/4] brcmfmac: Enable 40MHz bandwidth in 2GHz band and OBSS scanning operations
Date: Thu, 20 Mar 2014 10:18:00 +0100
Message-ID: <1395307083-31523-2-git-send-email-arend@broadcom.com> (sfid-20140320_101827_606177_1A96FFAD)
In-Reply-To: <1395307083-31523-1-git-send-email-arend@broadcom.com>
References: <1395307083-31523-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Kim <dekim@broadcom.com>

This patch enables 40MHz bandwidth in 2GHz band after checking whether
cfg80211 allows it or not, and enables OBSS scanning operations to
to support 20/40 BSS coexistence.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Daniel Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |   10 ++++++++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   26 ++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index af17a5b..614e488 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -48,6 +48,11 @@
 
 #define BRCMF_MAXRATES_IN_SET		16	/* max # of rates in rateset */
 
+/* OBSS Coex Auto/On/Off */
+#define BRCMF_OBSS_COEX_AUTO		(-1)
+#define BRCMF_OBSS_COEX_OFF		0
+#define BRCMF_OBSS_COEX_ON		1
+
 enum brcmf_fil_p2p_if_types {
 	BRCMF_FIL_P2P_IF_CLIENT,
 	BRCMF_FIL_P2P_IF_GO,
@@ -87,6 +92,11 @@ struct brcmf_fil_bss_enable_le {
 	__le32 enable;
 };
 
+struct brcmf_fil_bwcap_le {
+	__le32 band;
+	__le32 bw_cap;
+};
+
 /**
  * struct tdls_iovar - common structure for tdls iovars.
  *
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 9f75afb..428b4cb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -191,6 +191,7 @@ static struct ieee80211_supported_band __wl_band_2ghz = {
 	.n_channels = ARRAY_SIZE(__wl_2ghz_channels),
 	.bitrates = wl_g_rates,
 	.n_bitrates = wl_g_rates_size,
+	.ht_cap = {IEEE80211_HT_CAP_SUP_WIDTH_20_40, true},
 };
 
 static struct ieee80211_supported_band __wl_band_5ghz_a = {
@@ -4929,6 +4930,19 @@ static void init_vif_event(struct brcmf_cfg80211_vif_event *event)
 	mutex_init(&event->vif_event_lock);
 }
 
+static int brcmf_set_bwcap(struct brcmf_if *ifp, u32 band, u32 bw_cap)
+{
+	struct brcmf_fil_bwcap_le band_bwcap;
+	int err;
+
+	band_bwcap.band = cpu_to_le32(band);
+	band_bwcap.bw_cap = cpu_to_le32(bw_cap);
+	err = brcmf_fil_iovar_data_set(ifp, "bw_cap", &band_bwcap,
+				       sizeof(band_bwcap));
+
+	return err;
+}
+
 struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 						  struct device *busdev)
 {
@@ -4986,6 +5000,18 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		goto cfg80211_p2p_attach_out;
 	}
 
+	/* If cfg80211 didn't disable 40MHz HT CAP in wiphy_register(),
+	 * setup 40MHz in 2GHz band and enable OBSS scanning.
+	 */
+	if (wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.cap &
+	    IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
+		err = brcmf_set_bwcap(ifp, WLC_BAND_2G, WLC_BW_CAP_40MHZ);
+		if (!err) {
+			err = brcmf_fil_iovar_int_set(ifp, "obss_coex",
+						      BRCMF_OBSS_COEX_AUTO);
+		}
+	}
+
 	err = brcmf_fil_iovar_int_set(ifp, "tdls_enable", 1);
 	if (err) {
 		brcmf_dbg(INFO, "TDLS not enabled (%d)\n", err);
-- 
1.7.9.5

