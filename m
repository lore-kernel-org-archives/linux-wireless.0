Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44130 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab0LAPDn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 10:03:43 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: fix build with CONFIG_LEDS_CLASS=m
Date: Wed,  1 Dec 2010 16:03:29 +0100
Message-Id: <1291215810-1140-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.37.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/compat/compat-2.6.37.c b/compat/compat-2.6.37.c
index 48707ff..a522b4e 100644
--- a/compat/compat-2.6.37.c
+++ b/compat/compat-2.6.37.c
@@ -152,7 +152,7 @@ int compat_genl_unregister_family(struct genl_family *family)
 }
 EXPORT_SYMBOL(compat_genl_unregister_family);
 
-#ifdef CONFIG_LEDS_CLASS
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
 
 #undef led_brightness_set
 #undef led_classdev_unregister
-- 
1.7.1

