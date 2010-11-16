Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61400 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab0KPDe7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 22:34:59 -0500
Received: by qyk4 with SMTP id 4so251447qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Nov 2010 19:34:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101116000605.GA5679@tux>
References: <1289528843-21982-1-git-send-email-lrodriguez@atheros.com>
	<AANLkTimKdqoWx2FtvJ9HG3Yj0ofROMDNo30=FJv1vVGG@mail.gmail.com>
	<20101112202732.GI25089@tux>
	<20101116000605.GA5679@tux>
Date: Mon, 15 Nov 2010 22:34:57 -0500
Message-ID: <AANLkTinOdQMi=vF1CgLmdmMQTC_jayV361KsxTanAoy5@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Fix regulatory bug with multiple cards with a
 delayed CRDA response
From: Mark Mentovai <mark@moxienet.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis-

Excellent, this does the trick!

I’ve got some review comments. This looks longish, but many of these
suggestions are minor and will probably result in a simpler and better
implementation.

- The reg_process_hint call in regulatory_core bypasses the queue. I
don’t think this is a great idea. regulatory_core call should probably
go through queue_regulatory_request instead. Since the kernel
regulatory code doesn’t maintain any sort of synchronization with user
space, I think it’s real important to avoid having more than one
request pending at any time. It would be bad if there were a pending
request out, CRDA was slow to respond, and then a regulatory_hint_core
call came in from restore_regulatory_settings expecting to set things
back to a clean slate. That would put two outstanding requests out at
once. When CRDA responds, the kernel wouldn’t be able to distinguish
between the responses, it would possibly process them out of order,
and with only a single last_request to refer to, it would process them
incorrectly even if handled in the correct order.

- With the above change to regulatory_core, last_request becomes
extraneous: it’s a rough synonym for the head of reg_requests_list.
You may be able to get rid of last_request altogether. This is a more
invasive change and should almost certainly not be a part of this
patch, but it’s something to keep in mind.

- This will spin on reg_delayed_work/reg_process_pending_hints if user
space never provides regulatory data. (You point this out in your
subsequent e-mail.) The way things are implemented in your patch, I
don’t see any point to spinning in reg_delayed_work. You could just
call schedule_work from where you set last_request->processed to true
if reg_requests_list is non-empty.

- Also looking at delayed work, it looks like there’s a way to call
schedule_delayed_work when delayed work is already scheduled, and I
think that the workqueue implementation considers this a bug. Assume
that reg_process_pending_hints calls schedule_delayed_work. Then,
before the delay expires, regulatory_hint calls
queue_regulatory_request, which calls schedule_work. In that case,
reg_process_pending_hints can be called again before the delay expires
from the earlier pass through, and you’ll hit this case (kernel bug.)

- I don’t think queue_regulatory_request needs to call schedule_work
if there was already something in reg_requests_list. I guess that
making the call conditional on an empty list would work around the
above problem too, although you’d still have to worry about the
schedule_work call in regulatory_hint_found_beacon—more on that in a
sec. Still, this doesn’t feel as clean or simple to me as just getting
rid of the delayed work. Then you could keep this schedule_work call
and just let the workqueue’s one-shot nature sort it all out for you.

- I haven’t looked at reg_process_pending_beacon_hints or
regulatory_hint_found_beacon much, but I suspect that they don’t have
anything to do with ordering CRDA calls, and it might be better to
just separate the beacon stuff and the regulatory request stuff into
their own work_structs. Be especially careful if you decide to keep
them on the same work_struct AND you keep the delayed work—see above.

- Your comment describing @processed in regulatory.h could be
reworded: “the currently regulatory domain set” and “when a the last
request”.

I agree that the most serious concern is the one you pointed out in
your e-mail about the “missing or sick CRDA” problem. I think that
this is particularly scary because CRDA is needed pretty much right
from the first time the module initializes. If at any point CRDA is
missing, there’s no way to ensure that regulatory data is correct,
even if CRDA shows up later. I think that the only reasonable thing to
do is to just ensure that there’s only one request outstanding at a
time. I’m very opposed to reissuing CRDA requests as long as there’s
no way to synchronize by tying a CRDA response to a specific kernel
request. Still, it might not be a bad idea to log something if CRDA
doesn’t respond for, say, five seconds, and then to log something
again if CRDA finally shows up. Getting rid of the delayed work spin
in the kernel means that at least the rest of the system won’t suffer
if CRDA goes to lunch.

It sucks that user space isn’t as reliable as kernel space and that
it’s possible for a transient problem like “no more processes” or “no
more FDs” in user space to wedge the regulatory code like this, but I
guess that was already considered and dismissed when the
regulatory-CRDA interface was designed.

Thanks for working on this.

Mark
