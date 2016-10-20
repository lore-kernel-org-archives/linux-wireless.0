Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36046 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752708AbcJTG7d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 02:59:33 -0400
Received: by mail-pf0-f193.google.com with SMTP id r16so4664659pfg.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2016 23:59:32 -0700 (PDT)
Date: Thu, 20 Oct 2016 12:29:33 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
        florian.c.schilhabel@googlemail.com
Subject: [PATCH] staging: rtl8712: Free memory and return failure when
 kmalloc fails
Message-ID: <20161020065932.GA21705@symbol-HP-ZBook-15> (sfid-20161020_085938_067768_D87EBFDE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is added to free memory and return failure when kmalloc fails

Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
---
 drivers/staging/rtl8712/os_intfs.c     | 3 ++-
 drivers/staging/rtl8712/rtl871x_cmd.c  | 5 ++++-
 drivers/staging/rtl8712/rtl871x_xmit.c | 5 ++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index cbe4de0..aab3141 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -313,7 +313,8 @@ u8 r8712_init_drv_sw(struct _adapter *padapter)
 		return _FAIL;
 	if (r8712_init_mlme_priv(padapter) == _FAIL)
 		return _FAIL;
-	_r8712_init_xmit_priv(&padapter->xmitpriv, padapter);
+	if ((_r8712_init_xmit_priv(&padapter->xmitpriv, padapter)) != _SUCCESS)
+		return _FAIL;
 	_r8712_init_recv_priv(&padapter->recvpriv, padapter);
 	memset((unsigned char *)&padapter->securitypriv, 0,
 	       sizeof(struct security_priv));
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index b7ee5e6..04638f1 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -72,8 +72,11 @@ static sint _init_cmd_priv(struct cmd_priv *pcmdpriv)
 			    ((addr_t)(pcmdpriv->cmd_allocated_buf) &
 			    (CMDBUFF_ALIGN_SZ - 1));
 	pcmdpriv->rsp_allocated_buf = kmalloc(MAX_RSPSZ + 4, GFP_ATOMIC);
-	if (!pcmdpriv->rsp_allocated_buf)
+	if (!pcmdpriv->rsp_allocated_buf) {
+		kfree(pcmdpriv->cmd_allocated_buf);
+		pcmdpriv->cmd_allocated_buf = NULL;
 		return _FAIL;
+	}
 	pcmdpriv->rsp_buf = pcmdpriv->rsp_allocated_buf  +  4 -
 			    ((addr_t)(pcmdpriv->rsp_allocated_buf) & 3);
 	pcmdpriv->cmd_issued_cnt = 0;
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index be38364..484d2f2 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -128,8 +128,11 @@ sint _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv,
 	_init_queue(&pxmitpriv->pending_xmitbuf_queue);
 	pxmitpriv->pallocated_xmitbuf = kmalloc(NR_XMITBUFF * sizeof(struct xmit_buf) + 4,
 						GFP_ATOMIC);
-	if (!pxmitpriv->pallocated_xmitbuf)
+	if (!pxmitpriv->pallocated_xmitbuf) {
+		kfree(pxmitpriv->pallocated_frame_buf);
+		pxmitpriv->pallocated_frame_buf = NULL;
 		return _FAIL;
+	}
 	pxmitpriv->pxmitbuf = pxmitpriv->pallocated_xmitbuf + 4 -
 			      ((addr_t)(pxmitpriv->pallocated_xmitbuf) & 3);
 	pxmitbuf = (struct xmit_buf *)pxmitpriv->pxmitbuf;
-- 
1.9.1
