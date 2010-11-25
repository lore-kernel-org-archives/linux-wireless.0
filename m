Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52963 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab0KYOsu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 09:48:50 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/5] compat-wireless: fix CONFIG_BRCM80211 config option
Date: Thu, 25 Nov 2010 15:48:36 +0100
Message-Id: <1290696517-20437-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1290696517-20437-1-git-send-email-hauke@hauke-m.de>
References: <1290696517-20437-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_BRCM80211 Does not need CONFIG_WIRELESS_EXT, so we can build it
also if this is not available. Add commented out CONFIG_BRCMFMAC
option. This only build if CONFIG_BRCM80211_PCI is not build as module.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/config.mk b/config.mk
index ad597cb..38477b8 100644
--- a/config.mk
+++ b/config.mk
@@ -516,6 +516,10 @@ CONFIG_BT_HCIBTSDIO=m
 CONFIG_BT_MRVL_SDIO=m
 
 ifneq ($(CONFIG_COMPAT_STAGING),)
+
+CONFIG_BRCM80211=m
+CONFIG_BRCM80211_PCI=y
+
 ifdef CONFIG_WIRELESS_EXT
 CONFIG_ATH6KL_CFG80211=y
 CONFIG_ATH6KL_DEBUG=y
@@ -529,8 +533,9 @@ CONFIG_ATH6KL_ENABLE_TARGET_DEBUG_PRINTS=y
 CONFIG_ATH6KL_VIRTUAL_SCATTER_GATHER=y
 CONFIG_ATH6K_LEGACY=m
 
-CONFIG_BRCM80211=m
-CONFIG_BRCM80211_PCI=y
+# It is not possible to compile CONFIG_BRCM80211 and CONFIG_BRCMFMAC as
+# module at the same time
+# CONFIG_BRCMFMAC=y
 
 endif #CONFIG_WIRELESS_EXT
 endif #CONFIG_MMC
-- 
1.7.1

