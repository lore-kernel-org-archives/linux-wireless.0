Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:59254 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbaAVPN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 10:13:56 -0500
Message-ID: <1390403634.4189.39.camel@porter.coelho.fi> (sfid-20140122_161359_883315_8E79AD84)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 22 Jan 2014 17:13:54 +0200
In-Reply-To: <1390403432.4334.33.camel@jlt4.sipsolutions.net>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	 <1390316761.6199.27.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	 <1390380726.4334.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com>
	 <1390382020.4334.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=iQ26EMyOS4Eroqf2G-uLtUUZHAxN6rD3Eq6CvSUj5Xg@mail.gmail.com>
	 (sfid-20140122_111301_086907_C6814DB8) <1390385995.4334.27.camel@jlt4.sipsolutions.net>
	 <1390394166.4189.28.camel@porter.coelho.fi>
	 <1390403432.4334.33.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 16:10 +0100, Johannes Berg wrote:
> On Wed, 2014-01-22 at 14:36 +0200, Luca Coelho wrote:
> 
> > I don't think we should try to merge the channel switches.  We should
> > just perform them separately, especially because the exact time of the
> > switch will most likely not be the same (since the TBTTs are not in
> > sync).
> 
> Do you mean that we shouldn't even have all that new API to switch
> multiple interfaces simultaneously?

Right, I'm not really sure it's necessary.  PErhaps with non-chanctx we
need something like that, but maybe it would still be better not to do
this in the nl80211 API, but sync/merge in cfg80211/mac80211?

--
Luca.

