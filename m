Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933230AbYHRTbe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 15:31:34 -0400
Subject: [PATCH] atmel: try open system authentication too
From: Dan Williams <dcbw@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	simon@thekelleys.org.uk
Content-Type: text/plain
Date: Mon, 18 Aug 2008 15:32:41 -0400
Message-Id: <1219087961.2154.7.camel@localhost.localdomain> (sfid-20080818_213143_416373_4D27CC98)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the AP rejects a Shared Key authentication request, try Open System
auth too.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 28b6ff3..e4cc37d 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -3061,12 +3062,20 @@ static void authenticate(struct atmel_private *priv, u16 frame_len)
 	}
 
 	if (status == WLAN_STATUS_NOT_SUPPORTED_AUTH_ALG) {
-		/* Do opensystem first, then try sharedkey */
+		/* Flip back and forth between WEP auth modes until the max
+		 * authentication tries has been exceeded.
+		 */
 		if (system == WLAN_AUTH_OPEN) {
 			priv->CurrentAuthentTransactionSeqNum = 0x001;
 			priv->exclude_unencrypted = 1;
 			send_authentication_request(priv, WLAN_AUTH_SHARED_KEY, NULL, 0);
 			return;
+		} else if (   system == WLAN_AUTH_SHARED_KEY
+		           && priv->wep_is_on) {
+			priv->CurrentAuthentTransactionSeqNum = 0x001;
+			priv->exclude_unencrypted = 0;
+			send_authentication_request(priv, WLAN_AUTH_OPEN, NULL, 0);
+			return;
 		} else if (priv->connect_to_any_BSS) {
 			int bss_index;
 


