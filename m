Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60594 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab0JQD5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Oct 2010 23:57:20 -0400
Received: by vws2 with SMTP id 2so1052093vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 16 Oct 2010 20:57:19 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 16 Oct 2010 20:57:19 -0700
Message-ID: <AANLkTimekH=rGObEejne8QqtbN5DVQayUkhUYnb2r36T@mail.gmail.com>
Subject: reconnection bug with ath9k
From: John Ettedgui <john.ettedgui@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have a connection issue between my wireless card and my router.
Basically the first time it connects fine, then for some reason it
disconnects and then it is quite hard to reconnect.

With wicd, it would just not see any network anymore.
I switched to network manager and thought the issue was solved but
when I have this issue it keeps popping up asking me for the password
to use to connect (I am using wep2 personal).

rmmod ath9k
modprobe ath9
fixes the issue in most case.

Here is my setup:

I have a wifi card with an atheros chip:
05:04.0 Network controller: Atheros Communications Inc. AR5008
Wireless Network Adapter (rev 01)

I am using the module in the kernel that gets loaded automatically:
ath9k                  77563  0
ath9k_common            4902  1 ath9k
ath9k_hw              286570  2 ath9k,ath9k_common
ath                     8822  2 ath9k,ath9k_hw
mac80211              189270  2 ath9k,ath9k_common
cfg80211              144231  4 ath9k,ath9k_common,ath,mac80211
led_class               2363  1 ath9k


Linux 2.6.35-ARCH #1 SMP PREEMPT Wed Sep 29 08:45:18 CEST 2010 x86_64
Intel(R) Core(TM) i5 CPU 750 @ 2.67GHz GenuineIntel GNU/Linux


I see this in dmesg:

TCP: Peer 121.223.98.212:18563/57886 unexpectedly shrunk window
2511361533:2511363096 (repaired)
No probe response from AP *MACADDRESS* after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
[drm:output_poll_execute] *ERROR* delayed enqueue failed -125
ath9k 0000:05:04.0: PCI INT A disabled
ath9k: Driver unloaded
ath9k 0000:05:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ath: EEPROM regdomain: 0x809c
ath: EEPROM indicates we should expect a country code
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x52
ath: Country alpha2 being used: CN
ath: Regpair used: 0x52
phy1: Selected rate control algorithm 'ath9k_rate_control'
cfg80211: Calling CRDA for country: CN
Registered led device: ath9k-phy1::radio
Registered led device: ath9k-phy1::assoc
Registered led device: ath9k-phy1::tx
Registered led device: ath9k-phy1::rx
phy1: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
mem=0xffffc900040c0000, irq=16
wlan0: authenticate with *MACADDRESS* (try 1)
wlan0: authenticated
wlan0: associate with *MACADDRESS* (try 1)
wlan0: RX AssocResp from *MACADDRESS* (capab=0x411 status=0 aid=1)
wlan0: associated
[drm:output_poll_execute] *ERROR* delayed enqueue failed -125
[drm:output_poll_execute] *ERROR* delayed enqueue failed -125
[drm:output_poll_execute] *ERROR* delayed enqueue failed -125
[drm:output_poll_execute] *ERROR* delayed enqueue failed -125
[drm:output_poll_execute] *ERROR* delayed enqueue failed -125
[drm:output_poll_execute] *ERROR* delayed enqueue failed -125
No probe response from AP *MACADDRESS* after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain

I am in the USA, not sure why it says the country code is CN.

Since I did not get that issue with my previous linksys / broadcom
card I am guessing the issue lies within ath9k but I could be wrong...

This is NM version: 0.8.1-1

Not sure what else to report...


Thank you!

John
