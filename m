Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45532 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbdGDOKm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Jul 2017 10:10:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/14] mwifiex: re-register wiphy across reset
References: <20170525001119.64791-1-briannorris@chromium.org>
        <20170525001119.64791-5-briannorris@chromium.org>
        <87fufk2hmm.fsf@purkki.adurom.net>
        <20170601173954.GA138807@google.com> <87inka77md.fsf@codeaurora.org>
        <1496999018.2424.5.camel@sipsolutions.net>
        <20170621182706.GB92340@google.com>
        <1498136554.2246.9.camel@sipsolutions.net>
        <20170627204858.GB93674@google.com>
Date: Tue, 04 Jul 2017 17:10:24 +0300
In-Reply-To: <20170627204858.GB93674@google.com> (Brian Norris's message of
        "Tue, 27 Jun 2017 13:48:59 -0700")
Message-ID: <87podgi97z.fsf@kamboji.qca.qualcomm.com> (sfid-20170704_161105_261969_1DE0E3A4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(I was on vacation and inbox exploded again)

Brian Norris <briannorris@chromium.org> writes:

> On Thu, Jun 22, 2017 at 03:02:34PM +0200, Johannes Berg wrote:
>> On Wed, 2017-06-21 at 11:27 -0700, Brian Norris wrote:
>
>> > > Without checking the code now, it seems entirely plausible that
>> > > this is
>> > > holding some lock that would lock out the control path entirely,
>> > > for
>> > > the duration until the wiphy is actually unregistered?
>> > > 
>> > > Actually, you can't unregister with the relevant locks held
>> > > (without
>> > > causing deadlocks), so perhaps it's marking the wiphy as
>> > > unavailable so
>> > > that all operations fail?
>> > 
>> > One of the above two sounds along the right line. But it's something
>> > I couldn't really figure out how to do quite right.
>> > 
>> > Dumb question: how would I mark the wiphy as unavailable? Is there
>> > something I can do at the cfg80211 level? Or would I really have to
>> > guard all the cfg80211 entry points into mwifiex with a flag or lock?
>> 
>> There isn't really a good way to do this. You can, of course, call
>> wiphy_unregister(), but if you could do that you'd already have the
>> problem solved, I think?
>
> That's probably along the right track. There are still some things we'd
> need to do properly before that though, and this is where all the
> problems are so far. (Also, this is what Kalle was already objecting to;
> he didn't think we should be unregistering/recreating the wiphy, but I
> think he ended up softening on that a bit.)

Just to clarify I was more like hoping there would be a better way to do
it, not really objecting the current method, but I didn't realise that
of course it's harder to do a transparent firmware restart with fullmac
design. And certainly what are you doing now is much much better than
doing nothing after a firmware crash.

-- 
Kalle Valo
