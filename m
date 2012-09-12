Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:48715 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab2ILIP4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 04:15:56 -0400
From: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
To: <linux-wireless@vger.kernel.org>, <linux-nfc@lists.01.org>
CC: <sameo@linux.intel.com>, <eric.lapuyade@linux.intel.com>,
	Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Subject: [PATCH 3/3] NFC: Clean rcv_q to avoid handling of remaing RSET
Date: Wed, 12 Sep 2012 10:15:35 +0200
Message-ID: <1347437735-15041-3-git-send-email-waldemar.rymarkiewicz@tieto.com> (sfid-20120912_101608_067946_373D5DA8)
In-Reply-To: <1347437735-15041-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
References: <1347437735-15041-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During processing incoming RSET frame chip, possibly due to its internal
timout, could retrnasmit an another RSET which is next queued for processing
in shdlc layer.

To avoid processing of those remaining in rcv_q purge the queue. Otherwise it
will be handled in CONNECTED state which will result in disconnection.

Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
---
 net/nfc/hci/shdlc.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index 12feb58..6ede86c 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -381,6 +381,12 @@ static void nfc_shdlc_rcv_u_frame(struct nfc_shdlc *shdlc,
 				shdlc->srej_support = srej_support;
 				r = nfc_shdlc_connect_send_ua(shdlc);
 				nfc_shdlc_connect_complete(shdlc, r);
+
+				if (shdlc->rcv_q.qlen)
+					/* Handling incoming RSET the chip could issue an another one,
+					 * possibly due to its internal timeout, so we have to make
+					 * sure we won't handle these remaining on the rcv_q */
+					skb_queue_purge(&shdlc->rcv_q);
 			}
 		} else if (shdlc->state == SHDLC_CONNECTED) {
 			/*
-- 
1.7.10

