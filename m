Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35297 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbcATPqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 10:46:12 -0500
Received: by mail-lf0-f49.google.com with SMTP id c192so8497153lfe.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 07:46:11 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] brcmfmac: fix setting primary channel for 80 MHz width
Date: Wed, 20 Jan 2016 16:46:04 +0100
Message-Id: <1453304764-11895-1-git-send-email-zajec5@gmail.com> (sfid-20160120_164615_675932_4092AD09)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First of all it changes the way we calculate primary channel offset. If
we use e.g. 80 MHz channel with primary frequency 5180 MHz (which means
center frequency is 5210 MHz) it makes sense to calculate primary offset
as -30 MHz.
Then it fixes values we compare primary_offset with. We were comparing
offset in MHz against -2 or 2 which was resulting in picking a wrong
primary channel.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 23 ++++++++++------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 8d9cff4..2b335de 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -247,7 +247,7 @@ static u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
 	brcmf_dbg(TRACE, "chandef: control %d center %d width %d\n",
 		  ch->chan->center_freq, ch->center_freq1, ch->width);
 	ch_inf.chnum = ieee80211_frequency_to_channel(ch->center_freq1);
-	primary_offset = ch->center_freq1 - ch->chan->center_freq;
+	primary_offset = ch->chan->center_freq - ch->center_freq1;
 	switch (ch->width) {
 	case NL80211_CHAN_WIDTH_20:
 	case NL80211_CHAN_WIDTH_20_NOHT:
@@ -256,24 +256,21 @@ static u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
 		break;
 	case NL80211_CHAN_WIDTH_40:
 		ch_inf.bw = BRCMU_CHAN_BW_40;
-		if (primary_offset < 0)
+		if (primary_offset > 0)
 			ch_inf.sb = BRCMU_CHAN_SB_U;
 		else
 			ch_inf.sb = BRCMU_CHAN_SB_L;
 		break;
 	case NL80211_CHAN_WIDTH_80:
 		ch_inf.bw = BRCMU_CHAN_BW_80;
-		if (primary_offset < 0) {
-			if (primary_offset < -CH_10MHZ_APART)
-				ch_inf.sb = BRCMU_CHAN_SB_UU;
-			else
-				ch_inf.sb = BRCMU_CHAN_SB_UL;
-		} else {
-			if (primary_offset > CH_10MHZ_APART)
-				ch_inf.sb = BRCMU_CHAN_SB_LL;
-			else
-				ch_inf.sb = BRCMU_CHAN_SB_LU;
-		}
+		if (primary_offset == -30)
+			ch_inf.sb = BRCMU_CHAN_SB_LL;
+		else if (primary_offset == -10)
+			ch_inf.sb = BRCMU_CHAN_SB_LU;
+		else if (primary_offset == 10)
+			ch_inf.sb = BRCMU_CHAN_SB_UL;
+		else
+			ch_inf.sb = BRCMU_CHAN_SB_UU;
 		break;
 	case NL80211_CHAN_WIDTH_80P80:
 	case NL80211_CHAN_WIDTH_160:
-- 
1.8.4.5

