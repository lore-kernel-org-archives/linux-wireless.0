Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42658 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966699AbcKLVIw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 Nov 2016 16:08:52 -0500
Message-ID: <1478984929.4226.3.camel@sipsolutions.net> (sfid-20161112_220855_652635_C0C400EB)
Subject: Re: [RFC] change mac80211_hwsim tx_rates to ieee80211_tx_rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        linux-wireless@vger.kernel.org
Date: Sat, 12 Nov 2016 22:08:49 +0100
In-Reply-To: <dcc2ec52-abe0-3182-e7f5-d1df40fd492b@uni-rostock.de> (sfid-20161111_182223_315895_6A05EDD8)
References: <dcc2ec52-abe0-3182-e7f5-d1df40fd492b@uni-rostock.de>
         (sfid-20161111_182223_315895_6A05EDD8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> So I would propose to put the whole struct into the netlink messages,

This is a terrible idea, since internal changes to this struct would
break the userland API/ABI. hwsim seems perhaps less important than
most APIs, but there is wmediumd etc. already.

> but I think that will break up the communication to e.g. bob
> copelands
> wmediumd and similar simulations. I would like to have our
> Implementation working with mainline kernels and therefore ask how we
> could achieve this easily.
> 
> Obviously, we could define another field in the hwsim messages, but
> as bob copeland already stated, significantly more information within
> the netlink messages could  intensify the timing overhead of hwsim.

I don't think we have any other choice but add the relevant fields as
proper attributes.

johannes
