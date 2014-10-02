Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50593 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJBLnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 07:43:55 -0400
Received: by mail-lb0-f172.google.com with SMTP id b6so2058788lbj.31
        for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2014 04:43:53 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: warn on unhandled htt events
Date: Thu,  2 Oct 2014 13:32:55 +0200
Message-Id: <1412249575-22387-1-git-send-email-michal.kazior@tieto.com> (sfid-20141002_134358_861468_DE0CF92B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It makes a lot more sense to print these kinds of
problems as a warning instead of a debug.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 60d40a0..9109d25 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1681,8 +1681,8 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 	default:
-		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt event (%d) not handled\n",
-			   resp->hdr.msg_type);
+		ath10k_warn(ar, "htt event (%d) not handled\n",
+			    resp->hdr.msg_type);
 		ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt event: ",
 				skb->data, skb->len);
 		break;
-- 
1.8.5.3

