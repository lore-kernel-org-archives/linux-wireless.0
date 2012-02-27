Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12061 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2B0GnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 01:43:06 -0500
Message-ID: <4F4B25F5.4090204@qca.qualcomm.com> (sfid-20120227_074312_341997_B9234BCE)
Date: Mon, 27 Feb 2012 08:43:01 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Anthony Ginger <mapfly@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: ath6kl hostapd
References: <CAK0tYSKLhALwUca2LPiRLfXTK-Qt3Oh3Lvk=V272AXdb=aAP7w@mail.gmail.com>
In-Reply-To: <CAK0tYSKLhALwUca2LPiRLfXTK-Qt3Oh3Lvk=V272AXdb=aAP7w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Anthony,

sorry for the late reply, I was sick a long time.

On 02/16/2012 01:30 PM, Anthony Ginger wrote:

> Can ath6kl support AP mode? If yes, how to config it? I tried a
> simplest config, but can't find the AP.

I have used AP mode only with wpasupplicant, I haven't tried with
hostapd yet. I would guess that ath6kl works with hostapd as well but of
course there can be some issues.

> I tried ath6kl driver in git://github.com/kvalo/ath6kl.git and the
> standard kernel 3.3-rc3.
> I am sure the HW is OK, wpa_supplicant works for me.
> hostapd & wpa_supplicant is the latest version build form
> git://w1.fi/srv/git/hostap.git,

This looks good.

> hostapd -v
> hostapd v1.0-rc2
> User space daemon for IEEE 802.11 AP management,
> IEEE 802.1X/WPA/WPA2/EAP/RADIUS Authenticator
> Copyright (c) 2002-2012, Jouni Malinen <j@w1.fi> and contributors
> 
> Firmware is form linux-firmware, here is the kernel log:
> [   14.534308] mmc1: new high speed SDIO card at address 0001
> [   15.245538] ath6kl: ar6003 hw 2.1.1 sdio fw 3.1.1.609

Ah, firmware is a bit old but IIRC it still should support AP mode. But
I need to submit latest firmware to linux-firmware.git.

> I used the simplest config:
> cat /etc/hostapd.conf
> #change wlan0 to your wireless device
> interface=wlan0
> driver=nl80211
> ssid=test
> channel=1
> 
> here is the log:
> hostapd -d /etc/hostapd.conf
> random: Trying to read entropy from /dev/random
> Configuration file: /etc/hostapd.conf
> nl80211: interface wlan0 in phy phy0
> rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
> nl80211: Using driver-based roaming
> nl80211: Add own interface ifindex 3
> nl80211: Set mode ifindex 3 iftype 3 (AP)
> nl80211: Create interface iftype 6 (MONITOR)
> Failed to create interface mon.wlan0: -95 (Operation not supported)
> nl80211: Driver does not support monitor interface type - try to run without it
> BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
> nl80211: Regulatory information - country=00
> nl80211: 2402-2472 @ 40 MHz
> nl80211: 2457-2482 @ 20 MHz
> nl80211: 2474-2494 @ 20 MHz
> nl80211: 5170-5250 @ 40 MHz
> nl80211: 5735-5835 @ 40 MHz
> nl80211: Added 802.11b mode based on 802.11g information
> Completing interface initialization
> Mode: IEEE 802.11b  Channel: 1  Frequency: 2412 MHz
> nl80211: Set freq 2412 (ht_enabled=0 sec_channel_offset=0)
> Failed to update rate sets in kernel module
> RATE[0] rate=10 flags=0x1
> RATE[1] rate=20 flags=0x1
> RATE[2] rate=55 flags=0x0
> RATE[3] rate=110 flags=0x0
> Flushing old station entries
> Could not connect to kernel driver.
> Deauthenticate all stations
> nl80211: Frame command failed: ret=-22 (Invalid argument) (freq=0 wait=0)
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=0
> set_tx=0 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=1
> set_tx=0 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=2
> set_tx=0 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=3
> set_tx=0 seq_len=0 key_len=0
> Using interface wlan0 with hwaddr 00:03:7f:be:f0:a0 and ssid 'test'
> nl80211: Set beacon (beacon_set=0)
> nl80211: Ignore AP isolation configuration error since isolation is not used
> wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
> netlink: Operstate: linkmode=-1, operstate=6
> Failed to set TX queue parameters for queue 0.
> Failed to set TX queue parameters for queue 1.
> Failed to set TX queue parameters for queue 2.
> Failed to set TX queue parameters for queue 3.
> wlan0: Setup of interface done.
> RTM_NEWLINK: operstate=1 ifi_flags=0x1003 ([UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Unknown event 5

>From the logs I can't identify what's wrong, but I have to admit that
I'm not very familiar with hostapd. I need to test this myself and I
will get back to you.

Kalle
