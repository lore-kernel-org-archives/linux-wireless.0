Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:64421 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbZLWW6R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 17:58:17 -0500
Subject: Re: 2.6.33.rc1-git3 - regression in rt61pci driver
From: Pavel Roskin <proski@gnu.org>
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <c6b1100b0912231448v759eac55kfb3dd1e6d6186c73@mail.gmail.com>
References: <c6b1100b0912231448v759eac55kfb3dd1e6d6186c73@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 23 Dec 2009 17:58:12 -0500
Message-Id: <1261609092.2774.4.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-12-23 at 22:48 +0000, Chris Clayton wrote:
> Hi,
> 
> I'm not subscribed, so please cc me on any reply.
> 
> I've built and installed today's -git kernel
> (v2.6.33-rc1-225-gc9f937e) and find that my (rt61pci) wireless card no
> longer works. All the usual drivers are loaded when I insert the card.
> The card works fine with 2.6.32.2 (as long as I disable power saving).
> 
> The symptoms are that:
> 
> 1. The file /proc/net/wireless never appears
> 
> 2. iwconfig gives "wlan0     no wireless extensions."

Have a closer look at your .config file.  I guess CONFIG_CFG80211_WEXT
is not defined there.  It's needed to make cfg80211 capable devices
support wireless extensions.

You can try using iw to configure your card.  That's the new utility.

[dropping cc to LKML, it's a purely wireless issue]

-- 
Regards,
Pavel Roskin
