Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49257 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924Ab1FURng (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 13:43:36 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: add CONFIG_B43_SSB and other b43 options.
Date: Tue, 21 Jun 2011 19:43:25 +0200
Message-Id: <1308678206-12934-1-git-send-email-hauke@hauke-m.de> (sfid-20110621_194339_566964_93918320)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_B43_SSB is now needed to compile b43 with ssb support. The other
options are deactivated as the features they should activate are not
working for now.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index 0692c6e..4e5e08c 100644
--- a/config.mk
+++ b/config.mk
@@ -270,6 +270,7 @@ CONFIG_B43_LEDS=y
 endif #CONFIG_MAC80211_LEDS
 CONFIG_B43_PHY_LP=y
 CONFIG_B43_PHY_N=y
+# CONFIG_B43_PHY_HT=y
 # CONFIG_B43_FORCE_PIO=y
 # CONFIG_B43_DEBUG=y
 
@@ -323,12 +324,14 @@ CONFIG_SSB_PCMCIAHOST=y
 endif #CONFIG_PCMCIA
 # CONFIG_SSB_DEBUG=y
 CONFIG_SSB_DRIVER_PCICORE=y
+CONFIG_B43_SSB=y
 endif #CONFIG_SSB
 
 CONFIG_BCMA=m
 CONFIG_BCMA_BLOCKIO=y
 CONFIG_BCMA_HOST_PCI=y
 # CONFIG_BCMA_DEBUG=y
+# CONFIG_B43_BCMA=y
 
 CONFIG_P54_PCI=m
 
-- 
1.7.4.1

