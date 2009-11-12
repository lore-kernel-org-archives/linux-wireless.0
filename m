Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759870AbZKLBfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 20:35:54 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: jeff.zheng@intel.com
Cc: Wifi-test-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] wifi-test: add initial simple test scripts
Date: Wed, 11 Nov 2009 20:35:58 -0500
Message-Id: <1257989758-30756-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wifi-test project currently deals only with a robust
test setup and requires access to an AP with a CLI like
the Cisco APs. For simpler environments such as an end
user we can work on simpler scripts and tests cases.

Lets start this off with some initial basic scripts to
start an AP with different encryption possible settings
and a client to connect to that AP. To start off with
we use wext as that has been tested previously. We'll
replace this with iw commands ASAP.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

I'm submitting these as-is from some old stuff I had which I had
tested with MadWifi. Eventually I'll test with ath9k and 11n, etc.
Feel free to send patches :)

 README                      |   14 +++
 simple/README               |   15 +++
 simple/create-ap.sh.txt     |  199 +++++++++++++++++++++++++++++++++++++++++++
 simple/create-client.sh.txt |  153 +++++++++++++++++++++++++++++++++
 4 files changed, 381 insertions(+), 0 deletions(-)
 create mode 100644 simple/README
 create mode 100755 simple/create-ap.sh.txt
 create mode 100755 simple/create-client.sh.txt

diff --git a/README b/README
index 491597a..eb88832 100644
--- a/README
+++ b/README
@@ -1,4 +1,18 @@
 
+Type of testing
+===============
+
+  * Robust testing environment with CLI AP
+
+This project is designed originally for using APs which you can
+configure yourself manually through some sort of CLI like the Cisco APs.
+
+  * Simple testing
+
+Simple testing utilities are only starting to being developed, for those
+refer to the simple/ directory. The rest of this document covers testing
+with robust environment and an AP with a CLI.
+
 *****************************************
 **	  Testing environment	       ** 
 *****************************************
diff --git a/simple/README b/simple/README
new file mode 100644
index 0000000..cd65290
--- /dev/null
+++ b/simple/README
@@ -0,0 +1,15 @@
+Simple Linux wirelss testing utilities
+======================================
+
+Use these if you don't have a complex testing environment, like
+only one AP you run yourself with hostapd and a client which you
+control as well.
+
+This doesn't yet collect information from connection establishment.
+
+TODO:
+
+  * Use iw commands
+
+  * Write nl80211 client which lisents to multicast events
+    to figure out connection completions/etc
diff --git a/simple/create-ap.sh.txt b/simple/create-ap.sh.txt
new file mode 100755
index 0000000..e4081a5
--- /dev/null
+++ b/simple/create-ap.sh.txt
@@ -0,0 +1,199 @@
+#!/bin/bash
+#
+# Copyright (c) 2008 Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+#
+# Linuxwireless.org generic AP setup utility
+#
+# Use this script setup an AP to tests drivers in STA mode against
+# generic AP modes. This script was designed to support all current
+# Linux wireless drivers which support AP mode but was tested mainly with 
+# MadWifi
+# 
+# Requirements:
+# 
+# * hostapd
+# * wireless-tools
+# * Wireless card and a respective Linux wireless driver which supports AP mode
+#
+#### Configurable items
+ESSID="linuxwireless.org-testap01"
+DEV="ath2"
+# Used for WEP and TKIP and CCMP PSK passphrase
+WEPKEY1="linuxwireless"
+MODULE="ath_pci"
+HOSTAPD_TKIP="/tmp/hostapd.conf.tkip"
+HOSTAPD_CCMP="/tmp/hostapd.conf.ccmp"
+#### You should not need to edit anything else bellow
+
+function generic-ap-setup() {
+	echo "Removing module $DRIVER..."
+	rmmod $MODULE
+	echo "Adding module $DRIVER..."
+	modprobe $MODULE
+	# Some drivers in AP mode will need this
+	echo "Letting module breathe for a bit..."
+	sleep 2
+	case "$MODULE" in
+		ath_pci)
+			wlanconfig $DEV destroy
+			wlanconfig $DEV create wlandev wifi0 wlanmode ap
+		;;
+		*)
+			iwconfig $DEV mode master
+		;;
+	esac
+	iwconfig $DEV essid $ESSID
+}
+
+function generate-hostapd() {
+	if [[ $# -ne 2 ]]; then
+		echo "Not enough arguments for generate-hostapd()"
+		usage
+		exit
+	fi
+
+	case "$1" in
+		TKIP)
+		PAIRWISE_ALG="TKIP";
+		;;
+		CCMP)
+		PAIRWISE_ALG="CCMP";
+		;;
+		*)
+		echo -e "Unsupported hostapd pairwise algorythm: $1"
+		exit
+		;;
+	esac
+	DRIVER="hostap"
+	case "$MODULE" in
+		ath_pci)
+			DRIVER="madwifi"
+		;;
+		# Other hostapd drivers are hostap, wired, and prism54, all these match
+		# ther respective module name
+		*)
+			DRIVER="$MODULE"
+		;;
+	esac
+	echo "
+interface=$DEV
+driver=$DRIVER
+logger_syslog=-1
+logger_syslog_level=2
+logger_stdout=-1
+logger_stdout_level=2
+debug=0
+dump_file=/tmp/hostapd.dump
+ctrl_interface=/var/run/hostapd
+ctrl_interface_group=0
+ssid=$ESSID
+max_num_sta=255
+macaddr_acl=0
+auth_algs=3
+wme_enabled=1
+wme_ac_bk_cwmin=4
+wme_ac_bk_cwmax=10
+wme_ac_bk_aifs=7
+wme_ac_bk_txop_limit=0
+wme_ac_bk_acm=0
+wme_ac_be_aifs=3
+wme_ac_be_cwmin=4
+wme_ac_be_cwmax=10
+wme_ac_be_txop_limit=0
+wme_ac_be_acm=0
+wme_ac_vi_aifs=2
+wme_ac_vi_cwmin=3
+wme_ac_vi_cwmax=4
+wme_ac_vi_txop_limit=94
+wme_ac_vi_acm=0
+wme_ac_vo_aifs=2
+wme_ac_vo_cwmin=2
+wme_ac_vo_cwmax=3
+wme_ac_vo_txop_limit=47
+wme_ac_vo_acm=0
+eapol_key_index_workaround=0
+eap_server=0
+own_ip_addr=127.0.0.1
+wpa=2
+wpa_passphrase=$WEPKEY1
+wpa_key_mgmt=WPA-PSK
+wpa_pairwise=$PAIRWISE_ALG
+" > $2
+}
+
+function mode-ap() {
+	echo "Setting up AP..."
+	generic-ap-setup
+	ifconfig $DEV up
+	echo "AP setup complete"
+}
+
+function mode-ap-wep() {
+	echo "Setting up AP in AP-WEP mode..."
+	generic-ap-setup
+	iwconfig $DEV key s:$WEPKEY1
+	ifconfig $DEV up
+	echo "AP setup complete"
+}
+
+function mode-ap-wpa() {
+	if [[ $# -ne 1 ]]; then
+		echo "Not enough arguments for mode-ap-wpa()"
+		usage
+		exit
+	fi
+
+	case "$1" in
+		TKIP)
+		PAIRWISE_ALG="TKIP"
+		HOSTAPD_CONF="$HOSTAPD_TKIP"
+		;;
+		CCMP)
+		PAIRWISE_ALG="CCMP"
+		HOSTAPD_CONF="$HOSTAPD_CCMP"
+		;;
+		*)
+		echo -e "Unsupported hostapd pairwise algorithm: $1"
+		exit;
+		;;
+	esac
+	echo "Setting up AP in AP-$PAIRWISE_ALG mode..."
+	generic-ap-setup
+	ifconfig $DEV up
+	generate-hostapd $PAIRWISE_ALG $HOSTAPD_CONF
+	hostapd $HOSTAPD_CONF
+	echo "AP setup complete"
+}
+
+function usage() {
+	echo -e "Usage: $0 AP-Mode"
+	echo -e "AP-Modes available:"
+	echo -e "\tAP\tNo encryption"
+	echo -e "\tAP-WEP\tWEP encryption"
+	echo -e "\tAP-TKIP\tTKIP encryption"
+	echo -e "\tAP-CCMP\tCCMP encryption"
+}
+
+if [[ $# -ne 1 ]]; then
+	usage
+	exit
+fi
+
+case "$1" in
+	AP)
+	mode-ap;
+	;;
+	AP-WEP)
+	mode-ap-wep;
+	;;
+	AP-TKIP)
+	mode-ap-wpa TKIP;
+	;;
+	AP-CCMP)
+	mode-ap-wpa CCMP;
+	;;
+	*)
+	echo -e "Unsupported AP mode: $1"
+	usage;
+	;;
+esac
diff --git a/simple/create-client.sh.txt b/simple/create-client.sh.txt
new file mode 100755
index 0000000..2c99072
--- /dev/null
+++ b/simple/create-client.sh.txt
@@ -0,0 +1,153 @@
+#!/bin/bash
+#
+# Copyright (c) 2008 Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+#
+# Linuxwireless.org generic STA test utility
+#
+# Use this script to test Linux wireless drivers
+# which require to associate to an access point.
+#
+#### Configurable items
+ESSID="linuxwireless.org-testap01"
+DEV="ath2"
+# Used for WEP and TKIP and CCMP PSK passphrase
+WEPKEY1="linuxwireless"
+MODULE="ath_pci"
+WPASUPPLICANT_TKIP="/tmp/wpasupplicant.conf.tkip"
+WPASUPPLICANT_CCMP="/tmp/wpasupplicant.conf.ccmp"
+#### You should not need to edit anything else bellow
+
+function generic-sta-setup() {
+	echo "Removing module $MODULE..."
+	rmmod $MODULE
+	echo "Adding module $MODULE..."
+	modprobe $MODULE
+	# Some drivers in AP mode will need this
+	echo "Letting module breathe for a bit..."
+	sleep 2
+	iwconfig $DEV mode Managed
+	iwconfig $DEV essid $ESSID
+}
+
+function generate-wpasupplicant() {
+	if [[ $# -ne 2 ]]; then
+		echo "Not enough arguments for generate-wpasupplicant()"
+		usage
+	exit
+	fi
+
+	case "$1" in
+		TKIP)
+		PAIRWISE_ALG="TKIP";
+		GROUPWISE_ALG="TKIP";
+		;;
+		CCMP)
+		PAIRWISE_ALG="CCMP";
+		GROUPWISE_ALG="CCMP";
+		;;
+		*)
+		echo -e "Unsupported hostapd pairwise algorythm: $1"
+		exit
+		;;
+	esac
+
+	echo "
+#ctrl_interface=/var/run/wpa_supplicant
+ctrl_interface_group=wheel
+network={
+	ssid=\"$ESSID\"
+	scan_ssid=1
+	key_mgmt=WPA-PSK
+	pairwise=$PAIRWISE_ALG
+	group=$GROUPWISE_ALG
+	psk=\"$WEPKEY1\"
+}
+" > $2
+}
+
+function mode-sta() {
+	echo "Setting up STA..."
+	generic-sta-setup
+	ifconfig $DEV up
+	echo "STA setup complete"
+}
+
+function mode-sta-wep() {
+	echo "Setting up AP in AP-WEP mode..."
+	generic-sta-setup
+	iwconfig $DEV key s:$WEPKEY1
+	ifconfig $DEV up
+	echo "STA setup complete"
+}
+
+function mode-sta-wpa() {
+	if [[ $# -ne 1 ]]; then
+		echo "Not enough arguments for mode-sta-wpa()"
+		usage
+		exit
+	fi
+
+	case "$1" in
+		TKIP)
+		PAIRWISE_ALG="TKIP"
+		WPASUPPLICANT_CONF="$WPASUPPLICANT_TKIP"
+		;;
+		CCMP)
+		PAIRWISE_ALG="CCMP"
+		WPASUPPLICANT_CONF="$WPASUPPLICANT_CCMP"
+		;;
+		*)
+		echo -e "Unsupported wpasupplicant pairwise algorithm: $1"
+		exit
+		;;
+	esac
+	DRIVER="wext"
+	case "$MODULE" in
+		ath_pci)
+			DRIVER="madwifi"
+		;;
+		# Drivers should now support wext
+		*)
+			DRIVER="wext"
+		;;
+	esac
+	echo "Setting up STA in STA-$PAIRWISE_ALG mode..."
+	generic-sta-setup
+	ifconfig $DEV up
+	generate-wpasupplicant $PAIRWISE_ALG $WPASUPPLICANT_CONF
+	wpa_supplicant -D${DRIVER} -i${DEV} -c $WPASUPPLICANT_CONF
+	echo "STA setup complete"
+}
+
+function usage() {
+	echo -e "Usage: $0 STA-Mode"
+	echo -e "STA-Modes available:"
+	echo -e "\tSTA\tNo encryption"
+	echo -e "\tSTA-WEP\tWEP encryption"
+	echo -e "\tSTA-TKIP\tTKIP encryption"
+	echo -e "\tSTA-CCMP\tCCMP encryption"
+}
+
+if [[ $# -ne 1 ]]; then
+	usage
+	exit
+fi
+
+case "$1" in
+	STA)
+	mode-sta;
+	;;
+	STA-WEP)
+	mode-sta-wep;
+	;;
+	STA-TKIP)
+	mode-sta-wpa TKIP;
+	;;
+	STA-CCMP)
+	mode-sta-wpa CCMP;
+	;;
+	*)
+	echo -e "Unsupported STA mode: $1"
+	usage;
+	;;
+esac
-- 
1.6.5.2.155.gbb47

