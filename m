Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:38314 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3J3FWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 01:22:35 -0400
Received: by mail-bk0-f54.google.com with SMTP id 6so274319bkj.13
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 22:22:34 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 13:22:34 +0800
Message-ID: <CAPgLHd9nCFPvSWMtrinySm=9bESiKXpYZgZYj6fhzUQKVJFkhw@mail.gmail.com> (sfid-20131030_062239_384396_BAA4ECA8)
Subject: [PATCH -next] libertas: fix error return code in if_cs_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linville@tuxdriver.com, hsweeten@visionengravers.com,
	gregkh@linuxfoundation.org, dcbw@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENODEV in the unknown model error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/libertas/if_cs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index ef8c98e..f499efc 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -902,6 +902,7 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
 	if (card->model == MODEL_UNKNOWN) {
 		pr_err("unsupported manf_id 0x%04x / card_id 0x%04x\n",
 		       p_dev->manf_id, p_dev->card_id);
+		ret = -ENODEV;
 		goto out2;
 	}
 

