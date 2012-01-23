Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47964 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab2AWQ7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 11:59:37 -0500
Received: by wgbed3 with SMTP id ed3so3015611wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jan 2012 08:59:36 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] compat-wireless: fix wl12xx driver-select
Date: Mon, 23 Jan 2012 19:02:34 +0200
Message-Id: <1327338154-3806-1-git-send-email-eliad@wizery.com> (sfid-20120123_175939_621377_FCCC8E97)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl12xx is a possible choice for both group drivers and
singular modules (making it impossible to build only
the wl12xx module). change the group name to "ti" instead.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 scripts/driver-select |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/driver-select b/scripts/driver-select
index f8ca02f..540d2fe 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -56,7 +56,7 @@ function usage {
 	echo -e "\t${CYAN}intel${NORMAL} < ${PURPLE} iwlwifi, iwlegacy ${NORMAL}>"
 	echo -e "\t${CYAN}rtl818x${NORMAL} < ${PURPLE} rtl8180 rtl8187 ${NORMAL}>"
 	echo -e "\t${CYAN}rtlwifi${NORMAL} < ${PURPLE} rtl8192ce ${NORMAL}>"
-	echo -e "\t${CYAN}wl12xx${NORMAL} < ${PURPLE} wl1251 wl12xx (SPI and SDIO)${NORMAL}>"
+	echo -e "\t${CYAN}ti${NORMAL} < ${PURPLE} wl1251 wl12xx (SPI and SDIO)${NORMAL}>"
 	
 	echo -e "\nSupported group drivers: Bluetooth & Ethernet:"
 	echo -e "\t${CYAN}atlxx${NORMAL} < ${PURPLE} atl1 atl2 atl1e atl1c ${NORMAL}>"
@@ -348,7 +348,7 @@ case $1 in
 		disable_bt_usb_ethernet_var
 		disable_lib80211
 		;;
-	wl12xx)
+	ti)
 		select_drivers		CONFIG_WL1251 \
 					CONFIG_WL12XX
 		disable_staging
-- 
1.7.6.401.g6a319

