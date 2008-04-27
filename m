Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:36576 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbYD0PtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 11:49:13 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [REGRESSION] Trouble seeing some wireless networks in latest git
Date: Sun, 27 Apr 2008 17:48:49 +0200
Cc: Priit Laes <plaes@plaes.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1209288298.3851.12.camel@localhost> <48149F2B.4000503@lwfinger.net>
In-Reply-To: <48149F2B.4000503@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804271748.49377.mb@bu3sch.de> (sfid-20080427_174927_633366_DA47A23F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 27 April 2008 17:43:39 Larry Finger wrote:
> Priit Laes wrote:
> > Hey,
> > 
> > There seems to be some kind of regression in wireless drivers that makes
> > it not possible to see some wireless networks.
> > 
> > This can be seen with both b43 and iwl3945 drivers.
> > 
> > Using Kismet wireless scanner these networks were visible under latest
> > git.
> > All the networks rendered invisible seem to be from channels: 1 (one
> > network visible), 3, 8, 12 and 13. Visible networks are in channels 1,
> > 4, 6, 9 and 11.
> > 
> > Any hints how to debug this further?
> 
> This regression sounds like a perfect place to use git bisection. As it affects 
> b43 and iwl3945, I would suspect some change in mac80211.

Nah, it's a regulatory setting issue.
The default regdomain is US, which only allows chans 1-11.
There's some module parameter to switch the regdomain.
This is not a regression, but a feature.

-- 
Greetings Michael.
