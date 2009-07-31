Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35227 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750863AbZGaXVe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 19:21:34 -0400
Message-ID: <4A737C7D.3070709@gmx.de>
Date: Sat, 01 Aug 2009 01:21:33 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Pavel Roskin <proski@gnu.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] compat-2.6:  Makefile: fixed test expressions for target
 install
References: <4A720FE4.4020301@gmx.de> <1248990136.10154.10.camel@mj>	 <4A733CDE.4060801@gmx.de> <1249066564.20276.3.camel@mj>
In-Reply-To: <1249066564.20276.3.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the two errors of [ with target "install"

[: 9: missing ]
[: 9: missing ]

and works with sh as well.

Signed-off-by: Joerg Albert <jal2@gmx.de>
---
  Makefile |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 62eb5db..e1ad666 100644
--- a/Makefile
+++ b/Makefile
@@ -80,7 +80,7 @@ install-scripts:
         @install scripts/athload        $(DESTDIR)/usr/sbin/
         @install scripts/b43load        $(DESTDIR)/usr/sbin/
         @install scripts/iwl-load       $(DESTDIR)/usr/sbin/
-       @if [ ! -z $(MADWIFI) && -z "$(DESTDIR)" ]; then \
+       @if [ ! -z "$(MADWIFI)" ] && [ -z "$(DESTDIR)" ]; then \
                 echo ;\
                 echo -n "Note: madwifi detected, we're going to disable it. "  ;\
                 echo "If you would like to enable it later you can run:"  ;\
@@ -89,7 +89,7 @@ install-scripts:
                 echo Running athenable ath5k...;\
                 /usr/sbin/athenable ath5k ;\
         fi
-       @if [ ! -z $(OLD_IWL) && -z "$(DESTDIR)" ]; then \
+       @if [ ! -z "$(OLD_IWL)" ] && [ -z "$(DESTDIR)" ]; then \
                 echo ;\
                 echo -n "Note: iwl4965 detected, we're going to disable it. "  ;\
                 echo "If you would like to enable it later you can run:"  ;\
-- 
1.6.0.4
