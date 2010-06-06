Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63913 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab0FFSFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 14:05:00 -0400
Received: by vws5 with SMTP id 5so2301581vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jun 2010 11:04:59 -0700 (PDT)
Message-ID: <4C0BE34F.7060205@gmail.com>
Date: Sun, 06 Jun 2010 14:05:03 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: compat-wireless: Enabled rt2800pci support for new rt30xx and rt35xx
 chips
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit d9d9c3caaa370cca3594f7ebe530cdca9e35abc5
Author: Rick Farina <sidhayn@gmail.com>
Date:   Sun Jun 6 14:00:18 2010 -0400

    compat-wireless: Enabled rt2800pci support for new rt30xx and rt35xx 
chips
    
    The rt2800pci driver now supports the rt30xx and rt35xx series of 
chips from ralink, this change
    cause that support to be built into the driver.  This change has 
been compile tested but I do not
    own any of these devices.
    
    Note: I am purposely leaving the SoC support disabled as it doesn't 
build right now. Hopefully
    this will be fixed in a later rc and I'll submit the change then.
    
    Signed-off-by: Rick Farina

diff --git a/config.mk b/config.mk
index 0001a7d..169a99c 100644
--- a/config.mk
+++ b/config.mk
@@ -270,8 +270,8 @@ CONFIG_RT2500PCI=m
 ifneq ($(CONFIG_CRC_CCITT),)
 CONFIG_RT2800PCI=m
 CONFIG_RT2800PCI_PCI=y
-# CONFIG_RT2800PCI_RT30XX=y
-# CONFIG_RT2800PCI_RT35XX=y
+CONFIG_RT2800PCI_RT30XX=y
+CONFIG_RT2800PCI_RT35XX=y
 # CONFIG_RT2800PCI_SOC=y
 endif
 NEED_RT2X00=y

