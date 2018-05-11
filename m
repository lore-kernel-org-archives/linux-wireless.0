Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36370 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753150AbeEKOy7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 10:54:59 -0400
Received: by mail-pf0-f196.google.com with SMTP id w129-v6so2850559pfd.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2018 07:54:59 -0700 (PDT)
From: Sushant Kumar Mishra <sushant2k1513@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
Subject: [PATCH 2/3] rsi: reset hibernate_resume flag to work hibernate resume in coex mode.
Date: Fri, 11 May 2018 20:27:52 +0530
Message-Id: <1526050673-7026-3-git-send-email-sushant2k1513@gmail.com> (sfid-20180511_165502_424369_E25A8E23)
In-Reply-To: <1526050673-7026-1-git-send-email-sushant2k1513@gmail.com>
References: <1526050673-7026-1-git-send-email-sushant2k1513@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

In coex mode, observed hibernate resume is not working properly, as the
hibernate_resume flag is not getting reset in rsi_coex_recv_pkt(),
when common card ready indication received from firmware. Hence resetting
hibernate_resume flag in this function.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_coex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_coex.c b/drivers/net/wireless/rsi/rsi_91x_coex.c
index d055099..c8ba148 100644
--- a/drivers/net/wireless/rsi/rsi_91x_coex.c
+++ b/drivers/net/wireless/rsi/rsi_91x_coex.c
@@ -73,6 +73,7 @@ int rsi_coex_recv_pkt(struct rsi_common *common, u8 *msg)
 	switch (msg_type) {
 	case COMMON_CARD_READY_IND:
 		rsi_dbg(INFO_ZONE, "common card ready received\n");
+		common->hibernate_resume = false;
 		rsi_handle_card_ready(common, msg);
 		break;
 	case SLEEP_NOTIFY_IND:
-- 
2.5.5
