Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34041 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758653Ab1CaQWn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:22:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/5] compat-wireless: clean up the config file
Date: Thu, 31 Mar 2011 18:22:07 +0200
Message-Id: <1301588527-16615-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1301588527-16615-1-git-send-email-hauke@hauke-m.de>
References: <1301588527-16615-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/config.mk b/config.mk
index f7b5323..5f861ca 100644
--- a/config.mk
+++ b/config.mk
@@ -204,9 +204,9 @@ else #CONFIG_CFG80211_WEXT
 $(warning "WARNING: CONFIG_CFG80211_WEXT will be deactivated or not working because kernel was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface like iwconfig will not work. To activate it build your kernel e.g. with CONFIG_LIBIPW=m.")
 endif #CONFIG_WIRELESS_EXT
 
-ifneq ($(CONFIG_STAGING),)
- CONFIG_COMPAT_STAGING=m
-endif
+ifdef CONFIG_STAGING
+CONFIG_COMPAT_STAGING=y
+endif #CONFIG_STAGING
 
 # mac80211 test driver
 CONFIG_MAC80211_HWSIM=m
@@ -546,9 +546,8 @@ CONFIG_IWM=m
 CONFIG_BT_HCIBTSDIO=m
 CONFIG_BT_MRVL_SDIO=m
 
-ifneq ($(CONFIG_COMPAT_STAGING),)
+ifdef CONFIG_COMPAT_STAGING
 
-CONFIG_BRCM80211=m
 CONFIG_BRCMSMAC=y
 # CONFIG_BRCMDBG=y
 
@@ -567,10 +566,10 @@ CONFIG_ATH6K_LEGACY=m
 CONFIG_BRCMFMAC=y
 
 endif #CONFIG_WIRELESS_EXT
-endif #CONFIG_MMC
+endif #CONFIG_COMPAT_STAGING
 
 
-endif # end of SDIO driver list
+endif #CONFIG_MMC
 
 CONFIG_RTLWIFI=m
 CONFIG_RTL8192C_COMMON=m
-- 
1.7.1

