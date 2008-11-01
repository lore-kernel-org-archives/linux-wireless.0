Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:39309 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbYKALb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 07:31:56 -0400
To: "Jouni Malinen" <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Allow AP mode to be enabled
References: <20081030175030.GD3923@jm.kir.nu>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 01 Nov 2008 13:31:30 +0200
In-Reply-To: <20081030175030.GD3923@jm.kir.nu> (ext Jouni Malinen's message of "Thu\, 30 Oct 2008 19\:50\:30 +0200")
Message-ID: <878ws3ptrh.fsf@nokia.com> (sfid-20081101_123215_438867_C5F3FAC4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Terve Jouni,

Jouni Malinen <j@w1.fi> writes:

> With the addition of basic rate set and TX queue parameter
> configuration and confirmation that power save buffering is
> working again, mac80211 is now in state that allows AP mode to be
> used without major problems. Consequently, it is time to allow this
> mode to be enabled without having to patch the kernel.
>
> AP mode requires hostapd for management frame processing and as such,
> configuring this mode is only allowed through cfg80211 (not with
> iwconfig and WEXT).

I'm very happy to see this, I have been eagerly waiting for the
official AP support in mac80211.

I tried to test this with latest hostapd (commit b6a55236) and
wireless-testing (commit d80fe0040), but unfortunately I wasn't
succesful. Here's the output from hostapd with b43:

$ sudo ./hostapd -dd wlan1.conf
Configuration file: wlan1.conf
ctrl_interface_group=0
Opening raw packet socket for ifindex 0
BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
Failed to update rate sets in kernel module
RATE[0] rate=10 flags=0x2
RATE[1] rate=20 flags=0x6
RATE[2] rate=55 flags=0x6
RATE[3] rate=110 flags=0x6
RATE[4] rate=60 flags=0x0
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x0
RATE[7] rate=180 flags=0x0
RATE[8] rate=240 flags=0x0
RATE[9] rate=360 flags=0x0
RATE[10] rate=480 flags=0x0
RATE[11] rate=540 flags=0x0
Could not set passive scanning: Unknown error 4294967295
Flushing old station entries
Deauthenticate all stations
Mode: IEEE 802.11g  Channel: 5  Frequency: 2432 MHz
Failed to set CTS protect in kernel driver
Failed to set Short Slot Time option in kernel driver
Could not set preamble for kernel driver
Using interface wlan1 with hwaddr 00:11:50:f4:c2:42 and ssid 'test'
ioctl[SIOCSIWESSID]: Operation not supported
len=4
Could not set SSID for kernel driver
wlan1: Unable to setup interface.
Flushing old station entries
Deauthenticate all stations

With ath5k I had to add BIT(NL80211_IFTYPE_AP) to
wiphy->interface_modes and the output is similar:

$ sudo ./hostapd -dd wlan1.conf
Configuration file: wlan1.conf
ctrl_interface_group=0
Opening raw packet socket for ifindex 0
BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
Failed to update rate sets in kernel module
RATE[0] rate=10 flags=0x2
RATE[1] rate=20 flags=0x6
RATE[2] rate=55 flags=0x6
RATE[3] rate=110 flags=0x6
RATE[4] rate=60 flags=0x0
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x0
RATE[7] rate=180 flags=0x0
RATE[8] rate=240 flags=0x0
RATE[9] rate=360 flags=0x0
RATE[10] rate=480 flags=0x0
RATE[11] rate=540 flags=0x0
Could not set passive scanning: Unknown error 4294967295
Flushing old station entries
Deauthenticate all stations
Mode: IEEE 802.11g  Channel: 5  Frequency: 2432 MHz
Failed to set CTS protect in kernel driver
Failed to set Short Slot Time option in kernel driver
Could not set preamble for kernel driver
Using interface wlan1 with hwaddr 00:0f:3d:a9:7d:82 and ssid 'test'
ioctl[SIOCSIWESSID]: Operation not supported
len=4
Could not set SSID for kernel driver
wlan1: Unable to setup interface.
Flushing old station entries
Deauthenticate all stations
rmdir[ctrl_interface]: No such file or directory

Especially I'm worried about "SIOCSIWESSID: operation not supported"
messages. I'm sure I'm just doing something wrong, but what?

I tested this on Lenovo X60s laptop running debian unstable in 32 bit
environment. These are the changes between hostapd.conf and my
wlan1.conf:

--- hostapd.conf        2008-10-20 09:58:10.000000000 +0300
+++ wlan1.conf  2008-11-01 13:17:52.000000000 +0200
@@ -3,7 +3,7 @@
 
 # AP netdevice name (without 'ap' postfix, i.e., wlan0 uses wlan0ap for
 # management frames); ath0 for madwifi
-interface=wlan0
+interface=wlan1
 
 # In case of madwifi and nl80211 driver interfaces, an additional configuration
 # parameter, bridge, must be used to notify hostapd if the interface is
@@ -14,7 +14,7 @@
 # default: hostap)
 # Use driver=none if building hostapd as a standalone RADIUS server that does
 # not control any wireless/wired driver.
-# driver=hostap
+driver=nl80211
 
 # hostapd event logger configuration
 #
@@ -105,14 +105,14 @@
 
 # Operation mode (a = IEEE 802.11a, b = IEEE 802.11b, g = IEEE 802.11g,
 # Default: IEEE 802.11b
-hw_mode=a
+hw_mode=g
 
 # Channel number (IEEE 802.11)
 # (default: 0, i.e., not set)
 # Please note that some drivers (e.g., madwifi) do not use this value from
 # hostapd and the channel will need to be configuration separately with
 # iwconfig.
-channel=60
+channel=5
 
 # Beacon interval in kus (1.024 ms) (default: 100; range 15..65535)
 beacon_int=100


-- 
Kalle Valo

