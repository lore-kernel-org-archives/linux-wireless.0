Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44624 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbcFOIKW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2016 04:10:22 -0400
Message-ID: <1465978217.2994.4.camel@sipsolutions.net> (sfid-20160615_101037_051903_80338FF8)
Subject: Re: [PATCH] mac80211_hwsim: Allow wmediumd to attach to radios
 created in its netns
From: Johannes Berg <johannes@sipsolutions.net>
To: Martin Willi <martin@strongswan.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 15 Jun 2016 10:10:17 +0200
In-Reply-To: <1463214884-5983-1-git-send-email-martin@strongswan.org>
References: <1463214884-5983-1-git-send-email-martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was about to apply this (with a typo fix for "responsile"), but
noticed these messages:

>  	printk(KERN_DEBUG "mac80211_hwsim: received a REGISTER, "
>  	       "switching to wmediumd mode with pid %d\n", info-
> >snd_portid);


> +	if (notify->portid == hwsim_net_get_wmediumd(notify->net)) {
>  		printk(KERN_INFO "mac80211_hwsim: wmediumd released
> netlink"
>  		       " socket, switching to perfect channel
> medium\n");
> 

I wonder if we can do something better about them? Or perhaps if we
should remove them, so other namespaces won't mess up the kernel log?

johannes
