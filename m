Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:29148 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZFIBRP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 21:17:15 -0400
Subject: Re: BUG at net/wireless/reg.c:2132 on PowerPC
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090608231919.GC23972@bombadil.infradead.org>
References: <1244501988.25158.57.camel@mj>
	 <20090608231919.GC23972@bombadil.infradead.org>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 21:17:16 -0400
Message-Id: <1244510236.28215.32.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-06-08 at 19:19 -0400, Luis R. Rodriguez wrote:

> Thank you for reporting this, try loading the system without ath5k present
> (mv ath5k.ko ath5k.ignore is an easy way) then prior to loadin git in a window
> get 'iw event' running.

I'm sorry, but I managed to "fix" the problem without having a way to
recreate it again.  I emptied /etc/udev/rules.d/70-persistent-net.rules
and removed /etc/sysconfig/network-scripts/ifcfg-wlan0, and the problem
is gone, but I didn't preserve the original files, and I cannot make the
crash happen again.

Also, it turns out that pciutils failed to upgrade to the Fedora 11
version, and "lspci -v" was crashing.  After upgrading pciutils the BUG
was gone, but downgrading it didn't make it reappear :-(

I tried what you said, and that's what I get:

# iw event
phy #0: regulatory domain change: set to US by a driver request on phy0
phy #1: regulatory domain change: set to US by a driver request on phy1

>  
> -		BUG_ON(request_wiphy->regd);
> +		/*
> +		 * Userspace could have sent two replies with only
> +		 * one kernel request.
> +		 */
> +		if (request_wiphy->regd)
> +			return -EALREADY;

I think it's a good idea.  Stupid userspace shouldn't cause kernel bugs.

-- 
Regards,
Pavel Roskin
