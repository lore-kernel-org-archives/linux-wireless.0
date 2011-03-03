Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42982 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687Ab1CCSsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:48:41 -0500
Received: by mail-ww0-f44.google.com with SMTP id 22so1737707wwb.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:48:40 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/19] rt2x00: Optimize TX descriptor memory layout
Date: Thu, 3 Mar 2011 19:42:58 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031942.02498.IvDoorn@gmail.com> <201103031942.36144.IvDoorn@gmail.com>
In-Reply-To: <201103031942.36144.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031942.58935.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some fields only need to be u8 and for ifs and txop we can use the
already available enums.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 3305520..3fa2406 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -315,17 +315,17 @@ struct txentry_desc {
 
 		struct {
 			u16 mcs;
-			u16 stbc;
-			u16 ba_size;
-			u16 mpdu_density;
-			short txop;
+			u8 stbc;
+			u8 ba_size;
+			u8 mpdu_density;
+			enum txop txop;
 		} ht;
 	} u;
 
 	u16 rate_mode;
 
 	short retry_limit;
-	short ifs;
+	enum ifs ifs;
 
 	enum cipher cipher;
 	u16 key_idx;
-- 
1.7.2.3

