Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:43894 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaBDDkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 22:40:46 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21232.24855.201543.400943@gargle.gargle.HOWL> (sfid-20140204_044051_067558_4F200386)
Date: Tue, 4 Feb 2014 09:10:07 +0530
To: Joe Perches <joe@perches.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 1/3] ath9k: Fix build error on ARM
In-Reply-To: <1391484878.2538.11.camel@joe-AO722>
References: <1391483274-20331-1-git-send-email-sujith@msujith.org>
	<1391483274-20331-2-git-send-email-sujith@msujith.org>
	<1391484878.2538.11.camel@joe-AO722>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >  	if (AR_SREV_9300_20_OR_LATER(ah))
> >  		udelay(50);
> >  	else if (AR_SREV_9100(ah))
> > -		udelay(10000);
> > +		mdelay(10);
> >  	else
> >  		udelay(100);
> 
> How can this help?
> There are udelays above and below this line.

A large value causes a build error on ARM:
https://lkml.org/lkml/2014/1/26/92

Sujith
