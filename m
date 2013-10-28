Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:46573 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab3J1BxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Oct 2013 21:53:21 -0400
Received: by mail-wg0-f47.google.com with SMTP id c11so5998630wgh.14
        for <linux-wireless@vger.kernel.org>; Sun, 27 Oct 2013 18:53:20 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 5/6] crda: make ssl keys include stdint.h
Date: Mon, 28 Oct 2013 02:53:01 +0100
Message-Id: <1382925182-7393-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20131028_025324_100748_3D97ABE6)
In-Reply-To: <1382925182-7393-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382925182-7393-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is required to fix compilation if we
move reglig to its own library.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 utils/key2pub.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/utils/key2pub.py b/utils/key2pub.py
index 4d85369..3e84cd2 100755
--- a/utils/key2pub.py
+++ b/utils/key2pub.py
@@ -59,6 +59,7 @@ def print_ssl_32(output, name, val):
 
 def print_ssl(output, name, val):
     import struct
+    output.write('#include <stdint.h>\n')
     if len(struct.pack('@L', 0)) == 8:
         return print_ssl_64(output, name, val)
     else:
@@ -85,6 +86,7 @@ static struct pubkey keys[] = {
     pass
 
 def print_gcrypt(output, name, val):
+    output.write('#include <stdint.h>\n')
     while val[0] == '\0':
         val = val[1:]
     output.write('static const uint8_t %s[%d] = {\n' % (name, len(val)))
-- 
1.8.4.rc3

