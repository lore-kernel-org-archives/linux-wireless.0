Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63404 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab0LAVwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 16:52:17 -0500
Received: by eye27 with SMTP id 27so3889584eye.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 13:52:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101130021911.GA18971@monopoli.naic.edu>
References: <20101122024208.GA13377@monopoli.naic.edu>
	<AANLkTikc9w+w8o=ZQBTnTD1=C0+yDVfq=jSfEFQ16dbm@mail.gmail.com>
	<20101125014511.GA1683@monopoli.naic.edu>
	<AANLkTi=nkayyyzECi6MO87ZO-CUpZeNP007_hMp8LiPV@mail.gmail.com>
	<20101126040742.GA5238@monopoli.naic.edu>
	<AANLkTim=P+QejCObCH1=5cPBDR6BpEXxuqHGZj3JBKbE@mail.gmail.com>
	<20101130021911.GA18971@monopoli.naic.edu>
Date: Wed, 1 Dec 2010 21:52:15 +0000
Message-ID: <AANLkTi=1PXk4u37mPd6=F6mjYWLqo=wg7trVmmpfV_WV@mail.gmail.com>
Subject: Re: orinoco_cs module and WPA not working
From: Dave Kilroy <kilroyd@gmail.com>
To: Giacomo Comes <comes@naic.edu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 30, 2010 at 2:19 AM, Giacomo Comes <comes@naic.edu> wrote:
> On Sun, Nov 28, 2010 at 04:10:30PM +0000, Dave Kilroy wrote:
>>
>> Just had a closer look at your log. wpa_supplicant is clearing keys 4
>> and 5, which is why you're getting invalid arguments reported. This
>> shouldn't affect driver behaviour.
>>
>> After that, something seems to go wrong with scanning. Try a plain
>> scan with wpa_supplicant turned off. Do you get any results?
>
> After a reboot and without configuring the wireless interface,
> iw dev eth1 scan
> gives:
> command failed: Network is down (-100)

The interface need to be up to scan:

ifconfig eth1 up

> I was trying to associate the wireless card using iwconfig:
>    iwconfig eth1 mode managed key <key>
>    iwconfig eth1 essid <essid>
> but the card does not associate with the AP.
> Isn't that supposed to work or am I missing something?

Was that AP using WEP or WPA? The former should work (with the
interface up, and all the parameters being set correctly). The latter
won't.

> Buy the way, if I configure the wireless interface with yast
> using WEP (the only way I can make the truemobile
> card work) then iw dev eth1 scan gives:
> BSS 00:13:10:aa:89:4b (on eth1)
>        TSF: 12179691 usec (0d, 00:00:12)
>        freq: 2437
>        beacon interval: 100
>        capability: ESS Privacy PBCC ShortSlotTime (0x0451)
>        signal: -27.00 dBm
>        last seen: 48 ms ago
>        SSID: ssid2
>        Supported rates: 1.0* 2.0* 5.5* 11.0* 22.0
>        DS Parameter set: channel 6
>        ERP: Barker_Preamble_Mode
>        Extended supported rates: 6.0 9.0 12.0 18.0 24.0 36.0 48.0 54.0
>        WPA:     * Version: 1
>                 * Group cipher: TKIP
>                 * Pairwise ciphers: TKIP
>                 * Authentication suites: PSK

That's what I wanted to see. So the card is able to scan, but your
wpa_supplicant log indicates it is continuously timing out the scans.
I don't know what is going on there.

What you can try is to turn off wpa_supplicant roaming, and force
wpa_supplicant to connect to the AP with highest priority in your
config. Set ap_scan=2 in wpa_supplicant.conf, and set

group=TKIP
pairwise=TKIP

in the network block.

This also prevents wpa_supplicant trying to connect to an AP using
BSSID, which the agere cards don't support.


Dave.
