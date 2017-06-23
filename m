Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34169 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754178AbdFWOK7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 10:10:59 -0400
Received: by mail-pf0-f196.google.com with SMTP id d5so7549093pfe.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 07:10:59 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 13/17] rsi: block/unblock data queues as per connection status
Date: Fri, 23 Jun 2017 19:37:32 +0530
Message-Id: <1498226856-6305-14-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170623_161111_710300_48412C47)
In-Reply-To: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Data queues should be unblocked after station add notify frame
is sent and should be blocked after station delete notify is sent.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 875e323..3b1e4e4 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1254,6 +1254,7 @@ void rsi_inform_bss_status(struct rsi_common *common,
 			   u16 aid)
 {
 	if (status) {
+		common->hw_data_qs_blocked = true;
 		rsi_hal_send_sta_notify_frame(common,
 					      RSI_IFTYPE_STATION,
 					      STA_CONNECTED,
@@ -1262,13 +1263,17 @@ void rsi_inform_bss_status(struct rsi_common *common,
 					      aid);
 		if (common->min_rate == 0xffff)
 			rsi_send_auto_rate_request(common);
+		if (!rsi_send_block_unblock_frame(common, false))
+			common->hw_data_qs_blocked = false;
 	} else {
+		common->hw_data_qs_blocked = true;
 		rsi_hal_send_sta_notify_frame(common,
 					      RSI_IFTYPE_STATION,
 					      STA_DISCONNECTED,
 					      bssid,
 					      qos_enable,
 					      aid);
+		rsi_send_block_unblock_frame(common, true);
 	}
 }
 
-- 
2.7.4
