Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4975 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbXD0Bd2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 21:33:28 -0400
Date: Thu, 26 Apr 2007 20:50:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 9/9] net_device: dont include wext bits if not required
Message-ID: <20070427005013.GA25332@tuxdriver.com>
References: <20070424180732.371620000@sipsolutions.net> <20070424180850.595757000@sipsolutions.net> <20070426165304.GC22576@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070426165304.GC22576@bougret.hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 26, 2007 at 09:53:04AM -0700, Jean Tourrilhes wrote:
> On Tue, Apr 24, 2007 at 08:07:41PM +0200, Johannes Berg wrote:
> > This patch makes the wext bits in struct net_device depend on
> > CONFIG_WIRELESS_EXT.
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> 	I personally would not do that. Having conditional fields in
> "struct net_device" is very bad, it's a sure way to crash on modules
> in some cases. If I remember well, Jeff Garzik has been fighting those
> over the years.

I'm not sure I understand the reasoning here.  Without a doubt kernel
modules need to be built against the same configuration as the kernels
that are loading them.  So, conditional component of net_device should
not cause crashes.

FWIW, there are other conditionally compiled portions of net_device
(NETPOLL, NET_POLL_CONTROLLER).  I don't see the harm here.

John
-- 
John W. Linville
linville@tuxdriver.com
