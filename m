Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56807.mail.re3.yahoo.com ([66.196.97.81]:33377 "HELO
	web56807.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934364Ab0EEJod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 05:44:33 -0400
Message-ID: <946956.98853.qm@web56807.mail.re3.yahoo.com>
Date: Wed, 5 May 2010 02:44:32 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH] compat-wireless: rt2x00 added to driver-select
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

With the ever expanding and improving rt2x00 supporting myriad of devices, I think its about time we enabled faster compilation via scripts/driver-select.

--- a/scripts/driver-select	2010-05-05 12:02:23.000000000 +0300
+++ b/scripts/driver-select	2010-05-05 12:02:01.000000000 +0300
@@ -7,6 +7,7 @@
 DRIVERS_MAKEFILE="drivers/net/wireless/Makefile"
 ATH_MAKEFILE="drivers/net/wireless/ath/Makefile"
 ATH9K_MAKEFILE="drivers/net/wireless/ath/ath9k/Makefile"
+RT2X00_MAKEFILE="drivers/net/wireless/rt2x00/Makefile"
 NET_WIRELESS_MAKEFILE="net/wireless/Makefile"
 EEPROM_MAKEFILE="drivers/misc/eeprom/Makefile"
 DRIVERS_NET="drivers/net/Makefile"
@@ -29,7 +30,7 @@ PURPLE="\033[35m"
 CYAN="\033[36m"
 UNDERLINE="\033[02m"
 
-SUPPORTED_DRIVERS="ath5k ath9k ath9k_htc ar9170 b43 zd1211rw"
+SUPPORTED_DRIVERS="ath5k ath9k ath9k_htc ar9170 b43 zd1211rw rt2x00"
 
 function usage {
 	echo -e "${GREEN}Usage${NORMAL}: ${CYAN}$0${NORMAL} [ ${PURPLE}<driver-name>${NORMAL} | ${PURPLE}<driver-group-name>${NORMAL} | ${GREEN}restore${NORMAL} ]"
@@ -293,6 +294,10 @@ case $1 in
 		disable_var_03
 		select_driver		CONFIG_B43
 		;;
+	rt2x00)
+		select_driver		CONFIG_RT2X00
+		disable_var_02
+		;;
 	*)
 		echo "Unsupported driver"
 		exit
 


      
