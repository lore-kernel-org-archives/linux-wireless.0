Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:58281 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZI3RvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 13:51:10 -0400
Message-ID: <4AC39A90.6060602@hartkopp.net>
Date: Wed, 30 Sep 2009 19:51:12 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>, Kalle Valo <kalle.valo@iki.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: mac80211: NOHZ: local_softirq_pending 08
References: <200909111648.50902.mb@bu3sch.de>	 <87ocosqykb.fsf@purkki.valot.fi> <1254322466.3959.5.camel@johannes.local>	 <200909301710.31082.mb@bu3sch.de> <1254324077.3959.7.camel@johannes.local>
In-Reply-To: <1254324077.3959.7.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2009-09-30 at 17:10 +0200, Michael Buesch wrote:
>> On Wednesday 30 September 2009 16:54:26 Johannes Berg wrote:
>>> On Wed, 2009-09-30 at 17:47 +0300, Kalle Valo wrote:
>>>
>>>> I agree with Michael. The bug is real and I have verified that
>>>> Michael's patch fixes the issue. Better to apply the patch now, it's
>>>> trivial to change the implementation if/when the network stack has
>>>> support for this.
>>> FWIW, I think in mac80211 the in_interrupt() check can never return true
>>> since we postpone all RX to the tasklet. But the tasklet seems to be ok
>>> -- so should it really be in_interrupt()?
>> I think a tasklet is also in_interrupt(), because it's a softirq.
> 
> Ah, yes, indeed, in_interrupt() vs. in_irq().
> 

Oops!

I missed that for my previous patch i added for two occurrences in the CAN
sources.

I'm currently compiling the patch for netif_rx_ti() and will post it in some
minutes (for CAN and mac80211) when it runs without probs.

Regards,
Oliver
