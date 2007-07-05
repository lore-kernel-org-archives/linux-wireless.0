Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:49546 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757446AbXGEInj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2007 04:43:39 -0400
Date: Thu, 5 Jul 2007 10:43:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Ingo Molnar <mingo@redhat.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Thomas Sattler <tsattler@gmx.de>
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
Message-ID: <20070705084323.GB2447@elte.hu>
References: <1182969638.4769.56.camel@johannes.berg> <1183048429.4089.1.camel@johannes.berg> <1183052001.4089.2.camel@johannes.berg> <1183190728.7932.43.camel@earth4> <20070630114658.GA344@tv-sign.ru> <1183381393.4089.117.camel@johannes.berg> <20070703173112.GA108@tv-sign.ru> <1183549772.3812.10.camel@johannes.berg> <20070704125219.GA98@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070704125219.GA98@tv-sign.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> > > Isn't it better to call lock_release() with nested == 1 ?
> > 
> > Not sure, Ingo?
> 
> Ingo, could you also explain the meaning of "nested" parameter? Looks 
> like it is just unneeded, lock_release_nested() does a quick check and 
> use lock_release_non_nested() when hlock is not on top of stack.

hm, i forgot about that. We basically turned off all bad-nesting 
warnings in lockdep due to false positives.

the workqueue dependencies should all nest perfectly so please just use 
nested==1, even though it's a dummy right now. We might want to turn 
unlock-nest checking back on in the future. Or we'll remove that 
parameter altogether.

	Ingo
