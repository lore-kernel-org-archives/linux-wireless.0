Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935429AbYCDX1p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 18:27:45 -0500
Message-Id: <200803042326.m24NQBYe003300@imap1.linux-foundation.org> (sfid-20080304_232754_376046_2F8BF1DA)
Subject: [patch 06/10] prism54: convert wpa_sem in a mutex
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	matthias@kaehlcke.net, flamingice@sourmilk.net,
	mcgrof@winlab.rutgers.edu
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2008 15:26:11 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matthias Kaehlcke <matthias@kaehlcke.net>

The semaphore wpa_sem is used as mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/prism54/isl_ioctl.c  |   10 +++++-----
 drivers/net/wireless/prism54/islpci_dev.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/net/wireless/prism54/isl_ioctl.c~convert-wpa_sem-in-a-mutex drivers/net/wireless/prism54/isl_ioctl.c
--- a/drivers/net/wireless/prism54/isl_ioctl.c~convert-wpa_sem-in-a-mutex
+++ a/drivers/net/wireless/prism54/isl_ioctl.c
@@ -2114,7 +2114,7 @@ prism54_wpa_bss_ie_add(islpci_private *p
 	if (wpa_ie_len > MAX_WPA_IE_LEN)
 		wpa_ie_len = MAX_WPA_IE_LEN;
 
-	down(&priv->wpa_sem);
+	mutex_lock(&priv->wpa_lock);
 
 	/* try to use existing entry */
 	list_for_each(ptr, &priv->bss_wpa_list) {
@@ -2165,7 +2165,7 @@ prism54_wpa_bss_ie_add(islpci_private *p
 		kfree(bss);
 	}
 
-	up(&priv->wpa_sem);
+	mutex_unlock(&priv->wpa_lock);
 }
 
 static size_t
@@ -2175,7 +2175,7 @@ prism54_wpa_bss_ie_get(islpci_private *p
 	struct islpci_bss_wpa_ie *bss = NULL;
 	size_t len = 0;
 
-	down(&priv->wpa_sem);
+	mutex_lock(&priv->wpa_lock);
 
 	list_for_each(ptr, &priv->bss_wpa_list) {
 		bss = list_entry(ptr, struct islpci_bss_wpa_ie, list);
@@ -2187,7 +2187,7 @@ prism54_wpa_bss_ie_get(islpci_private *p
 		len = bss->wpa_ie_len;
 		memcpy(wpa_ie, bss->wpa_ie, len);
 	}
-	up(&priv->wpa_sem);
+	mutex_unlock(&priv->wpa_lock);
 
 	return len;
 }
@@ -2196,7 +2196,7 @@ void
 prism54_wpa_bss_ie_init(islpci_private *priv)
 {
 	INIT_LIST_HEAD(&priv->bss_wpa_list);
-	sema_init(&priv->wpa_sem, 1);
+	mutex_init(&priv->wpa_lock);
 }
 
 void
diff -puN drivers/net/wireless/prism54/islpci_dev.h~convert-wpa_sem-in-a-mutex drivers/net/wireless/prism54/islpci_dev.h
--- a/drivers/net/wireless/prism54/islpci_dev.h~convert-wpa_sem-in-a-mutex
+++ a/drivers/net/wireless/prism54/islpci_dev.h
@@ -178,7 +178,7 @@ typedef struct {
 	int wpa; /* WPA mode enabled */
 	struct list_head bss_wpa_list;
 	int num_bss_wpa;
-	struct semaphore wpa_sem;
+	struct mutex wpa_lock;
 	u8 wpa_ie[MAX_WPA_IE_LEN];
 	size_t wpa_ie_len;
 
_
