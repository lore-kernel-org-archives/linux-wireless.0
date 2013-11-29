Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:37832 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab3K2Prs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 10:47:48 -0500
Received: by mail-pb0-f44.google.com with SMTP id rq2so14681023pbb.31
        for <linux-wireless@vger.kernel.org>; Fri, 29 Nov 2013 07:47:47 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, k.eugene.e@gmail.com,
	wcn36xx@lists.infradead.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] wcn36xx: fix typo error
Date: Fri, 29 Nov 2013 23:47:30 +0800
Message-Id: <1385740050-12827-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131129_164751_490441_BBC49FC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/hal.h |    2 +-
 drivers/net/wireless/ath/wcn36xx/smd.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index c02dbc6..3c2ef0c 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -2644,7 +2644,7 @@ struct wcn36xx_hal_trigger_ba_rsp_candidate {
 	struct add_ba_info ba_info[STACFG_MAX_TC];
 } __packed;
 
-struct wcn36xx_hal_trigget_ba_req_candidate {
+struct wcn36xx_hal_trigger_ba_req_candidate {
 	u8 sta_index;
 	u8 tid_bitmap;
 } __packed;
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 2f58a7d..24135d7 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1856,7 +1856,7 @@ out:
 int wcn36xx_smd_trigger_ba(struct wcn36xx *wcn, u8 sta_index)
 {
 	struct wcn36xx_hal_trigger_ba_req_msg msg_body;
-	struct wcn36xx_hal_trigget_ba_req_candidate *candidate;
+	struct wcn36xx_hal_trigger_ba_req_candidate *candidate;
 	int ret = 0;
 
 	mutex_lock(&wcn->hal_mutex);
@@ -1867,7 +1867,7 @@ int wcn36xx_smd_trigger_ba(struct wcn36xx *wcn, u8 sta_index)
 	msg_body.header.len += sizeof(*candidate);
 	PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
 
-	candidate = (struct wcn36xx_hal_trigget_ba_req_candidate *)
+	candidate = (struct wcn36xx_hal_trigger_ba_req_candidate *)
 		(wcn->hal_buf + sizeof(msg_body));
 	candidate->sta_index = sta_index;
 	candidate->tid_bitmap = 1;
-- 
1.7.9.5

