Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38486 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab0ISRtw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Sep 2010 13:49:52 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] compat-wireless: fix unresolved symbols with old kernels
Date: Sun, 19 Sep 2010 19:49:13 +0200
Message-Id: <1284918553-32365-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1284918408-32242-1-git-send-email-hauke@hauke-m.de>
References: <1284918408-32242-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_WEXT_PRIV and CONFIG_WEXT_SPY were introduced with kernel 2.6.33
and are not available in older kernel versions. We should just depend on
them for recent kernel versions, but this feature is not implemented in
compat-wireless yet. If compat-wireless was commpield against kernel <
2.6.29 with e.g. CONFIG_IPW2200=m then libipw was not build in compat-
wireless but ipw2200 was build, because the config options set in the
kernel config were used. For now we build ipw2*00 every time
CONFIG_WIRELESS_EXT is enabled. This could cause some problems with
kernel > 2.6.32 and CONFIG_WEXT_PRIV=n but there are no such
distribution kernel available and we haven't got an bug report because
of this problem although is problem existed for a long time.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/config.mk b/config.mk
index 7f73744..de5766f 100644
--- a/config.mk
+++ b/config.mk
@@ -249,8 +249,6 @@ CONFIG_B43LEGACY_DMA=y
 CONFIG_B43LEGACY_PIO=y
 
 ifdef CONFIG_WIRELESS_EXT
-ifdef CONFIG_WEXT_SPY
-ifdef CONFIG_WEXT_PRIV
 # The Intel ipws
 CONFIG_LIBIPW=m
 # CONFIG_LIBIPW_DEBUG=y
@@ -276,8 +274,6 @@ CONFIG_IPW2200_QOS=y
 # it on via sysfs:
 #
 # % echo 1 > /sys/bus/pci/drivers/ipw2200/*/rtap_iface
-endif #CONFIG_WEXT_PRIV
-endif #CONFIG_WEXT_SPY
 endif #CONFIG_WIRELESS_EXT
 
 ifdef CONFIG_SSB
@@ -337,8 +333,6 @@ CONFIG_ATL1C=m
 endif #CONFIG_COMPAT_KERNEL_27
 
 ifdef CONFIG_WIRELESS_EXT
-ifdef CONFIG_WEXT_SPY
-ifdef CONFIG_WEXT_PRIV
 CONFIG_HERMES=m
 CONFIG_HERMES_CACHE_FW_ON_INIT=y
 ifdef CONFIG_PPC_PMAC
@@ -352,8 +346,6 @@ ifdef CONFIG_PCMCIA
 CONFIG_PCMCIA_HERMES=m
 CONFIG_PCMCIA_SPECTRUM=m
 endif #CONFIG_PCMCIA
-endif #CONFIG_WEXT_PRIV
-endif #CONFIG_WEXT_SPY
 endif #CONFIG_WIRELESS_EXT
 
 endif #CONFIG_PCI
-- 
1.7.0.4

