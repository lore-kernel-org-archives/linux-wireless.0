Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58273 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab0LVSKs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 13:10:48 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: build led support conditionally
Date: Wed, 22 Dec 2010 19:10:34 +0100
Message-Id: <1293041434-3594-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not build compat-wireless with LED support when the kernel does not
contain a led subsystem.
This fixes some compile problems when CONFIG_LEDS_TRIGGERS is not set.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index 964c646..1f95908 100644
--- a/config.mk
+++ b/config.mk
@@ -133,7 +133,9 @@ CONFIG_COMPAT_MAC80211_RC_DEFAULT=minstrel_ht
 CONFIG_MAC80211_RC_PID=y
 CONFIG_MAC80211_RC_MINSTREL=y
 CONFIG_MAC80211_RC_MINSTREL_HT=y
+ifdef CONFIG_LEDS_TRIGGERS
 CONFIG_MAC80211_LEDS=y
+endif #CONFIG_LEDS_TRIGGERS
 
 # enable mesh networking too
 CONFIG_MAC80211_MESH=y
@@ -243,7 +245,9 @@ CONFIG_B43_PCI_AUTOSELECT=y
 ifdef CONFIG_PCMCIA
 CONFIG_B43_PCMCIA=y
 endif #CONFIG_PCMCIA
+ifdef CONFIG_MAC80211_LEDS
 CONFIG_B43_LEDS=y
+endif #CONFIG_MAC80211_LEDS
 CONFIG_B43_PHY_LP=y
 CONFIG_B43_PHY_N=y
 # CONFIG_B43_FORCE_PIO=y
@@ -252,7 +256,9 @@ CONFIG_B43_PHY_N=y
 CONFIG_B43LEGACY=m
 CONFIG_B43LEGACY_HWRNG=y
 CONFIG_B43LEGACY_PCI_AUTOSELECT=y
+ifdef CONFIG_MAC80211_LEDS
 CONFIG_B43LEGACY_LEDS=y
+endif #CONFIG_MAC80211_LEDS
 # CONFIG_B43LEGACY_DEBUG=y
 CONFIG_B43LEGACY_DMA=y
 CONFIG_B43LEGACY_PIO=y
@@ -408,18 +414,24 @@ endif #CONFIG_COMPAT_KERNEL_29
 
 CONFIG_P54_USB=m
 CONFIG_RTL8187=m
+ifdef CONFIG_MAC80211_LEDS
 CONFIG_RTL8187_LEDS=y
+endif #CONFIG_MAC80211_LEDS
 
 CONFIG_AT76C50X_USB=m
 
 ifndef CONFIG_COMPAT_KERNEL_28
 CONFIG_AR9170_USB=m
+ifdef CONFIG_MAC80211_LEDS
 CONFIG_AR9170_LEDS=y
+endif #CONFIG_MAC80211_LEDS
 endif #CONFIG_COMPAT_KERNEL_28
 
 ifndef CONFIG_COMPAT_KERNEL_29
 CONFIG_CARL9170=m
+ifdef CONFIG_MAC80211_LEDS
 CONFIG_CARL9170_LEDS=y
+endif #CONFIG_MAC80211_LEDS
 # CONFIG_CARL9170_DEBUGFS=y
 # CONFIG_CARL9170_WPC=y
 endif #CONFIG_COMPAT_KERNEL_29
@@ -559,7 +571,9 @@ CONFIG_RT2X00_LIB_CRYPTO=y
 ifdef CONFIG_COMPAT_KERNEL_25
 CONFIG_RT2X00_LIB_LEDS=n
 else #CONFIG_COMPAT_KERNEL_25
+ifdef CONFIG_LEDS_CLASS
 CONFIG_RT2X00_LIB_LEDS=y
+endif #CONFIG_LEDS_CLASS
 endif #CONFIG_COMPAT_KERNEL_25
 # CONFIG_RT2X00_DEBUG=y
 # CONFIG_RT2X00_LIB_DEBUGFS
@@ -567,7 +581,9 @@ endif
 
 # p54
 CONFIG_P54_COMMON=m
+ifdef CONFIG_MAC80211_LEDS
 CONFIG_P54_LEDS=y
+endif #CONFIG_MAC80211_LEDS
 
 # Atheros
 CONFIG_ATH_COMMON=m
@@ -594,7 +610,9 @@ endif #CONFIG_COMPAT_KERNEL_27
 # In more recent kernel versions use the in kernel rfkill module.
 ifdef CONFIG_COMPAT_KERNEL_31
 CONFIG_RFKILL_BACKPORT=m
+ifdef CONFIG_LEDS_TRIGGERS
 CONFIG_RFKILL_BACKPORT_LEDS=y
+endif #CONFIG_LEDS_TRIGGERS
 CONFIG_RFKILL_BACKPORT_INPUT=y
 endif #CONFIG_COMPAT_KERNEL_31
 
-- 
1.7.1

