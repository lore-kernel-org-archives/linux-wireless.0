Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:56522 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbaBCWCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 17:02:36 -0500
Received: by mail-we0-f181.google.com with SMTP id w61so3308001wes.12
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 14:02:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJwzM1kQJvfZwPi_suBSgCEquAHvYduwRWcM01==nT_TVd0d0g@mail.gmail.com>
References: <CAAUTuq_bgXcfKquXR+ATumO7xkyTE_WLUvUOMZ7bPYCP0_XnuQ@mail.gmail.com>
 <CAJwzM1kzbvy7UnjJerJ8EmUxvp5GYPeKS-9988SgxfoQrv-Zjw@mail.gmail.com>
 <CAAUTuq_LnUCTBaHndBiLDk0ge+055YJJMY4Ni+bV7PrYq_KSHA@mail.gmail.com> <CAJwzM1kQJvfZwPi_suBSgCEquAHvYduwRWcM01==nT_TVd0d0g@mail.gmail.com>
From: Andrew Wiley <wiley.andrew.j@gmail.com>
Date: Mon, 3 Feb 2014 16:02:14 -0600
Message-ID: <CAAUTuq9oU7+=_sjcix0WuSUp5_5OVRXK1cJdtRDtR1obaJrV1Q@mail.gmail.com> (sfid-20140203_230239_521765_FD67E473)
Subject: Re: mwifiex and SD8787: TX queue timeout in AP mode
To: Avinash Patil <avinashapatil@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Avinash,

On Mon, Feb 3, 2014 at 12:47 AM, Avinash Patil <avinashapatil@gmail.com> wrote:
> Hi Andrew,
>
> I would suggest few steps:
> 1. Disable hostapd probe response generation with following setting in
> hostadp conf
> send_probe_response=0

This doesn't seem to have an effect on the issue.

> 2. I see lot of prints for realloc headroom. While this is harmless,
> if you have any setting to increase this headroom from network stack,
> it would be good.

I'm not sure what userspace setting would correspond to this. The only
thing that looks related is /proc/sys/net/core/rmem_default and
/proc/sys/net/core/wmem_default, but those seem to operate on memory
pools rather than individual buffers.

>
> It looks like Tx to FW has timed out. Last TX happened at Line 11384.
> This issue is different from earlier one.
> Can you please let me know FW version?

mwifiex logs this on startup:
mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0 (14.66.9.p96)

> Does this issue happens with station interface as well?

I haven't really made use of station mode much, but I just tried it
and it seems stable. The first time I tried to connect, the driver had
a command timeout while scanning and the card dropped out, but the
second time, it connected and has stayed stable for 30 minutes or so.
The network I'm connected to uses WPA2. I'll continue to monitor the
box to see if the queue hangs.

Thanks,
Andrew
