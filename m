Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:34521 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbZI3L4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 07:56:20 -0400
Message-ID: <4AC3475C.7000403@hartkopp.net>
Date: Wed, 30 Sep 2009 13:56:12 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Michael Buesch <mb@bu3sch.de>, Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211: NOHZ: local_softirq_pending 08
References: <200909111648.50902.mb@bu3sch.de> <200909111707.23971.mb@bu3sch.de> <4AAA75CB.6040803@hartkopp.net> <200909111813.35810.mb@bu3sch.de> <4AABCF28.6090505@hartkopp.net> <20090929192928.GF2678@tuxdriver.com>
In-Reply-To: <20090929192928.GF2678@tuxdriver.com>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Sat, Sep 12, 2009 at 06:41:12PM +0200, Oliver Hartkopp wrote:
> 
>> i cooked a patch that introduces netif_rx_ti() and fixes up the problems in
>> mac80211 and the CAN subsystem.
> 
> Oliver,
> 
> Are you going to send this patch to Dave?  If you want me to carry
> it instead, please resend it with a proper changelog including a
> Signed-off-by line.  For that matter, Dave will most certainly want
> that as well...

Hello John,

as i wrote here

http://marc.info/?l=linux-netdev&m=125277885910179&w=2

there are currently only three occurrences of checks that use netif_rx() and
netif_rx_ni() depending on in_interrupt().

And regarding the suggested fix from Michael, that checked every(!) netif_rx()
whether it is in interrupt or not, i was unsure if a netif_tx_ti() would make
sense for only three cases?!?

If you think it makes sense, i can post a patch for that ... but:

Indeed it costs some additional investigation to prove whether netif_rx() or
netif_rx_ni() should be used in each case. But IMHO this has to be done before
providing a pump-gun function that solves the problem without thinking if we
are in irq-context or not. I want to avoid that people are using netif_rx_ti()
as some kind of default ...

I don't know how expensive in_interrupt() is, but it IMO should be avoided
when the context for a code section can be determined in another way.

Regards,
Oliver

