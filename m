Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46427 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab0FJRwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 13:52:50 -0400
Received: by gye5 with SMTP id 5so147831gye.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jun 2010 10:52:48 -0700 (PDT)
Message-ID: <4C112661.9060909@gmail.com>
Date: Thu, 10 Jun 2010 13:52:33 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: compat-wireless: Enabled RT3[05]xx support in rt2800pci driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 3e5212c1d07909478c38c6b606ccc9d88b2a7297
Author: Rick Farina <sidhayn@gmail.com>
Date:   Thu Jun 10 13:46:33 2010 -0400

 
    Enable CONFIG_RT2800PCI_RT30XX and CONFIG_RT2800PCI_RT35XX. This 
change has been
    compile tested only as I do not personally own this hardware.
    
    Added additional note about requirements to safely enable 
CONFIG_RT2800PCI_SOC.
    
    Signed-off-by: Rick Farina

diff --git a/config.mk b/config.mk
index 0001a7d..42ca58e 100644
--- a/config.mk
+++ b/config.mk
@@ -270,8 +270,11 @@ CONFIG_RT2500PCI=m
 ifneq ($(CONFIG_CRC_CCITT),)
 CONFIG_RT2800PCI=m
 CONFIG_RT2800PCI_PCI=y
-# CONFIG_RT2800PCI_RT30XX=y
-# CONFIG_RT2800PCI_RT35XX=y
+CONFIG_RT2800PCI_RT30XX=y
+CONFIG_RT2800PCI_RT35XX=y
+# XXX: This config param needs to be activated only if
+# RALINK_RT288X || RALINK_RT305X but the Makefile doesn't
+# support this yet.
 # CONFIG_RT2800PCI_SOC=y
 endif
 NEED_RT2X00=y

