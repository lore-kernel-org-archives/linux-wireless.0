Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43516 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab3BRRZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 12:25:20 -0500
Message-ID: <1361208314.8555.37.camel@jlt4.sipsolutions.net> (sfid-20130218_182522_754469_B0A7A612)
Subject: Re: [PATCH] cfg80211: fix station change if TDLS isn't supported
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Mon, 18 Feb 2013 18:25:14 +0100
In-Reply-To: <512263B9.3000402@lwfinger.net> (sfid-20130218_182434_336242_32BE8C45)
References: <51207925.5040702@lwfinger.net>
	 <1361196149-10731-1-git-send-email-johannes@sipsolutions.net>
	 <512263B9.3000402@lwfinger.net> (sfid-20130218_182434_336242_32BE8C45)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-18 at 11:24 -0600, Larry Finger wrote:
> On 02/18/2013 08:02 AM, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Larry noticed (and bisected) that commit df881293c6ba9a12868491a717b25
> > "cfg80211: Pass TDLS peer's QoS/HT/VHT information during set_station"
> > broke secure connections. This is is the case only for drivers that
> > don't support TDLS, where any kind of change, even just the change of
> > authorized flag that is required for normal operation, was rejected
> > now. To fix this, remove the checks. I have some patches that will add
> > proper verification for all the different cases later.
> >
> > Cc: Jouni Malinen <j@w1.fi>
> > Bisected-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Johannes,
> 
> Thanks. This patch does fix the problem. The only thing I saw was an unused 
> variable:
> 
> net/wireless/nl80211.c: In function ‘nl80211_set_station_tdls’:
> net/wireless/nl80211.c:3421:37: warning: unused variable ‘rdev’ [-Wunused-variable]
> 
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, I'll fix that variable and apply the patch.

johannes

