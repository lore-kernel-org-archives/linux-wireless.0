Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:51298 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab2IJH7z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 03:59:55 -0400
From: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
To: <linux-wireless@vger.kernel.org>, <linux-nfc@lists.01.org>
CC: <sameo@linux.intel.com>,
	Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Subject: [PATCH] NFC: Unify kfree_skb call for received u frame
Date: Mon, 10 Sep 2012 09:59:46 +0200
Message-ID: <1347263986-4327-1-git-send-email-waldemar.rymarkiewicz@tieto.com> (sfid-20120910_095959_099575_AAF5C8BB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
---
 net/nfc/hci/shdlc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index dc8443a..fd75cec 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -398,8 +398,6 @@ static void nfc_shdlc_rcv_u_frame(struct nfc_shdlc *shdlc,
 	default:
 		break;
 	}
-
-	kfree_skb(skb);
 }
 
 static void nfc_shdlc_handle_rcv_queue(struct nfc_shdlc *shdlc)
@@ -433,6 +431,7 @@ static void nfc_shdlc_handle_rcv_queue(struct nfc_shdlc *shdlc)
 		case SHDLC_CONTROL_HEAD_U:
 			u_frame_modifier = control & SHDLC_CONTROL_M_MASK;
 			nfc_shdlc_rcv_u_frame(shdlc, skb, u_frame_modifier);
+			kfree_skb(skb);
 			break;
 		default:
 			pr_err("UNKNOWN Control=%d\n", control);
-- 
1.7.10

