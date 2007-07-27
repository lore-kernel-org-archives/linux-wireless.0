Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:59003 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764831AbXG0V71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 17:59:27 -0400
Date: Fri, 27 Jul 2007 14:58:47 -0700
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Re: [PATCH] remove duplicated ioctl entries in compat_ioctl.c
Message-ID: <20070727215847.GA17991@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070727171301.GA16210@bougret.hpl.hp.com> <20070727191053.GA7572@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070727191053.GA7572@tuxdriver.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 27, 2007 at 03:10:54PM -0400, John W. Linville wrote:
> > 
> > 	Actually, you are wrong, and Masakazu is right. All those
> > ioctls contains a pointer and should go through the pointer
> > conversion.
> 
> Masakazu replied in agreement that the COMPATIBLE_IOCTL entries are
> the effective ones i.e. the code currently uses those entries and
> the others are currently just wasting space.

	No, he did not. This is what he said :
-----------------------------------------------
We can keep COMPATIBLE_IOCTL entries *if* the userland apps could work
around iw_point.pointer issue for these ioctls.
-----------------------------------------------
	The second part of the sentence is the most important one. We
don't want the apps to have to deal with this issue, therefore the
COMPATIBLE_IOCTL entries are wrong.

> >       The reason why Masakazu sent that patch is that he actually
> > stumbled on the problem and tested it.
> 
> The only problem stated is the not-quite-duplicate entries.

	You have to take account that Masakazu is not American. He did
not report a bug, he sent you a patch fixing the issue. And I want to
thank him for spending the time to track don this issue and report it.

> Perhaps the HANDLE_IOCTL entries are indeed the correct and intended
> ones.  You seem to be indicating so.

	Yes. We had a discussion about it a few month ago with
Johannes Berg which title was "wireless extensions vs. 64-bit
architectures". If you go back to that discussion, you will realise
that Johannes was clearly saying that the HANDLE_IOCTL entries are the
correct one.
		http://marc.info/?l=linux-wireless&m=117449937110479&w=2
	It seems that the fix we did at that point was not complete,
i.e. we added the missing HANDLE_IOCTL entries but forgot to remove
the corresponding COMPATIBLE_IOCTL entries. It seems that different
compiler do different things when there are duplicate.

> If this fixes a bug, then fine.  If we are trading the one "duplicate"
> entry we have been using for one that hasn't been in use, it doesn't
> make much sense.

	As I said earlier, if you want Wireless Extensions to keep
working, please cc me.

	Jean
