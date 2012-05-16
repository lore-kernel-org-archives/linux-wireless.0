Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:45519 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab2EPFZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 01:25:33 -0400
Date: Wed, 16 May 2012 01:23:19 -0400 (EDT)
Message-Id: <20120516.012319.1903390658912592000.davem@davemloft.net> (sfid-20120516_072612_786453_6A3567A2)
To: joe@perches.com
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] net: mac80211: Neaten debugging
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1337116578.git.joe@perches.com>
References: <1337106548.15553.8.camel@jlt3.sipsolutions.net>
	<cover.1337116578.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joe Perches <joe@perches.com>
Date: Tue, 15 May 2012 14:20:29 -0700

> Always use pr_debug variants instead of printk(KERN_DEBUG...)
> 
> Joe Perches (3):
>   net: mac80211: Convert printk(KERN_DEBUG to pr_debug
>   net: mac80211: Add and use ht_vdbg debugging macro
>   net: mac80211: Add and use ibss_vdbg debugging macro

I really think this is the right thing to do and I hope the wireless
folks integrate this.

I am well aware that you guys intend for some of these messages to be
indications and notifications the user is intended to SEE, but in the
cases where that is true KERN_DEBUG is absolutely not appropriate.

You should be using KERN_INFO or KERN_WARN in those situations
instead.

Thanks.
