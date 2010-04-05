Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52598 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab0DEVDk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Apr 2010 17:03:40 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: fix use of device_create
Date: Mon,  5 Apr 2010 23:03:30 +0200
Message-Id: <1270501410-3956-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1270501410-3956-1-git-send-email-hauke@hauke-m.de>
References: <1270501410-3956-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The signature of device_create changed in the last kernel version.
Backporting it in compat is hard because of the use of var args.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/25-device_create.patch |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)
 create mode 100644 patches/25-device_create.patch

diff --git a/patches/25-device_create.patch b/patches/25-device_create.patch
new file mode 100644
index 0000000..232816e
--- /dev/null
+++ b/patches/25-device_create.patch
@@ -0,0 +1,20 @@
+--- a/drivers/net/wireless/mac80211_hwsim.c
++++ b/drivers/net/wireless/mac80211_hwsim.c
+@@ -1211,8 +1211,17 @@ static int __init init_mac80211_hwsim(vo
+ 		data = hw->priv;
+ 		data->hw = hw;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
+ 		data->dev = device_create(hwsim_class, NULL, 0, hw,
+ 					  "hwsim%d", i);
++#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26))
++		data->dev = device_create_drvdata(hwsim_class, NULL, 0, hw,
++					  "hwsim%d", i);
++#else
++		data->dev = device_create(hwsim_class, NULL, 0,
++					  "hwsim%d", i);
++		dev_set_drvdata(data->dev, hw);
++#endif
+ 		if (IS_ERR(data->dev)) {
+ 			printk(KERN_DEBUG
+ 			       "mac80211_hwsim: device_create "
-- 
1.6.3.3

