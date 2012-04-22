Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51675 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab2DVWDn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 18:03:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 7/7] compat-wireless: add an extra include to ath6kl/htc_pipe.c
Date: Mon, 23 Apr 2012 00:03:19 +0200
Message-Id: <1335132199-21320-7-git-send-email-hauke@hauke-m.de> (sfid-20120423_000347_266004_C4AE4D45)
In-Reply-To: <1335132199-21320-1-git-send-email-hauke@hauke-m.de>
References: <1335132199-21320-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 patches/06-header-changes.patch |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/patches/06-header-changes.patch b/patches/06-header-changes.patch
index c6a1d63..92ed02d 100644
--- a/patches/06-header-changes.patch
+++ b/patches/06-header-changes.patch
@@ -4,6 +4,19 @@ made. Some code gets shifted around between headers or
 new headers are defined. This patch deals with such
 cases.
 
+--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
++++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+@@ -18,6 +18,10 @@
+ #include "debug.h"
+ #include "hif-ops.h"
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
++#include <asm/unaligned.h>
++#endif
++
+ #define HTC_PACKET_CONTAINER_ALLOCATION 32
+ #define HTC_CONTROL_BUFFER_SIZE (HTC_MAX_CTRL_MSG_LEN + HTC_HDR_LENGTH)
+ 
 --- a/drivers/net/wireless/b43/phy_common.h
 +++ b/drivers/net/wireless/b43/phy_common.h
 @@ -3,6 +3,9 @@
-- 
1.7.9.5

