Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:53194 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751339AbeEBHQA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:16:00 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 21/21] staging: wilc1000: rename WILC_WFI_band_2ghz variable to avoid mixedcase
Date: Wed, 2 May 2018 12:43:47 +0530
Message-ID: <1525245227-3924-22-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_093235_814163_DD16D189)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename 'WILC_WFI_band_2ghz' to avoid mixedcase for variable name.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ed613b3..dd91b47 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -148,7 +148,7 @@ static u8 p2p_recv_random;
 static u8 p2p_vendor_spec[] = {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
 static bool wilc_ie;
 
-static struct ieee80211_supported_band WILC_WFI_band_2ghz = {
+static struct ieee80211_supported_band wilc_band_2ghz = {
 	.channels = ieee80211_2ghz_channels,
 	.n_channels = ARRAY_SIZE(ieee80211_2ghz_channels),
 	.bitrates = ieee80211_bitrates,
@@ -2202,13 +2202,13 @@ static struct wireless_dev *wilc_wfi_cfg_alloc(void)
 	if (!wdev->wiphy)
 		goto _fail_mem_;
 
-	WILC_WFI_band_2ghz.ht_cap.ht_supported = 1;
-	WILC_WFI_band_2ghz.ht_cap.cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
-	WILC_WFI_band_2ghz.ht_cap.mcs.rx_mask[0] = 0xff;
-	WILC_WFI_band_2ghz.ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K;
-	WILC_WFI_band_2ghz.ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;
+	wilc_band_2ghz.ht_cap.ht_supported = 1;
+	wilc_band_2ghz.ht_cap.cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
+	wilc_band_2ghz.ht_cap.mcs.rx_mask[0] = 0xff;
+	wilc_band_2ghz.ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K;
+	wilc_band_2ghz.ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;
 
-	wdev->wiphy->bands[NL80211_BAND_2GHZ] = &WILC_WFI_band_2ghz;
+	wdev->wiphy->bands[NL80211_BAND_2GHZ] = &wilc_band_2ghz;
 
 	return wdev;
 
-- 
2.7.4
