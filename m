Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53334 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab1DOGX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 02:23:29 -0400
Received: by bwz15 with SMTP id 15so1947068bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 23:23:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104142251.10881.chunkeey@googlemail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
 <BANLkTi=HaJ0ZrtmDo=wwBOrEweZrjHqWXw@mail.gmail.com> <BANLkTikyCcN6dP0DiQboXv4rDoSGqTDdTA@mail.gmail.com>
 <201104142251.10881.chunkeey@googlemail.com>
From: Damian Lesiuk <lesiuk@gmail.com>
Date: Fri, 15 Apr 2011 08:22:48 +0200
Message-ID: <BANLkTinpodW6rjQ7GTOFkVV7L=KG8kuS7Q@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have debug USE flag disabled, I recompiled hostapd with that flag
and now I can see log like your.
You are right it's BSSs.

Is there option to do not scan for overlapping BSSs?
I know that it'll break some standards but that other networks are
very week. I can't see them from my laptop.


2011/4/14 Christian Lamparter <chunkeey@googlemail.com>:
> On Thursday 14 April 2011 21:36:05 Damian Lesiuk wrote:
>> I don't have any more log.
>> I dumped it by hostapd -dd /config/file &> log_file
>
> sure, this is what it looks like, your output is clearly "mangled".
>
> --- cut ---
> # hostapd -dd /etc/hostapd/hostapd.conf.2ghz
> Configuration file: /etc/hostapd/hostapd.conf.2ghz
> ctrl_interface_group=0
> nl80211: Add own interface ifindex 7
> nl80211: New interface mon.wlanap created: ifindex=9
> nl80211: Add own interface ifindex 9
> BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
> nl80211: Added 802.11b mode based on 802.11g information
> Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=20 dBm
> RATE[0] rate=10 flags=0x1
> RATE[1] rate=20 flags=0x1
> RATE[2] rate=55 flags=0x1
> RATE[3] rate=110 flags=0x1
> RATE[4] rate=60 flags=0x0
> RATE[5] rate=90 flags=0x0
> RATE[6] rate=120 flags=0x0
> RATE[7] rate=180 flags=0x0
> RATE[8] rate=240 flags=0x0
> RATE[9] rate=360 flags=0x0
> RATE[10] rate=480 flags=0x0
> RATE[11] rate=540 flags=0x0
> Scan for neighboring BSSes prior to enabling 40 MHz channel
> Scan requested (ret=0) - scan timeout 10 seconds
> Interface initialization will be completed in a callback
> nl80211: Event message available
> nl80211: Scan trigger
> RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
> RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlanap' added
> Unknown event 5
> RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlanap' added
> Unknown event 5
> RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlanap' added
> Unknown event 5
> nl80211: Event message available
> nl80211: New scan results available
> Received scan results (2 BSSes)
> 40 MHz affected channel range: [2427,2477] MHz
> Neighboring BSS: d8:5d:4c:c0:f8:e3 freq=2412 pri=1 sec=5
> 40 MHz pri/sec mismatch with BSS d8:5d:4c:c0:f8:e3 <2412,2432> (chan=1+) vs. <2462,2442> <====
> 20/40 MHz operation not permitted on channel pri=11 sec=7 based on overlapping BSSes <=========
> Completing interface initialization
>
> --- cut ---
>
> Regards,
>        Chr
>
