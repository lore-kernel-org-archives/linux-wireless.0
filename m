Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36308 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab1BUWby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 17:31:54 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 7/7] compat-wireless: build ath9k common when no pci is available
Date: Mon, 21 Feb 2011 23:31:24 +0100
Message-Id: <1298327484-16938-8-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1298327484-16938-1-git-send-email-hauke@hauke-m.de>
References: <1298327484-16938-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_common.ko and ath9k_hw.ko are not depending on pci or usb.
This patch fixes build of ath9k_htc.ko for a kernel without pci support.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/config.mk b/config.mk
index 08941b9..2a1bf54 100644
--- a/config.mk
+++ b/config.mk
@@ -211,21 +211,14 @@ endif
 # mac80211 test driver
 CONFIG_MAC80211_HWSIM=m
 
-# PCI Drivers
-ifdef CONFIG_PCI
-
 CONFIG_ATH5K=m
-CONFIG_ATH5K_PCI=y
 # CONFIG_ATH5K_DEBUG=y
 # CONFIG_ATH5K_AHB=y
 CONFIG_ATH9K_HW=m
-CONFIG_ATH9K=m
-# Note: once ath9k_htc is added we'll have to move
-# CONFIG_ATH9K_COMMON to an area that doesn't depend on PCI
-# as you could then have ath9k disabled but ath9k_htc enabled.
 CONFIG_ATH9K_COMMON=m
 # CONFIG_ATH9K_DEBUGFS=y
 # CONFIG_ATH9K_PKTLOG=y
+
 # Disable this to get minstrel as default, we leave the ath9k
 # rate control algorithm as the default for now as that is also
 # default upstream on the kernel. We will move this to minstrel
@@ -234,6 +227,11 @@ CONFIG_ATH9K_COMMON=m
 # for long range considerations.
 CONFIG_ATH9K_RATE_CONTROL=y
 
+# PCI Drivers
+ifdef CONFIG_PCI
+
+CONFIG_ATH5K_PCI=y
+CONFIG_ATH9K=m
 
 CONFIG_COMPAT_IWLWIFI=m
 # CONFIG_IWLWIFI_DEBUG=y
-- 
1.7.1

