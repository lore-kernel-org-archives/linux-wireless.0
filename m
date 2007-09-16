Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbXIPMIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:24 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:23 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/24] rt2x00: Fix DEV_RATEBIT_ definitions
Date: Sun, 16 Sep 2007 14:19:08 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161419.10297.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The DEV_RATEBIT_ were all shifted 1 bit too much,
this caused the RATEMASK to overflow.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00reg.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 5e7b63e..7927d5f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -231,18 +231,18 @@ static inline u8 rt2x00_get_field8(const u8 reg,
 /*
  * Bitfields
  */
-#define DEV_RATEBIT_1MB		( 1 << 1 )
-#define DEV_RATEBIT_2MB		( 1 << 2 )
-#define DEV_RATEBIT_5_5MB	( 1 << 3 )
-#define DEV_RATEBIT_11MB	( 1 << 4 )
-#define DEV_RATEBIT_6MB		( 1 << 5 )
-#define DEV_RATEBIT_9MB		( 1 << 6 )
-#define DEV_RATEBIT_12MB	( 1 << 7 )
-#define DEV_RATEBIT_18MB	( 1 << 8 )
-#define DEV_RATEBIT_24MB	( 1 << 9 )
-#define DEV_RATEBIT_36MB	( 1 << 10 )
-#define DEV_RATEBIT_48MB	( 1 << 11 )
-#define DEV_RATEBIT_54MB	( 1 << 12 )
+#define DEV_RATEBIT_1MB		( 1 << 0 )
+#define DEV_RATEBIT_2MB		( 1 << 1 )
+#define DEV_RATEBIT_5_5MB	( 1 << 2 )
+#define DEV_RATEBIT_11MB	( 1 << 3 )
+#define DEV_RATEBIT_6MB		( 1 << 4 )
+#define DEV_RATEBIT_9MB		( 1 << 5 )
+#define DEV_RATEBIT_12MB	( 1 << 6 )
+#define DEV_RATEBIT_18MB	( 1 << 7 )
+#define DEV_RATEBIT_24MB	( 1 << 8 )
+#define DEV_RATEBIT_36MB	( 1 << 9 )
+#define DEV_RATEBIT_48MB	( 1 << 10 )
+#define DEV_RATEBIT_54MB	( 1 << 11 )
 
 /*
  * Bitmasks for DEV_RATEMASK
-- 
1.5.3
