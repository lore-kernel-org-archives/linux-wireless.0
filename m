Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60328 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751835AbdFVNCt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 09:02:49 -0400
Message-ID: <1498136554.2246.9.camel@sipsolutions.net> (sfid-20170622_150316_936238_96684186)
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
Date: Thu, 22 Jun 2017 15:02:34 +0200
In-Reply-To: <20170621182706.GB92340@google.com> (sfid-20170621_202711_931649_388915DF)
References: <20170525001119.64791-1-briannorris@chromium.org>
         <20170525001119.64791-5-briannorris@chromium.org>
         <87fufk2hmm.fsf@purkki.adurom.net> <20170601173954.GA138807@google.com>
         <87inka77md.fsf@codeaurora.org> <1496999018.2424.5.camel@sipsolutions.net>
         <20170621182706.GB92340@google.com> (sfid-20170621_202711_931649_388915DF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-21 at 11:27 -0700, Brian Norris wrote:
> 
> > I'm not sure what you mean by "we need to atually stop all the
> > virtual interfaces ([...]) first".
> 
> Judging by your following comments, I may have been completely
> mistaken.
> (But that's why I asked you folks!)

:)

> > There are essentially only two/three ways to reach this - data
> > path,
> > which is getting stopped here, and control path (both nl80211 and
> > perhaps ndo ops like start/stop).
> 
> I think I was conflating virtual interfaces with control path (e.g.,
> nl80211 scans, set freq, etc.). The idea is that control operations
> may still get *started* after the above, and it's just plain
> impossible to resolve the races with driver queue teardown if we're
> queueing up new control ops at the same time.

Agree.

> But even if we kill off the wireless_dev's, I suppose there are still
> control interfaces that can talk directly to the wiphy.

Yeah, only a few.

> > Without checking the code now, it seems entirely plausible that
> > this is
> > holding some lock that would lock out the control path entirely,
> > for
> > the duration until the wiphy is actually unregistered?
> > 
> > Actually, you can't unregister with the relevant locks held
> > (without
> > causing deadlocks), so perhaps it's marking the wiphy as
> > unavailable so
> > that all operations fail?
> 
> One of the above two sounds along the right line. But it's something
> I couldn't really figure out how to do quite right.
> 
> Dumb question: how would I mark the wiphy as unavailable? Is there
> something I can do at the cfg80211 level? Or would I really have to
> guard all the cfg80211 entry points into mwifiex with a flag or lock?

There isn't really a good way to do this. You can, of course, call
wiphy_unregister(), but if you could do that you'd already have the
problem solved, I think?

I'm not really familiar enough with the context this happens in - can't
you let all the operations that try to talk to the firmware fail
(because the firmware is dead, or whatever) and then call
wiphy_unregister()?

> Also, IIUC, we need to wait for all control paths to complete (or
> cancel) before we can free up the associated resources; so just
> marking "unavailable" isn't enough.

Yeah, I suppose so. Though if you just do all the freeing after
wiphy_unregister() it'll do that for you?

johannes
