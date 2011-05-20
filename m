Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49498 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933951Ab1ETNfH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 09:35:07 -0400
Date: Fri, 20 May 2011 06:36:00 -0700
From: Greg KH <gregkh@suse.de>
To: Kalle Valo <kalle.valo@atheros.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@linuxdriverproject.org
Subject: Re: Plan for ath6kl cleanup
Message-ID: <20110520133600.GA10521@suse.de> (sfid-20110520_153516_850864_5A5F111E)
References: <4DD668F4.6090308@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DD668F4.6090308@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 20, 2011 at 04:13:24PM +0300, Kalle Valo wrote:
> We have been thinking about how to get ath6kl out from staging and get
> it to a first class citizen under drivers/net/wireless. There's quite a
> lot of work to do get ath6kl cleaned up and the prospect of doing all
> that through the staging-next tree wasn't that exciting. We would be
> sending hundreds of patches and it would take a long time to cleanup the
> driver. And the disconnection from the wireless core development also
> sounded very daunting (cfg80211 API changes etc.).

This sounds like, "We don't like the kernel development model, it
requires us to break everything up into small patches and show our work
to everyone."

Hopefully that is not the case here.

> So we started to find a faster way to clean up ath6kl and ended up with
> a setup where we would have a separate tree in kernel.org just for
> ath6kl clean up. Once we think that the driver is ready, we will take
> the driver from the cleanup tree and submit as a single patch for
> review. As we will submit the driver as a single commit, history doesn't
> matter and this makes it possible to use not so perfect patches in our
> tree and save a lot of time.

Yup, that is the case :(

> During the transition period we will still fix the important bugs in the
> staging driver, and naturally port them to the cleaned up driver. But
> once the cleaned up driver is accepted we plan to remove the staging driver.
> 
> We already started the cleanup and created ath6kl-clean git tree here:
> 
> http://git.kernel.org/?p=linux/kernel/git/kvalo/ath6kl-cleanup.git;a=summary
> 
> The tree is based on wireless-testing and I have cherry picked missing
> ath6kl patches from staging-next tree. Also the driver is already moved
> to drivers/net/wireless/ath/ath6kl directory to make it easy to submit
> the driver for review once it's ready.
> 
> Everyone is free to send patches and participate in the ath6kl cleanup.
> As we don't want to clutter linux-wireless mailing list with hundreds of
> useless "staging" patches, please send the patches to kvalo@adurom.com
> (have to use my private email due to buggy email servers) and I will
> apply them.
> 
> We have irc channel #ath6kl on freenode where some of the ath6kl devs
> hang out. Feel free to make any questions also there, just give enough
> time for people to answer. But naturally linux-wireless mailing list is
> the best place to ask questions.
> 
> Also the wiki page contains some information and we will start adding more:
> 
> http://wireless.kernel.org/en/users/Drivers/ath6kl
> 
> Thoughts?

Why don't I just delete the whole driver from the tree right now as you
all don't seem to understand how to develop stuff within the community
and want to do it all external until some magic "it is done" time when
you want us to take it back?

That's not nice at all.

Don't worry about "cluttering" up the mailing list, send them to me, and
to the driver devel mailing list, and I will take them just fine.

Have you somehow been finding that I not accept patches quick enough?
Do you not like the fact that others comment, review, and contribute
patches for this driver?

This sounds like a very big step back for your development effort, I
strongly advise you to not do this at all.

thanks,

greg k-h
