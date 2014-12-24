Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44909 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaLXGPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 01:15:14 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so12697715wiw.9
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 22:15:13 -0800 (PST)
Date: Wed, 24 Dec 2014 09:15:09 +0300
From: Alexey Tulia <alexey.tulia@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v3] staging: rtl8723au: fix sparse warning
Message-ID: <20141224061509.GA18562@epbyminw1710.minsk.epam.com> (sfid-20141224_071532_342963_EB9326E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/staging/rtl8723au/core/rtw_xmit.c:2375 warning: symbol
'rtw_ack_tx_done23a' was not declared. Should it be static?

Function 'rtw_ack_tx_done23a' seems to be unused in current staging
code.

Signed-off-by: Alexey Tulia <alexey.tulia@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_xmit.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c b/drivers/staging/rtl8723au/core/rtw_xmit.c
index 7a5e6bf..1c82dff 100644
--- a/drivers/staging/rtl8723au/core/rtw_xmit.c
+++ b/drivers/staging/rtl8723au/core/rtw_xmit.c
@@ -2372,12 +2372,3 @@ int rtw_ack_tx_wait23a(struct xmit_priv *pxmitpriv, u32 timeout_ms)
 	return rtw_sctx_wait23a(pack_tx_ops);
 }

-void rtw_ack_tx_done23a(struct xmit_priv *pxmitpriv, int status)
-{
-	struct submit_ctx *pack_tx_ops = &pxmitpriv->ack_tx_ops;
-
-	if (pxmitpriv->ack_tx)
-		rtw23a_sctx_done_err(&pack_tx_ops, status);
-	else
-		DBG_8723A("%s ack_tx not set\n", __func__);
-}
--
2.1.0

