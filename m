Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm3-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.154]:40329 "HELO
	nm3-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752672Ab1D0JB7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 05:01:59 -0400
Message-ID: <140850.94569.qm@web161612.mail.bf1.yahoo.com> (sfid-20110427_110202_691098_5F5F4CE0)
Date: Wed, 27 Apr 2011 02:01:58 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Reply-To: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH 2/2 re-send] compat-wireless: add rtl8192c/u to driver-select
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Add rtl8192c & rtl8192cu to rtlwifi/driver-selct 

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -59,7 +59,7 @@ function usage {
     echo -e "\t${CYAN}ath${NORMAL} < ${PURPLE} ath5k ath9k carl9170 ${NORMAL}>"
     echo -e "\t${CYAN}iwlagn${NORMAL} < ${PURPLE} iwlagn ${NORMAL}>"
     echo -e "\t${CYAN}rtl818x${NORMAL} < ${PURPLE} rtl8180 rtl8187 ${NORMAL}>"
-    echo -e "\t${CYAN}rtlwifi${NORMAL} < ${PURPLE} rtl8192ce ${NORMAL}>"
+    echo -e "\t${CYAN}rtlwifi${NORMAL} < ${PURPLE} rtl8192c rtl8192ce rtl8192cu ${NORMAL}>"
     echo -e "\t${CYAN}wl12xx${NORMAL} < ${PURPLE} wl1251 wl12xx (SPI and SDIO)${NORMAL}>"
     
     echo -e "\nSupported group drivers: Bluetooth & Ethernet:"
@@ -327,7 +327,8 @@ case $1 in
         disable_var_02
         ;;
     rtlwifi)
-        select_drivers        CONFIG_RTL8192CE CONFIG_RTLWIFI
+        select_drivers        CONFIG_RTL8192CE CONFIG_RTLWIFI \
+                    CONFIG_RTL8192C CONFIG_RTL8192CU
         disable_staging
         disable_bt_usb_ethernet_var
         ;;

