Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:40951 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967156Ab3DSCQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 22:16:56 -0400
Received: by mail-bk0-f44.google.com with SMTP id jk13so1520654bkc.17
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2013 19:16:54 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 19 Apr 2013 10:10:03 +0800
Message-ID: <CAPgLHd8GkC50rYFD0zDRuE3o0JUHBCnSGXQi2jNL9DdK+8pNDA@mail.gmail.com> (sfid-20130419_041659_974381_6B8DFD0B)
Subject: [PATCH -next] brcmfmac: fix error return code in brcmf_fws_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: brudley@broadcom.com, arend@broadcom.com, frankyl@broadcom.com,
	meuleman@broadcom.com, linville@tuxdriver.com,
	pieterpg@broadcom.com, phaber@broadcom.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 1bcd58c..df2ac2f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1875,8 +1875,9 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 		goto fail;
 	}
 
-	if (brcmf_fweh_register(drvr, BRCMF_E_FIFO_CREDIT_MAP,
-				brcmf_fws_notify_credit_map)) {
+	rc = brcmf_fweh_register(drvr, BRCMF_E_FIFO_CREDIT_MAP,
+				 brcmf_fws_notify_credit_map);
+	if (rc) {
 		brcmf_err("register credit map handler failed\n");
 		goto fail;
 	}

