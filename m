Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44994 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbaGUJh6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 05:37:58 -0400
Message-ID: <1405935461.32255.3.camel@jlt4.sipsolutions.net> (sfid-20140721_113801_292011_479CB510)
Subject: Re: GFP flags for cfg80211_rx_mgmt
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 21 Jul 2014 11:37:41 +0200
In-Reply-To: <2433125.jSlKTrms1X@lx-wigig-72>
References: <2433125.jSlKTrms1X@lx-wigig-72>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-07-13 at 08:02 -0700, Vladimir Kondratiev wrote:
> Hi,
> 
> In the cfg80211_rx_mgmt(), there is parameter 'gfp_t gfp' that is
> passed to the nl80211_send_mgmt() and then to alloc_skb().
> In fact, nl80211_send_mgmt() called under spinlock, so
> one can't use GFP_KERNEL. However, documentation for
> cfg80211_rx_mgmt does not restrict GFP flags.
> 
> I suggest to document this, and enforce in some way (WARN_ONCE?),
> or just remove this parameter - everywhere in the kernel
> GFP_ATOMIC is used.

I say just remove it, want to send a patch?

johannes

