Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:55557 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab3J3FaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 01:30:08 -0400
Received: by mail-bk0-f44.google.com with SMTP id mx11so277905bkb.31
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 22:30:07 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 13:30:07 +0800
Message-ID: <CAPgLHd9HRb_o+hac5_RjKhK1K-jJFtQmrv9P2iy7zegQv=WOcw@mail.gmail.com> (sfid-20131030_063013_236699_A37F72DE)
Subject: [PATCH -next] wcn36xx: fix missing unlock on error in wcn36xx_smd_update_proberesp_tmpl()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: k.eugene.e@gmail.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, wcn36xx@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function
wcn36xx_smd_update_proberesp_tmpl() in the error
handling case.

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

