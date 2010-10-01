Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60939 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab0JAX41 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 19:56:27 -0400
Received: by wyb28 with SMTP id 28so3475124wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 16:56:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010020052.35855.chunkeey@googlemail.com>
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com>
 <201010011636.58033.chunkeey@googlemail.com> <AANLkTimZYgDLLag+uGgdojrckZ5tgySC+UeyHCfee74J@mail.gmail.com>
 <201010020052.35855.chunkeey@googlemail.com>
From: Saqeb Akhter <saqeb.akhter@gmail.com>
Date: Fri, 1 Oct 2010 19:56:06 -0400
Message-ID: <AANLkTinfZdNCRNEmuaOot7_NadmbDN0UU5WbUX1pApYb@mail.gmail.com>
Subject: Re: carl9170: wnda3100 only 54MB/s
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes carl9170 (from 9/23).
-----------------------------------------------------------------------------------------------------

Output from lshw -C network:

 *-network
       description: Wireless interface
       physical id: 1
       bus info: usb@1:3
       logical name: wlan2
       serial: 00:22:3f:99:cd:81
       capabilities: ethernet physical wireless
       configuration: broadcast=yes driver=carl9170
driverversion=2.6.32-24-generic firmware=1.8.8.3 ip=192.168.10.60
multicast=yes wireless=IEEE 802.11abgn

----------------------------------------------------------------------------------------------

sakhter@sakhter-laptop:~$ dmesg | grep alg
[    0.342735] alg: No test for stdrng (krng)
[  143.665241] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'

------------------------------------------------------------------------------------------------
output iw dev wlan2 scan

BSS 30:46:9a:10:49:f7 (on wlan2) -- associated
	TSF: 90703162427 usec (1d, 01:11:43)
	freq: 5200
	beacon interval: 100
	capability: ESS ShortSlotTime (0x0401)
	signal: -53.00 dBm
	last seen: 672 ms ago
	SSID: sakhter-5g
	Supported rates: 6.0* 9.0 12.0* 18.0 24.0* 36.0 48.0 54.0
	DS Parameter set: channel 40
	HT capabilities:
		Capabilities: 0x1ce
			HT20/HT40
			SM Power Save disabled
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 7935 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 1/2 usec (0x02)
		HT RX MCS rate indexes supported: 0-15
		HT TX MCS rate indexes are undefined
	WPS:	 * Version: 1.0
		 * Manufacturer: Netgear, Inc.
		 * Model: WNDR3700
		 * Device name: WNDR3700(Wireless AP)
		 * Config methods: Ethernet, Label, PBC
---------------------------------------------------------------------------------------------------


Hopefully some of that info can help u out.



On Fri, Oct 1, 2010 at 6:52 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Saturday 02 October 2010 00:30:28 Saqeb Akhter wrote:
>> Below is the out put from iperf on windows (about 3x faster).
>>
>> Not sure what to do to get better throughput...is this considered a bug or a
>> lacking feature ?
> nope, the "feature" is there... It's just not utilized
>
>> -------------------------------------------------------------------------------
>> sakhter@sakhter-laptop:~$ iw dev wlan2 link
>> Connected to 30:46:9a:10:49:f7 (on wlan2)
>>     SSID: sakhter-5g
>>     freq: 5200
>>     RX: 222040 bytes (949 packets)
>>     TX: 12082 bytes (77 packets)
>>     signal: -45 dBm
>>     tx bitrate: 54.0 MBit/s
> are you sure carl9170 is actually handling the device (and not ar9170usb?).
> Also what's the chosen rate control alg? ( - dmesg - will tell you that,
> if it isn't "minstrel_ht", then post please post what "iw dev wlan2 scan"
> shows you about your AP)
>
> Regards,
>        Chr
>
>
