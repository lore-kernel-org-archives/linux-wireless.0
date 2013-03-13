Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from momout1-smtp.messagingengine.com ([66.111.4.229]:55682 "EHLO
	momout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187Ab3CMLj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 07:39:59 -0400
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id AE4421A1C
	for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2013 07:39:58 -0400 (EDT)
Message-Id: <1363174798.13944.140661203751385.64CA1D1D@webmail.messagingengine.com> (sfid-20130313_124004_644396_68F7898B)
From: =?UTF-8?Q?K=C3=A9vin=20THIERRY?= <kevinthierry@myopera.com>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: wpa_suplicant not working - WiFi Direct - P2P
Date: Wed, 13 Mar 2013 11:39:58 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to setup wifi direct but I'm unable to launch wpa_supplicant.

OS : Ubuntu 12.04 x86_64 kernel 3.5.0-25-generic
Dongle Wifi : Netgear model wna1000m
Driver : 8192cu (latest driver provided by Realtek :
http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=21&PFid=48&Level=5&Conn=4&DownTypeID=3&GetDown=false&Downloads=true)
wpa_suplicant : version 0.8.x (provided by Realtek with the driver)
wifi p2p: enabled with "iwpriv wlan1 p2p_set enable=1"

wpa_sulicant has been built with these options (.config file):

CONFIG_DRIVER_NL80211=y
CONFIG_CTRL_IFACE=y
CONFIG_WPS=y
CONFIG_WPS2=y
CONFIG_P2P=y
CONFIG_AP=y
CONFIG_WPA_CLI_EDIT=y
CONFIG_BACKEND=file
CONFIG_CTRL_IFACE_DBUS=y
CONFIG_CTRL_IFACE_DBUS_NEW=y
CONFIG_CTRL_IFACE_DBUS_INTRO=y
CONFIG_DEBUG_FILE=y

wpa_supplicant is launched with these parameters
(/etc/wpa_supplicant_wlan1.conf) :

update_config=1
ctrl_interface=/var/run/wpa_supplicant
ap_scan=1
device_name=Netgear Dongle wlan1
device_type=1-0050F204-1
p2p_listen_reg_class=81
p2p_listen_channel=1
p2p_oper_reg_class=81
p2p_oper_channel=1

Launching wpa_supplicant:

$ sudo wpa_supplicant -Dnl80211 -c/etc/wpa_supplicant_wlan1.conf -iwlan1
-d
wpa_supplicant v0.8.x
random: Trying to read entropy from /dev/random
Initializing interface 'wlan1' conf '/etc/wpa_supplicant_wlan1.conf'
driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant_wlan1.conf' ->
'/etc/wpa_supplicant_wlan1.conf'
Reading configuration file '/etc/wpa_supplicant_wlan1.conf'
update_config=1
ctrl_interface='/var/run/wpa_supplicant'
ap_scan=1
device_name='Netgear Dongle wlan1'
p2p_listen_reg_class=81
p2p_listen_channel=1
p2p_oper_reg_class=81
p2p_oper_channel=1
Could not open file /sys/class/net/wlan1/phy80211/name: No such file or
directory
rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
nl80211: Failed to set interface 6 to mode 2: -19 (No such device)
nl80211: Try mode change after setting interface down
nl80211: Failed to set interface 6 to mode 2: -19 (No such device)
nl80211: Failed to set interface 6 to mode 2: -19 (No such device)
nl80211: Failed to set interface 6 to mode 2: -19 (No such device)
nl80211: Failed to set interface 6 to mode 2: -19 (No such device)
nl80211: Failed to set interface 6 to mode 2: -19 (No such device)
nl80211: Failed to set interface 6 to mode 2: -19 (No such device)
nl80211: Failed to set interface 6 to mode 2: -19 (No such device)
nl80211: Failed to set interface 6 to mode 2: -19 (No such device)
nl80211: Failed to set interface 6 to mode 2: -19 (No such device)
nl80211: Failed to set interface 6 to mode 2: -19 (No such device)
nl80211: Interface mode change to 2 from 0 failed
nl80211: Could not configure driver to use managed mode
netlink: Operstate: linkmode=1, operstate=5
wlan1: Failed to initialize driver interface
Failed to add interface wlan1
wlan1: Cancelling scan request
wlan1: Cancelling authentication timeout

Since I followed the linux kernel wireless how to
(http://wireless.kernel.org/en/developers/p2p/howto) and Realtek
documentation (availlable with the driver) without getting better
results I figured that you might have an idea.

Thanks,

Kevin
