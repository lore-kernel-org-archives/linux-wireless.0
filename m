Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45566 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab0JBJfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:30 -0400
Received: by mail-ww0-f44.google.com with SMTP id 40so2321956wwj.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:29 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/20] rt2x00: Add register definition for busy time on secondary channel
Date: Sat, 2 Oct 2010 11:30:42 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021130.00255.IvDoorn@gmail.com> <201010021130.20755.IvDoorn@gmail.com>
In-Reply-To: <201010021130.20755.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021130.43811.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Add the register definition CH_BUSY_STA_SEC for reading the busy time
on the secondary channel in HT40 mode. Also update the comments about
channel busy/idle time registers to express the used unit.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 9bf50a1..f02ea12 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -747,16 +747,21 @@
 #define INT_TIMER_EN_GP_TIMER		FIELD32(0x00000002)
 
 /*
- * CH_IDLE_STA: channel idle time
+ * CH_IDLE_STA: channel idle time (in us)
  */
 #define CH_IDLE_STA			0x1130
 
 /*
- * CH_BUSY_STA: channel busy time
+ * CH_BUSY_STA: channel busy time on primary channel (in us)
  */
 #define CH_BUSY_STA			0x1134
 
 /*
+ * CH_BUSY_STA_SEC: channel busy time on secondary channel in HT40 mode (in us)
+ */
+#define CH_BUSY_STA_SEC			0x1138
+
+/*
  * MAC_STATUS_CFG:
  * BBP_RF_BUSY: When set to 0, BBP and RF are stable.
  *	if 1 or higher one of the 2 registers is busy.
-- 
1.7.2.3

