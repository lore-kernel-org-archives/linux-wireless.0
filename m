Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:33157 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754257AbdCFWdX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 17:33:23 -0500
Received: by mail-ot0-f170.google.com with SMTP id 19so52982405oti.0
        for <linux-wireless@vger.kernel.org>; Mon, 06 Mar 2017 14:32:05 -0800 (PST)
From: Jesse Jones <jjones@uniumwifi.com>
References: <58B09082.7020704@cococorp.com>              (sfid-20170224_205905_277542_E6C0402D)
 <1488202227.28431.9.camel@sipsolutions.net>             <58B487A8.7000602@cococorp.com>
         (sfid-20170227_211019_763670_B9D8D712) <1488443814.8390.3.camel@sipsolutions.net>
         <d717a94d5c6632b6665b7ac3b319b726@mail.gmail.com>       (sfid-20170302_184150_751594_B059708D)
 <1488803913.5761.11.camel@sipsolutions.net>
In-Reply-To: <1488803913.5761.11.camel@sipsolutions.net>
MIME-Version: 1.0
Date: Mon, 6 Mar 2017 10:01:00 -0800
Message-ID: <bb0cad75534e337507d6b06030909f20@mail.gmail.com> (sfid-20170306_233340_727302_56218F29)
Subject: RE: [PATCH v2] mac80211: Jitter HWMP MPATH reply frames to reduce
 collision on dense networks.
To: Johannes Berg <johannes@sipsolutions.net>, agreen@cococorp.com,
        linux-wireless@vger.kernel.org
Cc: Jesse Jones <jjones@cococorp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Well it certainly attempts to via stuff like carrier sense. But that
> > is not fool proof and any time two routers hear a frame and both
> > decide to forward it immediately there is a chance that they will both
> > sense the air at the same time, decide that it is clear, and lose both
> > their forwarded frames due to a collision. How often that happens is
> > hard to say but we have observed that exact behavior a few years ago
> > with an 802.11 multicast routing protocol and adding jitter
> > significantly improved reliability.
>
> I'm really surprised by this since they both should jitter their
> transmissions
> already between CWmin and CWmax. Is that window somehow really super
> small for what you're doing?

I don't think so.

  -- Jesse
