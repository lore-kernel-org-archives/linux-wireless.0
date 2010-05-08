Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:53037 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab0EHQYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 12:24:17 -0400
Received: by qyk13 with SMTP id 13so3447598qyk.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 May 2010 09:24:17 -0700 (PDT)
Date: Sat, 8 May 2010 18:24:02 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [patch 5/9] ath9k/htc_drv_main: off by one error
Message-ID: <20100508162402.GQ27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I changed "> ATH9K_HTC_MAX_TID" to ">= ATH9K_HTC_MAX_TID" to avoid a
potential overflow.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index e75db06..6c386da 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -465,7 +465,7 @@ static int ath9k_htc_aggr_oper(struct ath9k_htc_priv *priv,
 	int ret = 0;
 	u8 cmd_rsp;
 
-	if (tid > ATH9K_HTC_MAX_TID)
+	if (tid >= ATH9K_HTC_MAX_TID)
 		return -EINVAL;
 
 	memset(&aggr, 0, sizeof(struct ath9k_htc_target_aggr));
