Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15665 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbZI2Bfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 21:35:53 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 18:35:57 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	Greg KH <greg@kroah.com>, Andrey Yurovsky <andrey@cozybit.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC v2] compat-2.6: mangle drivers and symbols for driver-select
Date: Mon, 28 Sep 2009 18:35:55 -0700
Message-ID: <1254188155-6270-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When building only one driver with driver-select you will have bust
other present wireless drivers since they still rely on the old
mac80211 and cfg80211 modules. This is a non-issue unless you are
a distribution maintainer and do not want to build all modules
provided by compat-wireless. If you are an OEM you may also want
to just provide a one-driver solution for your own device without
affecting other drivers present.

When driver-select is used add a CONFIG_COMPAT_WIRELESS_MANGLE
so that mangled symbols are enabled and all cfg80211 and mac80211
driver symbols get mangled with a backport_ prefix.

Each driver family which has their own set of modules will also
need to define their own set of mangle definitions. This can be
done on compat/compat.h

The last step required to make this work is to rename the built
modules your driver will depend on. So mac80211 will become
backport_mac80211 and cfg80211 backport_cfg80211. As with
symbols driver families may also need to deal with this.
For example ath9k will require ath to be renamed to backport_ath.

Usbnet is a different story -- for that I think the best thing
is to just backport these modules. You will run into issues
with usbnet only if compiling all modules and it will only
become an issue with users of non backported usbnet modules.
If we backport all usbnet modules this is a non-issue.

Cc: John W. Linville <linville@tuxdriver.com>
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: Greg KH <greg@kroah.com>
Cc: Andrey Yurovsky <andrey@cozybit.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This one compiles for me and build a backport_mac80211,
backport_cfg80211, and even backport_ath, however I end up wit this
warning:

WARNING: at /build/buildd/linux-2.6.31/fs/sysfs/dir.c:487 sysfs_add_one+0xc5/0x130()
Hardware name: 7660A14
sysfs: cannot create duplicate filename '/class/ieee80211'
Modules linked in: backport_cfg80211(+) <etc>
Pid: 5604, comm: modprobe Tainted: G        WC 2.6.31-10-generic #34-Ubuntu
Call Trace:
 [<ffffffff81059778>] warn_slowpath_common+0x78/0xb0
 [<ffffffff8105980c>] warn_slowpath_fmt+0x3c/0x40
 [<ffffffff81181845>] sysfs_add_one+0xc5/0x130
 [<ffffffff81181913>] create_dir+0x63/0xb0
 [<ffffffff81181994>] sysfs_create_dir+0x34/0x50
 [<ffffffff8126f46a>] ? kobject_get+0x1a/0x30
 [<ffffffff8126f5c7>] kobject_add_internal+0xb7/0x200
 [<ffffffff8126f73f>] kset_register+0x2f/0x60
 [<ffffffff8131c9a8>] __class_register+0xf8/0x220
 [<ffffffffa0024000>] ? cfg80211_init+0x0/0x92 [backport_cfg80211]
 [<ffffffffa0265837>] wiphy_sysfs_init+0x17/0x20 [backport_cfg80211]
 [<ffffffffa0024020>] cfg80211_init+0x20/0x92 [backport_cfg80211]
 [<ffffffff8100a047>] do_one_initcall+0x37/0x1a0
 [<ffffffff8108cbc7>] sys_init_module+0xd7/0x230
 [<ffffffff81011fc2>] system_call_fastpath+0x16/0x1b
---[ end trace d8ca39e614c01267 ]---
kobject_add_internal failed for ieee80211 with -EEXIST, don't try to register things with the same name in the same directory.

Do we want to live with a new /class/backport_ieee80211/ ?
I'm not sure what the downside to this, someone more familiar with
this please let me know.

 compat/compat.h                |  161 ++++++++++++++++++++++++++++++++++++++++
 config.mk                      |    2 +
 scripts/admin-update.sh        |    2 +-
 scripts/driver-select          |   36 +++++++++-
 scripts/gen-compat-autoconf.sh |   10 ++-
 5 files changed, 206 insertions(+), 5 deletions(-)

diff --git a/compat/compat.h b/compat/compat.h
index 05612b2..24c3f31 100644
--- a/compat/compat.h
+++ b/compat/compat.h
@@ -22,4 +22,165 @@
 #include <net/compat-2.6.31.h>
 #include <net/compat-2.6.32.h>
 
+#ifdef CONFIG_COMPAT_WIRELESS_MANGLE
+
+/*
+ * When we use driver-select you are building one driver so all your
+ * other drivers present in your existing kernel can go bust since they
+ * rely on older versions of mac80211 and cfg80211. Because of this we
+ * mangle your symbols so that your new single compat-wireless driver
+ * only relies on the new mac80211 and cfg80211 backported modules.
+ */
+
+/* cfg80211 */
+#define wiphy_new					backport_wiphy_new
+#define wiphy_register					backport_wiphy_register
+#define wiphy_rfkill_start_polling			backport_wiphy_rfkill_start_polling
+#define wiphy_rfkill_stop_polling			backport_wiphy_rfkill_stop_polling
+#define wiphy_unregister				backport_wiphy_unregister
+#define wiphy_free					backport_wiphy_free
+#define wiphy_rfkill_set_hw_state			backport_wiphy_rfkill_set_hw_state
+#define cfg80211_ibss_joined				backport_cfg80211_ibss_joined
+#define print_ssid					backport_print_ssid
+#define lib80211_crypt_info_init			backport_lib80211_crypt_info_init
+#define lib80211_crypt_info_free			backport_lib80211_crypt_info_free
+#define lib80211_crypt_deinit_entries			backport_lib80211_crypt_deinit_entries
+#define lib80211_crypt_quiescing			backport_lib80211_crypt_quiescing
+#define lib80211_crypt_deinit_handler			backport_lib80211_crypt_deinit_handler
+#define lib80211_crypt_delayed_deinit			backport_lib80211_crypt_delayed_deinit
+#define lib80211_register_crypto_ops			backport_lib80211_register_crypto_ops
+#define lib80211_unregister_crypto_ops			backport_lib80211_unregister_crypto_ops
+#define lib80211_get_crypto_ops				backport_lib80211_get_crypto_ops
+#define cfg80211_send_rx_auth				backport_cfg80211_send_rx_auth
+#define cfg80211_send_rx_assoc				backport_cfg80211_send_rx_assoc
+#define cfg80211_send_deauth				backport_cfg80211_send_deauth
+#define cfg80211_send_disassoc				backport_cfg80211_send_disassoc
+#define cfg80211_send_auth_timeout			backport_cfg80211_send_auth_timeout
+#define cfg80211_send_assoc_timeout			backport_cfg80211_send_assoc_timeout
+#define cfg80211_michael_mic_failure			backport_cfg80211_michael_mic_failure
+#define cfg80211_testmode_alloc_reply_skb		backport_cfg80211_testmode_alloc_reply_skb
+#define cfg80211_testmode_reply				backport_cfg80211_testmode_reply
+#define cfg80211_testmode_alloc_event_skb		backport_cfg80211_testmode_alloc_event_skb
+#define cfg80211_testmode_event				backport_cfg80211_testmode_event
+#define ieee80211_radiotap_iterator_init		backport_ieee80211_radiotap_iterator_init
+#define ieee80211_radiotap_iterator_next		backport_ieee80211_radiotap_iterator_next
+#define freq_reg_info					backport_freq_reg_info
+#define wiphy_apply_custom_regulatory			backport_wiphy_apply_custom_regulatory
+#define regulatory_hint					backport_regulatory_hint
+#define cfg80211_scan_done				backport_cfg80211_scan_done
+#define cfg80211_get_bss				backport_cfg80211_get_bss
+#define cfg80211_get_mesh				backport_cfg80211_get_mesh
+#define cfg80211_inform_bss				backport_cfg80211_inform_bss
+#define cfg80211_inform_bss_frame			backport_cfg80211_inform_bss_frame
+#define cfg80211_put_bss				backport_cfg80211_put_bss
+#define cfg80211_unlink_bss				backport_cfg80211_unlink_bss
+#define cfg80211_wext_siwscan				backport_cfg80211_wext_siwscan
+#define cfg80211_wext_giwscan				backport_cfg80211_wext_giwscan
+#define cfg80211_connect_result				backport_cfg80211_connect_result
+#define cfg80211_roamed					backport_cfg80211_roamed
+#define cfg80211_disconnected				backport_cfg80211_disconnected
+#define ieee80211_get_response_rate			backport_ieee80211_get_response_rate
+#define ieee80211_channel_to_frequency			backport_ieee80211_channel_to_frequency
+#define ieee80211_frequency_to_channel			backport_ieee80211_frequency_to_channel
+#define __ieee80211_get_channel				backport___ieee80211_get_channel
+#define rfc1042_header					backport_rfc1042_header
+#define bridge_tunnel_header				backport_bridge_tunnel_header
+#define ieee80211_hdrlen				backport_ieee80211_hdrlen
+#define ieee80211_get_hdrlen_from_skb			backport_ieee80211_get_hdrlen_from_skb
+#define ieee80211_data_to_8023				backport_ieee80211_data_to_8023
+#define ieee80211_data_from_8023			backport_ieee80211_data_from_8023
+#define cfg80211_classify8021d				backport_cfg80211_classify8021d
+#define ieee80211_bss_get_ie				backport_ieee80211_bss_get_ie
+
+/*
+ * Your kernel's wext stuff is left intact as its built-in so we do not provide 
+ * defines for that here.
+ */
+
+#define cfg80211_wext_giwname				backport_cfg80211_wext_giwname
+#define cfg80211_wext_siwmode				backport_cfg80211_wext_siwmode
+#define cfg80211_wext_giwmode				backport_cfg80211_wext_giwmode
+#define cfg80211_wext_giwrange				backport_cfg80211_wext_giwrange
+#define cfg80211_wext_siwrts				backport_cfg80211_wext_siwrts
+#define cfg80211_wext_giwrts				backport_cfg80211_wext_giwrts
+#define cfg80211_wext_siwfrag				backport_cfg80211_wext_siwfrag
+#define cfg80211_wext_giwfrag				backport_cfg80211_wext_giwfrag
+#define cfg80211_wext_siwretry				backport_cfg80211_wext_siwretry
+#define cfg80211_wext_giwretry				backport_cfg80211_wext_giwretry
+#define cfg80211_wext_siwencode				backport_cfg80211_wext_siwencode
+#define cfg80211_wext_siwencodeext			backport_cfg80211_wext_siwencodeext
+#define cfg80211_wext_giwencode				backport_cfg80211_wext_giwencode
+#define cfg80211_wext_siwfreq				backport_cfg80211_wext_siwfreq
+#define cfg80211_wext_giwfreq				backport_cfg80211_wext_giwfreq
+#define cfg80211_wext_siwtxpower			backport_cfg80211_wext_siwtxpower
+#define cfg80211_wext_giwtxpower			backport_cfg80211_wext_giwtxpower
+#define cfg80211_wext_siwauth				backport_cfg80211_wext_siwauth
+#define cfg80211_wext_giwauth				backport_cfg80211_wext_giwauth
+#define cfg80211_wext_siwpower				backport_cfg80211_wext_siwpower
+#define cfg80211_wext_giwpower				backport_cfg80211_wext_giwpower
+#define cfg80211_wext_siwrate				backport_cfg80211_wext_siwrate
+#define cfg80211_wext_giwrate				backport_cfg80211_wext_giwrate
+#define cfg80211_wireless_stats				backport_cfg80211_wireless_stats
+#define cfg80211_wext_siwap				backport_cfg80211_wext_siwap
+#define cfg80211_wext_giwap				backport_cfg80211_wext_giwap
+#define cfg80211_wext_siwessid				backport_cfg80211_wext_siwessid
+#define cfg80211_wext_giwessid				backport_cfg80211_wext_giwessid
+#define cfg80211_wext_siwgenie				backport_cfg80211_wext_siwgenie
+#define cfg80211_wext_siwmlme				backport_cfg80211_wext_siwmlme
+
+/* mac80211 */
+#define ieee80211_start_tx_ba_session			backport_ieee80211_start_tx_ba_session
+#define ieee80211_start_tx_ba_cb			backport_ieee80211_start_tx_ba_cb
+#define ieee80211_start_tx_ba_cb_irqsafe		backport_ieee80211_start_tx_ba_cb_irqsafe
+#define ieee80211_stop_tx_ba_session			backport_ieee80211_stop_tx_ba_session
+#define ieee80211_stop_tx_ba_cb				backport_ieee80211_stop_tx_ba_cb
+#define ieee80211_stop_tx_ba_cb_irqsafe			backport_ieee80211_stop_tx_ba_cb_irqsafe
+#define __ieee80211_get_radio_led_name			backport___ieee80211_get_radio_led_name
+#define __ieee80211_get_assoc_led_name			backport___ieee80211_get_assoc_led_name
+#define __ieee80211_get_tx_led_name			backport___ieee80211_get_tx_led_name
+#define __ieee80211_get_rx_led_name			backport___ieee80211_get_rx_led_name
+#define ieee80211_tx_status_irqsafe			backport_ieee80211_tx_status_irqsafe
+#define ieee80211_tx_status				backport_ieee80211_tx_status
+#define ieee80211_restart_hw				backport_ieee80211_restart_hw
+#define ieee80211_alloc_hw				backport_ieee80211_alloc_hw
+#define ieee80211_register_hw				backport_ieee80211_register_hw
+#define ieee80211_unregister_hw				backport_ieee80211_unregister_hw
+#define ieee80211_free_hw				backport_ieee80211_free_hw
+#define ieee80211_beacon_loss				backport_ieee80211_beacon_loss
+#define ieee80211_rate_control_register			backport_ieee80211_rate_control_register
+#define ieee80211_rate_control_unregister		backport_ieee80211_rate_control_unregister
+#define rate_control_send_low				backport_rate_control_send_low
+#define ieee80211_rx					backport_ieee80211_rx
+#define ieee80211_rx_irqsafe				backport_ieee80211_rx_irqsafe
+#define ieee80211_scan_completed			backport_ieee80211_scan_completed
+#define ieee80211_find_sta				backport_ieee80211_find_sta
+#define ieee80211_get_tkip_key				backport_ieee80211_get_tkip_key
+#define ieee80211_beacon_get				backport_ieee80211_beacon_get
+#define ieee80211_rts_get				backport_ieee80211_rts_get
+#define ieee80211_ctstoself_get				backport_ieee80211_ctstoself_get
+#define ieee80211_get_buffered_bc			backport_ieee80211_get_buffered_bc
+#define wiphy_to_ieee80211_hw				backport_wiphy_to_ieee80211_hw
+#define ieee80211_generic_frame_duration		backport_ieee80211_generic_frame_duration
+#define ieee80211_rts_duration				backport_ieee80211_rts_duration
+#define ieee80211_ctstoself_duration			backport_ieee80211_ctstoself_duration
+#define ieee80211_wake_queue				backport_ieee80211_wake_queue
+#define ieee80211_stop_queue				backport_ieee80211_stop_queue
+#define ieee80211_stop_queues				backport_ieee80211_stop_queues
+#define ieee80211_queue_stopped				backport_ieee80211_queue_stopped
+#define ieee80211_wake_queues				backport_ieee80211_wake_queues
+#define ieee80211_iterate_active_interfaces		backport_ieee80211_iterate_active_interfaces
+#define ieee80211_iterate_active_interfaces_atomic	backport_ieee80211_iterate_active_interfaces_atomic
+#define ieee80211_queue_work				backport_ieee80211_queue_work
+#define ieee80211_queue_delayed_work			backport_ieee80211_queue_delayed_work
+
+/* Atheros */
+#define ath_regd_init					backport_ath_regd_init
+#define ath_is_world_regd				backport_ath_is_world_regd
+#define ath_reg_notifier_apply				backport_ath_reg_notifier_apply
+#define ath_regd_get_band_ctl				backport_ath_regd_get_band_ctl
+#define ath_hw_setbssidmask				backport_ath_hw_setbssidmask
+
+#endif /* CONFIG_COMPAT_WIRELESS_MANGLE */
+
+
 #endif /* LINUX_26_COMPAT_H */
diff --git a/config.mk b/config.mk
index b482b68..5bbf1f1 100644
--- a/config.mk
+++ b/config.mk
@@ -4,6 +4,8 @@ export
 ## Make sure to have each variable declaration start
 ## in the first column, no whitespace allowed.
 
+-include $(PWD)/driver-select.mk
+
 ifeq ($(wildcard $(KLIB_BUILD)/.config),)
 # These will be ignored by compat autoconf
  CONFIG_PCI=y
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index c65952d..0b8722b 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -210,7 +210,7 @@ if [ -d ./.git ]; then
 		echo -e "This is a ${RED}bleeding edge${NORMAL} compat-wireless release based on: ${PURPLE}$MASTER_TAG${NORMAL}"
 		;;
 	"linux-2.6-allstable.git") # HPA's all stable tree
-		echo "This is a ${GREEN}stable${NORMAL} compat-wireless release based on: ${PURPLE}$(git describe --abbrev=0)${NORMAL}"
+		echo -e "This is a ${GREEN}stable${NORMAL} compat-wireless release based on: ${PURPLE}$(git describe --abbrev=0)${NORMAL}"
 		;;
 	"linux-2.6.git") # Linus' 2.6 tree
 		;;
diff --git a/scripts/driver-select b/scripts/driver-select
index dcb777c..76b3be6 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -11,6 +11,8 @@ EEPROM_MAKEFILE="drivers/misc/eeprom/Makefile"
 DRIVERS_NET_USB_MAKEFILE="drivers/net/usb/Makefile"
 SSB_MAKEFILE="drivers/ssb/Makefile"
 
+SELECT_CONF="driver-select.mk"
+
 # used to backup files from foo to foo.${BACKUP_EXT}
 # If you change this also modify restore_compat() and
 # restore_file() below I couldn't find a way to use
@@ -51,6 +53,16 @@ function usage {
 	echo -e "\t${GREEN}restore${NORMAL}: you can use this option to restore compat-wireless to the original state"
 }
 
+function generate_driver_select_conf {
+	echo "CONFIG_COMPAT_WIRELESS_MANGLE=y" > $SELECT_CONF
+}
+
+function mangle_mac80211_modules {
+	sed -e 's/cfg80211/backport_cfg80211/' net/wireless/Makefile > .mangled
+	mv .mangled net/wireless/Makefile
+	sed -e 's/mac80211/backport_mac80211/' net/mac80211/Makefile > .mangled
+	mv .mangled net/mac80211/Makefile
+}
 function backup_file {
 	if [ -f $1.${BACKUP_EXT} ]; then
 		echo -e "Backup exists: ${CYAN}${1}.${BACKUP_EXT}${NORMAL}"
@@ -135,11 +147,17 @@ function disable_var_02 {
 	disable_usbnet
 }
 
+function mangle_ath_modules {
+	sed -e 's|ath\([^59]\)|ath_backport\1|' drivers/net/wireless/ath/Makefile > .mangled
+	mv .mangled  drivers/net/wireless/ath/Makefile
+}
+
 function select_ath_driver 
 {
 	backup_file $ATH_MAKEFILE
 	perl -i -ne 'print if /'$1'/ || /CONFIG_ATH_COMMON/ || /ath-objs/ ' $ATH_MAKEFILE
 	disable_var_01
+	mangle_ath_modules
 }
 
 # iwlwifi stuff needs more work
@@ -163,6 +181,7 @@ function restore_compat {
 	for i in $FILES; do
 		restore_file $i
 	done
+	rm -f $SELECT_CONF
 }
 
 if [ $# -ne 1 ]; then
@@ -181,9 +200,12 @@ if [[ ! -f built-in.o ]]; then
 	fi
 fi
 
-# Always backup the top level Makefile, unless restoring
+# Always backup the top level Makefile, unless restoring.
+# Also, always generate a driver-select.mk so that compat-wireless
+# mangles symbols for us.
 if [[ "$1" != "restore" ]]; then
 	backup_file Makefile
+	generate_driver_select_conf
 fi
 
 # If a user selects a new driver make sure we clean up for them
@@ -205,43 +227,55 @@ case $1 in
 		select_drivers		CONFIG_ATH_COMMON \
 					CONFIG_ZD1211RW
 		disable_var_01
+		mangle_ath_modules
+		mangle_mac80211_modules
 		;;
 	ath)
 		select_drivers		CONFIG_ATH_COMMON
 		disable_var_01
+		mangle_ath_modules
+		mangle_mac80211_modules
 		;;
 	intel)
 		select_drivers		CONFIG_IWLWIFI \
 					CONFIG_IPW
 		disable_var
+		mangle_mac80211_modules
 		;;
 	iwlwifi)
 		select_driver		CONFIG_IWLWIFI
 		disable_var_01
+		mangle_mac80211_modules
 		;;
 	wl12xx)
 		select_drivers		CONFIG_WL12XX
 		disable_var_01
+		mangle_mac80211_modules
 		;;
 	ath5k)
 		select_driver		CONFIG_ATH_COMMON
 		select_ath_driver	CONFIG_ATH5K
+		mangle_mac80211_modules
 		;;
 	ath9k)
 		select_driver		CONFIG_ATH_COMMON
 		select_ath_driver	CONFIG_ATH9K
+		mangle_mac80211_modules
 		;;
 	ar9170)
 		select_driver		CONFIG_ATH_COMMON
 		select_ath_driver	CONFIG_AR9170_USB
+		mangle_mac80211_modules
 		;;
 	rtl818x)
 		select_drivers		CONFIG_RTL8180 CONFIG_RTL8187
 		disable_var_02
+		mangle_mac80211_modules
 		;;
 	zd1211rw)
 		select_driver		CONFIG_ZD1211RW
 		disable_var_01
+		mangle_mac80211_modules
 		;;
 	*)
 		echo "Unsupported driver"
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 6c7cae7..e1ff8c5 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -21,9 +21,13 @@ if [ $# -ne 1 ]; then
 	exit
 fi
 
-COMPAT_CONFIG="$1"
+if [ -f driver-select.mk ]; then
+	COMPAT_CONFIGS="$1 driver-select.mk"
+else
+	COMPAT_CONFIGS="$1"
+fi
 
-if [ ! -f $COMPAT_CONFIG ]; then
+if [ ! -f $1 ]; then
 	echo "File $1 is not a file"
 	exit
 fi
@@ -148,7 +152,7 @@ kernel_version_req $OLDEST_KERNEL_SUPPORTED
 define_config_req CONFIG_WIRELESS_EXT
 
 # For each CONFIG_FOO=x option
-for i in $(grep '^CONFIG_' $COMPAT_CONFIG); do
+for i in $(grep '^CONFIG_' $COMPAT_CONFIGS | awk -F":" '{print $2}'); do
 	# Get the element on the left of the "="
 	VAR=$(echo $i | cut -d"=" -f 1)
 	# Get the element on the right of the "="
-- 
1.6.3.3

