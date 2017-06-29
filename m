Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34499 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752609AbdF2SqB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 14:46:01 -0400
Received: by mail-pf0-f177.google.com with SMTP id s66so54656747pfs.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jun 2017 11:46:01 -0700 (PDT)
Date: Thu, 29 Jun 2017 11:45:56 -0700
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
Message-ID: <20170629184555.GA127431@google.com> (sfid-20170629_204633_766269_762EBA22)
References: <20170525001119.64791-1-briannorris@chromium.org>
 <20170525001119.64791-5-briannorris@chromium.org>
 <87fufk2hmm.fsf@purkki.adurom.net>
 <20170601173954.GA138807@google.com>
 <87inka77md.fsf@codeaurora.org>
 <1496999018.2424.5.camel@sipsolutions.net>
 <20170621182706.GB92340@google.com>
 <1498136554.2246.9.camel@sipsolutions.net>
 <20170627204858.GB93674@google.com>
 <1498634929.12531.3.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1498634929.12531.3.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Wed, Jun 28, 2017 at 09:28:49AM +0200, Johannes Berg wrote:
> On Tue, 2017-06-27 at 13:48 -0700, Brian Norris wrote:
> 
> > > There isn't really a good way to do this. You can, of course, call
> > > wiphy_unregister(), but if you could do that you'd already have the
> > > problem solved, I think?
> > 
> > That's probably along the right track. There are still some things
> > we'd need to do properly before that though, and this is where all
> > the problems are so far. (Also, this is what Kalle was already
> > objecting to; he didn't think we should be unregistering/recreating
> > the wiphy, but I think he ended up softening on that a bit.)
> > 
> > For one, I still expect I should be removing the wireless dev's
> > before unregistering the wihpy, no? Otherwise, there will be existing
> > wdevs backed by an unregistered wiphy?
> 
> Yeah, that's true - though once you get rid of those they can't be
> accessed any more.

Right. That's the whole idea for the current reset implementation in
this driver anyway.

> > And that gets to the heart of another bug: deleting interfaces (e.g.,
> > "iw dev foo del") races with a lot of stuff -- like see
> > 
> > mwifiex_process_sta_event() ->
> >   EVENT_EXT_SCAN_REPORT ->
> >     netif_running(priv->netdev)
> > 
> > Because mwifiex_del_virtual_intf() doesn't stop any outstanding
> > commands, we can be both deleting the netdev and processing scans for
> > it.
> 
> Huh, well, I guess you need some kind of locking here anyway, since the
> user can always do things like deleting the interface while a scan is
> running?

Yes, some sort of locking, and maybe ability to cancel outstanding
commands on just the targeted interface. I gave the locking a try myself
previously and got something sorta working, before getting distracted by
other problems. I also reported this directly to Marvell to see if they
could be bothered to fix it. They might be working on that.

But actually I think the rmmod or reset code path has this a little
easier, since we're fine just killing all outstanding commands and
interfaces. So these two problems are somewhat orthogonal.

> > > > Also, IIUC, we need to wait for all control paths to complete (or
> > > > cancel) before we can free up the associated resources; so just
> > > > marking "unavailable" isn't enough.
> > > 
> > > Yeah, I suppose so. Though if you just do all the freeing after
> > > wiphy_unregister() it'll do that for you?
> > 
> > Yes, I think so. Then part of the problem is probably that some of
> > the current "cancel command" logic is tied up with the "free command
> > structures" logic. So we're freeing some stuff too early.
> > 
> > Anyway, those sorts of bugs aside, IIUC the full sequence for
> > teardown should probably be something like:
> > 
> > 1. Stop TX queues
> > 2. Cancel outstanding commands (let them fail or finish, etc.) -- but
> >    DON'T free their backing resources yet

I also failed to mention "don't queue new FW commands". The driver does
this before step 1 currently, though the code isn't beautiful:

mwifiex_send_cmd()
...
        if (adapter->surprise_removed) {
                mwifiex_dbg(adapter, ERROR,
                            "PREP_CMD: card is removed\n");
                return -1;
        }
... // continue on to prepare and queue (or sync) the command

static void mwifiex_uninit_sw(struct mwifiex_adapter *adapter)
{
...
        adapter->surprise_removed = true;
... // continue on to step 1, 2, ...


(And now that I think about it, I'm pretty sure there's a race in there
somewhere... Someone could easily miss the "surprise removed" check, grab a
command node, and miss out on step 2 (since the command isn't sitting on any of
the queues that get "canceled" yet). I believe this can easily blow up once
they try to queue the command, as we are no longer ready to handle the command
queue...)

> > 3. Remove wdevs
> > 4. wiphy_unregister()
> > 5. Free up resources
> > 
> > Current problems are at least:
> > 
> > * we don't do step 4 in the right place (if at all; see this patch)
> > * step 2 mixes in "free"ing resources too early
> 
> So I'm not sure what you mean by splitting in 2/5 - this seems
> reasonable, but I don't understand why something like a scan request
> wouldn't be freed while you cancel it in 2? In fact, you really have to
> free it before you remove the corresponding wdev, or cfg80211 will
> complain?

I haven't validated all the related code, but I think the problem isn't
that a scan is still being processed after the wdev is removed. The
problem is simply that we've canceled the command (and it will
"complete" before the wdev removal), but we're freeing the associated
resource before the caller is actually completely done with it. Or in
more detail:

The driver keeps a pool of FW command structures (like 'struct
cmd_ctrl_node') that are queued in various ways. We cancel everything in
step 2 (mwifiex_adapter_cleanup() -> mwifiex_cancel_all_pending_cmd()),
but we can't free the pool (mwifiex_free_cmd_buffer()) until step 5, since
there can be wdev or wiphy control paths that are still exiting (and using one
of the cmd nodes' "condition" variables) until we've finished waiting on them
with step 3 or 4. But currently we free these buffers in step 2
(mwifiex_adapter_cleanup() -> mwifiex_free_cmd_buffer()).

I could have missed something else, and my description above definitely
isn't exhaustive. But AFAICT, this straightens out a solution for some
of the problems I've noticed recently. (But then, I noticed another
problem, as noted above...ugh.)

Anyway, thanks for the pointers so far!

Brian
