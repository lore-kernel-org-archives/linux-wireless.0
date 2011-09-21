Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33633 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1IUREb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 13:04:31 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: add rcu_read_lock_held()
Date: Wed, 21 Sep 2011 19:04:23 +0200
Message-Id: <1316624664-7913-1-git-send-email-hauke@hauke-m.de> (sfid-20110921_190434_491874_59847561)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

just the version without lock debug support is implemented, if you want
to debug the logs use a more recent kernel version.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.34.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index 7bda52b..0ab344c 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -262,6 +262,11 @@ static inline int usb_disable_autosuspend(struct usb_device *udev)
 #define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
 
+static inline int rcu_read_lock_held(void)
+{
+	return 1;
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
 
 #endif /* LINUX_26_34_COMPAT_H */
-- 
1.7.4.1

