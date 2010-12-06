Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f43.google.com ([209.85.216.43]:60571 "EHLO
	mail-qw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab0LFWvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 17:51:07 -0500
Received: by qwk3 with SMTP id 3so7871085qwk.2
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 14:51:07 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 7 Dec 2010 09:44:49 +1100
Message-ID: <AANLkTingL2eooC2+jH6nQVADKZBFemE=6eTQ_Vhx_Swx@mail.gmail.com>
Subject: Re: carl9170 connect/disconnect loop
From: Wade Fitzpatrick <wade.fitzpatrick@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 December 2010 04:41, Christian Lamparter <chunkeey@googlemail.com> wrote:
> On Monday 06 December 2010 17:34:15 Wade Fitzpatrick wrote:
>> I could not get anything sensible from carl9170. I will keep trying though.
> hmm, hard to say what it is? I bet it could be conflicting
> stack/driver modules. (i.e.: the driver is from compact-wireless,
> whereas the mac80211, or cfg80211 is the original module from 2.6.36)
Having the right firmware helps ;)

>> The Otus message comes from arusb_lnx which was loaded automatically
>> after ar9170usb. Should I remove the arusb_lnx.ko file?
> either that, or add it to the module blacklist (also in /etc/modprobe.d)
I blacklisted arusb_lnk and ar9170usb

>> options mac80211 ieee80211_default_rc_algo=minstrel
>
> the problem with this is that carl9170 (or any other driver
> that relies on minstrel_ht to supply 802.11n MCS rates)
> are limited to the legacy rates (and physpeeds of 54Mbit)

I tried carl9170 with minstrel_ht and by forcing to only use minstrel.
Both times I get the same connect/disconnect loop happening every 1-2
seconds:


usb 2-1.3: reset high speed USB device using ehci_hcd and address 4
Compat-wireless backport release: compat-wireless-2010-11-23-7-g813c0e6
Backport based on linux-next.git next-20101202
cfg80211: Calling CRDA to update world regulatory domain
ieee80211 phy0: Selected rate control algorithm 'minstrel'
ieee80211 phy0: hwaddr 00:1a:ef:00:50:e6, RTL8187vB (default) V1 +
rtl8225z2, rfkill mask 2
rtl8187: Customer ID is 0xFF
Registered led device: rtl8187-phy0::radio
Registered led device: rtl8187-phy0::tx
Registered led device: rtl8187-phy0::rx
rtl8187: wireless switch is on
usbcore: registered new interface driver rtl8187
usb 2-5: reset high speed USB device using ehci_hcd and address 6
usbcore: registered new interface driver carl9170
usb 2-5: driver   API: 1.9.0 2010-10-29 [1-1]
usb 2-5: firmware API: 1.9.1 2010-12-06
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
ieee80211 phy1: Selected rate control algorithm 'minstrel'
Registered led device: carl9170-phy1::tx
usb 2-5: Atheros AR9170 is registered as 'phy1'
ADDRCONF(NETDEV_UP): wlan1: link is not ready
wlan1: authenticate with 00:22:3f:07:42:f3 (try 1)
wlan1: authenticated
wlan1: associate with 00:22:3f:07:42:f3 (try 1)
wlan1: RX AssocResp from 00:22:3f:07:42:f3 (capab=0x431 status=0 aid=3)
wlan1: associated
ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
wlan1: deauthenticated from 00:22:3f:07:42:f3 (Reason: 2)
cfg80211: Calling CRDA for country: US
wlan1: authenticate with 00:22:3f:07:42:f3 (try 1)
wlan1: authenticated
wlan1: associate with 00:22:3f:07:42:f3 (try 1)
wlan1: RX AssocResp from 00:22:3f:07:42:f3 (capab=0x431 status=0 aid=3)
wlan1: associated
wlan1: deauthenticated from 00:22:3f:07:42:f3 (Reason: 2)
cfg80211: Calling CRDA to update world regulatory domain
wlan1: no IPv6 routers present
wlan1: authenticate with 00:22:3f:07:42:f3 (try 1)
wlan1: authenticated
wlan1: associate with 00:22:3f:07:42:f3 (try 1)
wlan1: RX AssocResp from 00:22:3f:07:42:f3 (capab=0x431 status=0 aid=3)
wlan1: associated
wlan1: deauthenticated from 00:22:3f:07:42:f3 (Reason: 2)

# iw event -f
wlan1 (phy #1): deauth 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 reason
2: Previous authentication no longer valid [frame: c0 00 40 01 00 22
3f 8d 7b 05 00 22 3f 07 42 f3 00 22 3f 07 42 f3 70 00 02 00]
wlan1 (phy #1): disconnected (by AP) reason: 2: Previous
authentication no longer valid
wlan1 (phy #1): scan started
wlan1 (phy #1): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447
2452 2457 2462, ""
wlan1 (phy #1): auth 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 status: 0:
Successful [frame: b0 00 40 01 00 22 3f 8d 7b 05 00 22 3f 07 42 f3 00
22 3f 07 42 f3 00 00 00 00 02 00 00 00]
wlan1: new station 00:22:3f:07:42:f3
wlan1 (phy #1): assoc 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 status:
0: Successful [frame: 10 00 40 01 00 22 3f 8d 7b 05 00 22 3f 07 42 f3
00 22 3f 07 42 f3 10 00 31 04 00 00 03 c0 01 08 82 84 8b 0c 12 96 18
24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4
00 00 42 43 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a
00 03 7f 04 01 00 00 00 00 00 dd 1e 00 90 4c 33 4e 10 1b ff ff 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4e 10
1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 dd 1a 00 90 4c 34 01 05 1b 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 3d 16 01 05 1b 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00]
wlan1 (phy #1): connected to 00:22:3f:07:42:f3
wlan1 (phy #1): deauth 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 reason
2: Previous authentication no longer valid [frame: c0 00 40 01 00 22
3f 8d 7b 05 00 22 3f 07 42 f3 00 22 3f 07 42 f3 70 00 02 00]
wlan1 (phy #1): disconnected (by AP) reason: 2: Previous
authentication no longer valid
wlan1 (phy #1): scan started
wlan1 (phy #1): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447
2452 2457 2462, ""
wlan1 (phy #1): auth 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 status: 0:
Successful [frame: b0 00 40 01 00 22 3f 8d 7b 05 00 22 3f 07 42 f3 00
22 3f 07 42 f3 00 00 00 00 02 00 00 00]
wlan1: new station 00:22:3f:07:42:f3
wlan1 (phy #1): assoc 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 status:
0: Successful [frame: 10 00 40 01 00 22 3f 8d 7b 05 00 22 3f 07 42 f3
00 22 3f 07 42 f3 10 00 31 04 00 00 03 c0 01 08 82 84 8b 0c 12 96 18
24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4
00 00 42 43 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a
00 03 7f 04 01 00 00 00 00 00 dd 1e 00 90 4c 33 4e 10 1b ff ff 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4e 10
1b ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 dd 1a 00 90 4c 34 01 05 1b 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 3d 16 01 05 1b 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00]
wlan1 (phy #1): connected to 00:22:3f:07:42:f3

I had the router/AP set to 145Mbit mode but changed it to 300Mbit mode
with no difference.
Where to from here?
