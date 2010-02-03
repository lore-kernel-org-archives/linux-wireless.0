Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13285 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952Ab0BCVtI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 16:49:08 -0500
Subject: Re: Fwd: Atheros AR5418 with Ath9k driver hangs during file
 transfer
From: Pavel Roskin <proski@gnu.org>
To: Iordan Iordanov <iiordanov@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43075fc61002030924ufae1375icadf66713bf1637c@mail.gmail.com>
References: <43075fc61001272207y14e21782hb31efac08ff9f62f@mail.gmail.com>
	 <43075fc61002030846k3218de12o6f0f77fd691499cb@mail.gmail.com>
	 <1265217293.22737.11.camel@mj>
	 <43075fc61002030924ufae1375icadf66713bf1637c@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 03 Feb 2010 16:48:58 -0500
Message-Id: <1265233738.5583.22.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-02-03 at 12:24 -0500, Iordan Iordanov wrote:

> This is a very strange issue indeed. I had 2GB of RAM on the laptop at
> that moment (now they are 1.5GB) and was running nothing else. Hence,
> a memory leak seems more than likely in this situation. I didn't think
> to check the amount of free memory during the problems, but I'll
> certainly give it a shot. I am not experiencing this problem with b43
> or with the proprietary Broadcom driver and my bcm based adapter. The
> only time I've seen it is with ath9k, both the karmic koala one and
> the cutting edge one.
> 
> Can you please give me some hints as to tests I can do for you, or
> debugging I can enable so I can give you more useful information? The
> stall during large transfers is 100% reproducible. It would be
> wonderful if I can show you more debug info and shed some light on the
> situation.

Here's what you can try, in order of intrusiveness.

Use slabtop to see the kernel memory in use.  You should be able to spot
who is hogging memory.

Try MadWifi trunk with your card.  It's easy to compile and should
support AR5418 just fine.  That will show if ath9k is to blame.

Try compat-wireless.  That's a bigger package that would replace all
your wireless drivers, but you won't need to replace your kernel.  That
would help if the memory leak was fixed in the current wireless branch
of the kernel.

Recompile the kernel with CONFIG_DEBUG_KMEMLEAK and follow the
instructions in the kernel sources (Documentation/kmemleak.txt) how to
discover the leaks.

Ask in LKML (linux-kernel@vger.kernel.org), they may know better.

-- 
Regards,
Pavel Roskin
