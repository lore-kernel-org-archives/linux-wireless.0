Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:33161 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdFUS1L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 14:27:11 -0400
Received: by mail-pf0-f169.google.com with SMTP id e7so8903520pfk.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jun 2017 11:27:11 -0700 (PDT)
Date: Wed, 21 Jun 2017 11:27:07 -0700
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
Message-ID: <20170621182706.GB92340@google.com> (sfid-20170621_202746_396916_A7FF1C13)
References: <20170525001119.64791-1-briannorris@chromium.org>
 <20170525001119.64791-5-briannorris@chromium.org>
 <87fufk2hmm.fsf@purkki.adurom.net>
 <20170601173954.GA138807@google.com>
 <87inka77md.fsf@codeaurora.org>
 <1496999018.2424.5.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1496999018.2424.5.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Fri, Jun 09, 2017 at 11:03:38AM +0200, Johannes Berg wrote:
> On Mon, 2017-06-05 at 18:54 +0300, Kalle Valo wrote:
> 
> > > BTW, since you're taking an interest in this code now, can I
> > > trouble you with a question? Looking at mwifiex_uninit_sw() (after
> > > this patchset), you can see a loop like this:
> > > 
> > >         /* Stop data */
> > >         for (i = 0; i < adapter->priv_num; i++) {
> > >                 priv = adapter->priv[i];
> > >                 if (priv && priv->netdev) {
> > >                         mwifiex_stop_net_dev_queue(priv->netdev,
> > > adapter);
> > >                         if (netif_carrier_ok(priv->netdev))
> > >                                 netif_carrier_off(priv->netdev);
> > >                         netif_device_detach(priv->netdev);
> > >                 }
> > >         }
> > > 
> > > That seems to be the only attempt to prevent user space from
> > > talking to the device while we proceed to shut down
> > > (mwifiex_shutdown_drv()). AIUI, that's wholly insufficient, and we
> > > need to actually stop all the virtual interfaces (and possibly the
> > > wiphy as well) first. I'm looking at trying to move the
> > > mwifiex_del_virtual_intf() loop up much further in this function
> > > (but there are other bugs preventing me from doing that yet).
> > > 
> > > Does that sound like the right approach to you? I'm kinda figuring
> > > this should better mimic the mac80211 ieee80211_remove_interfaces()
> > > structure.
> > 
> > Johannes is much better person to answer this (CCed).
> 
> Wait, what? You're throwing me into pretty deep water ;-)

Regardless, thanks for the help :)

> I'm not sure what you mean by "we need to atually stop all the virtual
> interfaces ([...]) first".

Judging by your following comments, I may have been completely mistaken.
(But that's why I asked you folks!)

> There are essentially only two/three ways to reach this - data path,
> which is getting stopped here, and control path (both nl80211 and
> perhaps ndo ops like start/stop).

I think I was conflating virtual interfaces with control path (e.g.,
nl80211 scans, set freq, etc.). The idea is that control operations may
still get *started* after the above, and it's just plain impossible to
resolve the races with driver queue teardown if we're queueing up new
control ops at the same time.

But even if we kill off the wireless_dev's, I suppose there are still
control interfaces that can talk directly to the wiphy.

> Without checking the code now, it seems entirely plausible that this is
> holding some lock that would lock out the control path entirely, for
> the duration until the wiphy is actually unregistered?
> 
> Actually, you can't unregister with the relevant locks held (without
> causing deadlocks), so perhaps it's marking the wiphy as unavailable so
> that all operations fail?

One of the above two sounds along the right line. But it's something I
couldn't really figure out how to do quite right.

Dumb question: how would I mark the wiphy as unavailable? Is there
something I can do at the cfg80211 level? Or would I really have to
guard all the cfg80211 entry points into mwifiex with a flag or lock?

Also, IIUC, we need to wait for all control paths to complete (or
cancel) before we can free up the associated resources; so just marking
"unavailable" isn't enough.

Thanks,
Brian
