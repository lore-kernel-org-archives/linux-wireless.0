Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:42227 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604AbZKRTSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 14:18:15 -0500
Received: by iwn8 with SMTP id 8so1131275iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 11:18:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a563a2d5dfdbca955cbac7a65790f443@127.0.0.1>
References: <b0c954732ea30effda967bd97ef30597@127.0.0.1> <43e72e890911171335n3193b63foa6f473ceb659f3ab@mail.gmail.com>
	<a563a2d5dfdbca955cbac7a65790f443@127.0.0.1>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 18 Nov 2009 11:18:01 -0800
Message-ID: <43e72e890911181118o416145ach6b7140341cb6dfc5@mail.gmail.com>
Subject: Re: [ath5k-devel] "iwlist scan" shows same ap twice
To: Florian Engelhardt <flo@dotbox.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org, Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 11:09 AM, Florian Engelhardt <flo@dotbox.org> wrote:
> On Tue, 17 Nov 2009 13:35:24 -0800, "Luis R. Rodriguez" <mcgrof@gmail.com>
> wrote:
>
>> That's wild. What kernel are you using?
>
> # uname -a
> Linux eka 2.6.31-ARCH #1 SMP PREEMPT Tue Nov 10 19:48:17 CET 2009 i686
> Intel(R) Atom(TM) CPU N270 @ 1.60GHz GenuineIntel GNU/Linux
>
>> Have you tried:
>> http://wireless.kernel.org/en/users/Download/stable
>> or
>> http://wireless.kernel.org/en/users/Download
>
> Tried both, no change.
>
>> Can you provide the output of 'iw list', your dmesg, and your 'iw dev
>> wlan0 scan'.
>
> See attached files. Despite that i can add one additional information: I
> have a second Laptop with Intel WLAN Chip, and it shows exactly the same
> behaviour, MA-WLAN two, sometimes three times, with none of the addresses
> being correct.
>
> Somehow, i can not reproduce this kind of behaviour with my own wlan. It
> shows up only one time, not multiple, but it did two days ago on the ath5k
> chipset based netbook

As Bob pointed out your scan shows two beacons received on different BSSes:

00:80:48:5c:86:5d
00:80:48:5c:86:48

The TSF on the second one seems odd though. Do you have access to the
AP? Can you change the channel to see if you see the two beacons on a
new channel?

Can you try rebooting it?

BSS 00:80:48:5c:86:5d (on wlan0)
	TSF: 276107264385 usec (3d, 04:41:47)
	freq: 2457
	beacon interval: 100
	capability: ESS Privacy ShortPreamble (0x0031)
	signal: -92.00 dBm
	SSID: MA-WLAN
	Supported rates: 1.0* 2.0* 5.5 11.0
	DS Parameter set: channel 10
	Country: NA (in/outdoor), data: 0a 02 12
	ERP: <no flags>
	Extended supported rates: 6.0 9.0 12.0 18.0 24.0 36.0 48.0 54.0
	RSN:	 * Version: 1
		 * Group cipher: TKIP
		 * Pairwise ciphers: TKIP CCMP
		 * Authentication suites: PSK
		 * Capabilities: PreAuth (0x0001)
BSS 00:80:48:5c:86:48 (on wlan0)
	TSF: 921985 usec (0d, 00:00:00)
	freq: 2457
	beacon interval: 100
	capability: ESS Privacy ShortPreamble (0x0031)
	signal: -99.00 dBm
	SSID: MA-WLAN
	Supported rates: 1.0* 2.0* 5.5 11.0
	DS Parameter set: channel 10
	Country: NA (in/outdoor), data: 0a 02 12
	ERP: <no flags>
	Extended supported rates: 6.0 9.0 12.0 18.0 24.0 36.0 48.0 54.0
	RSN:	 * Version: 1
		 * Group cipher: TKIP
		 * Pairwise ciphers: TKIP CCMP
		 * Authentication suites: PSK
		 * Capabilities: PreAuth (0x0001)
