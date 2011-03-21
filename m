Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:63050 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab1CUInl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 04:43:41 -0400
From: juuso.oikarinen@nokia.com
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: Add mutex protection for interface list
Date: Mon, 21 Mar 2011 10:43:36 +0200
Message-Id: <1300697016-1652-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The interface list maintained in main.c is not mutex protected. This could
cause issues, as the list is accessed from notifier chains.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/main.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index db7ab85..1c09bfe 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -339,6 +339,7 @@ static struct platform_device wl1271_device = {
 	},
 };
 
+static DEFINE_MUTEX(wl_list_mutex);
 static LIST_HEAD(wl_list);
 
 static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
@@ -369,10 +370,12 @@ static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
 		return NOTIFY_DONE;
 
 	wl_temp = hw->priv;
+	mutex_lock(&wl_list_mutex);
 	list_for_each_entry(wl, &wl_list, list) {
 		if (wl == wl_temp)
 			break;
 	}
+	mutex_unlock(&wl_list_mutex);
 	if (wl != wl_temp)
 		return NOTIFY_DONE;
 
@@ -1390,8 +1393,10 @@ power_off:
 out:
 	mutex_unlock(&wl->mutex);
 
+	mutex_lock(&wl_list_mutex);
 	if (!ret)
 		list_add(&wl->list, &wl_list);
+	mutex_unlock(&wl_list_mutex);
 
 	return ret;
 }
@@ -1404,7 +1409,9 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 
 	wl1271_info("down");
 
+	mutex_lock(&wl_list_mutex);
 	list_del(&wl->list);
+	mutex_unlock(&wl_list_mutex);
 
 	WARN_ON(wl->state != WL1271_STATE_ON);
 
-- 
1.7.1

