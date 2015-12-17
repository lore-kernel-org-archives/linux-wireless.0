Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239AbbLQDRF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 22:17:05 -0500
Date: Thu, 17 Dec 2015 11:16:52 +0800
From: Dave Young <dyoung@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Stefan Lippers-Hollmann <s.l-h@gmx.de>
Subject: Re: [PATCH] wireless: change cfg80211 regulatory domain info as
 debug messages
Message-ID: <20151217031652.GA3821@dhcp-128-65.nay.redhat.com> (sfid-20151217_041729_303236_A9B58F11)
References: <20151115073105.GA18846@dhcp-128-65.nay.redhat.com>
 <1449844729.2324.15.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449844729.2324.15.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Johannes

Sorry for late feedback, I was busying on other things.

On 12/11/15 at 03:38pm, Johannes Berg wrote:
> On Sun, 2015-11-15 at 15:31 +0800, Dave Young wrote:
> > cfg80211 module prints a lot of messages like below. Actually
> > printing once is acceptable but sometimes it will print again and
> > again, it looks very annoying. It is better to change these detail
> > messages to debugging only.
> > 
> 
> Despite the objections, I've applied this patch now.
> 

Thanks a lot.

> I've made one change: keeping the alpha2 (e.g. "US") printed in some of
> the pr_err() cases in this file.
> I also got rid of CONFIG_CFG80211_REG_DEBUG in a separate patch.
> 
> I somewhat agree with the objections, but if the kernel is with
> CONFIG_DYNAMIC_DEBUG then it's really simple to get the messages back
> by enabling them for this file.
> 
> Where the messages were used as an indication of something having gone
> awry at a different level (e.g. mac80211 disconnect) I don't really
> quite agree - that then perhaps should have a more explicit (and less
> noisy) message.
> 
> I also agree that the regulatory code is quite opaque, and the way it
> arrives at certain conclusions is not always obvious. These messages
> don't help all that much though since they don't contain the actual
> input to the decisions. I think for that, we'd be much better served
> with some kind of tracepoint or so that records all the information.

I think you guys are expert in this area, I will agree with all of
above. But I hope we can have some rate limited messages at least
especially for endless things.

Thanks
Dave
