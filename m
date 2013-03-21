Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:46117 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab3CUHkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 03:40:01 -0400
Received: by mail-bk0-f50.google.com with SMTP id jg9so1276678bkc.37
        for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2013 00:40:00 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 21 Mar 2013 15:40:00 +0800
Message-ID: <CAPgLHd-BKoizHok9hDdAz9yBY1YqfpTov6s3CoefPTtbacQW3g@mail.gmail.com> (sfid-20130321_084007_798120_EC8AE3BA)
Subject: [PATCH] NFC: microread: use kfree_skb() instead of kfree()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use kfree_skb() instead of kfree() to free sk_buff.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/nfc/microread/mei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/microread/mei.c b/drivers/nfc/microread/mei.c
index eef38cf..da8264c 100644
--- a/drivers/nfc/microread/mei.c
+++ b/drivers/nfc/microread/mei.c
@@ -130,7 +130,7 @@ static void microread_event_cb(struct mei_device *device, u32 events,
 
 		reply_size = mei_recv(device, skb->data, MEI_NFC_MAX_READ);
 		if (reply_size < MEI_NFC_HEADER_SIZE) {
-			kfree(skb);
+			kfree_skb(skb);
 			return;
 		}
 

