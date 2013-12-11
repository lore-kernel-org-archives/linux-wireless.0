Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59433 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab3LKQnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 11:43:43 -0500
Received: by mail-wi0-f180.google.com with SMTP id hn9so1157480wib.7
        for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 08:43:42 -0800 (PST)
From: Michal Nazarewicz <mina86@mina86.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Peter Stuge <peter@stuge.se>,
	ath9k-devel <ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] net: wirelesse: wcn36xx: pull allocation outside of critical
 section
In-Reply-To: <20131211155249.GD7411@tuxdriver.com>
References: <1385744870-10164-1-git-send-email-mpn@google.com> <20131201004715.11125.qmail@stuge.se> <xa1tiov78kmp.fsf@mina86.com> <CAFSJ42YckTDO=UV=fWG9mmVXSBYep1x6xiHahzGDcrB4dy0oOQ@mail.gmail.com> <878uvw1t49.fsf@mina86.com> <CAFSJ42a5ngsShaQPwwjfLxaj3ojvghwTAvCBggG=tPr9oLwhEg@mail.gmail.com> <8738m2uukz.fsf@mina86.com> <20131211155249.GD7411@tuxdriver.com>
Date: Wed, 11 Dec 2013 17:43:39 +0100
Message-ID: <xa1tbo0nqqx0.fsf@mina86.com> (sfid-20131211_174417_261807_855B9464)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit [3469adb3: fix potential NULL pointer dereference] introduced
a check of msg_ind allocation, but omitted allocation of msg_ind->msg.
Moreover, it introduced two if statements, which looked a bit clunky.

This commit moves allocation code outside of the critical section so
there's no need to dance around mutex_unlock, and adds the missing
allocation check.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

On Wed, Dec 11 2013, John W. Linville wrote:
> Missing Signed-off-by...

Sorry about that.

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 8f37562..750626b 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2060,22 +2060,28 @@ static void wcn36xx_smd_rsp_process(struct wcn36xx *wcn, void *buf, size_t len)
 	case WCN36XX_HAL_OTA_TX_COMPL_IND:
 	case WCN36XX_HAL_MISSED_BEACON_IND:
 	case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
-		mutex_lock(&wcn->hal_ind_mutex);
 		msg_ind = kmalloc(sizeof(*msg_ind), GFP_KERNEL);
-		if (msg_ind) {
-			msg_ind->msg_len = len;
-			msg_ind->msg = kmalloc(len, GFP_KERNEL);
-			memcpy(msg_ind->msg, buf, len);
-			list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
-			queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
-			wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
+		if (!msg_ind)
+			goto nomem;
+		msg_ind->msg_len = len;
+		msg_ind->msg = kmalloc(len, GFP_KERNEL);
+		if (!msg_ind->msg) {
+			kfree(msg_ind);
+nomem:
+			/*
+			 * FIXME: Do something smarter then just
+			 * printing an error.
+			 */
+			wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
+				    msg_header->msg_type);
+			break;
 		}
+		memcpy(msg_ind->msg, buf, len);
+		mutex_lock(&wcn->hal_ind_mutex);
+		list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
+		queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
 		mutex_unlock(&wcn->hal_ind_mutex);
-		if (msg_ind)
-			break;
-		/* FIXME: Do something smarter then just printing an error. */
-		wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
-			    msg_header->msg_type);
+		wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
 		break;
 	default:
 		wcn36xx_err("SMD_EVENT (%d) not supported\n",
-- 
1.8.4

