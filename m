Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36143 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbbIIQsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 12:48:12 -0400
Received: by ioii196 with SMTP id i196so29105655ioi.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2015 09:48:11 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v3 2/3] ath10k: check for encryption before adding MIC_LEN
Date: Wed,  9 Sep 2015 12:47:35 -0400
Message-Id: <1441817256-3997-2-git-send-email-me@bobcopeland.com> (sfid-20150909_184815_043904_5BD6B3BE)
In-Reply-To: <1441817256-3997-1-git-send-email-me@bobcopeland.com>
References: <1441817256-3997-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the case of raw mode without nohwcrypt parameter, we
should still make sure the frame is protected before
adding MIC_LEN to avoid skb_under_panic errors.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index ea53c21..eb5ba9b 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -564,7 +564,8 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	     ieee80211_has_protected(hdr->frame_control)) {
 		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
 	} else if (!skb_cb->htt.nohwcrypt &&
-		   skb_cb->txmode == ATH10K_HW_TXRX_RAW) {
+		   skb_cb->txmode == ATH10K_HW_TXRX_RAW &&
+		   ieee80211_has_protected(hdr->frame_control)) {
 		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
 	}
 
-- 
2.1.4

