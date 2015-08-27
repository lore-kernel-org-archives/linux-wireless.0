Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36329 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbbH0K5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 06:57:32 -0400
Received: by iodv127 with SMTP id v127so52236967iod.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2015 03:57:31 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/3] ath10k: check for encryption before adding MIC_LEN
Date: Thu, 27 Aug 2015 06:57:03 -0400
Message-Id: <1440673024-13696-3-git-send-email-me@bobcopeland.com> (sfid-20150827_125743_901044_01407198)
In-Reply-To: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
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
index 43aa5e2..1c2d869 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -528,7 +528,8 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
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

