Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:64689 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaAWQT1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 11:19:27 -0500
Received: by mail-ig0-f171.google.com with SMTP id uy17so17376949igb.4
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 08:19:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKKnJbeVqvUUnW7E7yw3cvF_1DKw5_+xpYJ+jB3U-=VL=vQyVg@mail.gmail.com>
References: <CAKKnJbe=eBMzB3Bp7qkYvwSTr0x=g-bZkz9dQ6HUihZE5rc5iw@mail.gmail.com>
	<CAFED-jmUF9u=sLfVuCSy3rjmB4DM9x6BCLhJaq2CrY9MV6Wycg@mail.gmail.com>
	<CAKKnJbeVqvUUnW7E7yw3cvF_1DKw5_+xpYJ+jB3U-=VL=vQyVg@mail.gmail.com>
Date: Thu, 23 Jan 2014 11:19:24 -0500
Message-ID: <CAKKnJbe+bqnTv3BOai3YoyMzNZ3w3gY460O0d1GiZDZaZYg5Uw@mail.gmail.com> (sfid-20140123_171930_977841_CF5BCB25)
Subject: Re: wlcore-spi crash
From: Charles <hobbesc7@gmail.com>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> When I modprobe wlcore-spi I get a kernel crash.  Has anyone
>>> encountered this?  I found a similar problem here:
>>> http://marc.info/?l=linux-wireless&m=135212370625698&w=2
>>>
>>> I tried adding the patch mentioned there to backports-3.12-1, but I
>>> get this build error: "error: 'struct wl1271' has no member named
>>> 'set_power'"
>>>
>>> Here's the crash:
>>>
>>> [   98.325693] Unable to handle kernel NULL pointer dereference at
>>> virtual address 00000000
>>> [   98.334171] pgd = c0004000
>>> [   98.337031] [00000000] *pgd=00000000
>>> [   98.340791] Internal error: Oops: 80000007 [#1]
>>> [   98.345524] Modules linked in: wlcore_spi(O) wl12xx(O) wlcore(O)
>>> mac80211(O) cfg80211(O) compat(O) autofs4
>>> [   98.355661] CPU: 0    Tainted: G           O  (3.2.0)
>>> [   98.364120] PC is at 0x0
>>> [   98.366846] LR is at wl12xx_set_power_on+0x30/0x150 [wlcore]
>>
>> I think this should help:
>> http://www.spinics.net/lists/linux-wireless/msg98589.html
>>
>
> As I mentioned above, I get a compile error with that patch: the
> wl1271 struct doesn't have "set_power".

I got the patch to compile by adding "void (*set_power)(bool enable);"
to the wl1271 struct in wlcore.h.  Now the driver loads without
crashing, but I get a new error:

[   70.166191] wl1271_spi spi1.1: SPI read busy-word timeout!
[   70.208452] wl1271_spi spi1.1: SPI read busy-word timeout!
[   70.252324] wl1271_spi spi1.1: SPI read busy-word timeout!
[   70.294749] wl1271_spi spi1.1: SPI read busy-word timeout!
[   70.300515] wlcore: WARNING Top register access timed out.
[   70.306260] wlcore: ERROR couldn't get hw info
