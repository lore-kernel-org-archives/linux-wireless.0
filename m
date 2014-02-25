Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:44801 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaBYTap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 14:30:45 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Kim <dekim@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 12/14] brcmfmac: Correct mcs index report
Date: Tue, 25 Feb 2014 20:30:36 +0100
Message-ID: <1393356639-19169-13-git-send-email-arend@broadcom.com> (sfid-20140225_203127_170387_03480FFA)
In-Reply-To: <1393356639-19169-1-git-send-email-arend@broadcom.com>
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Kim <dekim@broadcom.com>

There is a mismatch between the mcs index(0-7) reported to cfg80211
and the actual mcs index(0-15) in use. This patch resolves the mismatch
by setting mcs info with the number of chains read from FW.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Daniel Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 81be69d..da7d055 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -5306,6 +5306,8 @@ static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 	u32 band_list[3];
 	u32 nmode;
 	u32 bw_cap[2] = { 0, 0 };
+	u32 rxchain;
+	u32 nchain;
 	s8 phy;
 	s32 err;
 	u32 nband;
@@ -5342,6 +5344,16 @@ static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 	brcmf_dbg(INFO, "nmode=%d, bw_cap=(%d, %d)\n", nmode,
 		  bw_cap[IEEE80211_BAND_2GHZ], bw_cap[IEEE80211_BAND_5GHZ]);
 
+	err = brcmf_fil_iovar_int_get(ifp, "rxchain", &rxchain);
+	if (err) {
+		brcmf_err("rxchain error (%d)\n", err);
+		nchain = 1;
+	} else {
+		for (nchain = 0; rxchain; nchain++)
+			rxchain = rxchain & (rxchain - 1);
+	}
+	brcmf_dbg(INFO, "nchain=%d\n", nchain);
+
 	err = brcmf_construct_reginfo(cfg, bw_cap);
 	if (err) {
 		brcmf_err("brcmf_construct_reginfo failed (%d)\n", err);
@@ -5370,10 +5382,7 @@ static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 		band->ht_cap.ht_supported = true;
 		band->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
 		band->ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16;
-		/* An HT shall support all EQM rates for one spatial
-		 * stream
-		 */
-		band->ht_cap.mcs.rx_mask[0] = 0xff;
+		memset(band->ht_cap.mcs.rx_mask, 0xff, nchain);
 		band->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 		bands[band->band] = band;
 	}
-- 
1.7.10.4

