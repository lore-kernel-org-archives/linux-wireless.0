Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:48740 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbZFIL0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 07:26:23 -0400
Received: by fxm9 with SMTP id 9so2885782fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2009 04:26:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com>
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com>
	<f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com>
	<3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 9 Jun 2009 13:26:04 +0200
Message-ID: <69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com>
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 9, 2009 at 1:59 AM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
> On Mon, Jun 8, 2009 at 6:11 PM, Stefan
> Steuerwald<salsasepp@googlemail.com> wrote:
>> Dear all,
>>
>> I have tried unsuccessfully to obtain any WLAN USB stick with a
>> chipset that supports AP mode.
>> This is for testing a mobile device that is supposed to work as an AP
>> with iPod/iPhone life forms.
>>
>> There only seem to be two choices: p54usb-based (preferred) and
>> rt2500-based devices. No luck in buying any of the listed devices
>> (they seem obsolete).
>> Turns out that anything current I can buy probably has RTL8187, RT73
>> or RT2800, and anything used I get from ebay is not what it seems
>> ("Netgear WG111 v2" can mean at least two different things I know of,
>> both unsuitable).
>>
>> Any pointers on
>> a) where to click-and-buy a stick that supports AP mode, or
>> b) whom to send money in exchange for a used stick are VERY much appreciated.
>
> At the risk of being yelled at, if you use the vendor driver (not the
> rw driver), Zydas zd1211 based USB stick can be made to work in AP
> mode. Caveats are (1) the vendor driver is known *not* to work on
> 64-bit host, and unlikely on anything but 32-bit intel linux, (2) you
> need a bunch of patches I posted earlier to build against current
> kernels. Search the archive.
> The zd1211 is quite popular for USB sticks.

This will cause problems for power-saving clients, as the ZD1211 chip
has no multicast buffering feature, something that must be done in
hardware even for softmac cards. (Possibly this can be worked around
in the firmware, but so far, no firmware source code has been released
for the ZD1211/AR2524, only for the ZD1221/AR9170.)

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
