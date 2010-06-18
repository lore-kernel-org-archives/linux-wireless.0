Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55607 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab0FRKlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 06:41:01 -0400
Received: by fxm10 with SMTP id 10so510271fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jun 2010 03:40:59 -0700 (PDT)
Subject: Re: IWL3945 problems in 2.6.35-rc1
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1276857009.3638.20.camel@jlt3.sipsolutions.net>
References: <1275395142.14385.6.camel@maxim-laptop>
	 <1276853327.3638.17.camel@jlt3.sipsolutions.net>
	 <1276856384.9114.3.camel@maxim-laptop>
	 <1276857009.3638.20.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 13:40:57 +0300
Message-ID: <1276857657.19036.0.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-18 at 12:30 +0200, Johannes Berg wrote: 
> Maxim,
> 
> Thanks for the quick reply!
> 
> > >  1) with the patch reverted, which is what presumably you're running
> > >     now, can you try
> > >     ifconfig wlan0 allmulti
> > >     ifconfig wlan0 -allmulti
> > > 
> > >     I think this will *break* the driver right now.
> > 
> > I didn't exactly understand how this supposed to break it.
> 
> Ok this needs some more explaining.
> 
> The old code did:
> 
> if (allmulti changed)
> 	"set grp-filter in hw according to allmulti"
> 
> the new code just did
> 
> "set grp-filter in hw according to allmulti"
> 
> 
> During normal operation the "allmulti changed" condition is never true.
> Therefore, the old code, despite being incorrect, never broke things.
> The above would make the condition true, and lead to it being broken
> because it would change to on/off and then the grp-filter in hw would be
> off, although it's required to be on.
> 
> Thus the real bug was there before my change, but it never triggered,
> and when I "optimised away" the condition I broke it.
Got it.

> 
> > >  2) with the patch *not* reverted, apply the patch below and see if that
> > >     fixes the problem as well (if it gets mangled, just remove the one
> > >     CHK() line manually)
> > > 
> > > Actually, (2) is obviously more important to me, but (1) would indicate
> > > that my guess is correct wrt. what's causing the problem
> 
> > I tested (2) and it works.
> 
> Thank you. I'll submit this patch instead.
> 
> johannes
> 

Best regards,
Maxim Levitsky

