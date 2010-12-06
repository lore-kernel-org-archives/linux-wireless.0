Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:58717 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0LFXkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 18:40:45 -0500
Received: by bwz16 with SMTP id 16so11377212bwz.4
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 15:40:43 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Wade Fitzpatrick <wade.fitzpatrick@gmail.com>
Subject: Re: carl9170 connect/disconnect loop
Date: Tue, 7 Dec 2010 00:32:22 +0100
Cc: linux-wireless@vger.kernel.org
References: <AANLkTingL2eooC2+jH6nQVADKZBFemE=6eTQ_Vhx_Swx@mail.gmail.com>
In-Reply-To: <AANLkTingL2eooC2+jH6nQVADKZBFemE=6eTQ_Vhx_Swx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012070032.23135.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 December 2010 23:44:49 Wade Fitzpatrick wrote:
> On 7 December 2010 04:41, Christian Lamparter <chunkeey@googlemail.com> wrote:
> > On Monday 06 December 2010 17:34:15 Wade Fitzpatrick wrote:
> >> options mac80211 ieee80211_default_rc_algo=minstrel
> > the problem with this is that carl9170 (or any other driver
> > that relies on minstrel_ht to supply 802.11n MCS rates)
> > are limited to the legacy rates (and physpeeds of 54Mbit)
> 
> I tried carl9170 with minstrel_ht and by forcing to only use minstrel.
> Both times I get the same connect/disconnect loop happening every 1-2
> seconds:
so unlike ar9170usb, carl1970 fails regardless which rate control
algorithm is selected. Now that's very interesting!

> usb 2-5: reset high speed USB device using ehci_hcd and address 6
> usbcore: registered new interface driver carl9170
> usb 2-5: driver   API: 1.9.0 2010-10-29 [1-1]
> usb 2-5: firmware API: 1.9.1 2010-12-06
> ath: EEPROM regdomain: 0x0
> ath: EEPROM indicates default country code should be used
> ath: doing EEPROM country->regdmn map search
> ath: country maps to regdmn code: 0x3a
> ath: Country alpha2 being used: US
> ath: Regpair used: 0x3a
> ieee80211 phy1: Selected rate control algorithm 'minstrel'
> Registered led device: carl9170-phy1::tx
> usb 2-5: Atheros AR9170 is registered as 'phy1'
> ADDRCONF(NETDEV_UP): wlan1: link is not ready
> wlan1: authenticate with 00:22:3f:07:42:f3 (try 1)
> wlan1: authenticated
> wlan1: associate with 00:22:3f:07:42:f3 (try 1)
> wlan1: RX AssocResp from 00:22:3f:07:42:f3 (capab=0x431 status=0 aid=3)
> wlan1: associated

> # iw event -f
> wlan1 (phy #1): deauth 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 reason
> 2: Previous authentication no longer valid [frame: c0 00 40 01 00 22
> 3f 8d 7b 05 00 22 3f 07 42 f3 00 22 3f 07 42 f3 70 00 02 00]
> wlan1 (phy #1): disconnected (by AP) reason: 2: Previous
> authentication no longer valid
> wlan1 (phy #1): scan started
> wlan1 (phy #1): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447
> 2452 2457 2462, ""
> wlan1 (phy #1): auth 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 status: 0:
> Successful [frame: b0 00 40 01 00 22 3f 8d 7b 05 00 22 3f 07 42 f3 00
> 22 3f 07 42 f3 00 00 00 00 02 00 00 00]
> wlan1: new station 00:22:3f:07:42:f3

> I had the router/AP set to 145Mbit mode but changed it to 300Mbit mode
> with no difference.
> Where to from here?

mac80211 comes with some powerful debug tools.
Since you get the disconnects fairly quickly, you should
setup a wlan monitor.

<http://linuxwireless.org/en/users/Documentation/iw#Adding_interfaces_with_iw>
 iw dev wlan1 interface add mon type monitor flags otherbss control
 ifconfig mon up

This will give you a running monitor interface. Now, all you need is to
attach a network sniffer like wireshark, tcpdump, etc... to the "mon" interface. 
just two things:
 - the sniffer needs network/root privileges and
 - try to avoid "promiscuous" mode

next, connect "wlan1" to your network and watch what 802.11 frames the
attached network sniffer picks up. After you acquired multiple "samples"
save the dump, (compress it) and send it to me (you probably want to
switch to "personal" mail for this, since WPA-PSKs can be retrieved from
these "network dump".)

Best Regards,
	Chr

P.S.: It's past 00:00 here, so good night! 
