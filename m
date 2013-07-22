Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:51904 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab3GVMZe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 08:25:34 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: improve tx throughput on slow machines
Date: Mon, 22 Jul 2013 14:25:28 +0200
Message-ID: <1374495928-29514-1-git-send-email-michal.kazior@tieto.com> (sfid-20130722_142537_864288_EC794FBD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is more efficient to move just the 802.11
header instead of the whole payload in most cases.

This has no measurable effect on modern hardware.
It should improve performance by a few percent on
hardware such as an Access Point that have a slow
CPU compared to a typical desktop CPU.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 07e5f7d..6705bc8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1383,9 +1383,9 @@ static void ath10k_tx_h_qos_workaround(struct ieee80211_hw *hw,
 		return;
 
 	qos_ctl = ieee80211_get_qos_ctl(hdr);
-	memmove(qos_ctl, qos_ctl + IEEE80211_QOS_CTL_LEN,
-		skb->len - ieee80211_hdrlen(hdr->frame_control));
-	skb_trim(skb, skb->len - IEEE80211_QOS_CTL_LEN);
+	memmove(skb->data + IEEE80211_QOS_CTL_LEN,
+		skb->data, (void *)qos_ctl - (void *)skb->data);
+	skb_pull(skb, IEEE80211_QOS_CTL_LEN);
 }
 
 static void ath10k_tx_h_update_wep_key(struct sk_buff *skb)
-- 
1.7.9.5

