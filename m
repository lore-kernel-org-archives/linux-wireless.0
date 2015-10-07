Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:44355 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbbJGFIx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 01:08:53 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: devel@driverdev.osuosl.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH next] staging: wilc1000: avoid NULL pointer dereference on error
Date: Wed,  7 Oct 2015 07:08:25 +0200
Message-Id: <1444194505-31080-1-git-send-email-vincent.stehle@laposte.net> (sfid-20151007_070917_193072_6E018C4A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The host_int_init() function can dereference the pstrWFIDrv pointer
while it is NULL on its error path. Jump directly to the _fail_ error
label in the end of the error handling path to avoid that.
	By doing that we also skip stopping our kthread and destroying
our message queue, but they were not started or created yet in that case
anyway.

This fixes the following coccinelle error:

  drivers/staging/wilc1000/host_interface.c:6100:17-33: ERROR: pstrWFIDrv is NULL but dereferenced.

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Johnny Kim <johnny.kim@atmel.com>
Cc: Rachel Kim <rachel.kim@atmel.com>
Cc: Dean Lee <dean.lee@atmel.com>
Cc: Chris Park <chris.park@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---


Hi,

Another form of this patch would make sense on mainline as well, but the
driver has changed so much in the mean time that it makes more sense to
modify staging-next.

Best regards,

V.


 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2cf82b2..2fe3023 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6017,7 +6017,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	pstrWFIDrv  = kzalloc(sizeof(tstrWILC_WFIDrv), GFP_KERNEL);
 	if (!pstrWFIDrv) {
 		result = -ENOMEM;
-		goto _fail_timer_2;
+		goto _fail_;
 	}
 	*phWFIDrv = pstrWFIDrv;
 	err = add_handler_in_list(pstrWFIDrv);
-- 
2.5.1

