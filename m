Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2ITHdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 03:33:17 -0400
Message-ID: <1348126434.4161.9.camel@jlt4.sipsolutions.net> (sfid-20120920_093321_231376_209B9FD7)
Subject: Re: [PATCH 0/3] mac80211: avoid useless delBA frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 20 Sep 2012 09:33:54 +0200
In-Reply-To: <CA+XVXfd1ZiYjZaRUFeZvDVvi5gqmE6fVs=qjZW-JshRaWxSoRA@mail.gmail.com> (sfid-20120919_214556_074969_D42F77F2)
References: <1348049313-7650-1-git-send-email-johannes@sipsolutions.net>
	 <CA+XVXfcxHENu1HzY+-WkyMr6g+3P2wSyj7BhDsfKgZoB7fZHRg@mail.gmail.com>
	 <1348083291.7081.11.camel@jlt4.sipsolutions.net>
	 <CA+XVXfd1ZiYjZaRUFeZvDVvi5gqmE6fVs=qjZW-JshRaWxSoRA@mail.gmail.com>
	 (sfid-20120919_214556_074969_D42F77F2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-19 at 22:45 +0300, Arik Nemtsov wrote:

> >> Maybe it's a good opportunity to also fix ieee80211_reconfig? I
> >> remember you mentioned some FW/HW issue there, perhaps this was solved
> >> in the meantime. Otherwise we can add a HW flag for that I guess.
> >
> > Not sure what you mean?
> 
> All BA sessions are destroyed right after reconfig. For devices that
> manage these in FW, the FW was just reloaded and doesn't know about
> existing sessions at all.
> So I guess there's sense in sending the delBA, but no sense calling
> the driver ampdu callback (at least for how 12xx works).

Oh right. This is more of a workaround I guess, since we can't restore
them very well after a firmware reload won't know anything about them. I
haven't really thought much about this at all.

johannes

