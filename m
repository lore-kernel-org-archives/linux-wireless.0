Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:52758 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933956AbaEFGe7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 02:34:59 -0400
Received: by mail-ee0-f43.google.com with SMTP id d17so1346772eek.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2014 23:34:58 -0700 (PDT)
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, ath9k-devel@venema.h4ckr.net,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH 2/2] ath9k: Handling flag IEEE80211_TX_CTRL_NO_DUR_UPDATE
Date: Tue,  6 May 2014 08:32:47 +0200
Message-Id: <1399357967-6541-2-git-send-email-marek.kwaczynski@tieto.com> (sfid-20140506_083504_084536_2E18A017)
In-Reply-To: <1399357967-6541-1-git-send-email-marek.kwaczynski@tieto.com>
References: <1399357967-6541-1-git-send-email-marek.kwaczynski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prevents durationId field updates for injected frames
when this information is included in radiotap header.
It could be very useful for testing NAV update.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 87cbec4..c24c113 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1092,8 +1092,15 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 	rates = bf->rates;
 	hdr = (struct ieee80211_hdr *)skb->data;
 
-	/* set dur_update_en for l-sig computation except for PS-Poll frames */
-	info->dur_update = !ieee80211_is_pspoll(hdr->frame_control);
+	if (tx_info->flags & IEEE80211_TX_CTRL_NO_DUR_UPDATE) {
+		info->dur_update = 0;
+	} else {
+		/* set dur_update_en for l-sig computation except for PS-Poll
+		 * frames
+		 */
+		info->dur_update = !ieee80211_is_pspoll(hdr->frame_control);
+	}
+
 	info->rtscts_rate = fi->rtscts_rate;
 
 	for (i = 0; i < ARRAY_SIZE(bf->rates); i++) {
-- 
1.7.9.5

