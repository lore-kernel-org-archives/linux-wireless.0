Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33225 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab3LNVkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 16:40:52 -0500
Received: by mail-wg0-f50.google.com with SMTP id a1so3241506wgh.5
        for <linux-wireless@vger.kernel.org>; Sat, 14 Dec 2013 13:40:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <21163.55288.562709.691719@gargle.gargle.HOWL>
References: <20131211174519.34966001@nehalam.linuxnetplumber.net>
	<21161.18818.926049.511664@gargle.gargle.HOWL>
	<C0DD393A-6810-4CB6-B705-AE801ED5BBBA@gmx.de>
	<21162.54025.118938.614891@gargle.gargle.HOWL>
	<CAA93jw5tOoYGB5Q=vFT6N_G7-KEjGC7=oxH2CwpM9FMT+J_A7g@mail.gmail.com>
	<CAA93jw7Tj+jdapc-OWFr1LDYQDx3r6crafk302jXJaa3va43-A@mail.gmail.com>
	<21163.55288.562709.691719@gargle.gargle.HOWL>
Date: Sat, 14 Dec 2013 13:40:51 -0800
Message-ID: <CAA93jw6P=dbfC1u8ePZPrPMZswj3_gQOEZwHBzto9SvpJTfq5Q@mail.gmail.com> (sfid-20131214_224056_502900_75FD21AE)
Subject: Re: [Cerowrt-devel] Wireless failures 3.10.17-3
From: Dave Taht <dave.taht@gmail.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Sebastian Moeller <sebastian.moeller@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"cerowrt-devel@lists.bufferbloat.net"
	<cerowrt-devel@lists.bufferbloat.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 13, 2013 at 8:00 PM, Sujith Manoharan <sujith@msujith.org> wrote:
> Dave Taht wrote:
>> OK, I couldn't help myself but boot up that release. Wet paint! It
>> successfully brought up
>> the 5ghz radio, but did not manage to assign an ip address to it
>> (netifd bug?) and failed on the 2ghz radio utterly.
>>
>> trying to restart it manually fails to bring up the 5ghz radio as well.
>> Here's an strace of that.
>>
>> http://snapon.lab.bufferbloat.net/~d/hostapd.strace.txt
>>
>> I don't see it beacon, either.
>>
>> Now, I don't have a grip on what started happening two releases back
>> (I was out of town) but I figure it is perhaps more relevant than
>> chasing the DMA tx thing. And ENOTIME for me on this til sunday. I
>> will revert this patch and bisect backwards.
>
> I am not sure how the patch would break things.
>
> Booting OpenWrt trunk (with the patch) on an AP96 reference board seems
> to work fine: http://pastebin.com/3rPSfuad
>
> Sujith

We appear to have a deeper problem. I reverted your patch, moved my build back
to 3.10.21 to match openwrt, felix reverted some stuff in netifd...

... and on first boot, somehow, all the wireless interfaces come up.

After a reboot, most don't. doing openwrt's wifi up is also
interesting with all sorts of failures trying to bring up different
interfaces.

So I suspect netifd has a race still.

Afer we get that sorted, we can move onto trying to poke into the DMA
tx error, or since it seems by hammering on it I can get an interface
up I can move forward a bit, in parallel.

-- 
Dave Täht

Fixing bufferbloat with cerowrt: http://www.teklibre.com/cerowrt/subscribe.html
