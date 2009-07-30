Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36179 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752886AbZG3VZ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 17:25:58 -0400
Message-ID: <4A720FE4.4020301@gmx.de>
Date: Thu, 30 Jul 2009 23:25:56 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] compat-2.6:  Makefile: fixed test expressions for target
 install
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the two errors of [ with target "install"

make[1]: Leaving directory `/home/joerg/src/linux-2.6.30'
[: 9: missing ]
[: 9: missing ]
depmod will prefer updates/ over kernel/ -- OK!


Signed-off-by: Joerg Albert <jal2@gmx.de>
---
  Makefile |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 62eb5db..90279c9 100644
--- a/Makefile
+++ b/Makefile
@@ -80,7 +80,7 @@ install-scripts:
         @install scripts/athload        $(DESTDIR)/usr/sbin/
         @install scripts/b43load        $(DESTDIR)/usr/sbin/
         @install scripts/iwl-load       $(DESTDIR)/usr/sbin/
-       @if [ ! -z $(MADWIFI) && -z "$(DESTDIR)" ]; then \
+       @if [ ! -z "$(MADWIFI)" -a -z "$(DESTDIR)" ]; then \
                 echo ;\
                 echo -n "Note: madwifi detected, we're going to disable it. "  ;\
                 echo "If you would like to enable it later you can run:"  ;\
@@ -89,7 +89,7 @@ install-scripts:
                 echo Running athenable ath5k...;\
                 /usr/sbin/athenable ath5k ;\
         fi
-       @if [ ! -z $(OLD_IWL) && -z "$(DESTDIR)" ]; then \
+       @if [ ! -z "$(OLD_IWL)" -a -z "$(DESTDIR)" ]; then \
                 echo ;\
                 echo -n "Note: iwl4965 detected, we're going to disable it. "  ;\
                 echo "If you would like to enable it later you can run:"  ;\
-- 
1.6.0.4
