Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726Ab3CGLuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 06:50:23 -0500
Message-ID: <1362657018.8694.31.camel@jlt4.sipsolutions.net> (sfid-20130307_125033_390350_6C6AE876)
Subject: Re: Memory leaks in cfg80211 and mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 07 Mar 2013 12:50:18 +0100
In-Reply-To: <5137D6F8.4050007@lwfinger.net> (sfid-20130307_005334_931364_1B9BDD2F)
References: <51365EBC.9080602@lwfinger.net>
	  (sfid-20130305_220821_742055_EAAAA72D) <1362562265.8457.7.camel@jlt4.sipsolutions.net>
	 <5137D6F8.4050007@lwfinger.net> (sfid-20130307_005334_931364_1B9BDD2F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-06 at 17:53 -0600, Larry Finger wrote:

> > However, that's a corner case, I don't think you ran into it. Since you
> > also didn't note any warnings, we can also discount a few cases that
> > would be code bugs and would leak.
> >
> > I wonder if this is related to the first warning? The "new" object in
> > the first block would typically take ownership of the "ies" object.
> 
> Although I do not get any warnings, your patch and mine have made the kmemleak 
> scan now come up clean. I will continue testing and let you know.

Ok. I guess I'll apply my patch, and we can see about yours later (since
it's only a false positive, while mine actually fixes a potential leak).

Were you reconfiguring your AP's SSID by any chance?

johannes

