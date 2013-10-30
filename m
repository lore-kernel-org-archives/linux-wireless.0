Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:39889 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab3J3TFS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 15:05:18 -0400
Received: by mail-la0-f41.google.com with SMTP id el20so1500367lab.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 12:05:16 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 20:05:16 +0100
Message-ID: <CAEk6gTB2as8XccgY3E9MBTXRCmKwLk9+9KzNx5YFqEz0L3A3tw@mail.gmail.com> (sfid-20131030_200526_642325_B627B551)
Subject: AP mode with hostapd
From: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
To: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HI all,
I have AR6004 USB dongle connected to Linux kernel 3.10, and am
testing latest hostapd.

I noticed that I was able to put the dongle in the AP mode only for
not-n mode (a or g).

Enabling both of these options:
hw_mode=g
ieee80211n=1

gives an error like this on starting:

random: Trying to read entropy from /dev/random
Configuration file: /home/drasko/hostapd.conf
HT (IEEE 802.11n) with WPA/WPA2 requires CCMP/GCMP to be enabled,
disabling HT capabilities
rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
rfkill: initial event: idx=2 type=2 op=0 soft=0 hard=0
rfkill: initial event: idx=5 type=1 op=0 soft=0 hard=0
nl80211: Using driver-based roaming
nl80211: Supports Probe Response offload in AP mode
nl80211: Disable use_monitor with device_ap_sme since no monitor mode
support detected
nl80211: interface wlan3 in phy phy3
nl80211: Add own interface ifindex 6
nl80211: Set mode ifindex 6 iftype 3 (AP)
nl80211: Setup AP - device_ap_sme=1 use_monitor=0
nl80211: Subscribe to mgmt frames with AP handle 0x1441480 (device SME)
nl80211: Register frame type=0xd0 nl_handle=0x1441480
nl80211: Register frame match - hexdump(len=0): [NULL]
nl80211: Enable Probe Request reporting nl_preq=0x14414c0
nl80211: Register frame type=0x40 nl_handle=0x14414c0
nl80211: Register frame match - hexdump(len=0): [NULL]
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Regulatory information - country=FR
nl80211: 2402-2482 @ 40 MHz
nl80211: 2402-2482 @ 20 mBm
nl80211: 5170-5250 @ 40 MHz
nl80211: 5170-5250 @ 20 mBm
nl80211: 5250-5330 @ 40 MHz
nl80211: 5250-5330 @ 20 mBm
nl80211: 5490-5710 @ 40 MHz
nl80211: 5490-5710 @ 27 mBm
nl80211: 57240-65880 @ 2160 MHz
nl80211: 57240-65880 @ 40 mBm
nl80211: Added 802.11b mode based on 802.11g information
Completing interface initialization
Mode: IEEE 802.11g  Channel: 7  Frequency: 2442 MHz
DFS 0 channels required radar detection
nl80211: Set freq 2442 (ht_enabled=1, vht_enabled=0, bandwidth=20 MHz,
cf1=2442 MHz, cf2=0 MHz)
nl80211: Failed to set channel (freq=2442): -22 (Invalid argument)
Could not set channel for kernel driver
wlan3: Unable to setup interface.
wlan3: Flushing old station entries
nl80211: flush -> DEL_STATION wlan3 (all)
wlan3: Deauthenticate all stations
nl80211: sta_remove -> DEL_STATION wlan3 ff:ff:ff:ff:ff:ff --> 0 (Success)
wpa_driver_nl80211_set_key: ifindex=6 (wlan3) alg=0 addr=(nil)
key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 (wlan3) alg=0 addr=(nil)
key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 (wlan3) alg=0 addr=(nil)
key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 (wlan3) alg=0 addr=(nil)
key_idx=3 set_tx=0 seq_len=0 key_len=0
nl80211: Skip disabling of Probe Request reporting
nl_preq=0x8888888889cc9c49 while in AP mode
netlink: Operstate: linkmode=0, operstate=6
nl80211: Set mode ifindex 6 iftype 2 (STATION)
nl80211: Disable Probe Request reporting nl_preq=0x8888888889cc9c49
nl80211: Unsubscribe mgmt frames handle 0x8888888889cc9c09 (AP
teardown (dev SME))
Failed to initialize interface

I have tried several channels - all were rejected with the same message.

Any idea where these error messages come from?


Best regards,
Drasko
