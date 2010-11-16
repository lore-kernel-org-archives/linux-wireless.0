Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23601 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab0KPU1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 15:27:33 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 12:27:20 -0800
Date: Tue, 16 Nov 2010 12:27:30 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Mark Mentovai <mark@moxienet.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Fix regulatory bug with multiple cards with
 a delayed CRDA response
Message-ID: <20101116202730.GA1783@tux>
References: <1289528843-21982-1-git-send-email-lrodriguez@atheros.com>
 <AANLkTimKdqoWx2FtvJ9HG3Yj0ofROMDNo30=FJv1vVGG@mail.gmail.com>
 <20101112202732.GI25089@tux>
 <20101116000605.GA5679@tux>
 <AANLkTinOdQMi=vF1CgLmdmMQTC_jayV361KsxTanAoy5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <AANLkTinOdQMi=vF1CgLmdmMQTC_jayV361KsxTanAoy5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 15, 2010 at 07:34:57PM -0800, Mark Mentovai wrote:
> Luis-
> 
> Excellent, this does the trick!
> 
> I’ve got some review comments. This looks longish, but many of these
> suggestions are minor and will probably result in a simpler and better
> implementation.
> 
> - The reg_process_hint call in regulatory_core bypasses the queue. I
> don’t think this is a great idea. regulatory_core call should probably
> go through queue_regulatory_request instead. Since the kernel
> regulatory code doesn’t maintain any sort of synchronization with user
> space, I think it’s real important to avoid having more than one
> request pending at any time. It would be bad if there were a pending
> request out, CRDA was slow to respond, and then a regulatory_hint_core
> call came in from restore_regulatory_settings expecting to set things
> back to a clean slate. That would put two outstanding requests out at
> once. When CRDA responds, the kernel wouldn’t be able to distinguish
> between the responses, it would possibly process them out of order,
> and with only a single last_request to refer to, it would process them
> incorrectly even if handled in the correct order.

Good point, I skipped the queue in the original work as I ran into
issues using it during the cfg80211's init process. Its odd, I had
complaints about using a mutex. Anyway, its using a mutex now and
it should work I think so I'll try it.

> - With the above change to regulatory_core, last_request becomes
> extraneous: it’s a rough synonym for the head of reg_requests_list.
> You may be able to get rid of last_request altogether. This is a more
> invasive change and should almost certainly not be a part of this
> patch, but it’s something to keep in mind.

Eh, not really, we'd have to keep around the request on the queue, and
we do not. So last_request really is the last process/being processed
request.

> - This will spin on reg_delayed_work/reg_process_pending_hints if user
> space never provides regulatory data. (You point this out in your
> subsequent e-mail.) The way things are implemented in your patch, I
> don’t see any point to spinning in reg_delayed_work. You could just
> call schedule_work from where you set last_request->processed to true
> if reg_requests_list is non-empty.

I also thought of doing it this way but for some reason which I forget
I ended up doing it using the delayed work.

> - Also looking at delayed work, it looks like there’s a way to call
> schedule_delayed_work when delayed work is already scheduled, and I
> think that the workqueue implementation considers this a bug. Assume
> that reg_process_pending_hints calls schedule_delayed_work. Then,
> before the delay expires, regulatory_hint calls
> queue_regulatory_request, which calls schedule_work. In that case,
> reg_process_pending_hints can be called again before the delay expires
> from the earlier pass through, and you’ll hit this case (kernel bug.)

Sure, thought of this as well, but left it as a after-thought excercise
for optimization.

> - I don’t think queue_regulatory_request needs to call schedule_work
> if there was already something in reg_requests_list. 

You mean because we'd be iterating over the list already?

> I guess that
> making the call conditional on an empty list would work around the
> above problem too, although you’d still have to worry about the
> schedule_work call in regulatory_hint_found_beacon—more on that in a
> sec. Still, this doesn’t feel as clean or simple to me as just getting
> rid of the delayed work. Then you could keep this schedule_work call
> and just let the workqueue’s one-shot nature sort it all out for you.

I'll review this a bit more, thanks for the pointers.

> - I haven’t looked at reg_process_pending_beacon_hints or
> regulatory_hint_found_beacon much, but I suspect that they don’t have
> anything to do with ordering CRDA calls, 

Right, they are used to send hints to cfg80211 when a beacon is found.
When a beacon from an AP is found we tell cfg80211, it in turn will
lift passive-scan and no-ibss flags from the channel if the card is
world roaming. This is done for all non-DFS and non-channel-12-13-14.

> and it might be better to
> just separate the beacon stuff and the regulatory request stuff into
> their own work_structs.

Don't see the point. I'd rather just clean up the possible theoretical
races you've pointed out.

> Be especially careful if you decide to keep
> them on the same work_struct AND you keep the delayed work—see above.

Sure.

> - Your comment describing @processed in regulatory.h could be
> reworded: “the currently regulatory domain set” and “when a the last
> request”.

Thanks.

> I agree that the most serious concern is the one you pointed out in
> your e-mail about the “missing or sick CRDA” problem. I think that
> this is particularly scary because CRDA is needed pretty much right
> from the first time the module initializes.

Not if you have CONFIG_CFG80211_INTERNAL_REGDB and are OK with
a static update of the regulatory database or if you are just
using world roaming cards.

> If at any point CRDA is
> missing, there’s no way to ensure that regulatory data is correct,

Yes there is, this was by design, you'll just world roam.

> even if CRDA shows up later.

If CRDA shows up later then yes, the only way to get a regulatory
domain applied to the card if it was not world roaming would be
to reload the module right now. This is a separate issue though
and I think we should treat it as such.

> I think that the only reasonable thing to
> do is to just ensure that there’s only one request outstanding at a
> time. I’m very opposed to reissuing CRDA requests as long as there’s
> no way to synchronize by tying a CRDA response to a specific kernel
> request. 

Sure, well so I believe udev is supposed to queue these things,
not sure, either way I am pretty sure if a udev event was issued
and CRDA was not present we would not get anything going. One idea
here is to implement a CRDA wrapper that uses inotify for /sbin/crda
and queues up requests until CRDA pops in. Can't say I have strong
motivation for this right now though, chances of you not having
CRDA are pretty slim ;) but its a way to resolve this IMHO.

> Still, it might not be a bad idea to log something if CRDA
> doesn’t respond for, say, five seconds, and then to log something
> again if CRDA finally shows up.

I'd rather leave this to userspace and just decide ourselves what
to do in the kernel if we never get a response.

I think that with the implementation I used but with your suggestion
with avoiding a delayed work struct might be best. If no CRDA response
goes through then we simply world roam unless you had
CONFIG_CFG80211_INTERNAL_REGDB.

Whatyda think?

> Getting rid of the delayed work spin
> in the kernel means that at least the rest of the system won’t suffer
> if CRDA goes to lunch.

Agreed wholeheartedly.

> It sucks that user space isn’t as reliable as kernel space and that
> it’s possible for a transient problem like “no more processes” or “no
> more FDs” in user space to wedge the regulatory code like this, but I
> guess that was already considered and dismissed when the
> regulatory-CRDA interface was designed.

That's userspace's problem :D but yea we can implement the inotify
thingy, that would help. Patches welcomed.

> Thanks for working on this.

Thanks for reporting this and working with me on testing it, and of course
all the suggestions.

  Luis
