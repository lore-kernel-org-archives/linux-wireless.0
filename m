Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58629 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab0KJCVb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:31 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5541qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:30 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 26/44] compat: remove a couple of macro definition protection
Date: Tue,  9 Nov 2010 21:20:08 -0500
Message-Id: <1289355626-25373-27-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.31.h |    4 ----
 include/linux/compat-2.6.32.h |    2 --
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/compat-2.6.31.h b/include/linux/compat-2.6.31.h
index b1b7b28..52291f4 100644
--- a/include/linux/compat-2.6.31.h
+++ b/include/linux/compat-2.6.31.h
@@ -50,13 +50,9 @@
 #endif
 #endif
 
-#ifndef NETDEV_PRE_UP
 #define NETDEV_PRE_UP		0x000D
-#endif
 
-#ifndef SDIO_DEVICE_ID_MARVELL_8688WLAN
 #define SDIO_DEVICE_ID_MARVELL_8688WLAN		0x9104
-#endif
 
 /*
  * kmemleak was introduced on 2.6.31, since older kernels do not have
diff --git a/include/linux/compat-2.6.32.h b/include/linux/compat-2.6.32.h
index 3b9915e..8f139b3 100644
--- a/include/linux/compat-2.6.32.h
+++ b/include/linux/compat-2.6.32.h
@@ -59,7 +59,6 @@ static inline void flush_delayed_work(struct delayed_work *dwork)
 
 #define SET_NETDEV_DEVTYPE(netdev, type)
 
-#ifdef __KERNEL__
 /* Driver transmit return codes */
 enum netdev_tx {
 	BACKPORT_NETDEV_TX_OK = NETDEV_TX_OK,       /* driver took care of packet */
@@ -67,7 +66,6 @@ enum netdev_tx {
 	BACKPORT_NETDEV_TX_LOCKED = NETDEV_TX_LOCKED,  /* driver tx lock was already taken */
 };
 typedef enum netdev_tx netdev_tx_t;
-#endif /* __KERNEL__ */
 
 /*
  * dev_pm_ops is only available on kernels >= 2.6.29, for
-- 
1.7.2.30.gc37d7.dirty

