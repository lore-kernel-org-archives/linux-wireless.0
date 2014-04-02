Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37006 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaDBEAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 00:00:18 -0400
Received: by mail-pd0-f178.google.com with SMTP id x10so10547238pdj.37
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 21:00:18 -0700 (PDT)
From: Fariya Fatima <fariyaf@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH 3/6] rsi: Fixed issue relating to variable de-referenced before check 'adapter'
Date: Wed,  2 Apr 2014 09:29:52 +0530
Message-Id: <1396411195-5051-4-git-send-email-fariyaf@gmail.com> (sfid-20140402_060026_136584_17AD99C8)
In-Reply-To: <1396411195-5051-1-git-send-email-fariyaf@gmail.com>
References: <1396411195-5051-1-git-send-email-fariyaf@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima <fariyaf@gmail.com>

Signed-off-by: Fariya Fatima <fariyaf@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 852453f..2e39d38 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -756,12 +756,13 @@ fail:
 static void rsi_disconnect(struct sdio_func *pfunction)
 {
 	struct rsi_hw *adapter = sdio_get_drvdata(pfunction);
-	struct rsi_91x_sdiodev *dev =
-		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
+	struct rsi_91x_sdiodev *dev;
 
 	if (!adapter)
 		return;
 
+	dev = (struct rsi_91x_sdiodev *)adapter->rsi_dev;
+
 	dev->write_fail = 2;
 	rsi_mac80211_detach(adapter);
 
-- 
1.7.5.4

