Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:58795 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab1GANe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 09:34:57 -0400
Received: by fxd18 with SMTP id 18so3291248fxd.11
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2011 06:34:56 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 1 Jul 2011 15:28:22 +0200
Subject: [PATCH] carl9170: use carl9170 queue enums
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Message-Id: <E1QcdtT-0007jZ-LO@debian64.daheim> (sfid-20110701_153500_434633_4D1E8B81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/main.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index fe82d1f..91b3fd3 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -345,11 +345,11 @@ static int carl9170_op_start(struct ieee80211_hw *hw)
 	carl9170_zap_queues(ar);
 
 	/* reset QoS defaults */
-	CARL9170_FILL_QUEUE(ar->edcf[0], 3, 15, 1023,  0); /* BEST EFFORT */
-	CARL9170_FILL_QUEUE(ar->edcf[1], 2, 7,    15, 94); /* VIDEO */
-	CARL9170_FILL_QUEUE(ar->edcf[2], 2, 3,     7, 47); /* VOICE */
-	CARL9170_FILL_QUEUE(ar->edcf[3], 7, 15, 1023,  0); /* BACKGROUND */
-	CARL9170_FILL_QUEUE(ar->edcf[4], 2, 3,     7,  0); /* SPECIAL */
+	CARL9170_FILL_QUEUE(ar->edcf[AR9170_TXQ_VO], 2, 3,     7, 47);
+	CARL9170_FILL_QUEUE(ar->edcf[AR9170_TXQ_VI], 2, 7,    15, 94);
+	CARL9170_FILL_QUEUE(ar->edcf[AR9170_TXQ_BE], 3, 15, 1023,  0);
+	CARL9170_FILL_QUEUE(ar->edcf[AR9170_TXQ_BK], 7, 15, 1023,  0);
+	CARL9170_FILL_QUEUE(ar->edcf[AR9170_TXQ_SPECIAL], 2, 3, 7, 0);
 
 	ar->current_factor = ar->current_density = -1;
 	/* "The first key is unique." */
-- 
1.7.5.4

