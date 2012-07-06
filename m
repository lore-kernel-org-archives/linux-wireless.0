Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43858 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2GFT6u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:58:50 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 03/33] NFC: Handle SHDLC RSET frames from an SHDLC connected chip
Date: Fri,  6 Jul 2012 22:09:23 +0200
Message-Id: <1341605393-32056-4-git-send-email-sameo@linux.intel.com> (sfid-20120706_215853_451615_76FBF5E2)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

shdlc reset may leave HCI in an inconsistent state by loosing parts of
HCI frames. Handle this case by reporting an unrecoverable error to HCI.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/hci/shdlc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index 18d1536..6f840c1 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -404,12 +404,12 @@ static void nfc_shdlc_rcv_u_frame(struct nfc_shdlc *shdlc,
 				r = nfc_shdlc_connect_send_ua(shdlc);
 				nfc_shdlc_connect_complete(shdlc, r);
 			}
-		} else if (shdlc->state > SHDLC_NEGOCIATING) {
+		} else if (shdlc->state == SHDLC_CONNECTED) {
 			/*
-			 * TODO: Chip wants to reset link
-			 * send ua, empty skb lists, reset counters
-			 * propagate info to HCI layer
+			 * Chip wants to reset link. This is unexpected and
+			 * unsupported.
 			 */
+			shdlc->hard_fault = -ECONNRESET;
 		}
 		break;
 	case U_FRAME_UA:
-- 
1.7.10

