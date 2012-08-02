Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm9.access.bullet.mail.mud.yahoo.com ([66.94.237.210]:44258
	"HELO nm9.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751876Ab2HBFuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 01:50:37 -0400
Date: Wed, 1 Aug 2012 22:44:37 -0700
From: Steven Luo <steven@steven676.net>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: [PATCH 2/2] compat-wireless: driver-select: update after
 introduction of CONFIG_WL_TI
Message-ID: <decee2f9df27aefc9e57ac1a18855f874278ff53.1343885909.git.steven@steven676.net> (sfid-20120802_075116_153397_25539BA9)
References: <ab6d95605ad827f0c7f973d47656a897ffe17fb7.1343885909.git.steven@steven676.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ab6d95605ad827f0c7f973d47656a897ffe17fb7.1343885909.git.steven@steven676.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The introduction of CONFIG_WL_TI broke selecting the TI drivers using
driver-select.  Fix this, and while we're at it, teach the script about
wl18xx as well.

Signed-off-by: Steven Luo <steven@steven676.net>
---
 scripts/driver-select |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/scripts/driver-select b/scripts/driver-select
index 48a43b7..03dd9d0 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -10,6 +10,7 @@ ATH_MAKEFILE="drivers/net/wireless/ath/Makefile"
 ATH9K_MAKEFILE="drivers/net/wireless/ath/ath9k/Makefile"
 BRCM80211_MAKEFILE="drivers/net/wireless/brcm80211/Makefile"
 RT2X00_MAKEFILE="drivers/net/wireless/rt2x00/Makefile"
+TI_MAKEFILE="drivers/net/wireless/ti/Makefile"
 NET_WIRELESS_MAKEFILE="net/wireless/Makefile"
 EEPROM_MAKEFILE="drivers/misc/eeprom/Makefile"
 DRIVERS_NET_ATHEROS="drivers/net/ethernet/atheros/Makefile"
@@ -252,6 +253,12 @@ function select_ath9k_driver_ap
 	perl -i -ne 'print if ! /CONFIG_COMPAT_ATH9K_RATE_CONTROL/ ' $COMPAT_CONFIG_CW
 }
 
+function select_ti_drivers
+{
+	select_drivers CONFIG_WL_TI
+	select_drivers_from_makefile $TI_MAKEFILE $@
+}
+
 function select_brcm80211_driver 
 {
 	backup_file $BRCM80211_MAKEFILE
@@ -364,8 +371,7 @@ case $1 in
 		disable_lib80211
 		;;
 	ti)
-		select_drivers		CONFIG_WL1251 \
-					CONFIG_WL12XX
+		select_drivers		CONFIG_WL_TI
 		disable_staging
 		disable_var_01
 		;;
@@ -451,12 +457,17 @@ case $1 in
 		disable_var_02
 		;;
 	wl1251)
-		select_drivers		CONFIG_WL1251
+		select_ti_drivers	CONFIG_WL1251
 		disable_staging
 		disable_var_01
 		;;
 	wl12xx)
-		select_drivers		CONFIG_WL12XX
+		select_ti_drivers	CONFIG_WL12XX
+		disable_staging
+		disable_var_01
+		;;
+	wl18xx)
+		select_ti_drivers	CONFIG_WL18XX
 		disable_staging
 		disable_var_01
 		;;
-- 
1.7.2.5

