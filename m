Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:54050 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbaE0K4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:38 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 13/16] brcmutil: assure unused bits are cleared in 11n chanspec
Date: Tue, 27 May 2014 12:56:25 +0200
Message-ID: <1401188188-16492-14-git-send-email-arend@broadcom.com> (sfid-20140527_125722_037956_3D191C24)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware channel specification is a bitfield using a
16-bit integer, but only 14 lsb are used. Upon encoding
this value assure all 16 bits are cleared.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmutil/d11.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmutil/d11.c b/drivers/net/wireless/brcm80211/brcmutil/d11.c
index 6cbc33d..2b2522b 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/d11.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/d11.c
@@ -54,6 +54,7 @@ static void brcmu_d11n_encchspec(struct brcmu_chan *ch)
 	if (ch->bw == BRCMU_CHAN_BW_20)
 		ch->sb = BRCMU_CHAN_SB_NONE;
 
+	ch->chspec = 0;
 	brcmu_maskset16(&ch->chspec, BRCMU_CHSPEC_CH_MASK,
 			BRCMU_CHSPEC_CH_SHIFT, ch->chnum);
 	brcmu_maskset16(&ch->chspec, BRCMU_CHSPEC_D11N_SB_MASK,
@@ -61,7 +62,6 @@ static void brcmu_d11n_encchspec(struct brcmu_chan *ch)
 	brcmu_maskset16(&ch->chspec, BRCMU_CHSPEC_D11N_BW_MASK,
 			0, d11n_bw(ch->bw));
 
-	ch->chspec &= ~BRCMU_CHSPEC_D11N_BND_MASK;
 	if (ch->chnum <= CH_MAX_2G_CHANNEL)
 		ch->chspec |= BRCMU_CHSPEC_D11N_BND_2G;
 	else
-- 
1.7.9.5

