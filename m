Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbXEKDBv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 23:01:51 -0400
Subject: [PATCH 14/19] libertas: remove SUPPORT_BOOT_COMMAND
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 23:05:22 -0400
Message-Id: <1178852722.8607.43.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the static definition of SUPPORT_BOOT_COMMAND.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Acked-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/Makefile |    3 +--
 drivers/net/wireless/libertas/if_usb.c |    2 --
 drivers/net/wireless/libertas/if_usb.h |    2 --
 3 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas/Makefile b/drivers/net/wireless/libertas/Makefile
index 19c9350..19e38d9 100644
--- a/drivers/net/wireless/libertas/Makefile
+++ b/drivers/net/wireless/libertas/Makefile
@@ -12,8 +12,7 @@ EXTRA_CFLAGS += -DDEBUG -DPROC_DEBUG
 endif
 
 
-# This is needed to support the newer boot2 bootloader (v >= 3104)
-EXTRA_CFLAGS += -DSUPPORT_BOOT_COMMAND
+#EXTRA_CFLAGS +=
 usb8xxx-objs += if_bootcmd.o
 usb8xxx-objs += if_usb.o
 
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 695fb6a..54853d8 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -775,7 +775,6 @@ restart:
 		return -1;
 	}
 
-#ifdef SUPPORT_BOOT_COMMAND
 	cardp->bootcmdresp = 0;
 	do {
 		int j = 0;
@@ -796,7 +795,6 @@ restart:
 		}
 		return -1;
 	}
-#endif
 
 	i = 0;
 	priv->adapter->fw_ready = 0;
diff --git a/drivers/net/wireless/libertas/if_usb.h b/drivers/net/wireless/libertas/if_usb.h
index 7851167..170dfe6 100644
--- a/drivers/net/wireless/libertas/if_usb.h
+++ b/drivers/net/wireless/libertas/if_usb.h
@@ -12,7 +12,6 @@
 #define USB8388_VID_2	0x05a3
 #define USB8388_PID_2	0x8388
 
-#ifdef SUPPORT_BOOT_COMMAND
 #define BOOT_CMD_FW_BY_USB     0x01
 #define BOOT_CMD_FW_IN_EEPROM  0x02
 #define BOOT_CMD_UPDATE_BOOT2  0x03
@@ -36,7 +35,6 @@ struct bootcmdrespStr
 	u8  u8result;
 	u8  au8dumy[2];
 };
-#endif /* SUPPORT_BOOT_COMMAND */
 
 /* read callback private data */
 struct read_cb_info {
-- 
1.5.0.6



