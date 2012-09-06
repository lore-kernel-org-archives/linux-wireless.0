Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:50775 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738Ab2IFKWf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 06:22:35 -0400
From: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
To: <linux-wireless@vger.kernel.org>, <linux-nfc@lists.01.org>,
	<sameo@linux.intel.com>
CC: <lauro.venancio@openbossa.org>, <aloisio.almeida@openbossa.org>,
	<eric.lapuyade@intel.com>,
	Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Subject: [PATCH 2/2] NFC: Correct outgoing frame before requeueing
Date: Thu, 6 Sep 2012 12:22:17 +0200
Message-ID: <1346926937-4968-2-git-send-email-waldemar.rymarkiewicz@tieto.com> (sfid-20120906_122238_170638_5B3AB231)
In-Reply-To: <1346926937-4968-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
References: <1346926937-4968-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Purge data added by lower layers (len and crc) in the head and tail of the frame
during initial send. Now, the frame is correct to be resent.

Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
---
 net/nfc/hci/shdlc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index 8a5f034..30e353e 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -241,8 +241,9 @@ static void nfc_shdlc_requeue_ack_pending(struct nfc_shdlc *shdlc)
 	pr_debug("ns reset to %d\n", shdlc->dnr);
 
 	while ((skb = skb_dequeue_tail(&shdlc->ack_pending_q))) {
-		skb_pull(skb, 2);	/* remove len+control */
-		skb_trim(skb, skb->len - 2);	/* remove crc */
+		/* remove client head + shdlc control field */
+		skb_pull(skb, shdlc->client_headroom + 1);
+		skb_trim(skb, skb->len - shdlc->client_tailroom);
 		skb_queue_head(&shdlc->send_q, skb);
 	}
 	shdlc->ns = shdlc->dnr;
-- 
1.7.10

