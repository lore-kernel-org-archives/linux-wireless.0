Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15865 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbZCFFSb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 00:18:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 21:18:30 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: sanity checks on freq range
Date: Thu, 5 Mar 2009 21:17:49 -0800
Message-ID: <1236316669-10093-1-git-send-email-lrodriguez@atheros.com> (sfid-20090306_061835_333429_518B9169)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do sanity checks on the frequency range before building upon it.
The kernel will reject these so we want to know if we goofed up
first.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

My python-fu sucks. But at least it bails out on errors.

 dbparse.py     |   13 +++++++++++++
 1 file changed, 13 insertions(+), 0 deletions(-)

diff --git a/dbparse.py b/dbparse.py
index 55615bd..dd64927 100755
--- a/dbparse.py
+++ b/dbparse.py
@@ -136,6 +136,19 @@ class DBParser(object):
             start, end = freqs.split('-')
             start = float(start)
             end = float(end)
+            # The kernel will reject these, so might as well reject this
+            # upon building it.
+            if start <= 0:
+            	self._syntax_error("Invalid start freq (%d)" % start)
+            if end <= 0:
+            	self._syntax_error("Invalid end freq (%d)" % end)
+            if start > end:
+            	self._syntax_error("Inverted freq range it seems (%d - %d)" % (start, end))
+            if end - start <= 0:
+            	self._syntax_error("Invalid bandwidth (%d)" % bw)
+            if end - start < bw:
+            	self._syntax_error("Invalid bandwidth: %d width channel "
+			"cannot possibly fit between %d - %d" % (bw, start, end))
         except ValueError:
             self._syntax_error("band must have frequency range")
 
