Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46106 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897AbZAROBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 09:01:06 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Luis Rodriguez <mcgrof@gmail.com>
Subject: [PATCH] crda: Throw verbose error message if M2Crypto is missing
Date: Sun, 18 Jan 2009 14:59:25 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200901181459.25771.mb@bu3sch.de> (sfid-20090118_150127_375163_5FE97310)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of throwing a cryptic Python backtrace, throw a better error message, if
the M2Crypto module is not installed.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

diff --git a/utils/key2pub.py b/utils/key2pub.py
index 47f50e3..f8918fc 100755
--- a/utils/key2pub.py
+++ b/utils/key2pub.py
@@ -1,7 +1,13 @@
 #!/usr/bin/env python
 
 import sys
-from M2Crypto import RSA
+try:
+	from M2Crypto import RSA
+except ImportError, e:
+	sys.stderr.write('ERROR: Failed to import the "M2Crypto" module: %s\n' % e.message)
+	sys.stderr.write('Please install the "M2Crypto" Python module.\n')
+	sys.stderr.write('On Debian GNU/Linux the package is called "python-m2crypto".\n')
+	sys.exit(1)
 
 def print_ssl(output, name, val):
     while val[0] == '\0':

-- 
Greetings, Michael.
