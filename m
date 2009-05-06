Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:61659 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbZEFUeQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 16:34:16 -0400
Subject: Re: [BUG] Crda oopses the system
From: Pavel Roskin <proski@gnu.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241606838.18657.1.camel@maxim-laptop>
References: <1241499867.4816.18.camel@maxim-laptop>
	 <43e72e890905051146n48bdad57s9db40a6e016cb81b@mail.gmail.com>
	 <1241606838.18657.1.camel@maxim-laptop>
Content-Type: text/plain
Date: Wed, 06 May 2009 16:34:16 -0400
Message-Id: <1241642056.3289.6.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

(Dropping the Intel list; I not subscribed to it and I don't think it's
Intel specific)

On Wed, 2009-05-06 at 13:47 +0300, Maxim Levitsky wrote:
> On Tue, 2009-05-05 at 11:46 -0700, Luis R. Rodriguez wrote:
> > On Mon, May 4, 2009 at 10:04 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > > Here what I see:
> > >
> > >
> > >> May  4 16:35:14 maxim-laptop kernel: [16939.109054] Process crda (pid: 29344, threadinfo ffff88007deaa000, task ffff880067369600)
> > >> May  4 16:35:14 maxim-laptop kernel: [16939.109058] Stack:
> > >> May  4 16:35:14 maxim-laptop kernel: [16939.109061]  0000000000000034 ffff88003fb8a640 0000000000000000 ffff8800634f5c20
> > >> May  4 16:35:14 maxim-laptop kernel: [16939.109069]  ffff88007deaba28 ffffffffa00eb3d0 000004f87deab9c8 ffff88003fb8a640
> > >> May  4 16:35:14 maxim-laptop kernel: [16939.109077]  0000000000000000 ffff8800634f5c24 ffff8800634f5c2c ffff8800634f5c34
> > >> May  4 16:35:14 maxim-laptop kernel: [16939.109086] Call Trace:
> > >> May  4 16:35:14 maxim-laptop kernel: [16939.109091]  [<ffffffffa00eb3d0>] nl80211_set_reg+0x100/0x2b0 [cfg80211]

It would be great if you run:
gdb /lib/modules/`uname -r`/kernel/net/wireless/cfg80211.ko

And then inside gdb:
l *nl80211_set_reg+0x100

And then send us the output.

-- 
Regards,
Pavel Roskin
