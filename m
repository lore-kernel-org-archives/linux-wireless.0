Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43935 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab2E2WkQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:40:16 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/8] compat-wireless: add asm/unaligned.h include to ath6kl
Date: Wed, 30 May 2012 00:39:39 +0200
Message-Id: <1338331182-29589-6-git-send-email-hauke@hauke-m.de> (sfid-20120530_004027_640562_407DC450)
In-Reply-To: <1338331182-29589-1-git-send-email-hauke@hauke-m.de>
References: <1338331182-29589-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some old kernel versions are missing this include and we get a compile
error because of missing get_unaligned_le16() prototype.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/06-header-changes.patch |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/patches/06-header-changes.patch b/patches/06-header-changes.patch
index db84468..d77e5fb 100644
--- a/patches/06-header-changes.patch
+++ b/patches/06-header-changes.patch
@@ -105,3 +105,13 @@ cases.
  
  #include "hidp.h"
  
+--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
++++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
+@@ -20,6 +20,7 @@
+ #include <linux/moduleparam.h>
+ #include <linux/inetdevice.h>
+ #include <linux/export.h>
++#include <asm/unaligned.h>
+ 
+ #include "core.h"
+ #include "cfg80211.h"
-- 
1.7.9.5

