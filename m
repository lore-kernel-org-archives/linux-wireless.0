Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54306 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2DRRMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 13:12:15 -0400
Received: by wibhj6 with SMTP id hj6so916809wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 10:12:14 -0700 (PDT)
From: Anisse Astier <anisse@astier.eu>
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Cc: linville@tuxdriver.com, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Anisse Astier <anisse@astier.eu>
Subject: [PATCH 1/2] rt2800: debugfs register access: BBP is 256 bytes big
Date: Wed, 18 Apr 2012 19:07:42 +0200
Message-Id: <1334768863-26839-1-git-send-email-anisse@astier.eu> (sfid-20120418_191220_865064_D5767BAE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're already using BBP for values > 128. Make that explicit and allow
debugfs access.

Signed-off-by: Anisse Astier <anisse@astier.eu>
---
 drivers/net/wireless/rt2x00/rt2800.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 1ce2634..d91f4f6 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -99,7 +99,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0110
 #define BBP_BASE			0x0000
-#define BBP_SIZE			0x0080
+#define BBP_SIZE			0x00ff
 #define RF_BASE				0x0004
 #define RF_SIZE				0x0010
 
-- 
1.7.9.4

