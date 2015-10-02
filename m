Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35820 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbJBMpe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 08:45:34 -0400
Received: by pacfv12 with SMTP id fv12so108315995pac.2
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 05:45:34 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/10] staging: wilc1000: use pr_err in host_int_wait_msg_queue_idle
Date: Fri,  2 Oct 2015 21:44:55 +0900
Message-Id: <1443789896-7082-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20151002_144538_336845_3CB14655)
In-Reply-To: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes PRINT_ER by pr_err.
It would be better to use netdev_err, but it cannot use it in this
function, so just use pr_err.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 69a4e79..79014ab 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5354,7 +5354,7 @@ int host_int_wait_msg_queue_idle(void)
 	msg.id = HOST_IF_MSG_Q_IDLE;
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result) {
-		PRINT_ER("wilc mq send fail\n");
+		pr_err("wilc mq send fail\n");
 		result = -EINVAL;
 	}
 
-- 
2.6.0

