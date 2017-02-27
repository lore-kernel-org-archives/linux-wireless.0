Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37092 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751435AbdB0Ox4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 09:53:56 -0500
Message-ID: <1488206078.28431.13.camel@sipsolutions.net> (sfid-20170227_155414_072442_A77D2BEC)
Subject: Re: [PATCH 099/306] mac80211-hwsim: notify user-space about channel
 change.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 27 Feb 2017 15:34:38 +0100
In-Reply-To: <e7500b9a-5020-0dcc-5d67-4a2d12704c33@candelatech.com>
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
         <1487918197.2540.1.camel@sipsolutions.net>
         <e7500b9a-5020-0dcc-5d67-4a2d12704c33@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-02-24 at 07:39 -0800, Ben Greear wrote:
> 
> On 02/23/2017 10:36 PM, Johannes Berg wrote:
> > 
> > 
> > > +	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
> > > +			       HWSIM_CMD_NOTIFY);
> > 
> > I think you should use a more specific command name.
> 
> My idea was that other attributes could be added over time without
> having to add a new cmd-id, so that is why I left it general.  If you
> still want a different command, do you want it to be something like
> 'HWSIM_CMD_CHANNEL_CHANGE' ?

We won't run out of command IDs any time soon, so I don't really see a
problem with using a new one for all of those things if needed.

But having a general NOTIFY just means that the application will have
to parse the attributes and understand what means what - that seems
like a case of the cure being worse than the disease?

johannes
