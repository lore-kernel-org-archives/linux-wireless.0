Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45028 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab0C1VQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 17:16:53 -0400
Received: by bwz1 with SMTP id 1so3124278bwz.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Mar 2010 14:16:52 -0700 (PDT)
Date: Mon, 29 Mar 2010 01:16:53 +0400
From: Paul Fertser <fercerpav@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] compat-wireless: driver-select: add b43 to the list
Message-ID: <20100328211653.GL6957@home.pavel.comp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---

It results in unneeded compilation of b43legacy and eeprom_93cx6 but it's
still much better than compiling the whole compat-wireless suit :)

Unfortunately, it still doesn't work with my lp-phy (4315) unless i load wl
first, but that's another story...

 scripts/driver-select |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/scripts/driver-select b/scripts/driver-select
index 68bb7ff..ebb2e86 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -29,7 +29,7 @@ PURPLE="\033[35m"
 CYAN="\033[36m"
 UNDERLINE="\033[02m"
 
-SUPPORTED_DRIVERS="ath5k ath9k ar9170 zd1211rw"
+SUPPORTED_DRIVERS="ath5k ath9k ar9170 zd1211rw b43"
 
 function usage {
 	echo -e "${GREEN}Usage${NORMAL}: ${CYAN}$0${NORMAL} [ ${PURPLE}<driver-name>${NORMAL} | ${PURPLE}<driver-group-name>${NORMAL} | ${GREEN}restore${NORMAL} ]"
@@ -287,6 +287,12 @@ case $1 in
 		select_driver		CONFIG_ZD1211RW
 		disable_var_01
 		;;
+	b43)
+		disable_usbnet
+		disable_ethernet
+		disable_var_03
+		select_driver		CONFIG_B43
+		;;
 	*)
 		echo "Unsupported driver"
 		exit
-- 
1.6.4.4

