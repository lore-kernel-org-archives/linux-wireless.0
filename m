Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:43877 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaBLTE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 14:04:59 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so6322047wes.2
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 11:04:58 -0800 (PST)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 1/9] wcn36xx: Fix copy paste error hal_exit_bmps -> hal_keep_alive
Date: Wed, 12 Feb 2014 19:04:40 +0000
Message-Id: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com> (sfid-20140212_200504_617698_EB543AB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 750626b..8a57dfe 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1637,12 +1637,12 @@ int wcn36xx_smd_keep_alive_req(struct wcn36xx *wcn,
 
 	ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
 	if (ret) {
-		wcn36xx_err("Sending hal_exit_bmps failed\n");
+		wcn36xx_err("Sending hal_keep_alive failed\n");
 		goto out;
 	}
 	ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
 	if (ret) {
-		wcn36xx_err("hal_exit_bmps response failed err=%d\n", ret);
+		wcn36xx_err("hal_keep_alive response failed err=%d\n", ret);
 		goto out;
 	}
 out:
-- 
1.8.3.2

