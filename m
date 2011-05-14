Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58372 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab1ENSAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 14:00:36 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: set CONFIG_COMPAT_STAGING=m
Date: Sat, 14 May 2011 20:00:26 +0200
Message-Id: <1305396027-5864-2-git-send-email-hauke@hauke-m.de> (sfid-20110514_200039_712410_056397AF)
In-Reply-To: <1305396027-5864-1-git-send-email-hauke@hauke-m.de>
References: <1305396027-5864-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If this is set to y and all CONFIG_BRCM* options are set to m it causes build
failures with kernel version < 2.6.36 as there is nothing build into
the kernel. Besides compat-wireless does not support build anything
into the kernel.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index 3c034c1..abe6030 100644
--- a/config.mk
+++ b/config.mk
@@ -200,7 +200,7 @@ $(warning "WARNING: CONFIG_CFG80211_WEXT will be deactivated or not working beca
 endif #CONFIG_WIRELESS_EXT
 
 ifdef CONFIG_STAGING
-CONFIG_COMPAT_STAGING=y
+CONFIG_COMPAT_STAGING=m
 endif #CONFIG_STAGING
 
 # mac80211 test driver
-- 
1.7.4.1

