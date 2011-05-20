Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61822 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934680Ab1ETOd1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 10:33:27 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 07:32:57 -0700
From: Kalle Valo <kalle.valo@atheros.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: Plan for ath6kl cleanup
References: <4DD668F4.6090308@atheros.com> <20110520133600.GA10521@suse.de>
Date: Fri, 20 May 2011 17:33:06 +0300
In-Reply-To: <20110520133600.GA10521@suse.de> (Greg KH's message of "Fri, 20
	May 2011 06:36:00 -0700")
Message-ID: <87tycpqw65.fsf@atheros.com> (sfid-20110520_163331_586955_9C2BBF1F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

thanks for the quick answer!

Greg KH <gregkh@suse.de> writes:

> On Fri, May 20, 2011 at 04:13:24PM +0300, Kalle Valo wrote:
>> We have been thinking about how to get ath6kl out from staging and get
>> it to a first class citizen under drivers/net/wireless. There's quite a
>> lot of work to do get ath6kl cleaned up and the prospect of doing all
>> that through the staging-next tree wasn't that exciting. We would be
>> sending hundreds of patches and it would take a long time to cleanup the
>> driver. And the disconnection from the wireless core development also
>> sounded very daunting (cfg80211 API changes etc.).
>
> This sounds like, "We don't like the kernel development model, it
> requires us to break everything up into small patches and show our work
> to everyone."
>
> Hopefully that is not the case here.

Trust me, that's not the case. Soon we will submit the driver for review
to linux-wireless list and then everyone are more than welcome to review
everything, down to the every bit in the driver.

And seriously, what good does it take to review some ugly patches about
removing OS abstractions, private user space interfaces, fixing coding
style and removing odd directory structures? Wouldn't it be better, and
easier, to review a smaller, leaner and cleaned up driver? At least I
would prefer that. And that's what we are going to do, once our tiger
team has finished the cleanup.

>> So we started to find a faster way to clean up ath6kl and ended up with
>> a setup where we would have a separate tree in kernel.org just for
>> ath6kl clean up. Once we think that the driver is ready, we will take
>> the driver from the cleanup tree and submit as a single patch for
>> review. As we will submit the driver as a single commit, history doesn't
>> matter and this makes it possible to use not so perfect patches in our
>> tree and save a lot of time.
>
> Yup, that is the case :(

See above.

And if you want to have a reason, it's about the staging area is not
really an easy place for active wireless driver development. Don't get
me wrong, staging is good for drivers which don't have that active
development. But ath6kl won't belong to that group anymore and I would
like to take some shortcuts to save time and focus on the real thing,
which is improving quality of the driver and adding more features.

>> During the transition period we will still fix the important bugs in the
>> staging driver, and naturally port them to the cleaned up driver. But
>> once the cleaned up driver is accepted we plan to remove the staging driver.
>> 
>> We already started the cleanup and created ath6kl-clean git tree here:
>> 
>> http://git.kernel.org/?p=linux/kernel/git/kvalo/ath6kl-cleanup.git;a=summary
>> 
>> The tree is based on wireless-testing and I have cherry picked missing
>> ath6kl patches from staging-next tree. Also the driver is already moved
>> to drivers/net/wireless/ath/ath6kl directory to make it easy to submit
>> the driver for review once it's ready.
>> 
>> Everyone is free to send patches and participate in the ath6kl cleanup.
>> As we don't want to clutter linux-wireless mailing list with hundreds of
>> useless "staging" patches, please send the patches to kvalo@adurom.com
>> (have to use my private email due to buggy email servers) and I will
>> apply them.
>> 
>> We have irc channel #ath6kl on freenode where some of the ath6kl devs
>> hang out. Feel free to make any questions also there, just give enough
>> time for people to answer. But naturally linux-wireless mailing list is
>> the best place to ask questions.
>> 
>> Also the wiki page contains some information and we will start adding more:
>> 
>> http://wireless.kernel.org/en/users/Drivers/ath6kl
>> 
>> Thoughts?
>
> Why don't I just delete the whole driver from the tree right now as you
> all don't seem to understand how to develop stuff within the community
> and want to do it all external until some magic "it is done" time when
> you want us to take it back?

Because there are currently users using the driver from staging. That
would be a disservice for them. We help our users better if we keep the
staging driver around and alive until the cleaned up version has been
merged.

> That's not nice at all.

For who? I think for users and for the community it's better that they
get a proper, and properly supported, upstream driver as soon as
possible. The timeframe is something like having a cleaned up version in
few weeks. But working with staging it would take months to get to the
same state.

> Don't worry about "cluttering" up the mailing list, send them to me, and
> to the driver devel mailing list, and I will take them just fine.

I'm talking about linux-wireless mailing list. And yes, I really think
that sending patches like removing A_MEMSET() is cluttering the mailing
list. I would rather see wireless hackers doing something productive
than reading patches like that.

And if someone really likes reading patches like that (I don't) then
they are all available in ath6k-cleanup git tree.

> Have you somehow been finding that I not accept patches quick enough?

Yes, you have been accepting the patches quickly, that's not the
problem. But when we talk about cleaning up the driver properly the flow
of patches increases significantly, at least hundreds of patches from
different people working concurrently. So we would have a huge ping-pong
of patches which conflict each other, you don't like or someone else
doesn't like and has to be submitted again. Managing all that will take
a lot of time and I would rather use that time better improving the
driver than just (re)submitting cleanup patches.

So to be more clear: I expect that if the cleanup would happen in
staging-next tree it would take months to finish but doing it in a
separate tree we can do it in weeks. I'm guessing that we will have a
first version of the driver ready for review in three weeks or so.

> Do you not like the fact that others comment, review, and contribute
> patches for this driver?

Oh yes, I like all that very much, no question about that. I like it so
much that I'm taking extra effort to get the driver to wireless-testing
as soon as possible and start getting the support from the Linux
wireless community. Because, let's face it, wireless community doesn't
care about staging drivers.

Staging is great for some type of drivers, but a very difficult place
for a wireless driver under active development. For example, cfg80211
API changes would be difficult to handle because wireless-testing would
have too old ath6kl and staging-next would have too old wireless core.
Just think all the pain we (Atheros developers) would have to suffer. I
really don't want to waste any time trying to get things working between
the two trees.

> This sounds like a very big step back for your development effort, I
> strongly advise you to not do this at all.

I understand why you are worried. But we have our "top men" working on
this and I'm sure the end result will be good :)

Did my explonation above decrease your worries at all?

Kalle
