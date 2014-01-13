Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62608 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbaAMQTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 11:19:01 -0500
Received: by mail-wi0-f175.google.com with SMTP id hi5so2469024wib.8
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 08:19:00 -0800 (PST)
Message-ID: <1389629930.2590.1.camel@canaries32-MCP7A> (sfid-20140113_171924_204710_F3167871)
Subject: [PATCH 2/6] staging: vt6656:  sparse fixes: device_get_stats
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 13 Jan 2014 16:18:50 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sparse warning
main_usb.c:1442:44: warning: cast removes address space of expression

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 4cb7aa7..59c2430 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1418,8 +1418,9 @@ static void device_set_multi(struct net_device *dev)
 static struct net_device_stats *device_get_stats(struct net_device *dev)
 {
 	struct vnt_private *pDevice = netdev_priv(dev);
+	struct net_device_stats *stats = &pDevice->stats;
 
-	return &pDevice->stats;
+	return stats;
 }
 
 static int device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-- 
1.8.5.2


