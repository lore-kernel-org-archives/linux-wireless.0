Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48404 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab1HIVAI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 17:00:08 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: remove include of compat-2.6.h in cfg80211.h
Date: Tue,  9 Aug 2011 22:59:41 +0200
Message-Id: <1312923582-31850-1-git-send-email-hauke@hauke-m.de> (sfid-20110809_230013_525429_B303F5F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The header file linux/compat-2.6.h is inclued through -include
$(M)/include/linux/compat-2.6.h in the main Makefile for a long time. This
includes all the compat-*.h files backporting some stuff needed to
compile on older kernels. We do not have to add this include into
cfg80211.h any more.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/98-add-compat-wireless.patch |   30 ------------------------------
 1 files changed, 0 insertions(+), 30 deletions(-)
 delete mode 100644 patches/98-add-compat-wireless.patch

diff --git a/patches/98-add-compat-wireless.patch b/patches/98-add-compat-wireless.patch
deleted file mode 100644
index 76def9a..0000000
--- a/patches/98-add-compat-wireless.patch
+++ /dev/null
@@ -1,30 +0,0 @@
-
-This patch file includes the changes required to add
-compat-wireless support. Besides all the patches in this
-directory we have our own compat-2.6.*.[ch] files which
-help backport more. These the respective compat-2.6.2x.c
-files get compiled and enabled if you are on older kernels
-to bring in support for new features when possible.
-
-Lastly, the cfg80211.h change is what allows us to
-get all compat-2.6.*.h files included. Its our only
-point of entry through compat code. It works because
-all drivers we are supporting through there one way
-or another depend on cfg80211. New wireless drivers
-are either mac80211 drivers or cfg80211 drivers, and
-all mac80211 drivesr are cfg80211 drivers.
-
-If your driver is not a cfg80211 driver you must
-ensure you include compat.h then. I think we
-added compat.h also for ssb, I forget.
-
---- a/include/net/cfg80211.h
-+++ b/include/net/cfg80211.h
-@@ -23,6 +23,7 @@
- /* remove once we remove the wext stuff */
- #include <net/iw_handler.h>
- #include <linux/wireless.h>
-+#include <linux/compat-2.6.h>
- 
- 
- /**
-- 
1.7.4.1

