Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59347 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaBBFBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Feb 2014 00:01:24 -0500
Received: by mail-wg0-f52.google.com with SMTP id b13so10486776wgh.31
        for <linux-wireless@vger.kernel.org>; Sat, 01 Feb 2014 21:01:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAUTuq--5EUYgKb1Bg9UWZnDAZRqcPZFd=GRVEo-YKictJJWwg@mail.gmail.com>
References: <CAAUTuq83oJJ02tMpT6sK4krkwNFEVZYuzfvsTtRoUX=fVYT9-w@mail.gmail.com>
 <CAJwzM1=0xBkQ0cw-T+zMcAHSZVJsJ7vJmK6O9eisqttn_qGyMA@mail.gmail.com> <CAAUTuq--5EUYgKb1Bg9UWZnDAZRqcPZFd=GRVEo-YKictJJWwg@mail.gmail.com>
From: Andrew Wiley <wiley.andrew.j@gmail.com>
Date: Sat, 1 Feb 2014 23:01:02 -0600
Message-ID: <CAAUTuq-O1BFBmJfYe2xuRfLmNDNKY=V9CkMCM-QCq1iujE3n2w@mail.gmail.com> (sfid-20140202_060149_668983_B2BB32F8)
Subject: Fwd: mwifiex and SD8787: How to create AP interface?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Avinash,

Thanks! That works for me. Would it be possible to add this to the
mwifiex page on wireless.kernel.org? As far as I know, this command is
completely undocumented within iw, and I know I'm not the only
Dreamplug owner experiencing this problem.

As for other issues, I'm seeing a hang in the TX queue on the device
after running an AP for a while, but I'm still gathering information
on that. I'll follow up with another thread.

Thanks,
Andrew

On Sat, Feb 1, 2014 at 9:48 PM, Avinash Patil <avinashapatil@gmail.com> wrote:
> Hi Andrew,
>
> AP interface can be created using iw utility. Command is as follows:
>
> iw dev mlan0 interface add uap0 type __ap
>
> There onwards hostapd can be used to start mwifiex AP operations. Please let
> me know if you face any issues.
>
> Thanks,
> Avinashw
>
> On Feb 2, 2014 8:28 AM, "Andrew Wiley" <wiley.andrew.j@gmail.com> wrote:
>>
>> Hello linux-wireless,
>>
>> I'm trying to get AP mode to work on a Marvell Kirkwood-based
>> Dreamplug with an SD8787 SDIO wireless chipset.
>>
>> Originally, the mwifiex driver would create three interfaces when it
>> loaded - mlan0, uap0, and ptp0, for station mode, AP mode, and PTP
>> mode, respectively. That behavior was removed in commit 1211c (
>>
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/net/wireless/mwifiex?id=1211c961170cedb21c30d5bb7e2033c8720b38db
>> ) because NetworkManager was trying to use all of the interfaces
>> rather than just mlan0.
>>
>> As I understand it, the normal workflow for this is that hostapd
>> changes an interface from station mode to AP mode when it starts up,
>> but when it tries to do this on the mlan0 interface, nl80211 returns
>> Operation Not Supported. Depending on the version of hostapd, it
>> either bails out there or tries to continue and bails out later in
>> setup.
>>
>> If I revert the patch I linked above, the driver creates the uap0
>> interface and I can run an AP with hostapd (although it has some other
>> issues - more on that in a later post).
>>
>> What is the "correct" way to access AP mode with this driver? As far
>> as I'm aware, there are no userspace utilities to directly create an
>> AP-mode interface, and mwifiex doesn't seem to support the normal
>> workflow that hostapd is trying to do.
>>
>> Thanks,
>> Andrew
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
