Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36602 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753807AbdGJMpg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 08:45:36 -0400
Received: by mail-pg0-f66.google.com with SMTP id u36so12593571pgn.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 05:45:36 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 13/17] rsi: block/unblock data queues as per connection status
Date: Mon, 10 Jul 2017 18:10:44 +0530
Message-Id: <1499690448-9956-14-git-send-email-amitkarwar@gmail.com> (sfid-20170710_144557_426320_8A35B67D)
In-Reply-To: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
References: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
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
index 77b6757..64bbd0a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1250,6 +1250,7 @@ void rsi_inform_bss_status(struct rsi_common *common,
 			   u16 aid)
 {
 	if (status) {
+		common->hw_data_qs_blocked = true;
 		rsi_hal_send_sta_notify_frame(common,
 					      RSI_IFTYPE_STATION,
 					      STA_CONNECTED,
@@ -1258,13 +1259,17 @@ void rsi_inform_bss_status(struct rsi_common *common,
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
