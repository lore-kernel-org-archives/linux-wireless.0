Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0082.outbound.protection.outlook.com ([104.47.41.82]:13203
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751473AbdLEUbq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 15:31:46 -0500
Date: Tue, 5 Dec 2017 23:31:30 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Marianna Carrera <mcarrera@quantenna.com>
Subject: Re: [RFC PATCH 2/2] nl80211: implement beacon change notifier
Message-ID: <20171205203129.flqhqrwa5y7uhgoz@bars> (sfid-20171205_213154_033963_C639083E)
References: <20171109094024.9085-1-sergey.matyukevich.os@quantenna.com>
 <20171109094024.9085-2-sergey.matyukevich.os@quantenna.com>
 <1510565429.30497.10.camel@sipsolutions.net>
 <20171113115841.3dcrcjqnp543kndi@bars>
 <1510575765.30497.38.camel@sipsolutions.net>
 <20171115153547.kkunkrfcivoqcsq2@bars>
 <1511784144.5456.12.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1511784144.5456.12.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

> > In our case, we are experimenting with applications running along with
> > hostapd and enabling band steering and client roaming functionality.
> > As I mentioned, various approaches are being examined, including
> > both pure nl80211-based approach as well as adding direct hooks
> > to hostapd.
> 
> To be honest, I'm torn on this.
> 
> On the one hand, I think it's fairly reasonable functionality, but on
> the other hand I'm not sure we should encourage such separate
> approaches - it seems to me that will lead to a lot of fragmentation
> and much harder debuggability for upstream where these things get used.
> 
> It's also a bunch of code we have to maintain, for nothing that seems
> of use to the community - since it's the sort of flexibility explicitly
> designed for non-public code (otherwise it could just be part of
> hostapd; actually it could even if it were non-public, at least in
> theory, unless you're planning it as a value-add thing to go with an
> open source hostapd ...).
> 
> So while I don't want to stop you entirely in your tracks with this,
> I'd really prefer you explore other options regarding where to put your
> client steering functionality, perhaps even working on hostapd.

Well, our preferred approach for these experiments is going to be
communication with hostapd instead of kernel. One of the reasons
is that GET_CMD_BEACON is not enough. We have to enable multiple
listeners of mgmt frames as well. However that feature was rejected
earlier this year: https://patchwork.kernel.org/patch/9615697

By the way, speaking about GET_CMD_BEACON and its possible users in the
community. There is already a stub for it in nl80211 uapi headers. What
was the original idea for that ? Or was it just a placeholder added
together with SET_BEACON ?

Regards,
Sergey
