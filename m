Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:59552 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab2ILIPv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 04:15:51 -0400
From: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
To: <linux-wireless@vger.kernel.org>, <linux-nfc@lists.01.org>
CC: <sameo@linux.intel.com>, <eric.lapuyade@linux.intel.com>,
	Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Subject: [PATCH 2/3] NFC: Fix ret check in nfc_shdlc_connect_complete
Date: Wed, 12 Sep 2012 10:15:34 +0200
Message-ID: <1347437735-15041-2-git-send-email-waldemar.rymarkiewicz@tieto.com> (sfid-20120912_101607_407626_04FD94CF)
In-Reply-To: <1347437735-15041-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
References: <1347437735-15041-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Typically, the r argument passed to nfc_shdlc_connect_complete()
comes from xmit() cb which returns, in successfull usecase, number
of successfully transmited bytes. Therefore, e.g. sending UA frame
the shdlc will go into wrong state (DISCONNECTED insted of CONNECTED).

Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
---
 net/nfc/hci/shdlc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index fe66cbc..12feb58 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -309,7 +309,7 @@ static void nfc_shdlc_connect_complete(struct nfc_shdlc *shdlc, int r)
 
 	del_timer_sync(&shdlc->connect_timer);
 
-	if (r == 0) {
+	if (r >= 0) {
 		shdlc->ns = 0;
 		shdlc->nr = 0;
 		shdlc->dnr = 0;
-- 
1.7.10

