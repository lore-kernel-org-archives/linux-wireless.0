Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:39160 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933439Ab1J3QNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Oct 2011 12:13:16 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id B6BF6EBB9C
	for <linux-wireless@vger.kernel.org>; Sun, 30 Oct 2011 18:03:01 +0200 (EET)
Received: from [192.168.2.116] (91-157-44-203.elisa-laajakaista.fi [91.157.44.203])
	by emh05.mail.saunalahti.fi (Postfix) with ESMTP id 9EF2727D85
	for <linux-wireless@vger.kernel.org>; Sun, 30 Oct 2011 18:02:58 +0200 (EET)
Message-ID: <4EAD7532.7020908@kuutio.org> (sfid-20111030_171325_601511_8E30C2B0)
Date: Sun, 30 Oct 2011 18:02:58 +0200
From: Oskari Simola <osku@kuutio.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] compat-wireless build: build fix for renamed driver iwlagn
 -> iwlwifi
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here is patch for compat-wireless build script to build correctly after 
driver name change.

diff --git a/config.mk b/config.mk
index a71de4e..87bd16a 100644
--- a/config.mk
+++ b/config.mk
@@ -246,7 +246,7 @@ ifdef CONFIG_PCI
  CONFIG_ATH5K_PCI=y
  CONFIG_ATH9K_PCI=y

-CONFIG_IWLAGN=m
+CONFIG_IWLWIFI=m
  # CONFIG_IWLWIFI_DEBUG=y
  # CONFIG_IWLWIFI_DEBUGFS=y
  # CONFIG_IWLWIFI_DEVICE_TRACING=y
diff --git a/scripts/driver-select b/scripts/driver-select
index 3619541..e280b4c 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -53,7 +53,7 @@ function usage {
         echo -e "\t${CYAN}atheros${NORMAL} < ${PURPLE} ath5k ath9k 
carl9170 zd1211rw ath6kl ${NORMAL}>"
         echo -e "\t${CYAN}ath${NORMAL} < ${PURPLE} ath5k ath9k carl9170 
ath6kl ${NORMAL}>"
         echo -e "\t${CYAN}brcm80211${NORMAL} < ${PURPLE} brcmsmac 
brcmfmac ${NORMAL}>"
-       echo -e "\t${CYAN}iwlagn${NORMAL} < ${PURPLE} iwlagn ${NORMAL}>"
+       echo -e "\t${CYAN}iwlwifi${NORMAL} < ${PURPLE} iwlwifi ${NORMAL}>"
         echo -e "\t${CYAN}rtl818x${NORMAL} < ${PURPLE} rtl8180 rtl8187 
${NORMAL}>"
         echo -e "\t${CYAN}rtlwifi${NORMAL} < ${PURPLE} rtl8192ce 
${NORMAL}>"
         echo -e "\t${CYAN}wl12xx${NORMAL} < ${PURPLE} wl1251 wl12xx 
(SPI and SDIO)${NORMAL}>"
@@ -310,6 +310,7 @@ case $1 in
                 ;;
         intel)
                 select_drivers          CONFIG_COMPAT_IWLWIFI \
+                                        CONFIG_IWLWIFI \
                                         CONFIG_IPW
                 disable_staging
                 disable_var
@@ -317,8 +318,8 @@ case $1 in
                 disable_ethernet
                 disable_usbnet
                 ;;
-       iwlagn)
-               select_driver           CONFIG_IWLAGN
+       iwlwifi)
+               select_driver           CONFIG_IWLWIFI
                 disable_staging
                 disable_var_01
                 disable_bt



