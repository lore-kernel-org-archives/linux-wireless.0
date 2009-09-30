Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52824 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZI3TAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 15:00:54 -0400
Date: Wed, 30 Sep 2009 14:47:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Oliver Hartkopp <oliver@hartkopp.net>
Cc: David Miller <davem@davemloft.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>, Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: fix NOHZ: local_softirq_pending 08
Message-ID: <20090930184722.GD6364@tuxdriver.com>
References: <200909111648.50902.mb@bu3sch.de> <87ocosqykb.fsf@purkki.valot.fi> <1254322466.3959.5.camel@johannes.local> <200909301710.31082.mb@bu3sch.de> <1254324077.3959.7.camel@johannes.local> <4AC39A90.6060602@hartkopp.net> <4AC3A0F1.3060306@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4AC3A0F1.3060306@hartkopp.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2009 at 08:18:25PM +0200, Oliver Hartkopp wrote:
> Socket buffers that are generated and received inside softirqs or from process
> context must not use netif_rx() that's intended to be used from irq context only.
> 
> This patch introduces a new helper function netif_rx_ti(skb) that tests for
> in_interrupt() before invoking netif_rx() or netif_rx_ni().
> 
> It fixes the ratelimited kernel warning
> 
>         NOHZ: local_softirq_pending 08
> 
> in the mac80211 and can subsystems.
> 
> Signed-off-by: Oliver Hartkopp <oliver@hartkopp.net>

http://bugzilla.kernel.org/show_bug.cgi?id=14278

Acked-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
