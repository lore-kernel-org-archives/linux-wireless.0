Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:56562 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751597AbaFIOwj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2014 10:52:39 -0400
Message-ID: <1402325549.2004.41.camel@dubbel> (sfid-20140609_165243_596438_1160E5BE)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 09 Jun 2014 17:52:29 +0300
In-Reply-To: <1402305679.2004.37.camel@dubbel>
References: <1402068423-23359-1-git-send-email-luca@coelho.fi>
	 <1402080365-15462-1-git-send-email-luca@coelho.fi>
	 <CA+BoTQkX=ZpDc=R+nWxsrj026XyaaEiwrosaB2buRVif2aOnxQ@mail.gmail.com>
	 <1402298460.2004.34.camel@dubbel>
	 <1402305420.17674.0.camel@jlt4.sipsolutions.net>
	 <1402305679.2004.37.camel@dubbel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [RFC option 2] mac80211: introduce refcount for
 queue_stop_reasons
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-06-09 at 12:21 +0300, Luca Coelho wrote:
> On Mon, 2014-06-09 at 11:17 +0200, Johannes Berg wrote:
> > On Mon, 2014-06-09 at 10:21 +0300, Luca Coelho wrote:
> > 
> > > > I think you need to make sure all stop/wake calls are balanced
> > > > everywhere (including device drivers). Otherwise you risk breaking
> > > > things silently in some cases.
> > 
> > > Checking this might be tricky, actually, since I think there are some
> > > assumptions that stopping a queue that is already stopped is a NOP, but
> > > now we add to the refcount...
> > 
> > I don't think we can force drivers to keep track of this, we'll have to
> > keep the API without refcounting for drivers, I'd say.
> 
> Yeah, I was thinking in the same terms... Even for mac80211 might be a
> bit tricky to do it.
> 
> Maybe I could keep the old APIs as is (ie. they wake the queues no
> matter what the refcount is) and make the new
> ieee80211_stop/wake_vif_queues() refcounted?

Actually, to make things easier, I'll make this patch include a
"refcounted" boolean in the start/stop queues functions and always call
with !refcounted for now.  Then we can gradually start using refcounted
queue stopping as needed (for instance with CSA and, possibly, with
aggregation where we already have refcounting).

New patch coming soon...

--
Luca.

