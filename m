Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56142 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab0KPVed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 16:34:33 -0500
Received: by qwh6 with SMTP id 6so989745qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 13:34:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101116202730.GA1783@tux>
References: <1289528843-21982-1-git-send-email-lrodriguez@atheros.com>
	<AANLkTimKdqoWx2FtvJ9HG3Yj0ofROMDNo30=FJv1vVGG@mail.gmail.com>
	<20101112202732.GI25089@tux>
	<20101116000605.GA5679@tux>
	<AANLkTinOdQMi=vF1CgLmdmMQTC_jayV361KsxTanAoy5@mail.gmail.com>
	<20101116202730.GA1783@tux>
Date: Tue, 16 Nov 2010 16:34:32 -0500
Message-ID: <AANLkTini7hkDiAr1-ddsSWCBOG0KRT7zYNLFJLZa=y+J@mail.gmail.com>
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

Luis R. Rodriguez wrote:
> On Mon, Nov 15, 2010 at 07:34:57PM -0800, Mark Mentovai wrote:
>> - I don’t think queue_regulatory_request needs to call schedule_work
>> if there was already something in reg_requests_list.
>
> You mean because we'd be iterating over the list already?

Yeah, but as I pointed out later, it doesn’t matter as long as you get
rid of the delayed work. It’s fine to make multiple calls to
schedule_work even if work is already pending since there’s no longer
any worry about overscheduling the timer.

>> and it might be better to
>> just separate the beacon stuff and the regulatory request stuff into
>> their own work_structs.
>
> Don't see the point. I'd rather just clean up the possible theoretical
> races you've pointed out.

OK. I was thinking that it would be cleaner to only have the work
queue run tasks that you know are ready to run, since you’ve got
pretty good signals for when to try running each. I was thinking that
this would avoid doing the unnecessary atomic operations in case there
was a storm of beacon work to do but nothing that involved CRDA
responses. Again, as long as the delayed thing is gone, this isn’t
strictly necessary. I’m just trying to keep things off the CPU as much
as possible.

>> I agree that the most serious concern is the one you pointed out in
>> your e-mail about the “missing or sick CRDA” problem. I think that
>> this is particularly scary because CRDA is needed pretty much right
>> from the first time the module initializes.
>
> Not if you have CONFIG_CFG80211_INTERNAL_REGDB and are OK with
> a static update of the regulatory database or if you are just
> using world roaming cards.

Sure. I was kind of assuming that we weren’t worrying about that here,
because the way things work won’t change at all if CRDA is expected to
be missing.

>> even if CRDA shows up later.
>
> If CRDA shows up later then yes, the only way to get a regulatory
> domain applied to the card if it was not world roaming would be
> to reload the module right now. This is a separate issue though
> and I think we should treat it as such.

Yup, I agree.

>> I think that the only reasonable thing to
>> do is to just ensure that there’s only one request outstanding at a
>> time. I’m very opposed to reissuing CRDA requests as long as there’s
>> no way to synchronize by tying a CRDA response to a specific kernel
>> request.
>
> Sure, well so I believe udev is supposed to queue these things,
> not sure, either way I am pretty sure if a udev event was issued
> and CRDA was not present we would not get anything going. One idea
> here is to implement a CRDA wrapper that uses inotify for /sbin/crda
> and queues up requests until CRDA pops in. Can't say I have strong
> motivation for this right now though, chances of you not having
> CRDA are pretty slim ;) but its a way to resolve this IMHO.

I agree, this isn’t terribly important right now.

I think that the bigger problem isn’t “CRDA missing” but “CRDA is sick
because user land is broken.” But that’s not really cfg80211’s
problem.

>> Still, it might not be a bad idea to log something if CRDA
>> doesn’t respond for, say, five seconds, and then to log something
>> again if CRDA finally shows up.
>
> I'd rather leave this to userspace and just decide ourselves what
> to do in the kernel if we never get a response.

For now, I think I’m fine just letting things get wedged. If CRDA is
missing from the get-go, there’s no change in behavior from how things
work now. If the user uninstalls CRDA, they deserve what they
get—similar to how there’s no great recovery option when you remove
ld.so. Practically, if user space gets so messed up that CRDA can’t
run properly, probably enough else is broken that the only reasonable
recovery path is to reboot. It’s probably not the worst thing in the
world for cfg80211’s internal regulatory state to just get stuck when
this happens. It’s a better behavior than skipping a CRDA update and
then resuming processing, or applying rules without intersection when
they were intended for intersection.

I’d be open to other ways of handling this in the kernel, too, but I
don’t think things should get too complex here.

> I think that with the implementation I used but with your suggestion
> with avoiding a delayed work struct might be best. If no CRDA response
> goes through then we simply world roam unless you had
> CONFIG_CFG80211_INTERNAL_REGDB.
>
> Whatyda think?

That works for me, and it should work for anyone else with multiple
cards too. Go team!
