Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9677 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbaCQNey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:34:54 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 08/21] wil6210: report reset time
Date: Mon, 17 Mar 2014 15:34:12 +0200
Message-ID: <1395063265-6522-9-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_145650_102865_4BF1EDFF)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Useful to detect hardware problems

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 8644418..1f9f1d2 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -230,7 +230,7 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 
 static void wil_target_reset(struct wil6210_priv *wil)
 {
-	int delay = 100;
+	int delay = 0;
 	u32 baud_rate;
 	u32 rev_id;
 
@@ -277,7 +277,7 @@ static void wil_target_reset(struct wil6210_priv *wil)
 	do {
 		msleep(1);
 		baud_rate = R(RGF_USER_SERIAL_BAUD_RATE);
-		if (delay-- < 0) {
+		if (delay++ > 100) {
 			wil_err(wil, "Reset not completed\n");
 			return;
 		}
@@ -286,7 +286,7 @@ static void wil_target_reset(struct wil6210_priv *wil)
 	if (rev_id == 2)
 		W(RGF_LOS_COUNTER_CTL, BIT(8));
 
-	wil_dbg_misc(wil, "Reset completed\n");
+	wil_dbg_misc(wil, "Reset completed in %d ms\n", delay);
 
 #undef R
 #undef W
-- 
1.8.3.2

