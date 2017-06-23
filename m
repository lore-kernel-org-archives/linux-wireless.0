Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44892 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753694AbdFWJVm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 05:21:42 -0400
Message-ID: <1498209700.2595.2.camel@sipsolutions.net> (sfid-20170623_112146_910532_78699D24)
Subject: Re: [RFC 3/6] mac80211: add a TXQ for other powersave-buffered
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Date: Fri, 23 Jun 2017 11:21:40 +0200
In-Reply-To: <3735eb1d-89b5-b4ad-6657-d0d4e9642574@candelatech.com>
References: <20170621235022.25362-1-johannes@sipsolutions.net>
         <20170621235022.25362-3-johannes@sipsolutions.net>
         <63c97c53-af93-107a-a28e-59cebcf01fd6@candelatech.com>
         <1498112650.2246.1.camel@sipsolutions.net>
         <3735eb1d-89b5-b4ad-6657-d0d4e9642574@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-06-22 at 07:43 -0700, Ben Greear wrote:
> 
> On 06/21/2017 11:24 PM, Johannes Berg wrote:
> > On Wed, 2017-06-21 at 17:02 -0700, Ben Greear wrote:
> > > I think a comment for the above code block would be warranted
> > > (and
> > > for ath10k as well).
> > > 
> > > I guess this is the part about dequeueing the frames immediately?
> > 
> > Yeah, I figured it was pretty obvious, but I can add a comment :)
> 
> It is fairly obvious today, but 6 months from now when someone tries
> yet again to figure out WTF is ath10k doing, it will be one more
> piece of mystery code!

:-)

Turns out this won't work well, I had misunderstood the TXQ code.

We do need queueing for these frames, we just do it on the pending
thing in mac80211... that's rather awful, and means we have to
integrate much deeper with ath9k/ath10k to make any progress here.

johannes
