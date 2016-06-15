Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46235 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbcFOMvx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2016 08:51:53 -0400
Message-ID: <1465995110.2994.6.camel@sipsolutions.net> (sfid-20160615_145158_027081_7A831707)
Subject: Re: [PATCH] mac80211_hwsim: Allow wmediumd to attach to radios
 created in its netns
From: Johannes Berg <johannes@sipsolutions.net>
To: Martin Willi <martin@strongswan.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 15 Jun 2016 14:51:50 +0200
In-Reply-To: <1465994233.3807.18.camel@strongswan.org>
References: <1463214884-5983-1-git-send-email-martin@strongswan.org>
	 <1465978217.2994.4.camel@sipsolutions.net>
	 <1465994233.3807.18.camel@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-06-15 at 14:37 +0200, Martin Willi wrote:
> > 
> > 
> > >  printk(KERN_INFO "mac80211_hwsim: wmediumd released netlink"
> > >         " socket, switching to perfect channel medium\n");
> 
> > I wonder if we can do something better about them? Or perhaps if we
> > should remove them, so other namespaces won't mess up the kernel
> > log
> 
> This is in fact not very nice, but not specific to hwsim. Any
> namespace
> can mess up the kernel log from different (networking) subsystems.
> This
> has been discussed some time ago [1], but AFAIK there is no real
> solution so far.
> 
> For this patch I think we have the following options:
>  * Keep the printk() messages as proposed
>  * Remove those callable from non-initial namespaces completely
>  * Suppress them when called from non-initial namespaces
>  * Include the associated "netgroup" in the message
> 
> I personally would prefer the first option, as this problem is not
> specific to hwsim or mac80211, but many subsystems. So we certainly
> can
> add some work-around, but there is not much to gain if other modules
> don't.
> 

Fair enough.

johannes
