Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:51222 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab0EHQXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 12:23:35 -0400
Received: by mail-qy0-f183.google.com with SMTP id 13so3446177qyk.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 May 2010 09:23:34 -0700 (PDT)
Date: Sat, 8 May 2010 18:23:20 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [patch 4/9] ath9k/htc_drv_main: null dereference typo
Message-ID: <20100508162320.GP27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a stray null dereference.  We initialize "ista" properly later on.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f503586..e75db06 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -461,7 +461,7 @@ static int ath9k_htc_aggr_oper(struct ath9k_htc_priv *priv,
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_htc_target_aggr aggr;
 	struct ieee80211_sta *sta = NULL;
-	struct ath9k_htc_sta *ista = (struct ath9k_htc_sta *) sta->drv_priv;
+	struct ath9k_htc_sta *ista;
 	int ret = 0;
 	u8 cmd_rsp;
 
