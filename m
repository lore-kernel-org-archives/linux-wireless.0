Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59651 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab2DSJZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 05:25:10 -0400
Received: by wgbdr13 with SMTP id dr13so8417888wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 02:25:09 -0700 (PDT)
From: Anisse Astier <anisse@astier.eu>
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Cc: linville@tuxdriver.com, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Anisse Astier <anisse@astier.eu>
Subject: [PATCH v2 1/2] rt2800: debugfs register access: BBP is 256 bytes big
Date: Thu, 19 Apr 2012 11:20:32 +0200
Message-Id: <1334827233-32686-1-git-send-email-anisse@astier.eu> (sfid-20120419_112524_229940_088CA862)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're already using BBP for values > 128. Make that explicit and allow
debugfs access.

Signed-off-by: Anisse Astier <anisse@astier.eu>
---
Changes since v1: none
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

