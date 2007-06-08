Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59768 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967472AbXFHJVk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 05:21:40 -0400
Date: Fri, 8 Jun 2007 11:21:46 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] mac80211: Set low initial rate in rc80211_simple
Message-ID: <20070608112146.2df3608c@griffin.suse.cz>
In-Reply-To: <200706072205.27902.flamingice@sourmilk.net>
References: <4668c71b.E0vXnFMnxxm8I5gE%Larry.Finger@lwfinger.net>
	<200706072038.36708.flamingice@sourmilk.net>
	<4668D1BB.40705@lwfinger.net>
	<200706072205.27902.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 7 Jun 2007 22:05:21 -0700, Michael Wu wrote:
> On Thursday 07 June 2007 20:49, Larry Finger wrote:
> > Does mode->rates[0].flags automatically have IEEE80211_RATE_SUPPORTED set?
> > That wasn't clear to me.
> >
> Yes. (see ieee80211_prepare_rates)

No :-) In theory, you can use PRISM2_HOSTAPD_SET_RATE_SETS ioctl to
disable the lowest available rate. Yes, that's deprecated and bad thing
to do; but unfortunately, it can be done with the current code.

Larry's patch is IMHO correct.

 Jiri

-- 
Jiri Benc
SUSE Labs
