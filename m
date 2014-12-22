Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58588 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbaLVQcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2014 11:32:51 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so7069114wgh.32
        for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2014 08:32:50 -0800 (PST)
Date: Mon, 22 Dec 2014 19:32:47 +0300
From: Alexey Tulia <alexey.tulia@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging: rtl8723au: fix sparse warning
Message-ID: <20141222163247.GA25707@epbyminw1710.minsk.epam.com> (sfid-20141222_173255_304772_64DEA321)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/staging/rtl8723au/core/rtw_xmit.c:2375 warning: symbol
'rtl8723a_EfusePgPacketRead' was not declared. Should it be static?

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

