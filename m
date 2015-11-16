Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbbKPB7s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2015 20:59:48 -0500
Date: Mon, 16 Nov 2015 09:59:41 +0800
From: Dave Young <dyoung@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net,
	johannes@sipsolutions.net
Subject: Re: [PATCH] wireless: change cfg80211 regulatory domain info as
 debug messages
Message-ID: <20151116015941.GB3439@dhcp-128-65.nay.redhat.com> (sfid-20151116_030009_757857_3CABB671)
References: <20151115073105.GA18846@dhcp-128-65.nay.redhat.com>
 <1447609134.6012.15.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447609134.6012.15.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/15 at 09:38am, Joe Perches wrote:
> On Sun, 2015-11-15 at 15:31 +0800, Dave Young wrote:
> > cfg80211 module prints a lot of messages like below. Actually printing
> > once is acceptable but sometimes it will print again and again, it looks
> > very annoying. It is better to change these detail messages to debugging
> > only.
> 
> So maybe add some wrapper that does a pr_info then
> a pr_debug for the second and subsequent uses like:
> 
> #define pr_info_once_then_debug(fmt, ...)			\
> ({								\
> 	static bool __print_once __read_mostly;			\
> 								\
> 	if (!__print_once) {					\
> 		__print_once = true;				\
> 		pr_info(fmt, ##__VA_ARGS__);			\
> 	} else {						\
> 		pr_debug(fmt, ##__VA_ARGS__);			\
> 	}							\
> })
> 

Hmm, it looks too much for this issue, I'm thinking about to add a cmdline
param to disable mute it.

Thanks
Dave
