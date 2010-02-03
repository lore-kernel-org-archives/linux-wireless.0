Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:53853 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab0BCRYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 12:24:51 -0500
Received: by ywh36 with SMTP id 36so1476717ywh.15
        for <linux-wireless@vger.kernel.org>; Wed, 03 Feb 2010 09:24:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265217293.22737.11.camel@mj>
References: <43075fc61001272207y14e21782hb31efac08ff9f62f@mail.gmail.com>
	 <43075fc61002030846k3218de12o6f0f77fd691499cb@mail.gmail.com>
	 <1265217293.22737.11.camel@mj>
Date: Wed, 3 Feb 2010 12:24:49 -0500
Message-ID: <43075fc61002030924ufae1375icadf66713bf1637c@mail.gmail.com>
Subject: Re: Fwd: Atheros AR5418 with Ath9k driver hangs during file transfer
From: Iordan Iordanov <iiordanov@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pavel,

> The log seems to show that you are very short on memory.  The backtraces
> come from "page allocation failure", not from any conditions in the
> ath9k driver.  You have a lot of free swap, so I assume it's the
> non-swappable memory.  This is also evidenced by lowmem_reserve:
>
> lowmem_reserve[]: 0 0 0 0
>
> I haven't heard of any major memory leaks in ath9k, so I would not blame
> it on the driver unless you can show that you don't get that problem
> with another driver.

This is a very strange issue indeed. I had 2GB of RAM on the laptop at
that moment (now they are 1.5GB) and was running nothing else. Hence,
a memory leak seems more than likely in this situation. I didn't think
to check the amount of free memory during the problems, but I'll
certainly give it a shot. I am not experiencing this problem with b43
or with the proprietary Broadcom driver and my bcm based adapter. The
only time I've seen it is with ath9k, both the karmic koala one and
the cutting edge one.

Can you please give me some hints as to tests I can do for you, or
debugging I can enable so I can give you more useful information? The
stall during large transfers is 100% reproducible. It would be
wonderful if I can show you more debug info and shed some light on the
situation.

>
> In the future, please send kernel logs produced by the dmesg command.
> This will avoid the timestamps from syslogd (especially since you
> already have kernel timestamps) and it would ensure that no kernel
> messages are skipped by syslogd because of their low urgency.

I had already lost the dmesg output due to a reboot. But in the
future, I'll make sure to grab the info before rebooting. I will
follow up with more results.

Cheers,
Iordan

-- 
The conscious mind has only one thread of execution.
