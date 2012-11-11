Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59623 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab2KKPuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 10:50:07 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so2074358eaa.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 07:50:05 -0800 (PST)
Message-ID: <1352648999.6460.21.camel@canaries32-MCP7A> (sfid-20121111_165012_643660_C7424A99)
Subject: [PATCH 10/14] staging: vt6656: 64bit fixes: key.c/h change unsigned
 long to u32
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Nov 2012 15:49:59 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes long issues.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/key.c | 6 +++---
 drivers/staging/vt6656/key.h | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 617fda1..bf24adb 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -223,7 +223,7 @@ BOOL KeybSetKey(
     PSKeyManagement pTable,
     PBYTE           pbyBSSID,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -675,7 +675,7 @@ BOOL KeybSetDefaultKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -791,7 +791,7 @@ BOOL KeybSetAllGroupKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
diff --git a/drivers/staging/vt6656/key.h b/drivers/staging/vt6656/key.h
index f749c7a..bd35d39 100644
--- a/drivers/staging/vt6656/key.h
+++ b/drivers/staging/vt6656/key.h
@@ -58,7 +58,7 @@
 typedef struct tagSKeyItem
 {
     BOOL        bKeyValid;
-    unsigned long       uKeyLength;
+	u32 uKeyLength;
     BYTE        abyKey[MAX_KEY_LEN];
     QWORD       KeyRSC;
     DWORD       dwTSC47_16;
@@ -107,7 +107,7 @@ BOOL KeybSetKey(
     PSKeyManagement pTable,
     PBYTE           pbyBSSID,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -146,7 +146,7 @@ BOOL KeybSetDefaultKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -156,7 +156,7 @@ BOOL KeybSetAllGroupKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
-- 
1.8.0




