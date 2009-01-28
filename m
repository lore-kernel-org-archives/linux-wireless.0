Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24709 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbZA1Opi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 09:45:38 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 06:45:38 -0800
Date: Wed, 28 Jan 2009 06:44:55 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: add get reg command
Message-ID: <20090128144455.GE6174@tesla> (sfid-20090128_154544_019981_CF5F0510)
References: <1233111125-7955-1-git-send-email-lrodriguez@atheros.com> <1233137841.3936.2.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1233137841.3936.2.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 28, 2009 at 02:17:21AM -0800, Johannes Berg wrote:
> On Tue, 2009-01-27 at 18:52 -0800, Luis R. Rodriguez wrote:
> 
> > +	mutex_lock(&cfg80211_drv_mutex);
> > +	regd = reg_get_current_rd();
> > +	mutex_unlock(&cfg80211_drv_mutex);
> > +
> > +	if (!regd)
> > +		goto out;
> 
> Any reason you need to copy and can't just build the whole thing under
> lock?

Glad you asked, we can lock the entire call or we can do the above to
copy. I picked a copy to not let a regular user (get reg can be called
by anyone) abuse the lock as cfg80211_drv_mutex is used in a lot of places,
I guess its silly but other's input on this is appreciated as well. Not sure
if the copy was the best choice.

  Luis
