Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37044 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2KKPcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 10:32:12 -0500
Received: by mail-we0-f174.google.com with SMTP id t9so2447617wey.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 07:32:11 -0800 (PST)
Message-ID: <1352647925.6460.10.camel@canaries32-MCP7A> (sfid-20121111_163215_672515_298F089F)
Subject: [PATCH 05/14] staging: vt6656: 64 bit fixes: use u32 for QWORD
 definition.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Nov 2012 15:32:05 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Size of long issues replace with u32.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/ttype.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
index 8e9450e..0f70562c 100644
--- a/drivers/staging/vt6656/ttype.h
+++ b/drivers/staging/vt6656/ttype.h
@@ -29,6 +29,8 @@
 #ifndef __TTYPE_H__
 #define __TTYPE_H__
 
+#include <linux/types.h>
+
 /******* Common definitions and typedefs ***********************************/
 
 typedef int             BOOL;
@@ -51,8 +53,8 @@ typedef unsigned long   DWORD;          // 32-bit
 // which is NOT really a floating point number.
 typedef union tagUQuadWord {
     struct {
-        DWORD   dwLowDword;
-        DWORD   dwHighDword;
+	u32 dwLowDword;
+	u32 dwHighDword;
     } u;
     double      DoNotUseThisField;
 } UQuadWord;
-- 
1.8.0




