Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34916 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752490AbdBMTvc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2017 14:51:32 -0500
Message-ID: <1487015489.19813.9.camel@sipsolutions.net> (sfid-20170213_205135_491915_2F1FDECE)
Subject: Re: VHT 160Mhz and nss related config.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
Date: Mon, 13 Feb 2017 20:51:29 +0100
In-Reply-To: <0f30d7bf-b710-10a8-91e6-bfd75457cf75@candelatech.com>
References: <0082a9e3-83f3-9bc3-af43-b890b91cfd93@candelatech.com>
         <1486969571.5142.3.camel@sipsolutions.net>
         <d53a8fac-b4e0-2fb2-c1e1-c537a2c5e8aa@candelatech.com>
         <1487014657.19813.3.camel@sipsolutions.net>
         <0f30d7bf-b710-10a8-91e6-bfd75457cf75@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-02-13 at 11:42 -0800, Ben Greear wrote:
> On 02/13/2017 11:37 AM, Johannes Berg wrote:
> > 
> > > > This was recently added to the VHT capabilities in the spec,
> > > > see
> > > > Table 9-250 in 802.11-2016.
> > > I don't have that spec...maybe you could post a patch that adds
> > > that
> > > flag and/or other fields to the appropriate header files?  I can
> > > attempt to add support to ath10k after that...
> > 
> > We're planning to, but it's not the most important thing on my list
> > right now ... I'll check where that's at now.
> > 
> > I can't even easily explain it, since it's really complicated.
> 
> So, think it is worthwhile to use the max-rx-rate as a proxy
> until the 'real' spec is implemented?  If 2x2 160Mhz is super
> complicated, and yields no useful throughput improvement, then likely
> it will be a long time before someone implements it properly I'd
> guess.

I don't know, I haven't really followed that discussion.

I don't think implementing the spec here will be really complicated,
there are just a bunch of cases to consider when parsing the VHT
capabilities. I won't do anything with max rate in mac80211, and I
doubt you really should implement any workarounds for not having the
spec here in the driver itself.

johannes
