Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46836 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753644AbdCFMig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 07:38:36 -0500
Message-ID: <1488803913.5761.11.camel@sipsolutions.net> (sfid-20170306_133839_289429_8585257E)
Subject: Re: [PATCH v2] mac80211: Jitter HWMP MPATH reply frames to reduce
 collision on dense networks.
From: Johannes Berg <johannes@sipsolutions.net>
To: Jesse Jones <jjones@uniumwifi.com>, agreen@cococorp.com,
        linux-wireless@vger.kernel.org
Cc: Jesse Jones <jjones@cococorp.com>
Date: Mon, 06 Mar 2017 13:38:33 +0100
In-Reply-To: <d717a94d5c6632b6665b7ac3b319b726@mail.gmail.com> (sfid-20170302_184150_751594_B059708D)
References: <58B09082.7020704@cococorp.com>
                 (sfid-20170224_205905_277542_E6C0402D) <1488202227.28431.9.camel@sipsolutions.net>
                 <58B487A8.7000602@cococorp.com>
         (sfid-20170227_211019_763670_B9D8D712) <1488443814.8390.3.camel@sipsolutions.net>
         <d717a94d5c6632b6665b7ac3b319b726@mail.gmail.com>
         (sfid-20170302_184150_751594_B059708D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Well it certainly attempts to via stuff like carrier sense. But that
> is not fool proof and any time two routers hear a frame and both
> decide to forward it immediately there is a chance that they will
> both sense the air at the same time, decide that it is clear, and
> lose both their forwarded frames due to a collision. How often that
> happens is hard to say but we have observed that exact behavior a few
> years ago with an 802.11 multicast routing protocol and adding jitter
> significantly improved reliability.

I'm really surprised by this since they both should jitter their
transmissions already between CWmin and CWmax. Is that window somehow really super small for what you're doing?

johannes
