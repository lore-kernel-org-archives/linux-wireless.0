Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50444 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753253AbcLMQEd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 11:04:33 -0500
Message-ID: <1481645071.20412.30.camel@sipsolutions.net> (sfid-20161213_170602_582992_C60E6119)
Subject: Re: [PATCH] RFC: Universal scan proposal
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Shmidt <dimitrysh@google.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Dec 2016 17:04:31 +0100
In-Reply-To: <CAH7ZN-wP+9AGrXFUS4RY65-RyfP-J46svBvLdytP2c=QPtiaug@mail.gmail.com> (sfid-20161207_193938_431091_4D11FB31)
References: <94eb2c110db85c2379054172dad0@google.com>
         <1480948100.31788.15.camel@sipsolutions.net>
         <CAH7ZN-wcvoJLTr_zYMwpbjuvMBGwmNhuVYx-MuNU1pOPTf9HEA@mail.gmail.com>
         <1481093061.4092.17.camel@sipsolutions.net>
         <CAH7ZN-wP+9AGrXFUS4RY65-RyfP-J46svBvLdytP2c=QPtiaug@mail.gmail.com>
         (sfid-20161207_193938_431091_4D11FB31)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Well eventually we also have to clear for location if we run out of
> > memory, that usually means dumping them out to the host, no?
> 
> Being out of memory and consuming more memory are different
> things, but I agree - maybe we don't need to worry about it.

Well, reaching the limit of what we're willing to spend on it is
equivalent I guess :)

> > I'm not entirely sure about this case - surely noticing "we can do
> > better now" is still better than waiting for being able to make the
> > perfect decision?
> 
> Maybe we can just keep flag saying that currently available results
> were not received by usual full scan.

Elsewhere we were planning per-channel results, and a cookie to filter
them - perhaps we could have a similar thing where you may even have to
request these scan results specifically with a certain cookie you got
from the scanning, or so. Or indicate the cookie there so you can tie
it back to the scan request somehow?

> So, let's summarize:
> Instead of creating new type of generic scan with special types,
> we want to go with additional expansion of scheduled scan options and
> parameters (in order not to "multiply entities"), including ability
> to send new scheduled scan request without stopping previous one.
> 
> Is it Ok?

Sounds fine to me.

johannes
