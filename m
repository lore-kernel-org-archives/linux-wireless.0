Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36151 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab1EJWD4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 18:03:56 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH v2 3/3] compat-wireless: enable RT33XX support.
Date: Wed, 11 May 2011 00:03:35 +0200
Message-Id: <1305065015-27078-1-git-send-email-hauke@hauke-m.de> (sfid-20110511_000402_390771_89490096)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is based on a patch by Walter Goldens.

RT2800PCI_RT35XX, RT2800PCI_RT53XX, RT2800USB_RT35XX and
RT2800USB_RT53XX are still experimental and deactivated because of that.

CC: Walter Goldens <goldenstranger@yahoo.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
v2: do not activate CONFIG_RT2800USB_RT53XX and CONFIG_RT2800PCI_RT53XX 
    by default as they are not stable.

 config.mk |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/config.mk b/config.mk
index 3411743..3c034c1 100644
--- a/config.mk
+++ b/config.mk
@@ -326,7 +326,7 @@ CONFIG_RT2400PCI=m
 CONFIG_RT2500PCI=m
 ifdef CONFIG_CRC_CCITT
 CONFIG_RT2800PCI=m
-# CONFIG_RT2800PCI_RT33XX=y
+CONFIG_RT2800PCI_RT33XX=y
 # CONFIG_RT2800PCI_RT35XX=y
 # CONFIG_RT2800PCI_RT53XX=y
 endif #CONFIG_CRC_CCITT
@@ -451,8 +451,9 @@ CONFIG_ATH9K_HTC=m
 CONFIG_RT2500USB=m
 ifdef CONFIG_CRC_CCITT
 CONFIG_RT2800USB=m
-# CONFIG_RT2800USB_RT33XX=y
+CONFIG_RT2800USB_RT33XX=y
 # CONFIG_RT2800USB_RT35XX=y
+# CONFIG_RT2800USB_RT53XX=y
 CONFIG_RT2800USB_UNKNOWN=y
 endif #CONFIG_CRC_CCITT
 CONFIG_RT2X00_LIB_USB=m
-- 
1.7.4.1

