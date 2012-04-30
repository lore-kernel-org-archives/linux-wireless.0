Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37085 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab2D3Qii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 12:38:38 -0400
Received: by wejx9 with SMTP id x9so1914879wej.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2012 09:38:37 -0700 (PDT)
From: Anisse Astier <anisse@astier.eu>
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Cc: Ivo van Doorn <IvDoorn@gmail.com>, linville@tuxdriver.com,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Anisse Astier <anisse@astier.eu>
Subject: [PATCH v5 1/3] rt2800: debugfs register access: BBP is 256 bytes big
Date: Mon, 30 Apr 2012 18:33:31 +0200
Message-Id: <1335803613-1253-2-git-send-email-anisse@astier.eu> (sfid-20120430_183851_701663_2F0BB6BF)
In-Reply-To: <1335803613-1253-1-git-send-email-anisse@astier.eu>
References: <1335803613-1253-1-git-send-email-anisse@astier.eu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're already using BBP for values > 128. Make that explicit and allow
debugfs access.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
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

