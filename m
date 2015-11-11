Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0098.hostedemail.com ([216.40.44.98]:47727 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751635AbbKKNnT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 08:43:19 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave01.hostedemail.com (Postfix) with ESMTP id 9A7C25D9F6
	for <linux-wireless@vger.kernel.org>; Wed, 11 Nov 2015 13:34:34 +0000 (UTC)
Date: Wed, 11 Nov 2015 08:34:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
	Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC v2 3/4] mac80211: use static keys for hw flags
Message-ID: <20151111083430.1e77c329@gandalf.local.home> (sfid-20151111_144322_774178_41B4AE5B)
In-Reply-To: <1447227472.2276.7.camel@sipsolutions.net>
References: <1447145549-27376-1-git-send-email-johannes@sipsolutions.net>
	<1447145549-27376-4-git-send-email-johannes@sipsolutions.net>
	<1447201345.2475.15.camel@coelho.fi>
	<1447227472.2276.7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 11 Nov 2015 08:37:52 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2015-11-11 at 02:22 +0200, Luca Coelho wrote:
> > 
> > Now that you have all these options in Kconfig, wouldn't it be
> > possible
> > to remove the calls to the "static" ieee80211_hw_set() in the drivers
> > and somehow set all the flags that are defined in Kconfig
> > automatically?
> >   
> 
> Since Kconfig flags are global (across multiple drivers) I don't really
> see a way to do that.
> 
> I'd *love*, however, to have an "increment" in Kconfig, then I could
> get rid of the _OFF ones:
> 
> config MAC80211_NUM_DRIVERS
> 	int
> 
> config MAC80211_HW_HAS_RATE_CONTROL
> 	int
> 
> config MY_DRIVER
> 	depends on MAC80211
> 	increment MAC80211_NUM_DRIVERS
> 	increment MAC80211_HW_MYFLAG

If you don't need to check more that >0 why not just use SELECT?

-- Steve

> 
> 
> and then later
> 
> if (CONFIG_MAC80211_HW_MYFLAG == 0)
> 	/* optimise for flag OFF */
> else if (CONFIG_MAC80211_HW_MYFLAG > 0 &&
>          CONFIG_MAC80211_NUM_DRIVERS == CONFIG_MAC80211_HW_MYFLAG)
> 	/* optimise for flag ON */
> else if (CONFIG_MAC80211_HW_MYFLAG > 0)
> 	/* don't optimise */
> 
> That's far more maintainable in the long term, since each driver only
> needs to list in its Kconfig the flags it *wants*, not *all*.
> 
> Maybe I'll try to see if I can hack Kconfig to do that.
> 
> johannes

