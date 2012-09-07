Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:52128 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab2IGJKf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 05:10:35 -0400
From: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
To: <linux-wireless@vger.kernel.org>, <linux-nfc@lists.01.org>,
	<eric.lapuyade@intel.com>
CC: <sameo@linux.intel.com>,
	Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Subject: [PATCH v2 2/2] NFC: Correct outgoing frame before requeueing
Date: Fri, 7 Sep 2012 11:08:30 +0200
Message-ID: <1347008910-11472-2-git-send-email-waldemar.rymarkiewicz@tieto.com> (sfid-20120907_111038_971995_E29A0DDC)
In-Reply-To: <1347008910-11472-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
References: <1347008910-11472-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver must handle its data added to the frame, so at this point
removeing control field of shdlc frame is enough.

Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
---
 net/nfc/hci/shdlc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index 8a5f034..775dff8 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -241,8 +241,7 @@ static void nfc_shdlc_requeue_ack_pending(struct nfc_shdlc *shdlc)
 	pr_debug("ns reset to %d\n", shdlc->dnr);
 
 	while ((skb = skb_dequeue_tail(&shdlc->ack_pending_q))) {
-		skb_pull(skb, 2);	/* remove len+control */
-		skb_trim(skb, skb->len - 2);	/* remove crc */
+		skb_pull(skb, 1);  /* remove control field */
 		skb_queue_head(&shdlc->send_q, skb);
 	}
 	shdlc->ns = shdlc->dnr;
-- 
1.7.10

