Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56803.mail.re3.yahoo.com ([66.196.97.77]:24456 "HELO
	web56803.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752296Ab0JTPMD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 11:12:03 -0400
Message-ID: <575562.62119.qm@web56803.mail.re3.yahoo.com>
Date: Wed, 20 Oct 2010 08:12:00 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH 2/4] compat-wireless: enable bluetooth via driver-select
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- reshuffle driver-select, enable "bt" group for all bluetooth modules with driver-select

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -53,11 +53,6 @@ function usage {
         echo -e "\t${PURPLE}${i}${NORMAL}"
     done
 
-    echo -e "\nSupported Ethernet drivers: < ${PURPLE}atl1 atl2 atl1e atl1c${NORMAL} >"
-    for i in $SUPPORTED_ETH_DRIVERS; do
-        echo -e "\t${PURPLE}${i}${NORMAL}"
-    done
-
     # These should match the switch below.
     echo -e "\nSupported group drivers:"
     echo -e "\t${CYAN}atheros${NORMAL} < ${PURPLE} ath5k ath9k carl9170 zd1211rw ${NORMAL}>"
@@ -67,7 +62,9 @@ function usage {
     echo -e "\t${CYAN}rtl818x${NORMAL} < ${PURPLE} rtl8180 rtl8187 ${NORMAL}>"
     echo -e "\t${CYAN}wl12xx${NORMAL} < ${PURPLE} wl1251 wl1271 (SPI and SDIO)${NORMAL}>"
     
+    echo -e "\nSupported group drivers: Bluetooth & Ethernet:"
     echo -e "\t${BLUE}atlxx${NORMAL} < ${PURPLE} atl1 atl2 atl1e atl1c ${NORMAL}>"
+    echo -e "\t${BLUE}bt${NORMAL} < ${PURPLE} Linux bluetooth drivers ${NORMAL}>"
 
     echo -e "Restoring compat-wireless:"
     echo -e "\t${GREEN}restore${NORMAL}: you can use this option to restore compat-wireless to the original state"
@@ -390,7 +387,7 @@ case $1 in
         disable_staging
         disable_var_01
         ;;
-# Ethernet drivers
+# Ethernet and Bluetooth drivers
     atl1)
         enable_only_ethernet
         echo -e "obj-\$(CONFIG_ATL1) += atlx/" > $DRIVERS_NET
@@ -412,6 +409,13 @@ case $1 in
         enable_only_ethernet
         disable_b44
         ;;
+    bt)
+        select_driver         CONFIG_BT
+        disable_var
+        disable_ethernet
+        disable_staging
+        disable_80211
+        ;;
     *)
         echo "Unsupported driver"
         exit



      
