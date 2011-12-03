Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50297 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab1LCOqw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Dec 2011 09:46:52 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/6] compat-wireless: add config var for CORDIC and CRC8
Date: Sat,  3 Dec 2011 15:46:20 +0100
Message-Id: <1322923585-13966-1-git-send-email-hauke@hauke-m.de> (sfid-20111203_154656_513527_C14D3776)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes the kernel version compat-wireless is build against has
support for cordic and crc8 in its source, but these modules were not
build when the kernel was build, because no one selected them. The modules are
needed for the bcmsmac driver and they should be build every time when
they were not already build while the kernel was build.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index 05edb79..5eabc51 100644
--- a/config.mk
+++ b/config.mk
@@ -657,6 +657,14 @@ endif #CONFIG_CRC7
 
 CONFIG_MWIFIEX=m
 
+ifndef CONFIG_CORDIC
+CONFIG_COMPAT_CORDIC=y
+endif #CONFIG_CORDIC
+
+ifndef CONFIG_CRC8
+CONFIG_COMPAT_CRC8=y
+endif #CONFIG_CRC8
+
 ifdef CONFIG_COMPAT_KERNEL_2_6_27
 CONFIG_LIBERTAS=n
 else #CONFIG_COMPAT_KERNEL_2_6_27
-- 
1.7.5.4

