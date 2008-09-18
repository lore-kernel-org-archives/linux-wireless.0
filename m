Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:56730 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbYIRRZh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 13:25:37 -0400
Subject: Re: [PATCH] iw: add kernel version checks for pending upstream
	kernel features
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1221752489.9262.81.camel@johannes.berg>
References: <>  <1221748533-11000-1-git-send-email-linville@tuxdriver.com>
	 <1221752489.9262.81.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 19:26:23 +0200
Message-Id: <1221758783.6782.29.camel@californication> (sfid-20080918_192541_292360_4501B7EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > +/* This funcionality first appears "officially" in 2.6.28... */
> > +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
> 
> This bites all developers of the tool. I'd use #ifdef
> NL80211_ATTR_SUPPORTED_IFTYPES like Jouni did for a bunch of things but
> I forgot to add
> #define NL80211_ATTR_SUPPORTED_IFTYPES NL80211_ATTR_SUPPORTED_IFTYPES
> to nl80211.h
> 
> On the other hand, I'm with Pavel in that it sucks if you have a tool
> which your distro compiled against 2.6.27 and then suddenly you want to
> upgrade your kernel to 2.6.28 and the features don't work...

if the numbers you are planning to use are stable, then please use the
above approach to just add the missing defines to it. Like adding a
compat.h file with

#ifndef NL80211_ATTR_SUPPORTED_IFTYPES
#define NL80211_ATTR_SUPPORTED_IFTYPES boo
#endif

That would make a distro complied binary work with an updates kernel and
we don't end up with the issue the iwconfig current has when it has been
compiled for an older kernel.

However make sure to keep you numbers stable. Otherwise you break kernel
and/or userspace assumptions.

Regards

Marcel


