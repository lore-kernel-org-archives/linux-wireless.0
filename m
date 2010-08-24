Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41296 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab0HXV3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 17:29:21 -0400
Received: by bwz11 with SMTP id 11so97312bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Aug 2010 14:29:19 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: better rssi->dbm conversion for longbow phys
Date: Tue, 24 Aug 2010 23:29:05 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008242329.06120.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch should fix the dodgy signal and noise value
reports for most longbow (p54spi) users:

e.g.: (an older tcpdump extract)
> 2.0 Mb/s 2437 MHz (0x00a0) -49dB signal -41dB noise 
> 1.0 Mb/s 2437 MHz (0x00a0) 4dB signal -41dB noise

The formula is taken from stlc45xx:
http://gitorious.org/stlc45xx/mainline/blobs/master/stlc45xx.c#line1199

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 1dc0dbf..1fe971c 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -275,15 +275,15 @@ static int p54_rssi_to_dbm(struct p54_common *priv, int rssi)
 {
 	int band = priv->hw->conf.channel->band;
 
-	if (priv->rxhw != 5)
+	if (priv->rxhw != 5) {
 		return ((rssi * priv->rssical_db[band].mul) / 64 +
 			 priv->rssical_db[band].add) / 4;
-	else
+	} else {
 		/*
 		 * TODO: find the correct formula
 		 */
-		return ((rssi * priv->rssical_db[band].mul) / 64 +
-			 priv->rssical_db[band].add) / 4;
+		return rssi / 2 - 110;
+	}
 }
 
 /*
