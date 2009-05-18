Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:47567 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZERR27 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 13:28:59 -0400
Received: by ey-out-2122.google.com with SMTP id 9so1052510eyd.37
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 10:29:00 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@web.de>, flamingice@sourmilk.net,
	Andrew Morton <akpm@linux-foundation.org>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] p54spi: drop test for FW_STATE_RESET in p54spi_work
Date: Mon, 18 May 2009 21:28:55 +0400
Message-Id: <1242667735-24471-1-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <4A11756F.5000206@gmail.com>
References: <4A11756F.5000206@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop test for FW_STATE_RESET in p54spi_work as fw_state
is never assigned this value.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/net/wireless/p54/p54spi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index fe90f88..bd75f10 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -511,8 +511,7 @@ static void p54spi_work(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
-	if (priv->fw_state == FW_STATE_OFF &&
-	    priv->fw_state == FW_STATE_RESET)
+	if (priv->fw_state == FW_STATE_OFF)
 		goto out;
 
 	ints = p54spi_read32(priv, SPI_ADRS_HOST_INTERRUPTS);
-- 
1.6.0.6

