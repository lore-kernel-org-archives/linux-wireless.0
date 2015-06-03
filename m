Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42942 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbbFCHEs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:04:48 -0400
Message-ID: <1433315085.2274.3.camel@sipsolutions.net> (sfid-20150603_090505_765340_08CCCF1C)
Subject: Re: [RFC] mac80211: convert HW flags to unsigned long bitmap
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, gregory.greenman@intel.com
Date: Wed, 03 Jun 2015 09:04:45 +0200
In-Reply-To: <1433313312.4861.119.camel@perches.com>
References: <1433273994-14430-1-git-send-email-johannes@sipsolutions.net>
	 <1433313312.4861.119.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-02 at 23:35 -0700, Joe Perches wrote:

> > +	IEEE80211_HW_HAS_RATE_CONTROL,
> > +	IEEE80211_HW_RX_INCLUDES_FCS,
> 
> It may be nicer to use specified bit numbers here.
> 
> It may make compatibility easier and maybe it should be
> written down that new entries are only to be added at
> the bottom of the enum and not inserted in the middle.

There's no reason for that, since it's pure kernel internal API any
renumbering of these bits is perfectly fine.

> This is similar to the broadcom tg3 driver, but a little different.
> 
> The mechanism in tg3 compared to ieee80211_hw is
> 	tg3_flag	ieee80211_hw_check
> 	tg3_flag_set	ieee80211_hw_set
> 	tg3_flag_clear	?
> 
> Would a ieee80211_hw_clear be useful?

See my reply to Julian.

> Would it be clearer without the _check?

Well, I thought it would read as

ieee80211_hw "check has_rate_control"

with this in a sense, for example.

> >  static ssize_t hwflags_read(struct file *file, char __user *user_buf,
> >  			    size_t count, loff_t *ppos)
> >  {
> []
> > +	for (i = 0; i < NUM_IEEE80211_HW_FLAGS; i++) {
> > +		if (test_bit(i, local->hw.flags))
> 
> Maybe use the ieee80211_hw_check() function?

Obviously that won't work. :) I could use the _ieee80211 one, but I'm
considering just getting rid of that one and inlining the test_bit into
the macro instead.

johannes

