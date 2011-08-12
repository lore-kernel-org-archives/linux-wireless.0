Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab1HLSXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 14:23:11 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1QrwNx-0004FS-N6
	for linux-wireless@vger.kernel.org; Fri, 12 Aug 2011 20:23:09 +0200
Subject: [PATCH] compat: fix LED lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 20:23:08 +0200
Message-ID: <1313173388.4022.21.camel@jlt3.sipsolutions.net> (sfid-20110812_202319_944462_07DA75B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The led_lock is never initialised, so there
are warnings/errors. It can also be made
static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 compat/compat-2.6.37.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/compat/compat-2.6.37.c b/compat/compat-2.6.37.c
index a62b13f..257880e 100644
--- a/compat/compat-2.6.37.c
+++ b/compat/compat-2.6.37.c
@@ -158,7 +158,7 @@ EXPORT_SYMBOL(compat_genl_unregister_family);
 #undef led_brightness_set
 #undef led_classdev_unregister
 
-spinlock_t led_lock;
+static DEFINE_SPINLOCK(led_lock);
 static LIST_HEAD(led_timers);
 
 struct led_timer {


