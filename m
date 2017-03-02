Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:34980 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753997AbdCBSPe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 13:15:34 -0500
Received: by mail-ot0-f182.google.com with SMTP id x37so13298940ota.2
        for <linux-wireless@vger.kernel.org>; Thu, 02 Mar 2017 10:14:34 -0800 (PST)
From: Jesse Jones <jjones@uniumwifi.com>
References: <58B09082.7020704@cococorp.com>      (sfid-20170224_205905_277542_E6C0402D)
 <1488202227.28431.9.camel@sipsolutions.net>     <58B487A8.7000602@cococorp.com>
 (sfid-20170227_211019_763670_B9D8D712) <1488443814.8390.3.camel@sipsolutions.net>
In-Reply-To: <1488443814.8390.3.camel@sipsolutions.net>
MIME-Version: 1.0
Date: Thu, 2 Mar 2017 09:41:48 -0800
Message-ID: <d717a94d5c6632b6665b7ac3b319b726@mail.gmail.com> (sfid-20170302_191558_622715_F3A02736)
Subject: RE: [PATCH v2] mac80211: Jitter HWMP MPATH reply frames to reduce
 collision on dense networks.
To: Johannes Berg <johannes@sipsolutions.net>, agreen@cococorp.com,
        linux-wireless@vger.kernel.org
Cc: Jesse Jones <jjones@cococorp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi Alexis,
>
> > This is loosely based on RFC5148, specifically event-triggered message
> > generation as described in section 5.2.
>
> I'm confused. I see how that generally seems to apply to any mobile
> network, but it *does* state up-front that
>     In some instances, these problems can be solved in these lower
>     layers, but in other instances, some help at the network and higher
>     layers is necessary.
>
> I believe 802.11 *does* in fact solve these issues at lower layers. Can
> you explain how you observed any problem in this area?

Well it certainly attempts to via stuff like carrier sense. But that is not
fool proof and any time two routers hear a frame and both decide to forward
it immediately there is a chance that they will both sense the air at the
same time, decide that it is clear, and lose both their forwarded frames due
to a collision. How often that happens is hard to say but we have observed
that exact behavior a few years ago with an 802.11 multicast routing
protocol and adding jitter significantly improved reliability.

An example of where this would be solved at a lower layer would be something
like a TDMA network that has better mechanisms to ensure that multiple
devices do not send at the same time.

> > The frames are not duplicated, but, hopefully offset enough so they
> > don't collide at the receiver
>
> That wasn't my question - my question regarding duplicating was if this
> was
> intended to *suppress* duplicates, but it sounds like not.

No, it's not intended to suppress duplicates.

  -- Jesse
