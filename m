Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47714 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754422AbdCBJBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 04:01:36 -0500
Message-ID: <1488443814.8390.3.camel@sipsolutions.net> (sfid-20170302_100314_709414_0D93108B)
Subject: Re: [PATCH v2] mac80211: Jitter HWMP MPATH reply frames to reduce
 collision on dense networks.
From: Johannes Berg <johannes@sipsolutions.net>
To: agreen@cococorp.com, linux-wireless@vger.kernel.org
Cc: Jesse Jones <jjones@cococorp.com>
Date: Thu, 02 Mar 2017 09:36:54 +0100
In-Reply-To: <58B487A8.7000602@cococorp.com> (sfid-20170227_211019_763670_B9D8D712)
References: <58B09082.7020704@cococorp.com>
         (sfid-20170224_205905_277542_E6C0402D) <1488202227.28431.9.camel@sipsolutions.net>
         <58B487A8.7000602@cococorp.com> (sfid-20170227_211019_763670_B9D8D712)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alexis,

> This is loosely based on RFC5148, specifically event-triggered
> message generation as described in section 5.2.

I'm confused. I see how that generally seems to apply to any mobile
network, but it *does* state up-front that
    In some instances, these problems can be solved in these lower
    layers, but in other instances, some help at the network and higher
    layers is necessary.

I believe 802.11 *does* in fact solve these issues at lower layers.

Can you explain how you observed any problem in this area?

> The frames are not duplicated, but, hopefully offset enough so they
> don't collide at the receiver 

That wasn't my question - my question regarding duplicating was if this
was intended to *suppress* duplicates, but it sounds like not.

> (and, since, these are management frames, there is no retransmission
> and we may lose the information contained in them).

That statement isn't true in general, though it does seem that some of
the frames you're touching are actually *multicast* frames and as such
don't have any retries.

> If the two (or more) devices that reply are synchronized well enough,
> carrier sense will tell them that air is clear and messages will go
> out at the same time. It doesn't happen too often, but we found it
> noticeable enough in our testing.

I'm still curious how it happens at all, since NAV synchronisation
should prevent it at a much lower level?

johannes
