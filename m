Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:26251 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbaELIrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 04:47:47 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 13/14] brcmfmac: handle 80MHz chanspecs in construct_reg_info() function
Date: Mon, 12 May 2014 10:47:38 +0200
Message-ID: <1399884459-5048-14-git-send-email-arend@broadcom.com> (sfid-20140512_104758_448390_6577D4AF)
In-Reply-To: <1399884459-5048-1-git-send-email-arend@broadcom.com>
References: <1399884459-5048-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The device is queried about the usability of channels, but it did not
take 80MHz channels into consideration. This patch adds processing those
chanspecs and clear the NO_80MHZ flag for those control/primary channels.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   21 +++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 2d7c77d..290fc09 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -5191,6 +5191,9 @@ static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg,
 		if (!(bw_cap[band] & WLC_BW_40MHZ_BIT) &&
 		    ch.bw == BRCMU_CHAN_BW_40)
 			continue;
+		if (!(bw_cap[band] & WLC_BW_80MHZ_BIT) &&
+		    ch.bw == BRCMU_CHAN_BW_80)
+			continue;
 		update = false;
 		for (j = 0; (j < *n_cnt && (*n_cnt < array_size)); j++) {
 			if (band_chan_arr[j].hw_value == ch.chnum) {
@@ -5207,10 +5210,13 @@ static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg,
 				ieee80211_channel_to_frequency(ch.chnum, band);
 			band_chan_arr[index].hw_value = ch.chnum;
 
-			if (ch.bw == BRCMU_CHAN_BW_40) {
-				/* assuming the order is HT20, HT40 Upper,
-				 * HT40 lower from chanspecs
-				 */
+			/* assuming the chanspecs order is HT20,
+			 * HT40 upper, HT40 lower, and VHT80.
+			 */
+			if (ch.bw == BRCMU_CHAN_BW_80) {
+				band_chan_arr[index].flags &=
+					~IEEE80211_CHAN_NO_80MHZ;
+			} else if (ch.bw == BRCMU_CHAN_BW_40) {
 				ht40_flag = band_chan_arr[index].flags &
 					    IEEE80211_CHAN_NO_HT40;
 				if (ch.sb == BRCMU_CHAN_SB_U) {
@@ -5231,8 +5237,13 @@ static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg,
 						    IEEE80211_CHAN_NO_HT40MINUS;
 				}
 			} else {
+				/* disable other bandwidths for now as mentioned
+				 * order assure they are enabled for subsequent
+				 * chanspecs.
+				 */
 				band_chan_arr[index].flags =
-							IEEE80211_CHAN_NO_HT40;
+						IEEE80211_CHAN_NO_HT40 |
+						IEEE80211_CHAN_NO_80MHZ;
 				ch.bw = BRCMU_CHAN_BW_20;
 				cfg->d11inf.encchspec(&ch);
 				channel = ch.chspec;
-- 
1.7.9.5

