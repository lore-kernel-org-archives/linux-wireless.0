Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33943 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaLTSZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2014 13:25:21 -0500
Received: by mail-wi0-f179.google.com with SMTP id ex7so4650292wid.12
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2014 10:25:19 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [BUG REPORT] brcmfmac: wrong logic in finding control/primary channel relative location
Date: Sat, 20 Dec 2014 19:25:04 +0100
Message-Id: <1419099904-13303-1-git-send-email-zajec5@gmail.com> (sfid-20141220_192532_176976_715122C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
Hi guys,

Let me report something I think is a bug in this unusual-patch way ;)
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 39b45c0..2c9e88b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -313,11 +313,13 @@ static u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
 	case NL80211_CHAN_WIDTH_80:
 		ch_inf.bw = BRCMU_CHAN_BW_80;
 		if (primary_offset < 0) {
+			/* FIXME: We compare frequencies offset with a value -2. Looks like a wrong logic. */
 			if (primary_offset < -CH_10MHZ_APART)
 				ch_inf.sb = BRCMU_CHAN_SB_UU;
 			else
 				ch_inf.sb = BRCMU_CHAN_SB_UL;
 		} else {
+			/* FIXME: We compare frequencies offset with a value 2. Looks like a wrong logic. */
 			if (primary_offset > CH_10MHZ_APART)
 				ch_inf.sb = BRCMU_CHAN_SB_LL;
 			else
-- 
1.8.4.5

