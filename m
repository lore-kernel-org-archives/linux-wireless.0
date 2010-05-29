Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55748 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab0E2NfS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 May 2010 09:35:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: use /etc/init.d/ and not sudo service
Date: Sat, 29 May 2010 15:35:06 +0200
Message-Id: <1275140107-4616-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1275140107-4616-1-git-send-email-hauke@hauke-m.de>
References: <1275140107-4616-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sudo is not installed and used on all distributions. the user should
call the script with the needed rights and the script should not
include sudo. This fails on debian lenny.

service is only available on very recent distributions and not on old
ons like debian lenny in the default configuration. Use the old init.d
script. This also works on ubuntu 10.04.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/btload.sh   |    4 ++--
 scripts/btunload.sh |    4 ++--
 scripts/load.sh     |    4 ++--
 scripts/unload.sh   |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/scripts/btload.sh b/scripts/btload.sh
index 50f37b6..e3f7cef 100755
--- a/scripts/btload.sh
+++ b/scripts/btload.sh
@@ -5,6 +5,6 @@ for i in $MODULES; do
 	modprobe $i
 done
 echo Starting bluetooth service..
-sudo service bluetooth start
-sudo service bluetooth status
+/etc/init.d/bluetooth start
+/etc/init.d/bluetooth status
 
diff --git a/scripts/btunload.sh b/scripts/btunload.sh
index c14f8c6..56046c2 100755
--- a/scripts/btunload.sh
+++ b/scripts/btunload.sh
@@ -1,8 +1,8 @@
 #!/bin/bash
 MODULES="hidp rfcomm bnep l2cap sco btusb bluetooth"
 echo Stoping bluetooth service..
-sudo service bluetooth stop
-sudo service bluetooth status
+/etc/init.d/bluetooth stop
+/etc/init.d/bluetooth status
 
 for i in $MODULES; do
 	grep ^$i /proc/modules 2>&1 > /dev/null
diff --git a/scripts/load.sh b/scripts/load.sh
index 9f82e2c..304798c 100755
--- a/scripts/load.sh
+++ b/scripts/load.sh
@@ -22,5 +22,5 @@ athload ath5k
 # For b43 we must make sure to unload bcm43xx first
 b43load b43
 echo Starting bluetooth service..
-sudo service bluetooth start
-sudo service bluetooth status
+/etc/init.d/bluetooth start
+/etc/init.d/bluetooth status
diff --git a/scripts/unload.sh b/scripts/unload.sh
index 0cd8a0a..12bb35c 100755
--- a/scripts/unload.sh
+++ b/scripts/unload.sh
@@ -31,8 +31,8 @@ MODULES="$MODULES mac80211 cfg80211 lib80211"
 MODULES="$MODULES hidp rfcomm bnep l2cap sco btusb bluetooth"
 MODULES="$MODULES compat"
 echo Stoping bluetooth service..
-sudo service bluetooth stop
-sudo service bluetooth status
+/etc/init.d/bluetooth stop
+/etc/init.d/bluetooth status
 MADWIFI_MODULES="ath_pci ath_rate_sample wlan_scan_sta wlan ath_hal"
 IPW3945D="/sbin/ipw3945d-`uname -r`"
 
-- 
1.7.0.4

