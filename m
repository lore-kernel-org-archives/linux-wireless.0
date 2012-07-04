Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab2GDKtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 06:49:45 -0400
Message-ID: <1341398983.12432.0.camel@jlt3.sipsolutions.net> (sfid-20120704_124949_270873_53E38893)
Subject: Re: Kernel oops in __netif_schedule() for at76c50x-usb
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Date: Wed, 04 Jul 2012 12:49:43 +0200
In-Reply-To: <1341395171.4482.10.camel@jlt3.sipsolutions.net> (sfid-20120704_114618_455741_41EF0E8A)
References: <4FF1BC71.4070002@lwfinger.net>
	 (sfid-20120702_172127_238924_ED185EFD) <1341243087.19642.20.camel@jlt3.sipsolutions.net>
	 <4FF1C887.8090009@lwfinger.net>
	 (sfid-20120702_181310_720968_3FE88ADC) <1341250736.19642.22.camel@jlt3.sipsolutions.net>
	 <4FF225AC.8020205@lwfinger.net>
	 (sfid-20120703_005025_974399_3EFA8A16) <1341395171.4482.10.camel@jlt3.sipsolutions.net>
	 (sfid-20120704_114618_455741_41EF0E8A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-04 at 11:46 +0200, Johannes Berg wrote:

> > >> Although you may want to change the enable code path, some patch will be needed
> > >> to prevent a regression in 3.5. If this is the one, you may add a "Tested-by"
> > >> for me.
> > >
> > > Thanks. Could you try this patch instead? I think it makes more sense.
> > >
> > > http://p.sipsolutions.net/c3e9b814a409ca11.txt
> > 
> > That one fails and gives the oops in __netif_schedule.
> 
> Hmmm, that's odd. I'll try to reproduce this to be able to track it
> better.

Ok, strange. I can reproduce the original problem easily with hwsim, but
with this new patch, which should be equivalent to the old, it's fixed:

http://p.sipsolutions.net/d78d8740ad2d15b4.txt

Can you try just this patch?

johannes

