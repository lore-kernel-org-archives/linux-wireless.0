Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33235 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758201Ab2EJJqP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:46:15 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Soumik DAS <soumik.das@stericsson.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Increment probe_send_count earlier
References: <2E48302EED53D048A7BA72B0A307FB511FB9009098@EXDCVYMBSTM005.EQ1STM.local>
	<87vck48q92.fsf@purkki.adurom.net>
	<2E48302EED53D048A7BA72B0A307FB511FB9009215@EXDCVYMBSTM005.EQ1STM.local>
Date: Thu, 10 May 2012 12:46:10 +0300
In-Reply-To: <2E48302EED53D048A7BA72B0A307FB511FB9009215@EXDCVYMBSTM005.EQ1STM.local>
	(Soumik DAS's message of "Thu, 10 May 2012 10:43:57 +0200")
Message-ID: <87mx5g8j31.fsf@purkki.adurom.net> (sfid-20120510_114618_699775_9FD8F2D6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Soumik,

Soumik DAS <soumik.das@stericsson.com> writes:

> In some cases the sequence of events gets changed -
> 	a. call ieee80211_send_nullfunc()
> 		(current thread gets scheduled out/pre-empted at this point)
> 	b. null frame gets transmitted and acked
> 	c. probe_send_count is incremented
> 	d. mac80211 waits for some specified timeout and checks that probe_send_count is still > 0. It concludes that AP did not acknowledge the null frame and disassociates from the current AP.
> 	e. After a scan STA again re-associate with the same AP.

Ok, so there's a race in mac80211? You should describe the race in the
commit log so that a random developer understands what's happening. It
doesn't need to be anything fancy, usually just few sentences is enough
to give sufficient background for the patch. Where the race is, how
often it happens and how to fix it properly, that sort of things.

I repeat this a lot (sorry!) but the most important question the commit
log should answer is "Why?". The question "What?" isn't actually that
important as anyone can read the patch themselves.

-- 
Kalle Valo
