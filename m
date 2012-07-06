Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1068 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab2GFUAH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 16:00:07 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 24/33] NFC: Forbid SSAP binding to a not well known LLCP service
Date: Fri,  6 Jul 2012 22:09:44 +0200
Message-Id: <1341605393-32056-25-git-send-email-sameo@linux.intel.com> (sfid-20120706_220536_164409_C9ED01F4)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With not Well Known Services there is no guarantees as to which
SSAP the server will be listening on, so there is no reason to
support binding to a specific source SAP.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 1031abd..9ab17ec 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -234,24 +234,12 @@ u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
 
 		return LLCP_WKS_NUM_SAP + ssap;
 
-	} else if (sock->ssap != 0) {
-		if (sock->ssap < LLCP_WKS_NUM_SAP) {
-			if (!test_bit(sock->ssap, &local->local_wks)) {
-				set_bit(sock->ssap, &local->local_wks);
-				mutex_unlock(&local->sdp_lock);
-
-				return sock->ssap;
-			}
-
-		} else if (sock->ssap < LLCP_SDP_NUM_SAP) {
-			if (!test_bit(sock->ssap - LLCP_WKS_NUM_SAP,
-				      &local->local_sdp)) {
-				set_bit(sock->ssap - LLCP_WKS_NUM_SAP,
-					&local->local_sdp);
-				mutex_unlock(&local->sdp_lock);
+	} else if (sock->ssap != 0 && sock->ssap < LLCP_WKS_NUM_SAP) {
+		if (!test_bit(sock->ssap, &local->local_wks)) {
+			set_bit(sock->ssap, &local->local_wks);
+			mutex_unlock(&local->sdp_lock);
 
-				return sock->ssap;
-			}
+			return sock->ssap;
 		}
 	}
 
-- 
1.7.10

