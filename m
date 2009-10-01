Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40233 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741AbZJATKi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 15:10:38 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] net: fix NOHZ: local_softirq_pending 08
Date: Thu, 1 Oct 2009 21:10:32 +0200
Cc: David Miller <davem@davemloft.net>, oliver@hartkopp.net,
	kalle.valo@iki.fi, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <1254324077.3959.7.camel@johannes.local> <200910011604.42916.mb@bu3sch.de> <1254422548.3959.24.camel@johannes.local>
In-Reply-To: <1254422548.3959.24.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910012110.34216.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 01 October 2009 20:42:28 Johannes Berg wrote:
> On Thu, 2009-10-01 at 16:04 +0200, Michael Buesch wrote:
> > On Thursday 01 October 2009 01:33:33 David Miller wrote:
> > 
> > > I'm not applying this until all of these details are sorted out 
> > 
> > John, please apply my fix to wireless-testing to get rid of the regression.
> > You can revert it later, if there's a better fix available.
> 
> I agree with davem, don't. Just fix the driver to local_bh_disable()
> around the rx function if necessary.

For the benefit of a much bigger critical section? I don't get it why this would be any better.

I _am_ going to do one thing now, however. That is ignoring any regression bugreport.
(Yes, it _is_ a regression for b43)

-- 
Greetings, Michael.
