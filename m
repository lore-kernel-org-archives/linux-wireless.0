Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58242 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753380AbeAaWDg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 17:03:36 -0500
Message-ID: <1517436213.28814.7.camel@sipsolutions.net> (sfid-20180131_230339_689079_AFAFAB44)
Subject: Re: [PATCH 3/6] nl80211: Add CMD_CONTROL_PORT_FRAME API
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org,
        Jouni Malinen <j@w1.fi>
Date: Wed, 31 Jan 2018 23:03:33 +0100
In-Reply-To: <b59b9107-36bb-5fec-e8f0-364431095ad8@gmail.com> (sfid-20180131_230121_881957_8A08B409)
References: <20180131213329.25322-1-denkenz@gmail.com>
         <20180131213329.25322-4-denkenz@gmail.com>
         <1517435126.2189.62.camel@sipsolutions.net>
         <b59b9107-36bb-5fec-e8f0-364431095ad8@gmail.com>
         (sfid-20180131_230121_881957_8A08B409)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-31 at 16:01 -0600, Denis Kenzior wrote:
> Hi Johannes,
> 
> > > + * @NL80211_CMD_CONTROL_PORT_FRAME: Control Port (e.g. PAE) frame TX request
> > > + *	and RX notification.  This command is used both as a request to transmit
> > > + *	a control port frame and as a notification that a control port frame
> > > + *	has been received. %NL80211_ATTR_FRAME is used to specify the
> > > + *	frame contents.  The frame is the raw EAPoL data, without ethernet or
> > > + *	802.11 headers.
> > 
> > Never mind, so it's without Ethernet header. Is that really desirable
> > though? I mean, it could be that the Ethernet address even matters (not
> > sure) and it'd probably be easier to handle in (existing) userspace
> > where Ethernet frames are expected now?
> 
> I also include the from address inside the NL80211 message as ATTR_MAC. 
> The protocol as well.  I wrote the docs first and never updated the 
> little details afterwards.  Will fix.

Good point, I could've seen that.

Still not sure it makes a big difference, but I guess it doesn't really
matter that much (though in a sense it'd be easier to take Ethernet
header apart than putting it back together - but even that can be done
in place in the message buffer)

> > > + nla_put_failure:
> > > +	genlmsg_cancel(msg, hdr);
> > 
> > nit: there's no point in cancelling if you free it (immediately).
> 
> Just following some existing code, but will fix.

Yeah I just never got around to cleaning up that antipattern ... I'll
make an spatch.

johannes
