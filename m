Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:4049 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992591AbXCWWSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 18:18:16 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1150804uga
        for <linux-wireless@vger.kernel.org>; Fri, 23 Mar 2007 15:18:15 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: Prevent unregistering of unregistered hw
Date: Fri, 23 Mar 2007 23:17:48 +0100
Cc: Jiri Benc <jbenc@suse.cz>, John <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
References: <200703232021.26462.IvDoorn@gmail.com> <1174680868.4470.8.camel@johannes.berg>
In-Reply-To: <1174680868.4470.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703232317.48451.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 March 2007 21:14, Johannes Berg wrote:
> On Fri, 2007-03-23 at 20:21 +0100, Ivo van Doorn wrote:
> 
> > diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> > index 577dbe3..e7a613d 100644
> > --- a/net/mac80211/ieee80211.c
> > +++ b/net/mac80211/ieee80211.c
> > @@ -4765,6 +4765,9 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
> >  	/* TODO: skb_queue should be empty here, no need to do anything? */
> >  
> >  	rtnl_lock();
> > +
> > +	BUG_ON(local->reg_state != IEEE80211_DEV_REGISTERED);
> > +
> 
> Hm. Maybe that's better since then there's no race like in my patch. Use
> this one instead of mine please. But it does kill the system pretty
> badly if you BUG_ON with rtnl held :)

Well it would increase motivation to fix such a bug in the driver then. ;)
(yes, fixing that bug in rt2x00 is on my todo list :P)

Ivo
