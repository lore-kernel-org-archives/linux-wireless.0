Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37288 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751387AbdB0PYl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 10:24:41 -0500
Message-ID: <1488205997.28431.12.camel@sipsolutions.net> (sfid-20170227_162524_214893_C0B2351C)
Subject: Re: [PATCH 160/306] mac80211-hwsim: add rate-limited debugging for
 rx-netlink
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 27 Feb 2017 15:33:17 +0100
In-Reply-To: <c014eb8c-7f93-3831-3375-07f6f6325a6a@candelatech.com>
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
         <1487896109-23851-5-git-send-email-greearb@candelatech.com>
         <1487918388.2540.6.camel@sipsolutions.net>
         <c014eb8c-7f93-3831-3375-07f6f6325a6a@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-02-24 at 07:27 -0800, Ben Greear wrote:
> 
> On 02/23/2017 10:39 PM, Johannes Berg wrote:
> > 
> > > +	    !info->attrs[HWSIM_ATTR_SIGNAL]) {
> > > +		if (net_ratelimit())
> > > +			printk(KERN_DEBUG " hwsim rx-nl: Missing
> > > required attribute\n");
> > 
> > I'm not convinced net_ratelimit() is a good idea, that's a global
> > rate limiter.
> 
> Is there a better rate-limiter w/out hand-crafting something?

You can use include/linux/ratelimit.h to do that?

johannes
