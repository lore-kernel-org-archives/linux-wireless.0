Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37366 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab0JBQk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 12:40:57 -0400
Received: by wyb28 with SMTP id 28so3825403wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 09:40:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010021332.09809.chunkeey@googlemail.com>
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com>
 <AANLkTimmSaQsBdTLAjZT2_8sQ9V7r4OvAzGATr+bmOxG@mail.gmail.com>
 <AANLkTimXGQLnSaU6ASeRPkw1YThF18_zC7peu_uCeGKU@mail.gmail.com> <201010021332.09809.chunkeey@googlemail.com>
From: Saqeb Akhter <saqeb.akhter@gmail.com>
Date: Sat, 2 Oct 2010 12:40:35 -0400
Message-ID: <AANLkTi=nGL2HiU1LFuPaxsjTOzbhGp5vC5DH5TAu8Fxd@mail.gmail.com>
Subject: Re: carl9170: wnda3100 only 54MB/s
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a scan before a dropout:
-------------------------------------------------------------------------------------------
sakhter@sakhter-laptop:~$ sudo iw dev wlan1 scan
BSS 30:46:9a:10:49:f7 (on wlan1) -- associated
	TSF: 35799960635 usec (0d, 09:56:39)
	freq: 5220
	beacon interval: 100
	capability: ESS ShortSlotTime (0x0401)
	signal: -51.00 dBm
	last seen: 7988 ms ago
	SSID: sakhter-5g
	Supported rates: 6.0* 9.0 12.0* 18.0 24.0* 36.0 48.0 54.0
	DS Parameter set: channel 44
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec
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
-------------------------------------------------------------------------------------------

After a dropout -

	TSF: 36735900731 usec (0d, 10:12:15), So I guess that's not the reason.


For the QoS I'm not sure how the Video is being sent it's over samba,
most likely just BE.


On Sat, Oct 2, 2010 at 7:32 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Saturday 02 October 2010 08:18:07 Saqeb Akhter wrote:
>> I guess you were right about it being unstable - almost unusable for
>> video streaming.
> Video streaming? Does your application use QoS AC_VI(deo) for streaming,
> or just bulk data (AC_BE(st effort))?
>
>> sakhter@sakhter-laptop:~$ dmesg | grep Reason
>> [ 1166.512087] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
>> [ 1526.059997] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
>> [ 2125.324356] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
>> [ 2845.783011] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
>> [ 3565.994832] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
>> [ 5128.903576] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
>> [ 5726.046230] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
>> [ 6326.042938] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
>> [ 6835.689445] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
>> [ 7197.337060] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
>>
>> Seems to disconnect quite frequently. Even tried uninstalling networkmanager.
> Reason 7 is: [AP received a] class 3 (data) frame from non-associated STA.
> This can happen when your are "actively" disassociating from the AP (unlikely),
> when the AP thinks you are out-of-reach(unlikely, since your signal seems to
> be strong and PSM isn't enabled by default) or when the AP crashes and resets.
>
> You should check your AP's TSF. (iw dev wlanX scan).
> It should not go backwards.
> (But if it does, then it might be because carl9170 has accidentally DoSed it?!)
>
> Regards,
>        Christian
>
