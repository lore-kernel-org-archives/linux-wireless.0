Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56807.mail.re3.yahoo.com ([66.196.97.81]:39760 "HELO
	web56807.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752525Ab0J1JMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 05:12:50 -0400
Message-ID: <879667.39110.qm@web56807.mail.re3.yahoo.com>
Date: Thu, 28 Oct 2010 02:12:48 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH 1/2] compat-wireless: disable update-initramfs except for b4xx/ssb
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, the only drivers requiring update of the initramfs image
are b43/legacy/b44/ssb, yet the process is in place for every other
driver, including driver-select entries. Disable update-initramfs
for all but b4xx/ssb.
 

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -169,6 +169,7 @@ function disable_bt_usb_ethernet_var {
 	disable_ethernet
 	disable_var_03
 	disable_bt
+	disable_update-initramfs
 } 
 
 function enable_only_ethernet {
@@ -187,6 +188,7 @@ function disable_var {
 	disable_ssb
 	disable_usbnet
 	disable_eeprom
+	disable_update-initramfs
 } 
 
 function disable_var_01 {
@@ -199,6 +201,7 @@ function disable_var_02 {
 	disable_lib80211
 	disable_ssb
 	disable_usbnet
+	disable_update-initramfs
 }
 
 function disable_staging {
@@ -216,6 +219,12 @@ function disable_brcm80211 {
 	perl -i -ne 'print if ! /brcm80211/ ' Makefile
 }
 
+function disable_update-initramfs
+{
+	backup_file Makefile
+	perl -i -ne 'print if ! /update-initramfs/' Makefile
+}
+
 function select_ath_driver 
 {
 	backup_file $ATH_MAKEFILE
@@ -408,6 +417,7 @@ case $1 in
 		select_drivers		CONFIG_ATL1 CONFIG_ATL2 CONFIG_ATL1E CONFIG_ATL1C
 		enable_only_ethernet
 		disable_b44
+		disable_update-initramfs
 		;;
 	bt)
 		select_driver 		CONFIG_BT



      
