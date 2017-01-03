Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33961 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753120AbdACQto (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 11:49:44 -0500
Received: by mail-lf0-f65.google.com with SMTP id d16so30597881lfb.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2017 08:49:43 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH next V2] brcmfmac: avoid writing channel out of allocated array
Date: Tue,  3 Jan 2017 17:49:30 +0100
Message-Id: <20170103164930.29989-1-zajec5@gmail.com> (sfid-20170103_175007_851683_EA0DF468)
In-Reply-To: <20170103083858.6981-1-zajec5@gmail.com>
References: <20170103083858.6981-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Our code was assigning number of channels to the index variable by
default. If firmware reported channel we didn't predict this would
result in using that initial index value and writing out of array. This
never happened so far (we got a complete list of supported channels) but
it means possible memory corruption so we should handle it anyway.

This patch simply detects unexpected channel and ignores it.

As we don't try to create new entry now, it's also safe to drop hw_value
and center_freq assignment. For known channels we have these set anyway.

I decided to fix this issue by assigning NULL or a target channel to the
channel variable. This was one of possible ways, I prefefred this one as
it also avoids using channel[index] over and over.

Fixes: 58de92d2f95e ("brcmfmac: use static superset of channels for wiphy bands")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Add extra comment in code for not-found channel.
    Make it clear this problem have never been seen so far
    Explain why it's safe to drop extra assignments
    Note & reason changing channel variable usage
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 32 ++++++++++++----------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 9c2c128..a16dd7b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5825,7 +5825,6 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 	u32 i, j;
 	u32 total;
 	u32 chaninfo;
-	u32 index;
 
 	pbuf = kzalloc(BRCMF_DCMD_MEDLEN, GFP_KERNEL);
 
@@ -5873,33 +5872,36 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 		    ch.bw == BRCMU_CHAN_BW_80)
 			continue;
 
-		channel = band->channels;
-		index = band->n_channels;
+		channel = NULL;
 		for (j = 0; j < band->n_channels; j++) {
-			if (channel[j].hw_value == ch.control_ch_num) {
-				index = j;
+			if (band->channels[j].hw_value == ch.control_ch_num) {
+				channel = &band->channels[j];
 				break;
 			}
 		}
-		channel[index].center_freq =
-			ieee80211_channel_to_frequency(ch.control_ch_num,
-						       band->band);
-		channel[index].hw_value = ch.control_ch_num;
+		if (!channel) {
+			/* It seems firmware supports some channel we never
+			 * considered. Something new in IEEE standard?
+			 */
+			brcmf_err("Firmware reported unexpected channel %d\n",
+				  ch.control_ch_num);
+			continue;
+		}
 
 		/* assuming the chanspecs order is HT20,
 		 * HT40 upper, HT40 lower, and VHT80.
 		 */
 		if (ch.bw == BRCMU_CHAN_BW_80) {
-			channel[index].flags &= ~IEEE80211_CHAN_NO_80MHZ;
+			channel->flags &= ~IEEE80211_CHAN_NO_80MHZ;
 		} else if (ch.bw == BRCMU_CHAN_BW_40) {
-			brcmf_update_bw40_channel_flag(&channel[index], &ch);
+			brcmf_update_bw40_channel_flag(channel, &ch);
 		} else {
 			/* enable the channel and disable other bandwidths
 			 * for now as mentioned order assure they are enabled
 			 * for subsequent chanspecs.
 			 */
-			channel[index].flags = IEEE80211_CHAN_NO_HT40 |
-					       IEEE80211_CHAN_NO_80MHZ;
+			channel->flags = IEEE80211_CHAN_NO_HT40 |
+					 IEEE80211_CHAN_NO_80MHZ;
 			ch.bw = BRCMU_CHAN_BW_20;
 			cfg->d11inf.encchspec(&ch);
 			chaninfo = ch.chspec;
@@ -5907,11 +5909,11 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 						       &chaninfo);
 			if (!err) {
 				if (chaninfo & WL_CHAN_RADAR)
-					channel[index].flags |=
+					channel->flags |=
 						(IEEE80211_CHAN_RADAR |
 						 IEEE80211_CHAN_NO_IR);
 				if (chaninfo & WL_CHAN_PASSIVE)
-					channel[index].flags |=
+					channel->flags |=
 						IEEE80211_CHAN_NO_IR;
 			}
 		}
-- 
2.10.1
