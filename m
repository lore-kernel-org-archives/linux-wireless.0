Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54924 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbYISB0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 21:26:38 -0400
Date: Thu, 18 Sep 2008 21:25:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw: add kernel version checks for pending upstream
	kernel features
Message-ID: <20080919012553.GD3306@tuxdriver.com> (sfid-20080919_032643_218619_F557A668)
References: <1221748533-11000-1-git-send-email-linville@tuxdriver.com> <1221752489.9262.81.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1221752489.9262.81.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2008 at 05:41:28PM +0200, Johannes Berg wrote:
> On Thu, 2008-09-18 at 10:35 -0400, John W. Linville wrote:
> >  
> > +/* This funcionality first appears "officially" in 2.6.28... */
> > +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
> 
> This bites all developers of the tool. I'd use #ifdef
> NL80211_ATTR_SUPPORTED_IFTYPES like Jouni did for a bunch of things but
> I forgot to add
> #define NL80211_ATTR_SUPPORTED_IFTYPES NL80211_ATTR_SUPPORTED_IFTYPES
> to nl80211.h

That seems a bit error prone, but probably manageable.  As for
the developers, we _could_ have a nicer check that also tested for
DEVELOPER_MODE or something.

> On the other hand, I'm with Pavel in that it sucks if you have a tool
> which your distro compiled against 2.6.27 and then suddenly you want to
> upgrade your kernel to 2.6.28 and the features don't work...

FWIW, I don't see that as any worse than having a tool that supports
functionality that your kernel can't support.  Besides, if the new
functionality is worth having, some user will be happy to remind the
iw maintainer to rebuild and push an update (at least in the land
of Fedora).

> I don't know. Tell me what to do. I don't really like shipping the
> header file either but it may be the lesser of two evils?

It was still early in the morning here on the left coast, so I was
forgetting that netlink-based API could be loosely couple w/ the
kernel, so it would be OK to have the tool know about options that
the kernel didn't support.  I think the best option is probably to
snapshot nl80211.h (or possible a sanitized version of it) inside
the iw source tree.

John
-- 
John W. Linville
linville@tuxdriver.com
