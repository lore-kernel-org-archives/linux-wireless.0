Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35423 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbcFHHlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 03:41:18 -0400
Received: by mail-pf0-f169.google.com with SMTP id c2so23603pfa.2
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jun 2016 00:41:17 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	driverdev-devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 2/2] staging: r8723au: Remove unused semaphores
Date: Wed,  8 Jun 2016 13:10:55 +0530
Message-Id: <1465371655-6768-3-git-send-email-binoy.jayan@linaro.org> (sfid-20160608_094148_187123_AFD905A9)
In-Reply-To: <1465371655-6768-1-git-send-email-binoy.jayan@linaro.org>
References: <1465371655-6768-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The semaphores xmit_sema, terminate_xmitthread_sema, tx_retevt and
io_req have no users, hence remove all references to them.
Semaphores are going away in the future.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/staging/rtl8723au/core/rtw_xmit.c         | 4 ----
 drivers/staging/rtl8723au/include/osdep_service.h | 1 -
 drivers/staging/rtl8723au/include/rtw_io.h        | 2 --
 drivers/staging/rtl8723au/include/rtw_xmit.h      | 5 -----
 4 files changed, 12 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c b/drivers/staging/rtl8723au/core/rtw_xmit.c
index 3de40cf..003576d 100644
--- a/drivers/staging/rtl8723au/core/rtw_xmit.c
+++ b/drivers/staging/rtl8723au/core/rtw_xmit.c
@@ -60,8 +60,6 @@ int _rtw_init_xmit_priv23a(struct xmit_priv *pxmitpriv,
 
 	spin_lock_init(&pxmitpriv->lock);
 	spin_lock_init(&pxmitpriv->lock_sctx);
-	sema_init(&pxmitpriv->xmit_sema, 0);
-	sema_init(&pxmitpriv->terminate_xmitthread_sema, 0);
 
 	pxmitpriv->adapter = padapter;
 
@@ -177,8 +175,6 @@ int _rtw_init_xmit_priv23a(struct xmit_priv *pxmitpriv,
 	for (i = 0; i < 4; i ++)
 		pxmitpriv->wmm_para_seq[i] = i;
 
-	sema_init(&pxmitpriv->tx_retevt, 0);
-
 	pxmitpriv->ack_tx = false;
 	mutex_init(&pxmitpriv->ack_tx_mutex);
 	rtw_sctx_init23a(&pxmitpriv->ack_tx_ops, 0);
diff --git a/drivers/staging/rtl8723au/include/osdep_service.h b/drivers/staging/rtl8723au/include/osdep_service.h
index 98250b1..33ecb9c 100644
--- a/drivers/staging/rtl8723au/include/osdep_service.h
+++ b/drivers/staging/rtl8723au/include/osdep_service.h
@@ -33,7 +33,6 @@
 #include <asm/byteorder.h>
 #include <linux/atomic.h>
 #include <linux/io.h>
-#include <linux/semaphore.h>
 #include <linux/sem.h>
 #include <linux/sched.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/staging/rtl8723au/include/rtw_io.h b/drivers/staging/rtl8723au/include/rtw_io.h
index c8119e2..d875e9e 100644
--- a/drivers/staging/rtl8723au/include/rtw_io.h
+++ b/drivers/staging/rtl8723au/include/rtw_io.h
@@ -20,7 +20,6 @@
 #include <osdep_intf.h>
 
 #include <asm/byteorder.h>
-#include <linux/semaphore.h>
 #include <linux/list.h>
 /* include <linux/smp_lock.h> */
 #include <linux/spinlock.h>
@@ -105,7 +104,6 @@ struct io_req {
 	u32	command;
 	u32	status;
 	u8	*pbuf;
-	struct semaphore	sema;
 
 	void (*_async_io_callback)(struct rtw_adapter *padater, struct io_req *pio_req, u8 *cnxt);
 	u8 *cnxt;
diff --git a/drivers/staging/rtl8723au/include/rtw_xmit.h b/drivers/staging/rtl8723au/include/rtw_xmit.h
index 2b7d6d0..24f326b 100644
--- a/drivers/staging/rtl8723au/include/rtw_xmit.h
+++ b/drivers/staging/rtl8723au/include/rtw_xmit.h
@@ -275,9 +275,6 @@ struct agg_pkt_info {
 struct	xmit_priv {
 	spinlock_t	lock;
 
-	struct semaphore	xmit_sema;
-	struct semaphore	terminate_xmitthread_sema;
-
 	struct rtw_queue	be_pending;
 	struct rtw_queue	bk_pending;
 	struct rtw_queue	vi_pending;
@@ -310,8 +307,6 @@ struct	xmit_priv {
 				 * 2->be, 3->bk.
 				 */
 
-	struct semaphore	tx_retevt;/* all tx return event; */
-
 	struct tasklet_struct xmit_tasklet;
 
 	struct rtw_queue free_xmitbuf_queue;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

