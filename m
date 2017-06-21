Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:35998 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752075AbdFURsd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 13:48:33 -0400
Received: by mail-pg0-f53.google.com with SMTP id u62so60661152pgb.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jun 2017 10:48:33 -0700 (PDT)
Date: Wed, 21 Jun 2017 10:48:30 -0700
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 05/14] mwifiex: re-register wiphy across reset
Message-ID: <20170621174829.GA92340@google.com> (sfid-20170621_194907_240706_8184E7DE)
References: <20170525001119.64791-1-briannorris@chromium.org>
 <20170525001119.64791-5-briannorris@chromium.org>
 <87fufk2hmm.fsf@purkki.adurom.net>
 <20170601173954.GA138807@google.com>
 <87inka77md.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87inka77md.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle (and Johannes; I'll reply to Johannes response separately too),

On Mon, Jun 05, 2017 at 06:54:18PM +0300, Kalle Valo wrote:
> Brian Norris <briannorris@chromium.org> writes:
> > That's not to say that there aren't such bugs out there. I'd still be
> > willing to bet there are. And IMO, it seems wise to just do the same
> > teardown/setup as one would do for (e.g.) 'rmmod', to prevent exposing
> > *too* many new permutations of "wiphy is available but rest of the
> > driver is torn down".
> 
> This feels like a sledge hammer approach causing all sort of problems

Yes, it is a sledge hammer. But I'm working with what we have here. With
this approach, it's also easier to tell that things aren't out-of-sync,
since I'm never quite sure how much state was held in the firmware (and
now won't match what user space thinks). A full removal / re-init makes
this clear -- user space should expect *everything* to be reset.

I'm open to learning better approaches if possible, but this also might
be difficult if I don't get any support from Marvell on this. (They seem
quite happy to let sleeping dogs lie.)

> for user space and I really like the mac80211 approach more. For
> example, if an ath10k firmware crash happens user only sees a few second
> pause in data traffic and a warning in kernel log, otherwise everything
> happens behind the scenes. Of course there are very likely races
> somewhere but at least I haven't seen that many reports related to
> firmware restart functionality.

Yes, that all sounds nice. But for my sake, can you describe better
what's actually going on there (e.g., can you point me at which code
does this)? I'm really not familiar with mac80211 (though I was aware of
the above general behavior). But to my knowledge, mac80211 drivers keep
a lot more state managed in the kernel, so it's a little easier and
more natural to get the driver/FW back to "the same state" than it is
with a full-MAC driver.

> > But if none of this is convincing to you, I can take a stab at a
> > different solution.
> 
> I don't have any problem applying this patch but more about being
> curious why doing it like this. And hopefully finding a less intrusive
> solution in the future.

OK, sure. I'll see what I can do, but I don't see an easy path at the
moment toward fixing (i.e., completely rewriting) this long-standing
driver behavior.

[trim]

Thanks,
Brian
