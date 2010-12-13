Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:47560 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab0LMLkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:35 -0500
Received: by mail-ew0-f45.google.com with SMTP id 10so3803451ewy.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:34 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/17] rt2x00: remove stray semicolon
Date: Mon, 13 Dec 2010 12:38:49 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131236.19791.IvDoorn@gmail.com> <201012131236.39071.IvDoorn@gmail.com>
In-Reply-To: <201012131236.39071.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131238.50510.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Stezenbach <js@sig21.net>

The stray semicolon after DEBUG_PRINTK_MSG causes things
like "if (...) WARNING(...); else {}" to fail with syntax error.

Signed-off-by: Johannes Stezenbach <js@sig21.net>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 556b744..5ea62554 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -66,7 +66,7 @@
 
 #ifdef CONFIG_RT2X00_DEBUG
 #define DEBUG_PRINTK(__dev, __kernlvl, __lvl, __msg, __args...)	\
-	DEBUG_PRINTK_MSG(__dev, __kernlvl, __lvl, __msg, ##__args);
+	DEBUG_PRINTK_MSG(__dev, __kernlvl, __lvl, __msg, ##__args)
 #else
 #define DEBUG_PRINTK(__dev, __kernlvl, __lvl, __msg, __args...)	\
 	do { } while (0)
-- 
1.7.2.3

