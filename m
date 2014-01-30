Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f194.google.com ([209.85.223.194]:54804 "EHLO
	mail-ie0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaA3WfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 17:35:06 -0500
Received: by mail-ie0-f194.google.com with SMTP id ar20so1459453iec.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jan 2014 14:35:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKKnJbe+bqnTv3BOai3YoyMzNZ3w3gY460O0d1GiZDZaZYg5Uw@mail.gmail.com>
References: <CAKKnJbe=eBMzB3Bp7qkYvwSTr0x=g-bZkz9dQ6HUihZE5rc5iw@mail.gmail.com>
	<CAFED-jmUF9u=sLfVuCSy3rjmB4DM9x6BCLhJaq2CrY9MV6Wycg@mail.gmail.com>
	<CAKKnJbeVqvUUnW7E7yw3cvF_1DKw5_+xpYJ+jB3U-=VL=vQyVg@mail.gmail.com>
	<CAKKnJbe+bqnTv3BOai3YoyMzNZ3w3gY460O0d1GiZDZaZYg5Uw@mail.gmail.com>
Date: Thu, 30 Jan 2014 17:20:08 -0500
Message-ID: <CAKKnJbfTUf01uLxS199GP_BMkjEw5LWBKNGQQ4v1Q98gPkp2qw@mail.gmail.com> (sfid-20140130_233611_669587_0FA08622)
Subject: Re: wlcore-spi crash
From: Charles <hobbesc7@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>> When I modprobe wlcore-spi I get a kernel crash.  Has anyone
>>>> encountered this?  I found a similar problem here:
>>>> http://marc.info/?l=linux-wireless&m=135212370625698&w=2
>>>>
>>>> I tried adding the patch mentioned there to backports-3.12-1, but I
>>>> get this build error: "error: 'struct wl1271' has no member named
>>>> 'set_power'"
>>>>
>>>> Here's the crash:
>>>>
>>>> [   98.325693] Unable to handle kernel NULL pointer dereference at
>>>> virtual address 00000000
>>>> [   98.334171] pgd = c0004000
>>>> [   98.337031] [00000000] *pgd=00000000
>>>> [   98.340791] Internal error: Oops: 80000007 [#1]
>>>> [   98.345524] Modules linked in: wlcore_spi(O) wl12xx(O) wlcore(O)
>>>> mac80211(O) cfg80211(O) compat(O) autofs4
>>>> [   98.355661] CPU: 0    Tainted: G           O  (3.2.0)
>>>> [   98.364120] PC is at 0x0
>>>> [   98.366846] LR is at wl12xx_set_power_on+0x30/0x150 [wlcore]
>>>
>>> I think this should help:
>>> http://www.spinics.net/lists/linux-wireless/msg98589.html
>>>
>>
>> As I mentioned above, I get a compile error with that patch: the
>> wl1271 struct doesn't have "set_power".
>
> I got the patch to compile by adding "void (*set_power)(bool enable);"
> to the wl1271 struct in wlcore.h.  Now the driver loads without
> crashing, but I get a new error:
>

So my hack was obviously not the right solution, because I'm not
powering the chip.  I know that in wlcore\spi.c, I need to set a
.power function in spi_ops (i.e. .power = wl12xx_spi_power).  And I
already have a wl12xx_platform_data with a .set_power function defined
in my board platform file.  But I don't know how to access my platform
file's set_power function from the wl12xx_spi_power function in spi.c.

In other words, I can' figure out how to do this from wlcore\spi.c:

static int wl12xx_spi_power(struct device *child, bool enable) {

    set_power_function_defined_in_my_board_platform_file(enable);

}
