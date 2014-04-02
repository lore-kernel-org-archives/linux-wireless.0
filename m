Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61892 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbaDBCIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 22:08:20 -0400
Received: by mail-pa0-f47.google.com with SMTP id lj1so10750878pab.20
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 19:08:20 -0700 (PDT)
From: Fariya Fatima <fariyaf@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH 3/6] rsi: Fixed issue relating to variable de-referenced before check 'adapter'
Date: Wed,  2 Apr 2014 07:38:02 +0530
Message-Id: <1396404485-3989-4-git-send-email-fariyaf@gmail.com> (sfid-20140402_040823_704279_18BB5543)
In-Reply-To: <1396404485-3989-1-git-send-email-fariyaf@gmail.com>
References: <1396404485-3989-1-git-send-email-fariyaf@gmail.com>
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

