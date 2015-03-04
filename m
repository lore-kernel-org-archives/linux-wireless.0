Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:39536 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147AbbCDTwA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 14:52:00 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 567C834079D
	for <linux-wireless@vger.kernel.org>; Wed,  4 Mar 2015 19:51:59 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH crda 3/4] fix openssl generation
Date: Wed,  4 Mar 2015 14:51:53 -0500
Message-Id: <1425498714-8654-3-git-send-email-vapier@gentoo.org> (sfid-20150304_205205_240814_2BB65EF7)
In-Reply-To: <1425498714-8654-1-git-send-email-vapier@gentoo.org>
References: <1425498714-8654-1-git-send-email-vapier@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mike Frysinger <vapier@chromium.org>

This file uses BN_ULONG but doesn't include the openssl headers leading
to build failures:
keys-ssl.c:2:8: error: unknown type name 'BN_ULONG'
 static BN_ULONG e_0[1] = {

The large unqualified constants also break building:
keys-ssl.c:8:2: warning: overflow in implicit constant conversion [-Woverflow]
  0x63a2705416a0d8e1, 0xdc9fca11c8ba757b,
  ^

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 utils/key2pub.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/utils/key2pub.py b/utils/key2pub.py
index 3e84cd2..c504aca 100755
--- a/utils/key2pub.py
+++ b/utils/key2pub.py
@@ -24,7 +24,7 @@ def print_ssl_64(output, name, val):
     for v1, v2, v3, v4, v5, v6, v7, v8 in vnew:
         if not idx:
             output.write('\t')
-        output.write('0x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x, ' % (ord(v1), ord(v2), ord(v3), ord(v4), ord(v5), ord(v6), ord(v7), ord(v8)))
+        output.write('0x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2xULL, ' % (ord(v1), ord(v2), ord(v3), ord(v4), ord(v5), ord(v6), ord(v7), ord(v8)))
         idx += 1
         if idx == 2:
             idx = 0
@@ -60,6 +60,7 @@ def print_ssl_32(output, name, val):
 def print_ssl(output, name, val):
     import struct
     output.write('#include <stdint.h>\n')
+    output.write('#include <openssl/bn.h>\n')
     if len(struct.pack('@L', 0)) == 8:
         return print_ssl_64(output, name, val)
     else:
-- 
2.3.1

