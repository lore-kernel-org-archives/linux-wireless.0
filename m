Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45433 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757682AbZAWXoB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 18:44:01 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 15:44:01 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: example debian packaging
Date: Fri, 23 Jan 2009 15:43:25 -0800
Message-ID: <1232754205-27297-1-git-send-email-lrodriguez@atheros.com> (sfid-20090124_004408_198140_FA2E1153)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dummy example packaging using of wireless-regdb using cdbs
to help distributions. This doesn't add the man page yet,
will add that if it gets merged.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 debian-example/changelog |    5 +++++
 debian-example/compat    |    1 +
 debian-example/control   |   15 +++++++++++++++
 debian-example/copyright |   21 +++++++++++++++++++++
 debian-example/docs      |    1 +
 debian-example/rules     |   10 ++++++++++
 6 files changed, 53 insertions(+), 0 deletions(-)
 create mode 100644 debian-example/changelog
 create mode 100644 debian-example/compat
 create mode 100644 debian-example/control
 create mode 100644 debian-example/copyright
 create mode 100644 debian-example/docs
 create mode 100755 debian-example/rules

diff --git a/debian-example/changelog b/debian-example/changelog
new file mode 100644
index 0000000..7bbce5c
--- /dev/null
+++ b/debian-example/changelog
@@ -0,0 +1,5 @@
+wireless-regdb (2009.01.15-1) unstable; urgency=low
+
+  * Initial release
+
+ -- Luis R. Rodriguez <mcgrof@gmail.com>  Thu, 22 Jan 2009 16:00:00 +0100
diff --git a/debian-example/compat b/debian-example/compat
new file mode 100644
index 0000000..7ed6ff8
--- /dev/null
+++ b/debian-example/compat
@@ -0,0 +1 @@
+5
diff --git a/debian-example/control b/debian-example/control
new file mode 100644
index 0000000..a5b518b
--- /dev/null
+++ b/debian-example/control
@@ -0,0 +1,15 @@
+Source: wireless-regdb
+Section: admin
+Priority: optional
+Maintainer: Luis R. Rodriguez <mcgrof@gmail.com>
+Build-Depends: cdbs, debhelper (>= 5), python
+Standards-Version: 3.7.3
+
+Package: wireless-regdb
+Architecture: all
+Depends:
+Suggests: crda
+Description: The Linux wireless regulatory database
+ This package contains the wireless regulatory database used by all
+ cfg80211 based Linux wireless drivers. The wireless database being
+ used is maintained by John Linville, the Linux wireless kernel maintainer.
diff --git a/debian-example/copyright b/debian-example/copyright
new file mode 100644
index 0000000..c01f1a0
--- /dev/null
+++ b/debian-example/copyright
@@ -0,0 +1,21 @@
+This package was debianized by Luis Rodriguez <mcgrof@gmail.com> on
+Thu, 22 Jan 2009 16:00:00 +0100.
+
+The wireless-regdb packages was downloaded from <http://wireless.kernel.org/download/wireless-regdb/>
+
+Copyright (c) 2008, Luis R. Rodriguez <mcgrof@gmail.com>
+Copyright (c) 2008, Johannes Berg <johannes@sipsolutions.net>
+Copyright (c) 2008, Michael Green <Michael.Green@Atheros.com>
+
+Permission to use, copy, modify, and/or distribute this software for any
+purpose with or without fee is hereby granted, provided that the above
+copyright notice and this permission notice appear in all copies.
+
+THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+
diff --git a/debian-example/docs b/debian-example/docs
new file mode 100644
index 0000000..e845566
--- /dev/null
+++ b/debian-example/docs
@@ -0,0 +1 @@
+README
diff --git a/debian-example/rules b/debian-example/rules
new file mode 100755
index 0000000..2b4137e
--- /dev/null
+++ b/debian-example/rules
@@ -0,0 +1,10 @@
+#!/usr/bin/make -f
+  
+include /usr/share/cdbs/1/rules/debhelper.mk
+
+PREFIX = /usr
+CDRA_LIB = $(PREFIX)/lib/crda
+
+install/wireless-regdb::
+	install -o 0 -g 0 -m 755 -d debian/$(cdbs_curpkg)/$(CDRA_LIB)
+	install -o 0 -g 0 -m 644 regulatory.bin debian/$(cdbs_curpkg)/$(CDRA_LIB)/regulatory.bin
-- 
1.6.1.rc3.51.g5832d

