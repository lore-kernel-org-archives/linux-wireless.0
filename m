Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:58764 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbYIRQK1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 12:10:27 -0400
Subject: Re: [PATCH] iw: add kernel version checks for pending upstream
	kernel features
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1221752489.9262.81.camel@johannes.berg>
References: <>  <1221748533-11000-1-git-send-email-linville@tuxdriver.com>
	 <1221752489.9262.81.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 12:10:24 -0400
Message-Id: <1221754224.5565.20.camel@dv> (sfid-20080918_181032_922180_171F138A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-09-18 at 17:41 +0200, Johannes Berg wrote:
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

I agree.  I always prefer to test for features, not for numbers.

> On the other hand, I'm with Pavel in that it sucks if you have a tool
> which your distro compiled against 2.6.27 and then suddenly you want to
> upgrade your kernel to 2.6.28 and the features don't work...
> 
> I don't know. Tell me what to do. I don't really like shipping the
> header file either but it may be the lesser of two evils?

I think the build system should use the included header by default.  But
it should be easy to enable compiling against the kernel sources.  For
instance, if the kernel path is defined in .config or there is an option
on the command line.

-- 
Regards,
Pavel Roskin
