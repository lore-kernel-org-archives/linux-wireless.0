Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:33684 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab3LHJ1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Dec 2013 04:27:37 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Luciano Coelho <luca@coelho.fi>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, freemangordon@abv.bg,
	aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
	joni.lapilainen@gmail.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 16/16] wl1251: fix NULL pointer dereference
Date: Sun,  8 Dec 2013 10:25:14 +0100
Message-Id: <1386494714-21070-17-git-send-email-pali.rohar@gmail.com> (sfid-20131208_102853_665192_9AD8936F)
In-Reply-To: <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Reported-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/net/wireless/ti/wl1251/event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/event.c b/drivers/net/wireless/ti/wl1251/event.c
index 192cebd..db01053 100644
--- a/drivers/net/wireless/ti/wl1251/event.c
+++ b/drivers/net/wireless/ti/wl1251/event.c
@@ -124,7 +124,7 @@ static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 			return ret;
 	}
 
-	if (vector & SYNCHRONIZATION_TIMEOUT_EVENT_ID) {
+	if (wl->vif && vector & SYNCHRONIZATION_TIMEOUT_EVENT_ID) {
 		wl1251_debug(DEBUG_EVENT, "SYNCHRONIZATION_TIMEOUT_EVENT");
 
 		/* indicate to the stack, that beacons have been lost */
-- 
1.7.9.5

