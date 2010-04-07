Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:65104 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab0DGFbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 01:31:03 -0400
Subject: [PATCH 3/4] compat-wireless: remove 25-device_create.patch,
 it's handled by compat
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 07 Apr 2010 01:31:02 -0400
Message-ID: <20100407053102.23575.37321.stgit@mj.roinet.com>
In-Reply-To: <20100407053051.23575.94594.stgit@mj.roinet.com>
References: <20100407053051.23575.94594.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 patches/25-device_create.patch |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)
 delete mode 100644 patches/25-device_create.patch

diff --git a/patches/25-device_create.patch b/patches/25-device_create.patch
deleted file mode 100644
index 232816e..0000000
--- a/patches/25-device_create.patch
+++ /dev/null
@@ -1,20 +0,0 @@
---- a/drivers/net/wireless/mac80211_hwsim.c
-+++ b/drivers/net/wireless/mac80211_hwsim.c
-@@ -1211,8 +1211,17 @@ static int __init init_mac80211_hwsim(vo
- 		data = hw->priv;
- 		data->hw = hw;
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
- 		data->dev = device_create(hwsim_class, NULL, 0, hw,
- 					  "hwsim%d", i);
-+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26))
-+		data->dev = device_create_drvdata(hwsim_class, NULL, 0, hw,
-+					  "hwsim%d", i);
-+#else
-+		data->dev = device_create(hwsim_class, NULL, 0,
-+					  "hwsim%d", i);
-+		dev_set_drvdata(data->dev, hw);
-+#endif
- 		if (IS_ERR(data->dev)) {
- 			printk(KERN_DEBUG
- 			       "mac80211_hwsim: device_create "
