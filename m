Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37079 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2FETR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 15:17:58 -0400
Date: Tue, 5 Jun 2012 15:00:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Soumik DAS <soumik.das@stericsson.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Increment probe_send_count earlier
Message-ID: <20120605190058.GC1937@tuxdriver.com> (sfid-20120605_211802_646222_4B2CC8E4)
References: <2E48302EED53D048A7BA72B0A307FB511FB9009098@EXDCVYMBSTM005.EQ1STM.local>
 <87vck48q92.fsf@purkki.adurom.net>
 <2E48302EED53D048A7BA72B0A307FB511FB9009215@EXDCVYMBSTM005.EQ1STM.local>
 <87mx5g8j31.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87mx5g8j31.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2012 at 12:46:10PM +0300, Kalle Valo wrote:
> Hi Soumik,
> 
> Soumik DAS <soumik.das@stericsson.com> writes:
> 
> > In some cases the sequence of events gets changed -
> > 	a. call ieee80211_send_nullfunc()
> > 		(current thread gets scheduled out/pre-empted at this point)
> > 	b. null frame gets transmitted and acked
> > 	c. probe_send_count is incremented
> > 	d. mac80211 waits for some specified timeout and checks that probe_send_count is still > 0. It concludes that AP did not acknowledge the null frame and disassociates from the current AP.
> > 	e. After a scan STA again re-associate with the same AP.
> 
> Ok, so there's a race in mac80211? You should describe the race in the
> commit log so that a random developer understands what's happening. It
> doesn't need to be anything fancy, usually just few sentences is enough
> to give sufficient background for the patch. Where the race is, how
> often it happens and how to fix it properly, that sort of things.
> 
> I repeat this a lot (sorry!) but the most important question the commit
> log should answer is "Why?". The question "What?" isn't actually that
> important as anyone can read the patch themselves.
> 
> -- 
> Kalle Valo

Soumik,

Are you going to repost with a proper changelog?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
