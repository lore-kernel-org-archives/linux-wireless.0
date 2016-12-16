Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55634 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760712AbcLPKOA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 05:14:00 -0500
Message-ID: <1481883237.27953.22.camel@sipsolutions.net> (sfid-20161216_111424_866028_E27BBE36)
Subject: Re: [RFC V3 03/11] nl80211: add support for gscan
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 16 Dec 2016 11:13:57 +0100
In-Reply-To: <f4f83c57-3e46-b017-fa36-b3776d71670a@broadcom.com> (sfid-20161214_100133_128171_00CEAAA4)
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
         <1481543997-24624-4-git-send-email-arend.vanspriel@broadcom.com>
         <1481645962.20412.41.camel@sipsolutions.net>
         <3dd64ef5-f05e-4a80-0c98-9a2548affd1c@broadcom.com>
         <1481668194.22319.0.camel@sipsolutions.net>
         <f4f83c57-3e46-b017-fa36-b3776d71670a@broadcom.com>
         (sfid-20161214_100133_128171_00CEAAA4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-12-14 at 10:01 +0100, Arend Van Spriel wrote:

> Had to look for "> 16" ;-)

Sorry.

> Here an instance of the tab vs. space issue you mentioned. Will go
> over the patch and fix that.

There were a few, not really interesting though - git would probably
flag it anyway, or checkpatch :)

> > +	if (num_chans > 16)
> > +		return -EINVAL;
> 
> I suspect this is the restriction you were referring to. 

Yes.

> There is no
> reason for this although the android wifi hal has max 16 channels in
> a bucket so I might have picked that up. 

I thought I saw something with a u16 bitmap that seemed related, but I
don't see that now so I'm probably just confused.

> So could a driver have a similar limit and should we add such to the
> gscan capabilities? For instance our firmware api has a nasty
> restriction of 64 channels for all buckets together, eg. can do 4
> buckets of 16 channels each.

We do have a limit of the maximum scan buckets, which seems to be 16
right now. We also have a limit on the number of channels per bucket,
which is also 16, but no combined limit afaict (so 16x16 seems fine).

Maybe we do need some advertisement in that area then? Right now,
wifihal seems to be able to read as capabilities the number of buckets
(wifi_gscan_capabilities), but assumes the number of channels:

const unsigned MAX_CHANNELS                = 16;
const unsigned MAX_BUCKETS                 = 16;

I guess we took that and combined it, and you had more negotiation with
Google ;-)

We may then have to actually advertise the limit you have ("64 channels
combined over all buckets"), unless you can get away with just
advertising 4 buckets (and us saying 16 channels per bucket is enough?)

I'm a bit tempted to make this more forward compatible though and not
hard-limit the number of channels per bucket in the code.

johannes
