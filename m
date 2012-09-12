Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:51919 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab2ILINS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 04:13:18 -0400
From: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
To: <linux-wireless@vger.kernel.org>, <linux-nfc@lists.01.org>
CC: <sameo@linux.intel.com>, <eric.lapuyade@linux.intel.com>,
	Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Subject: [PATCH 1/3] NFC: Handle RSET in SHDLC_CONNECTING state
Date: Wed, 12 Sep 2012 10:13:07 +0200
Message-ID: <1347437589-14450-1-git-send-email-waldemar.rymarkiewicz@tieto.com> (sfid-20120912_101324_757079_C527FA61)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As queue_work() does not guarantee ordered execution of sm_work it
can happen in crossover RSET usecase that connect timer will constantly
change the shdlc state from NEGOTIATING to CONNECTING before shdlc have
chance to handle incoming frame.

As a result the incoming RSET frame will remain not handled before putting
shdlc into DISCONNECTED state which is too late.

Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
---
 net/nfc/hci/shdlc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index fd75cec..fe66cbc 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -365,7 +365,8 @@ static void nfc_shdlc_rcv_u_frame(struct nfc_shdlc *shdlc,
 
 	switch (u_frame_modifier) {
 	case U_FRAME_RSET:
-		if (shdlc->state == SHDLC_NEGOCIATING) {
+		if ( (shdlc->state == SHDLC_NEGOCIATING) ||
+					(shdlc->state == SHDLC_CONNECTING) ) {
 			/* we sent RSET, but chip wants to negociate */
 			if (skb->len > 0)
 				w = skb->data[0];
-- 
1.7.10

