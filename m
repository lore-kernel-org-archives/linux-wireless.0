Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42594 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab1KXTrp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 14:47:45 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: add config var for CORDIC and CRC8
Date: Thu, 24 Nov 2011 20:47:35 +0100
Message-Id: <1322164056-22118-1-git-send-email-hauke@hauke-m.de> (sfid-20111124_204748_366146_4233FAEB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes the kernel version compat-wireless is build against has
support for cordic and crc8 in its source, but these modules where not
build when the kernel was build, because no one selected them. They are
needed for the bcmsmac driver and they should be build every time when
there is not an kernel module already.

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

