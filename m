Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47718 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754427AbdCBJBk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 04:01:40 -0500
Message-ID: <1488443884.8390.4.camel@sipsolutions.net> (sfid-20170302_100543_143087_70DE8004)
Subject: Re: [PATCH 099/306] mac80211-hwsim: notify user-space about channel
 change.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Date: Thu, 02 Mar 2017 09:38:04 +0100
In-Reply-To: <03ca5a0f-0ab0-76a4-06f3-ead61ab73c94@candelatech.com>
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
         <1487918197.2540.1.camel@sipsolutions.net>
         <03ca5a0f-0ab0-76a4-06f3-ead61ab73c94@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-02-27 at 12:48 -0800, Ben Greear wrote:
> On 02/23/2017 10:36 PM, Johannes Berg wrote:
> > 
> > 
> > > +	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
> > > +			       HWSIM_CMD_NOTIFY);
> > 
> > I think you should use a more specific command name.
> > 
> > > +	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
> > > +		    ETH_ALEN, data->addresses[1].addr))
> > > +		goto nla_put_failure;
> > 
> > and at least also add a more specific identifier like the radio ID.
> > 
> > > +	if (data->channel)
> > > +		center_freq = data->channel->center_freq;
> > > +
> > > +	if (nla_put_u32(skb, HWSIM_ATTR_FREQ, center_freq))
> > > +		goto nla_put_failure;
> > 
> > and have the full channel definition
> 
> You want chandef.center_freq1,
> 	 chandef.center_freq2,
> 	 chandef.width?
> 
> 
> Anything else?

The control channel center_freq is already there so that should be the
full chandef. I guess center_freq2 should be conditional on being non-
zero.

johannes
