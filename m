Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53888 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751526AbdFIJDo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 05:03:44 -0400
Message-ID: <1496999018.2424.5.camel@sipsolutions.net> (sfid-20170609_112032_148095_AE25BFE4)
Subject: Re: [PATCH 05/14] mwifiex: re-register wiphy across reset
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Fri, 09 Jun 2017 11:03:38 +0200
In-Reply-To: <87inka77md.fsf@codeaurora.org>
References: <20170525001119.64791-1-briannorris@chromium.org>
         <20170525001119.64791-5-briannorris@chromium.org>
         <87fufk2hmm.fsf@purkki.adurom.net> <20170601173954.GA138807@google.com>
         <87inka77md.fsf@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-06-05 at 18:54 +0300, Kalle Valo wrote:

> > BTW, since you're taking an interest in this code now, can I
> > trouble you with a question? Looking at mwifiex_uninit_sw() (after
> > this patchset), you can see a loop like this:
> > 
> >         /* Stop data */
> >         for (i = 0; i < adapter->priv_num; i++) {
> >                 priv = adapter->priv[i];
> >                 if (priv && priv->netdev) {
> >                         mwifiex_stop_net_dev_queue(priv->netdev,
> > adapter);
> >                         if (netif_carrier_ok(priv->netdev))
> >                                 netif_carrier_off(priv->netdev);
> >                         netif_device_detach(priv->netdev);
> >                 }
> >         }
> > 
> > That seems to be the only attempt to prevent user space from
> > talking to the device while we proceed to shut down
> > (mwifiex_shutdown_drv()). AIUI, that's wholly insufficient, and we
> > need to actually stop all the virtual interfaces (and possibly the
> > wiphy as well) first. I'm looking at trying to move the
> > mwifiex_del_virtual_intf() loop up much further in this function
> > (but there are other bugs preventing me from doing that yet).
> > 
> > Does that sound like the right approach to you? I'm kinda figuring
> > this should better mimic the mac80211 ieee80211_remove_interfaces()
> > structure.
> 
> Johannes is much better person to answer this (CCed).


Wait, what? You're throwing me into pretty deep water ;-)

I'm not sure what you mean by "we need to atually stop all the virtual
interfaces ([...]) first".

There are essentially only two/three ways to reach this - data path,
which is getting stopped here, and control path (both nl80211 and
perhaps ndo ops like start/stop).

Without checking the code now, it seems entirely plausible that this is
holding some lock that would lock out the control path entirely, for
the duration until the wiphy is actually unregistered?

Actually, you can't unregister with the relevant locks held (without
causing deadlocks), so perhaps it's marking the wiphy as unavailable so
that all operations fail?

johannes
