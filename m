Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55512 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750829AbdF1H2y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 03:28:54 -0400
Message-ID: <1498634929.12531.3.camel@sipsolutions.net> (sfid-20170628_092927_804617_4960F145)
Subject: Re: [PATCH 05/14] mwifiex: re-register wiphy across reset
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Norris <briannorris@chromium.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 28 Jun 2017 09:28:49 +0200
In-Reply-To: <20170627204858.GB93674@google.com> (sfid-20170627_224903_828027_554AFBFB)
References: <20170525001119.64791-1-briannorris@chromium.org>
         <20170525001119.64791-5-briannorris@chromium.org>
         <87fufk2hmm.fsf@purkki.adurom.net> <20170601173954.GA138807@google.com>
         <87inka77md.fsf@codeaurora.org> <1496999018.2424.5.camel@sipsolutions.net>
         <20170621182706.GB92340@google.com>
         <1498136554.2246.9.camel@sipsolutions.net>
         <20170627204858.GB93674@google.com> (sfid-20170627_224903_828027_554AFBFB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-06-27 at 13:48 -0700, Brian Norris wrote:

> > There isn't really a good way to do this. You can, of course, call
> > wiphy_unregister(), but if you could do that you'd already have the
> > problem solved, I think?
> 
> That's probably along the right track. There are still some things
> we'd need to do properly before that though, and this is where all
> the problems are so far. (Also, this is what Kalle was already
> objecting to; he didn't think we should be unregistering/recreating
> the wiphy, but I think he ended up softening on that a bit.)
> 
> For one, I still expect I should be removing the wireless dev's
> before unregistering the wihpy, no? Otherwise, there will be existing
> wdevs backed by an unregistered wiphy?

Yeah, that's true - though once you get rid of those they can't be
accessed any more.

> And that gets to the heart of another bug: deleting interfaces (e.g.,
> "iw dev foo del") races with a lot of stuff -- like see
> 
> mwifiex_process_sta_event() ->
>   EVENT_EXT_SCAN_REPORT ->
>     netif_running(priv->netdev)
> 
> Because mwifiex_del_virtual_intf() doesn't stop any outstanding
> commands, we can be both deleting the netdev and processing scans for
> it.

Huh, well, I guess you need some kind of locking here anyway, since the
user can always do things like deleting the interface while a scan is
running?

> > > Also, IIUC, we need to wait for all control paths to complete (or
> > > cancel) before we can free up the associated resources; so just
> > > marking "unavailable" isn't enough.
> > 
> > Yeah, I suppose so. Though if you just do all the freeing after
> > wiphy_unregister() it'll do that for you?
> 
> Yes, I think so. Then part of the problem is probably that some of
> the current "cancel command" logic is tied up with the "free command
> structures" logic. So we're freeing some stuff too early.
> 
> Anyway, those sorts of bugs aside, IIUC the full sequence for
> teardown should probably be something like:
> 
> 1. Stop TX queues
> 2. Cancel outstanding commands (let them fail or finish, etc.) -- but
>    DON'T free their backing resources yet
> 3. Remove wdevs
> 4. wiphy_unregister()
> 5. Free up resources
> 
> Current problems are at least:
> 
> * we don't do step 4 in the right place (if at all; see this patch)
> * step 2 mixes in "free"ing resources too early

So I'm not sure what you mean by splitting in 2/5 - this seems
reasonable, but I don't understand why something like a scan request
wouldn't be freed while you cancel it in 2? In fact, you really have to
free it before you remove the corresponding wdev, or cfg80211 will
complain?

johannes
