Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55814 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1HLOZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 10:25:49 -0400
Received: by fxh19 with SMTP id 19so2339347fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 07:25:47 -0700 (PDT)
From: Alexander Simon <alexander.simon@saxnet.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] mac80211: Add HT operation modes for IBSS
Date: Fri, 12 Aug 2011 16:25:45 +0200
Message-ID: <2276990.7uHyxQX4MO@alex-1> (sfid-20110812_162552_587151_D883185F)
In-Reply-To: <1313152536.4022.9.camel@jlt3.sipsolutions.net>
References: <1888623.Vt5VZUN2cU@alex-1> <1312990268.3128.22.camel@alex-2> <1313152536.4022.9.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Ok, that makes sense. So you need the get_bss_ht() only for fixed mode I
> guess.
Exactly.
> 
> > This should answer your last questions:
> > When not fixed, the BSSID configuration always is preferred. Thus, we
> > would join as HT40 even though not requested.
> > So, when we requsted HT40-, but the IBSS is HT40+, we would work on -.
> 
> ? I think I know what you mean but your example seems .. the wrong way
> around?
Damn, you're right. We would work on HT+, not -, as the BSS config is 
preferred.
> 
> > I wanted to have the opportunity to start HT on an existing IBSS.
> 
> Well that should always be OK?
> 
> > The problem is that legacy station may "kill" the HT configuration:
> > If STA A starts in HT IBSS and lets say Windows STA B joins, B would
> > advertise that IBSS as non-HT as it ignores our HT IE.
> > Then, if STA A dies and STA C joins, it will be non-HT.
> 
> mac80211 is STA C? Would it be a problem to use HT if the IBSS was
> previously non-HT? The old members will ignore it, but other new HT
> members may work OK? IOW -- is it not possible to have a mixed HT/non-HT
> IBSS?
Basically, as to my knowledge, the only difference is that we add HI IEs. Non-
HT stations will ignore these, of course.
A mixed network should be no problem - as long as Greenfield is turned off 
(and i don't turn in on anywhere).

To proceed with basics: I follow a very simple approach (for non-fixed freq):
Use current BSS HT settings. If none exists, use iw config. If no iw config, 
no HT.

But there may be a chance that a N-Node joins a mixed IBSS without an iw HT 
setting.
If it joins from a G-Node's beacon, it won't see or use HT.

That is the reason I inspect later incoming beacons for HT settings and 
reconfigure our beacon skb, when received one. That also resolves the "windows 
example" above.
> 
> > No, pretty sure not. We *are* already joined. That means the TSFs of all
> > stations *within* our BSSID match. TSFs can only tell whitch BSSID is
> > older...
> > So there is no way to distinguish which station first joined.
> > Or am i wrong? That would be good in that case :)
> 
> Oh, no, you're right of course.
As said above, I take *any* HT configuration from *any* beacon and reconfigure 
our node (first beacon wins).

For two different HT configs it is normally distributed which config would 
"win". Identifying the first node would help here...

If there were many stations, with different HT configs, joining at the same 
time, it would take several beacons until the configurations would tilt into a 
homogeneous one.

If you have a good idea - I'll be eager to hear :)
> 
> johannes

I hope I could make my thoughts somewhat more understandable...

Alex
