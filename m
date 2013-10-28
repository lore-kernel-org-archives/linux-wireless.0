Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47679 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab3J1Qmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 12:42:31 -0400
Received: by mail-wi0-f175.google.com with SMTP id hm4so4151566wib.14
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 09:42:30 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v2 5/6] crda: make ssl keys include stdint.h
Date: Mon, 28 Oct 2013 17:42:05 +0100
Message-Id: <1382978526-23929-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20131028_174236_702832_30A102E2)
In-Reply-To: <1382978526-23929-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382978526-23929-1-git-send-email-mcgrof@do-not-panic.com>
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

