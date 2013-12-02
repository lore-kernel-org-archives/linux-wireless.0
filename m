Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46588 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3LBNJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 08:09:38 -0500
Received: by mail-wg0-f46.google.com with SMTP id m15so11653836wgh.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 05:09:37 -0800 (PST)
From: Michal Nazarewicz <mina86@mina86.com>
To: Peter Stuge <peter@stuge.se>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Eugene Krasnikov <k.eugene.e@gmail.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCHv2] net: wireless: wcn36xx: fix potential NULL pointer dereference
In-Reply-To: <20131201004715.11125.qmail@stuge.se>
References: <1385744870-10164-1-git-send-email-mpn@google.com> <20131201004715.11125.qmail@stuge.se>
Date: Mon, 02 Dec 2013 14:09:34 +0100
Message-ID: <xa1tiov78kmp.fsf@mina86.com> (sfid-20131202_140942_679142_790D6871)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


If kmalloc fails wcn36xx_smd_rsp_process will attempt to dereference
a NULL pointer.  There might be a better error recovery then just
printing an error, but printing an error message is better then the
current behaviour.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

On Sun, Dec 01 2013, Peter Stuge wrote:
> Michal Nazarewicz wrote:
>> +			wcn36xx_err("Run out of memory while hnadling SMD_EVENT (%d)\n",
>> +				    msg_header->msg_type);
>
> Typo hnadling.

Fixed.

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index de9eb2c..3663394 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2041,13 +2041,20 @@ static void wcn36xx_smd_rsp_process(struct wcn36xx *wcn, void *buf, size_t len)
 	case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
 		mutex_lock(&wcn->hal_ind_mutex);
 		msg_ind = kmalloc(sizeof(*msg_ind), GFP_KERNEL);
-		msg_ind->msg_len = len;
-		msg_ind->msg = kmalloc(len, GFP_KERNEL);
-		memcpy(msg_ind->msg, buf, len);
-		list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
-		queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
-		wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
+		if (msg_ind) {
+			msg_ind->msg_len = len;
+			msg_ind->msg = kmalloc(len, GFP_KERNEL);
+			memcpy(msg_ind->msg, buf, len);
+			list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
+			queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
+			wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
+		}
 		mutex_unlock(&wcn->hal_ind_mutex);
+		if (msg_ind)
+			break;
+		/* FIXME: Do something smarter then just printing an error. */
+		wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
+			    msg_header->msg_type);
 		break;
 	default:
 		wcn36xx_err("SMD_EVENT (%d) not supported\n",
-- 
1.8.4.1

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
