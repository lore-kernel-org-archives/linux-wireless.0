Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33950 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753713AbdF0UtD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 16:49:03 -0400
Received: by mail-pf0-f179.google.com with SMTP id s66so22149651pfs.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jun 2017 13:49:02 -0700 (PDT)
Date: Tue, 27 Jun 2017 13:48:59 -0700
From: Brian Norris <briannorris@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/14] mwifiex: re-register wiphy across reset
Message-ID: <20170627204858.GB93674@google.com> (sfid-20170627_224925_255969_76826BB0)
References: <20170525001119.64791-1-briannorris@chromium.org>
 <20170525001119.64791-5-briannorris@chromium.org>
 <87fufk2hmm.fsf@purkki.adurom.net>
 <20170601173954.GA138807@google.com>
 <87inka77md.fsf@codeaurora.org>
 <1496999018.2424.5.camel@sipsolutions.net>
 <20170621182706.GB92340@google.com>
 <1498136554.2246.9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1498136554.2246.9.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 22, 2017 at 03:02:34PM +0200, Johannes Berg wrote:
> On Wed, 2017-06-21 at 11:27 -0700, Brian Norris wrote:

> > > Without checking the code now, it seems entirely plausible that
> > > this is
> > > holding some lock that would lock out the control path entirely,
> > > for
> > > the duration until the wiphy is actually unregistered?
> > > 
> > > Actually, you can't unregister with the relevant locks held
> > > (without
> > > causing deadlocks), so perhaps it's marking the wiphy as
> > > unavailable so
> > > that all operations fail?
> > 
> > One of the above two sounds along the right line. But it's something
> > I couldn't really figure out how to do quite right.
> > 
> > Dumb question: how would I mark the wiphy as unavailable? Is there
> > something I can do at the cfg80211 level? Or would I really have to
> > guard all the cfg80211 entry points into mwifiex with a flag or lock?
> 
> There isn't really a good way to do this. You can, of course, call
> wiphy_unregister(), but if you could do that you'd already have the
> problem solved, I think?

That's probably along the right track. There are still some things we'd
need to do properly before that though, and this is where all the
problems are so far. (Also, this is what Kalle was already objecting to;
he didn't think we should be unregistering/recreating the wiphy, but I
think he ended up softening on that a bit.)

For one, I still expect I should be removing the wireless dev's before
unregistering the wihpy, no? Otherwise, there will be existing wdevs
backed by an unregistered wiphy?

And that gets to the heart of another bug: deleting interfaces (e.g.,
"iw dev foo del") races with a lot of stuff -- like see

mwifiex_process_sta_event() ->
  EVENT_EXT_SCAN_REPORT ->
    netif_running(priv->netdev)

Because mwifiex_del_virtual_intf() doesn't stop any outstanding
commands, we can be both deleting the netdev and processing scans for
it.

> I'm not really familiar enough with the context this happens in - can't
> you let all the operations that try to talk to the firmware fail
> (because the firmware is dead, or whatever) and then call
> wiphy_unregister()?

Yes, something like that, barring some of the other bugs mentioned.

> > Also, IIUC, we need to wait for all control paths to complete (or
> > cancel) before we can free up the associated resources; so just
> > marking "unavailable" isn't enough.
> 
> Yeah, I suppose so. Though if you just do all the freeing after
> wiphy_unregister() it'll do that for you?

Yes, I think so. Then part of the problem is probably that some of the
current "cancel command" logic is tied up with the "free command
structures" logic. So we're freeing some stuff too early.

Anyway, those sorts of bugs aside, IIUC the full sequence for teardown
should probably be something like:

1. Stop TX queues
2. Cancel outstanding commands (let them fail or finish, etc.) -- but
   DON'T free their backing resources yet
3. Remove wdevs
4. wiphy_unregister()
5. Free up resources

Current problems are at least:

* we don't do step 4 in the right place (if at all; see this patch)
* step 2 mixes in "free"ing resources too early

Brian
