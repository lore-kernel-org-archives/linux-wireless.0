Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43411 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3K3Xhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 18:37:48 -0500
Received: by mail-lb0-f182.google.com with SMTP id u14so7910092lbd.27
        for <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 15:37:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHdPZaN6GusQbpmNHt=4cHkUKsJTOrGuc0oBF7O8e0oL0neoPQ@mail.gmail.com>
References: <CAHdPZaN6GusQbpmNHt=4cHkUKsJTOrGuc0oBF7O8e0oL0neoPQ@mail.gmail.com>
Date: Sun, 1 Dec 2013 07:37:46 +0800
Message-ID: <CAKH5=LvXgYkU1mdGSZAoq=bkbp-jQdtxE16Dc1GEHjFeoJBg_w@mail.gmail.com> (sfid-20131201_003807_712687_D8841A6E)
Subject: Re: unable to set iwlwifi master mode
From: Naughtboy <skylvlinux@gmail.com>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

you  shoud set frepue in the hostapd.conf
just add channel=6  ok
and lost of things can immplient in the hostapd.conf


if you keep on use iwconfig command to set frequecny
the above all things  should complited by iwconfrig ,or when you run
hostapd and the hostapd will choose the default channel (channel 1)for
the wireless driver

2013/12/1 devendra.aaru <devendra.aaru@gmail.com>:
> Hello,
>
> I was trying to use my intel wireless device as an AP. I used hostapd (1.1).
>
> It seem to be that i couldn't able to get it working.
>
> My hostapd config:
>
> interface=wlp3s0
> driver=nl80211
> country_code=US
> ieee80211d=1
> ssid=testhostapd
> channel=1
> hw_mode=g
> auth_algs=1
> wpa=3
> wpa_passphrase=mypassword
> wpa_key_mgmt=WPA-PSK
> wpa_pairwise=TKIP CCMP
> rsn_pairwise=CCMP
>
> I have got the following output when i run hostapd -ddd hostapd.conf
>
> random: Trying to read entropy from /dev/random
> Configuration file: 1
> nl80211: interface wlp3s0 in phy phy0
> rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
> nl80211: Using driver-based off-channel TX
> nl80211: Register frame command failed (type=208): ret=-114 (Operation
> already in progress)
> nl80211: Register frame match - hexdump(len=1): 06
> nl80211: Failed to register Action frame processing - ignore for now
> nl80211: Add own interface ifindex 3
> nl80211: Set mode ifindex 3 iftype 3 (AP)
> nl80211: Failed to set interface 3 to mode 3: -95 (Operation not supported)
> nl80211: Interface already in requested mode - ignore error
> nl80211: Create interface iftype 6 (MONITOR)
> nl80211: New interface mon.wlp3s0 created: ifindex=15
> nl80211: Add own interface ifindex 15
> BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
> nl80211: Regulatory information - country=US
> nl80211: 2402-2472 @ 40 MHz
> nl80211: 5170-5250 @ 40 MHz
> nl80211: 5250-5330 @ 40 MHz
> nl80211: 5490-5600 @ 40 MHz
> nl80211: 5650-5710 @ 40 MHz
> nl80211: 5735-5835 @ 40 MHz
> nl80211: 57240-63720 @ 2160 MHz
> nl80211: Added 802.11b mode based on 802.11g information
> Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=14 dBm
> Completing interface initialization
> Mode: IEEE 802.11g  Channel: 1  Frequency: 2412 MHz
> nl80211: Set freq 2412 (ht_enabled=0 sec_channel_offset=0)
> nl80211: Failed to set channel (freq=2412): -16 (Device or resource busy)
> Could not set channel for kernel driver
> wlp3s0: Unable to setup interface.
> Flushing old station entries
> Could not connect to kernel driver.
> Deauthenticate all stations
> nl80211: Remove interface ifindex=15
> netlink: Operstate: linkmode=0, operstate=6
> nl80211: Set mode ifindex 3 iftype 2 (STATION)
>
> -------------------------------------------x------------------------------------
> Seems that the setting of channel is failing
>
> and i tried with iwconfig wlp3s0 channel 6. It says
>
> Error for wireless request "Set Frequency" (8B04) :
>     SET failed on device wlp3s0 ; Device or resource busy.
>
> What could be the possible mistake?
>
> in case:
>
> lspci -v output:
>
> 03:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000
> [Condor Peak]
> Subsystem: Intel Corporation Centrino Wireless-N 1000 BGN
> Flags: bus master, fast devsel, latency 0, IRQ 45
> Memory at f2400000 (64-bit, non-prefetchable) [size=8K]
> Capabilities: [c8] Power Management version 3
> Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> Capabilities: [e0] Express Endpoint, MSI 00
> Capabilities: [100] Advanced Error Reporting
> Capabilities: [140] Device Serial Number 00-26-c7-ff-ff-51-11-1a
> Kernel driver in use: iwlwifi
>
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
