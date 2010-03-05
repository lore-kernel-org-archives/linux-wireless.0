Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:41709 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab0CEQo0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 11:44:26 -0500
Received: by fxm19 with SMTP id 19so4325205fxm.21
        for <linux-wireless@vger.kernel.org>; Fri, 05 Mar 2010 08:44:25 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: remove KSEG1ADDR define from rt2x00soc.h
Date: Fri, 5 Mar 2010 17:44:22 +0100
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201003051744.22521.helmut.schaa@googlemail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the KSEG1ADDR define from rt2x00soc.h as it redefines and covers the
correct one from the arch/mips/include/asm/addrspace.h. Otherwise the driver
oopses on the target platform (Ralink rt3050 board).

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---

 drivers/net/wireless/rt2x00/rt2x00soc.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.h b/drivers/net/wireless/rt2x00/rt2x00soc.h
index 4739edf..474cbfc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00soc.h
+++ b/drivers/net/wireless/rt2x00/rt2x00soc.h
@@ -26,8 +26,6 @@
 #ifndef RT2X00SOC_H
 #define RT2X00SOC_H
 
-#define KSEG1ADDR(__ptr) __ptr
-
 /*
  * SoC driver handlers.
  */
-- 
1.6.0.2

