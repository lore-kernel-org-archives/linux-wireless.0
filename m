Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59086 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab3KHRfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 12:35:00 -0500
Received: by mail-wg0-f41.google.com with SMTP id b13so24489wgh.4
        for <linux-wireless@vger.kernel.org>; Fri, 08 Nov 2013 09:34:59 -0800 (PST)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: [PATCH 1/3] Add the missing unlock before return from function wcn36xx_smd_update_proberesp_tmpl() in the error handling case.
Date: Fri,  8 Nov 2013 17:34:37 +0000
Message-Id: <1383932079-3791-2-git-send-email-k.eugene.e@gmail.com> (sfid-20131108_183507_804169_A03E9970)
In-Reply-To: <1383932079-3791-1-git-send-email-k.eugene.e@gmail.com>
References: <1383932079-3791-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index f8c3a10..04df70b 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1327,7 +1327,8 @@ int wcn36xx_smd_update_proberesp_tmpl(struct wcn36xx *wcn,
 	if (skb->len > BEACON_TEMPLATE_SIZE) {
 		wcn36xx_warn("probe response template is too big: %d\n",
 			     skb->len);
-		return -E2BIG;
+		ret = -E2BIG;
+		goto out;
 	}
 
 	msg.probe_resp_template_len = skb->len;
-- 
1.8.3.2

