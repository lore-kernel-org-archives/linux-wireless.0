Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53408 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757780Ab3EWJKo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 05:10:44 -0400
Received: by mail-bk0-f46.google.com with SMTP id my13so1687841bkb.33
        for <linux-wireless@vger.kernel.org>; Thu, 23 May 2013 02:10:43 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 May 2013 17:10:43 +0800
Message-ID: <CAPgLHd9HBQWnjA-ViiK27Z2AjnuwHgjrUqFhSLxGCRZD1fGsSA@mail.gmail.com> (sfid-20130523_111102_454037_A5810DE9)
Subject: [PATCH -next] wil6210: use kfree_skb() instead of kfree()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: qca_vkondrat@qca.qualcomm.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	wil6210@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use kfree_skb() instead of kfree() to free sk_buff.

Introduced by commit e270045b569cc7030abd29857f3a4e7906524ec0
(wil6210: Sanity check for reported DMA length)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 082f76b..00dffed 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -369,7 +369,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 
 	if (dmalen > sz) {
 		wil_err(wil, "Rx size too large: %d bytes!\n", dmalen);
-		kfree(skb);
+		kfree_skb(skb);
 		return NULL;
 	}
 	skb_trim(skb, dmalen);

