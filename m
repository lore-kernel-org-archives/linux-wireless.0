Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41521 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760139Ab0FRKaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 06:30:12 -0400
Subject: Re: IWL3945 problems in 2.6.35-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1276856384.9114.3.camel@maxim-laptop>
References: <1275395142.14385.6.camel@maxim-laptop>
	 <1276853327.3638.17.camel@jlt3.sipsolutions.net>
	 <1276856384.9114.3.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 12:30:09 +0200
Message-ID: <1276857009.3638.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim,

Thanks for the quick reply!

> >  1) with the patch reverted, which is what presumably you're running
> >     now, can you try
> >     ifconfig wlan0 allmulti
> >     ifconfig wlan0 -allmulti
> > 
> >     I think this will *break* the driver right now.
> 
> I didn't exactly understand how this supposed to break it.

Ok this needs some more explaining.

The old code did:

if (allmulti changed)
	"set grp-filter in hw according to allmulti"

the new code just did

"set grp-filter in hw according to allmulti"


During normal operation the "allmulti changed" condition is never true.
Therefore, the old code, despite being incorrect, never broke things.
The above would make the condition true, and lead to it being broken
because it would change to on/off and then the grp-filter in hw would be
off, although it's required to be on.

Thus the real bug was there before my change, but it never triggered,
and when I "optimised away" the condition I broke it.

> >  2) with the patch *not* reverted, apply the patch below and see if that
> >     fixes the problem as well (if it gets mangled, just remove the one
> >     CHK() line manually)
> > 
> > Actually, (2) is obviously more important to me, but (1) would indicate
> > that my guess is correct wrt. what's causing the problem

> I tested (2) and it works.

Thank you. I'll submit this patch instead.

johannes

