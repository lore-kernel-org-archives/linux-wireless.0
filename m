Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13441 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757969AbYEWByt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 21:54:49 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 2/5] hostap: fix references to 8802.11
To: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>
Date: Thu, 22 May 2008 21:54:48 -0400
Message-ID: <20080523015448.16636.37283.stgit@dv.roinet.com> (sfid-20080523_035451_584067_4FD08E69)
In-Reply-To: <20080523015442.16636.92254.stgit@dv.roinet.com>
References: <20080523015442.16636.92254.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

802.11 is meant in all cases.  The section numbers match the actual
802.11 standard.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/hostap/hostap_ap.c |    8 ++++----
 drivers/net/wireless/hostap/hostap_ap.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index ab981af..19ed075 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -9,11 +9,11 @@
  *
  * AP:  FIX:
  * - if unicast Class 2 (assoc,reassoc,disassoc) frame received from
- *   unauthenticated STA, send deauth. frame (8802.11: 5.5)
+ *   unauthenticated STA, send deauth. frame (802.11: 5.5)
  * - if unicast Class 3 (data with to/from DS,deauth,pspoll) frame received
- *   from authenticated, but unassoc STA, send disassoc frame (8802.11: 5.5)
+ *   from authenticated, but unassoc STA, send disassoc frame (802.11: 5.5)
  * - if unicast Class 3 received from unauthenticated STA, send deauth. frame
- *   (8802.11: 5.5)
+ *   (802.11: 5.5)
  */
 
 #include <linux/proc_fs.h>
@@ -1956,7 +1956,7 @@ static void handle_pspoll(local_info_t *local,
 	/* FIX: todo:
 	 * - add timeout for buffering (clear aid in TIM vector if buffer timed
 	 *   out (expiry time must be longer than ListenInterval for
-	 *   the corresponding STA; "8802-11: 11.2.1.9 AP aging function"
+	 *   the corresponding STA; "802.11: 11.2.1.9 AP aging function"
 	 * - what to do, if buffered, pspolled, and sent frame is not ACKed by
 	 *   sta; store buffer for later use and leave TIM aid bit set? use
 	 *   TX event to check whether frame was ACKed?
diff --git a/drivers/net/wireless/hostap/hostap_ap.h b/drivers/net/wireless/hostap/hostap_ap.h
index 2fa2452..0d2cbf4 100644
--- a/drivers/net/wireless/hostap/hostap_ap.h
+++ b/drivers/net/wireless/hostap/hostap_ap.h
@@ -103,7 +103,7 @@ struct sta_info {
 #define MAX_STA_COUNT 1024
 
 /* Maximum number of AIDs to use for STAs; must be 2007 or lower
- * (8802.11 limitation) */
+ * (802.11 limitation) */
 #define MAX_AID_TABLE_SIZE 128
 
 #define STA_HASH_SIZE 256
