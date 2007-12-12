Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:39901 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752901AbXLLAOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 19:14:17 -0500
Date: Wed, 12 Dec 2007 01:10:21 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP][PATCH] rc80211_pid: Send events to userspace for
 debugging
Message-ID: <20071212011021.4d058b55@morte> (sfid-20071212_001419_730199_4879D09A)
In-Reply-To: <1197418044.7030.32.camel@localhost>
References: <1197414686.7030.27.camel@localhost>
	<1197418044.7030.32.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 12 Dec 2007 01:07:24 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> I guess from the second graph we can see that the integration interval
> is too large. I think I should try increasing the proportional
> coefficient and decrease the integral coefficient. What do you think?
> Control theory people please speak up :-)

Which parameters have been used here? What's the scenario? Any changes in
environment while testing? It looks like there are a lot of small integral
wind-up phenomena. You should maybe just decrease the integral coefficient
and don't vary the other parameters, and see what happens. But again, I
would need to know environmental conditions. If your driver reports SNR,
e.g., it may make sense to report it on the graph.


--
Ciao
Stefano
