Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:45558 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaEMVnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 17:43:49 -0400
Date: Tue, 13 May 2014 17:43:45 -0400 (EDT)
Message-Id: <20140513.174345.406760552060437774.davem@davemloft.net> (sfid-20140513_234418_480422_E763F142)
To: w-lkml@lebenslange-mailadresse.de
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-acenic@sunsite.dk, nios2-dev@lists.rocketboards.org,
	linuxppc-dev@lists.ozlabs.org, e1000-devel@lists.sourceforge.net,
	devel@linuxdriverproject.org, linux-usb@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
	b.a.t.m.a.n@lists.open-mesh.org, bridge@lists.linux-foundation.org,
	dev@openvswitch.org, trivial@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [resend] net: get rid of SET_ETHTOOL_OPS
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140511001231.GC7875@kaos.lebenslange-mailadresse.de>
References: <20140511001231.GC7875@kaos.lebenslange-mailadresse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>
Date: Sun, 11 May 2014 00:12:32 +0000

> net: get rid of SET_ETHTOOL_OPS
> 
> Dave Miller mentioned he'd like to see SET_ETHTOOL_OPS gone.
> This does that.
> 
> Mostly done via coccinelle script:
> @@
> struct ethtool_ops *ops;
> struct net_device *dev;
> @@
> -       SET_ETHTOOL_OPS(dev, ops);
> +       dev->ethtool_ops = ops;
> 
> Compile tested only, but I'd seriously wonder if this broke anything.
> 
> Suggested-by: Dave Miller <davem@davemloft.net>
> Signed-off-by: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>

Applied to net-next, thanks.
