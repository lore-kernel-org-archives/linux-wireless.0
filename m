Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42328 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757661AbZAWXQy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 18:16:54 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 15:16:54 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: add example spec file
Date: Fri, 23 Jan 2009 15:16:17 -0800
Message-ID: <1232752577-24011-1-git-send-email-lrodriguez@atheros.com> (sfid-20090124_001658_484065_531ED06B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a simple example spec file which can be used
by RPM distributions. Note that the man page isn't yet
installed as it has not yet been commited.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 wireless-regdb.spec |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 wireless-regdb.spec

diff --git a/wireless-regdb.spec b/wireless-regdb.spec
new file mode 100644
index 0000000..b76d391
--- /dev/null
+++ b/wireless-regdb.spec
@@ -0,0 +1,35 @@
+Summary: Linux wireless regulatory database
+Name: wireless-regdb
+Version: 2009.01.15
+Release: 1
+License: ISC
+Group: System Enviroment/Base
+Source: http://wireless.kernel.org/download/wireless-regdb/wireless-regdb-2009-01-15.tar.bz2
+URL: http://wireless.kernel.org/en/developers/Regulatory/
+Packager: Luis R. Rodriguez <mcgrof@gmail.com>
+BuildRoot : /var/tmp/%{name}-buildroot
+Requires: python
+BuildArch: noarch
+
+%define crda_lib /usr/lib/crda
+
+%description
+This package contains the wireless regulatory database used by all
+cfg80211 based Linux wireless drivers. The wireless database being
+used is maintained by John Linville, the Linux wireless kernel maintainer
+http://wireless.kernel.org/en/developers/Regulatory/
+
+%prep
+%setup -n %name-2009-01-15
+%build
+%install
+install -m 755 -d %buildroot/%crda_lib
+install -m 644 regulatory.bin %buildroot/%{crda_lib}/regulatory.bin
+%files
+%crda_lib/regulatory.bin
+%doc README LICENSE
+
+%changelog
+* Fri Jan 23 2009 - mcgrof@gmail.com
+- Started wireless-regdb package
+
-- 
1.6.1.rc3.51.g5832d

