Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46630 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbbK0NwG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 08:52:06 -0500
Message-ID: <1448632323.1014.0.camel@sipsolutions.net> (sfid-20151127_145210_151657_1B280D4E)
Subject: Re: [PATCH] mac80211_hwsim: stop using pointers as cookies
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Nov 2015 14:52:03 +0100
In-Reply-To: <20151108234923.GA30106@localhost> (sfid-20151109_005630_005048_7732FEA0)
References: <1446807443-12133-1-git-send-email-johannes@sipsolutions.net>
	 <20151108234923.GA30106@localhost> (sfid-20151109_005630_005048_7732FEA0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-11-08 at 18:49 -0500, Bob Copeland wrote:
> On Fri, Nov 06, 2015 at 11:57:23AM +0100, Johannes Berg wrote:
> > Instead of using pointers, use sequentially assigned cookies.
> > This is easier to understand while debugging and also avoids
> > problems when the pointer is reused for the next allocation.
> 
> I tested this out in wmediumd and it didn't go so well...
> 
> > +	info->rate_driver_data[0] = (void *)cookie;
> 
> [...]
> 
> > +		skb_cookie = (u64)(uintptr_t)txi->driver_data[0];
> 
> rate_driver_data vs driver_data?

Yep, that fixes it. I've applied the patch with that fix.

johannes
