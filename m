Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48524 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758708AbbIDMaI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 08:30:08 -0400
Message-ID: <1441369803.1971.4.camel@sipsolutions.net> (sfid-20150904_143036_582086_E12EE242)
Subject: Re: [PATCH] cfg80211: regulatory: restore proper user alpha2
From: Johannes Berg <johannes@sipsolutions.net>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	linux-wireless@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 04 Sep 2015 14:30:03 +0200
In-Reply-To: <55E72B2F.0@maciej.szmigiero.name>
References: <55E72B2F.0@maciej.szmigiero.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-02 at 19:00 +0200, Maciej S. Szmigiero wrote:
> restore_regulatory_settings() should restore alpha2
> as computed in restore_alpha2(), not raw user_alpha2 to
> behave as described in the comment just above that code.
> 
> This fixes endless loop of calling CRDA for "00" and "97"
> countries after resume from suspend on my laptop.
> 
> Looks like others had the same problem, too:
> http://ath9k-devel.ath9k.narkive.com/knY5W6St/ath9k-and-crda-messages
> -in-logs
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/899335
> https://forum.porteus.org/viewtopic.php?t=4975&p=36436
> https://forums.opensuse.org/showthread.php/
> 483356-Authentication-Regulatory-Domain-issues-ath5k-12-2
> 

Applied, thanks.

johannes
