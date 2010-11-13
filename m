Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33747 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab0KMSOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 13:14:09 -0500
Received: by ewy8 with SMTP id 8so221913ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 10:14:07 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/9] rt2x00: Increase REGISTER_BUSY_COUNT
Date: Sat, 13 Nov 2010 19:08:14 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011131908.15595.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For some hardware the REGISTER_BUSY_COUNT isn't sufficient,
increase the REGISTER_BUSY_COUNT to 100 to catch most
devices which have more problems with accessing the registers.

For normal operating devices nothing would change as they will
exit the loop early anyway.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 42bd3a9..0a55eef 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -915,7 +915,7 @@ struct rt2x00_dev {
  * in those cases REGISTER_BUSY_COUNT attempts should be
  * taken with a REGISTER_BUSY_DELAY interval.
  */
-#define REGISTER_BUSY_COUNT	5
+#define REGISTER_BUSY_COUNT	100
 #define REGISTER_BUSY_DELAY	100
 
 /*
-- 
1.7.2.3

