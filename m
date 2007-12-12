Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39418 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753156AbXLLAeA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 19:34:00 -0500
Subject: Re: [WIP][PATCH] rc80211_pid: Send events to userspace for
	debugging
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20071212011021.4d058b55@morte>
References: <1197414686.7030.27.camel@localhost>
	 <1197418044.7030.32.camel@localhost>  <20071212011021.4d058b55@morte>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 01:33:57 +0100
Message-Id: <1197419637.7030.40.camel@localhost> (sfid-20071212_003405_367547_95C91E5F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-12-12 at 01:10 +0100, Stefano Brivio wrote:
> On Wed, 12 Dec 2007 01:07:24 +0100
> Mattias Nissler <mattias.nissler@gmx.de> wrote:
> 
> > I guess from the second graph we can see that the integration interval
> > is too large. I think I should try increasing the proportional
> > coefficient and decrease the integral coefficient. What do you think?
> > Control theory people please speak up :-)
> 
> Which parameters have been used here? What's the scenario? Any changes in
> environment while testing? It looks like there are a lot of small integral
> wind-up phenomena. 

Correct :-)

> You should maybe just decrease the integral coefficient
> and don't vary the other parameters, and see what happens. 

I'll do more experiments later this week.

> But again, I
> would need to know environmental conditions. If your driver reports SNR,
> e.g., it may make sense to report it on the graph.

Well, that's a good idea. The problem is where to get it from. The rate
control algorithm only has information about tx frames and their status,
and there is no way to get SNR information from that. Can we read SNR
using some mac80211 function? Furthermore, we'd actually need the SNR at
the receiver, which is even harder to add to the diagram.

Mattias

