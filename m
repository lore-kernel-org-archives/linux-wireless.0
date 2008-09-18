Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:51739 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbYIRTTK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 15:19:10 -0400
Subject: Re: [PATCH] iw: add kernel version checks for pending upstream
	kernel features
From: Pavel Roskin <proski@gnu.org>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1221758783.6782.29.camel@californication>
References: <>  <1221748533-11000-1-git-send-email-linville@tuxdriver.com>
	 <1221752489.9262.81.camel@johannes.berg>
	 <1221758783.6782.29.camel@californication>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 15:19:07 -0400
Message-Id: <1221765547.9477.4.camel@dv> (sfid-20080918_211914_007427_4CBE1C40)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-09-18 at 19:26 +0200, Marcel Holtmann wrote:

> if the numbers you are planning to use are stable, then please use the
> above approach to just add the missing defines to it. Like adding a
> compat.h file with
> 
> #ifndef NL80211_ATTR_SUPPORTED_IFTYPES
> #define NL80211_ATTR_SUPPORTED_IFTYPES boo
> #endif

I'm sure the numbers used to communicate between the kernel and the
userspace are meant to be stable.

> That would make a distro complied binary work with an updates kernel and
> we don't end up with the issue the iwconfig current has when it has been
> compiled for an older kernel.

Having the include file in the sources would have the same effect.

But your approach is easier to get wrong.  Some numbers are from enum,
not from preprocessor defines.  It's easy to put a wrong number into the
compatibility code.  This code will need to be tested on older kernels.

-- 
Regards,
Pavel Roskin
