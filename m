Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31616 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab2CDX5j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:57:39 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 06/22] NFC: Fix bitops usage in LLCP
Date: Mon,  5 Mar 2012 01:03:38 +0100
Message-Id: <1330905834-6994-7-git-send-email-sameo@linux.intel.com> (sfid-20120305_005743_817539_81E7A806)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index bbfaa27..443407e 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -176,7 +176,7 @@ u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
 				return LLCP_SAP_MAX;
 			}
 
-			set_bit(BIT(ssap), &local->local_wks);
+			set_bit(ssap, &local->local_wks);
 			mutex_unlock(&local->sdp_lock);
 
 			return ssap;
@@ -195,25 +195,25 @@ u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
 
 		pr_debug("SDP ssap %d\n", LLCP_WKS_NUM_SAP + ssap);
 
-		set_bit(BIT(ssap), &local->local_sdp);
+		set_bit(ssap, &local->local_sdp);
 		mutex_unlock(&local->sdp_lock);
 
 		return LLCP_WKS_NUM_SAP + ssap;
 
 	} else if (sock->ssap != 0) {
 		if (sock->ssap < LLCP_WKS_NUM_SAP) {
-			if (!(local->local_wks & BIT(sock->ssap))) {
-				set_bit(BIT(sock->ssap), &local->local_wks);
+			if (!test_bit(sock->ssap, &local->local_wks)) {
+				set_bit(sock->ssap, &local->local_wks);
 				mutex_unlock(&local->sdp_lock);
 
 				return sock->ssap;
 			}
 
 		} else if (sock->ssap < LLCP_SDP_NUM_SAP) {
-			if (!(local->local_sdp &
-				BIT(sock->ssap - LLCP_WKS_NUM_SAP))) {
-				set_bit(BIT(sock->ssap - LLCP_WKS_NUM_SAP),
-							&local->local_sdp);
+			if (!test_bit(sock->ssap - LLCP_WKS_NUM_SAP,
+				      &local->local_sdp)) {
+				set_bit(sock->ssap - LLCP_WKS_NUM_SAP,
+					&local->local_sdp);
 				mutex_unlock(&local->sdp_lock);
 
 				return sock->ssap;
@@ -238,7 +238,7 @@ u8 nfc_llcp_get_local_ssap(struct nfc_llcp_local *local)
 		return LLCP_SAP_MAX;
 	}
 
-	set_bit(BIT(local_ssap), &local->local_sap);
+	set_bit(local_ssap, &local->local_sap);
 
 	mutex_unlock(&local->sdp_lock);
 
@@ -265,7 +265,7 @@ void nfc_llcp_put_ssap(struct nfc_llcp_local *local, u8 ssap)
 
 	mutex_lock(&local->sdp_lock);
 
-	clear_bit(1 << local_ssap, sdp);
+	clear_bit(local_ssap, sdp);
 
 	mutex_unlock(&local->sdp_lock);
 }
-- 
1.7.7.3

