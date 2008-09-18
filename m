Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:33887 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbYIRUmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:42:36 -0400
Subject: Re: [PATCH] iw: add kernel version checks for pending upstream
	kernel features
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1221758934.9262.89.camel@johannes.berg>
References: <>  <1221748533-11000-1-git-send-email-linville@tuxdriver.com>
	 <1221752489.9262.81.camel@johannes.berg>
	 <1221758783.6782.29.camel@californication>
	 <1221758934.9262.89.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 22:43:23 +0200
Message-Id: <1221770603.6782.35.camel@californication> (sfid-20080918_224238_992239_0CB08673)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > if the numbers you are planning to use are stable, then please use the
> > above approach to just add the missing defines to it. Like adding a
> > compat.h file with
> > 
> > #ifndef NL80211_ATTR_SUPPORTED_IFTYPES
> > #define NL80211_ATTR_SUPPORTED_IFTYPES boo
> > #endif
> 
> Well, at that point I can also just copy nl80211.h from wireless-testing
> whenever I think the numbers will remain stable, no? And that doesn't
> work as-is anyway since nl80211.h uses an enum to define the numbers,
> not #defines.

it is possible to work around with just define the enum entries also as
defines. Netlink does this a lot. It is not pretty, but possible.

> I guess it's the lesser of all the evils. I'm not too fond of copying in
> the header file, it creates more work and doesn't make all that much
> sense, but all the other proposals take even more work, and as long as
> we don't change the numbers after putting things into wireless-testing
> we should be fine.

Simple speaking, yes :)

Regards

Marcel


