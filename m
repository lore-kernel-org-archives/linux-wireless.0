Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:40929 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZEROtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 10:49:21 -0400
Received: by ewy24 with SMTP id 24so4116873ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 07:49:21 -0700 (PDT)
Message-ID: <4A11756F.5000206@gmail.com>
Date: Mon, 18 May 2009 16:49:19 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: flamingice@sourmilk.net
CC: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] wireless/p54: fw_state can't be both OFF and RESET
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fw_state can't be both OFF and RESET

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
This was not tested in any way, so please review.

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index d1fe577..c327659 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -516,7 +516,7 @@ static void p54spi_work(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
-	if (priv->fw_state == FW_STATE_OFF &&
+	if (priv->fw_state == FW_STATE_OFF ||
 	    priv->fw_state == FW_STATE_RESET)
 		goto out;
 
