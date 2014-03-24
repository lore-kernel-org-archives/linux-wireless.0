Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42289 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753445AbaCXSds (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 14:33:48 -0400
In-Reply-To: <CADqH6VxgwbZkFgEkpiaabKekijeU+e=DMg0VVHoiXBQmjQfE0Q@mail.gmail.com>
References: <CADqH6VygZFB4HEgcSesZB0cAhB4OvGnST+9mvTjw_QEAD_6QnQ@mail.gmail.com> <1384765780.22010.42.camel@porter.coelho.fi> <CADqH6VxgwbZkFgEkpiaabKekijeU+e=DMg0VVHoiXBQmjQfE0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
From: Luca Coelho <luca@coelho.fi>
Date: Mon, 24 Mar 2014 20:32:47 +0200
To: Jaya Kumar <jayakumar.lkml@gmail.com>
CC: linux-wireless@vger.kernel.org
Message-ID: <a84c8a1f-f71b-48ca-9c8e-782c19aef609@email.android.com> (sfid-20140324_193351_503431_C7E3C8F2)
Subject: Re: WL12xx support for WL1270 and ti-connectivity firmware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On March 24, 2014 2:03:12 PM EET, Jaya Kumar <jayakumar.lkml@gmail.com> wrote:
>On Mon, Nov 18, 2013 at 5:09 PM, Luca Coelho <luca@coelho.fi> wrote:
>>
>> Same as above... If this wl1270 is indeed based on the wl1271, it
>should
>> probably work.  With the driver you may need to add some new SDIO IDs
>> for it to be recognized though.
>>
>
>Hi,
>
>I'm now bringing up the board with the wl1270. I'm using 3.0.35 (stuck
>on this kernel version due to other drivers).

Do you mean out-of-tree drivers? If they were in the mainline you should be able to upgrade.

Anyway, you should at least try to use compat (now called backport) to get the latest wireless stuff.

> The good news is that
>the chip is detected and wl12xx/wl12xx_sdio loads. However, I haven't
>been able to get it to get any scan results and can't associate with
>any AP (even open).

Usually this happens because you're not getting any interrupts. Are you sure the WLAN IRQ GPIO is correctly configured?
 


>---
>mmc1: card claims to support voltages below the defined range. These
>will be ignored.
>mmc1: queuing unknown CIS tuple 0x91 (3 bytes)
>mmc1: new SDIO card at address 0001
>...
>I'm using ti-linux-firmware-wl12xx-r3-m1-rc2.tar.gz for the nvs and fw
>files.
>
>root@freescale ~$ modprobe wl12xx
>root@freescale ~$ modprobe wl12xx_sdio
>add wake up source irq 106
>wl1271: loaded
>wl1271: initialized
>root@freescale ~$ ifconfig wlan0 up
>wl1271: firmware booted (Rev 6.1.5.50.69)
>
>root@freescale ~$ iwlist wlan0 scan

You should really be using the iw tool instead of the old wireless-tools.  This probably won't make a difference in your case, but there's no reason to use a tool that had been deprecated for years...


>wlan0     No scan results
>---
>
>I retried with debug_level=256 (scan debug) and I see a lot of output
>appended below. I haven't figured out how to interpret them yet. I'd
>be grateful for any advice/suggestions on this.

There's nothing very useful in those kids
It just shows that the scan command was issued but you never got the scan complete interrupt.

--
Luca.

