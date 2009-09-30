Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56806 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbZI3PKc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 11:10:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211: NOHZ: local_softirq_pending 08
Date: Wed, 30 Sep 2009 17:10:28 +0200
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <200909111648.50902.mb@bu3sch.de> <87ocosqykb.fsf@purkki.valot.fi> <1254322466.3959.5.camel@johannes.local>
In-Reply-To: <1254322466.3959.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200909301710.31082.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 September 2009 16:54:26 Johannes Berg wrote:
> On Wed, 2009-09-30 at 17:47 +0300, Kalle Valo wrote:
> 
> > I agree with Michael. The bug is real and I have verified that
> > Michael's patch fixes the issue. Better to apply the patch now, it's
> > trivial to change the implementation if/when the network stack has
> > support for this.
> 
> FWIW, I think in mac80211 the in_interrupt() check can never return true
> since we postpone all RX to the tasklet. But the tasklet seems to be ok
> -- so should it really be in_interrupt()?

I think a tasklet is also in_interrupt(), because it's a softirq.
in_interrupt() returns false in process context. The problem appeared when
the b43 driver started passing RX frames while being in process context (threaded IRQ).
It previously was in tasklet (= softirq) context.

-- 
Greetings, Michael.
