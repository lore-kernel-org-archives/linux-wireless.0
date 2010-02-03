Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:6752 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428Ab0BCRPD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 12:15:03 -0500
Subject: Re: Fwd: Atheros AR5418 with Ath9k driver hangs during file
 transfer
From: Pavel Roskin <proski@gnu.org>
To: Iordan Iordanov <iiordanov@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43075fc61002030846k3218de12o6f0f77fd691499cb@mail.gmail.com>
References: <43075fc61001272207y14e21782hb31efac08ff9f62f@mail.gmail.com>
	 <43075fc61002030846k3218de12o6f0f77fd691499cb@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 03 Feb 2010 12:14:53 -0500
Message-Id: <1265217293.22737.11.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-02-03 at 11:46 -0500, Iordan Iordanov wrote:

> When I start a file transfer over wireless (from an NFS mount), I
> achieve about 8.5MB/s for a while, and then the transfer hangs. Also,
> any other network communication is hung as well it seems indefinitely.

The log seems to show that you are very short on memory.  The backtraces
come from "page allocation failure", not from any conditions in the
ath9k driver.  You have a lot of free swap, so I assume it's the
non-swappable memory.  This is also evidenced by lowmem_reserve:

lowmem_reserve[]: 0 0 0 0

I haven't heard of any major memory leaks in ath9k, so I would not blame
it on the driver unless you can show that you don't get that problem
with another driver.

In the future, please send kernel logs produced by the dmesg command.
This will avoid the timestamps from syslogd (especially since you
already have kernel timestamps) and it would ensure that no kernel
messages are skipped by syslogd because of their low urgency.

-- 
Regards,
Pavel Roskin
