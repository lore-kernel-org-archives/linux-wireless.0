Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33117 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab0IWART (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 20:17:19 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: jiajia.zheng@intel.com
Cc: linux-wireless@vger.kernel.org,
	wifi-test-devel@lists.sourceforge.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH] wifi-test: add simple roam test script
Date: Wed, 22 Sep 2010 20:17:17 -0400
Message-Id: <1285201037-29405-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a simple roam test script. It uses the supplicant
wpa_cli utility to interact with your existing session.
You can either use Network Manager and connect to an ESS
or use wpa_supplicant manually and connect to an ESS, in
both cases you need to hand pick an ESS by SSID and support
the control interface of the supplicant. The script will just
force a roam onto all the APs on the ESS in round robin,
sleeping 2 seconds between each roam. If you are not testing
signal drops you can use this to move around APs without
walking around a building.

Cc: Paul Stewart <pstew@google.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

The wifi-test.git tree is down right now.. so if you want to test
this you can download the script from:

http://bombadil.infradead.org/~mcgrof/test-roam

for now. This script let me find a bug, I'll post the oops
shortly.

 simple/test-roam |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100755 simple/test-roam

diff --git a/simple/test-roam b/simple/test-roam
new file mode 100755
index 0000000..9d1c0c4
--- /dev/null
+++ b/simple/test-roam
@@ -0,0 +1,66 @@
+#!/bin/bash
+# Copyright (c) 2010 Luis R. Rodriguez <mcgrof@gmail.com>
+#
+# Permission to use, copy, modify, and/or distribute this software for any
+# purpose with or without fee is hereby granted, provided that the above
+# copyright notice and this permission notice appear in all copies.
+#
+# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING O
+
+# Pretty colors
+GREEN="\033[01;32m"
+YELLOW="\033[01;33m"
+NORMAL="\033[00m"
+BLUE="\033[34m"
+RED="\033[31m"
+PURPLE="\033[35m"
+CYAN="\033[36m"
+
+if [ $# -ne 1 ]; then
+	echo -e "Usage: $0 <SSID>"
+	exit
+fi
+
+SSID="$1"
+
+# assumes you have a control interface exposed,
+# If you want to use this with network-manager ensure
+# you modify your dbus settings for wpa_supplicant. This is
+# documented here:
+#
+# http://wireless.kernel.org/en/users/Documentation/wpa_supplicant#Enabling_control_interface_and_nl80211_driver
+
+echo -e "${CYAN}Issuing first scan...${NORMAL}"
+
+# XXX: add 'iw event <event-type> -c 1' support
+sudo wpa_cli scan
+
+echo -e "${CYAN}Waiting for results...${NORMAL}"
+sleep 5
+
+echo -e "${CYAN}Collecting scan results...${NORMAL}"
+ESS=$(sudo wpa_cli scan_results| grep $SSID | awk '{print $1}')
+COUNT=$(echo $ESS | wc -w)
+
+echo -e "${RED}$COUNT ${NORMAL}APs found on ESS ${GREEN}$SSID${NORMAL}, going to roam between them now"
+echo -e "AP list:${NORMAL}"
+
+echo -e "\t${GREEN}BSS\t\t\t${YELLOW}Freq${NORMAL}"
+for i in $ESS; do
+	FREQ=$(sudo wpa_cli scan_results| grep $i | awk '{print $2}')
+	echo -e "\t${GREEN}$i\t${YELLOW}$FREQ"
+done
+
+while true; do
+	for i in $ESS; do
+		FREQ=$(sudo wpa_cli scan_results| grep $i | awk '{print $2}')
+		echo -e "${NORMAL}Roaming to ${CYAN}${SSID} ${GREEN}${i} ${YELLOW}${FREQ} ${NORMAL}MHz..."
+		sudo wpa_cli roam $i;
+		sleep 2;
+	done;
+done
-- 
1.7.0.4

