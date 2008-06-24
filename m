Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:19839 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbYFXRcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 13:32:12 -0400
Received: by ug-out-1314.google.com with SMTP id h2so758094ugf.16
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 10:32:11 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Add RTNL warning for workqueue
Date: Tue, 24 Jun 2008 19:32:37 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200806241923.36230.IvDoorn@gmail.com> <1214328526.8967.292.camel@johannes.berg>
In-Reply-To: <1214328526.8967.292.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806241932.37536.IvDoorn@gmail.com> (sfid-20080624_193216_818932_B816927A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 24 June 2008, Johannes Berg wrote:
> On Tue, 2008-06-24 at 19:23 +0200, Ivo van Doorn wrote:
> > The workqueue provided by mac80211 should not be used for
> > scheduled tasks that acquire the RTNL lock. This could be done
> > when the driver uses the function ieee80211_iterate_active_interfaces()
> > within the scheduled work. Such behavior will end in locking
> > dependencies problems when an interface is being removed.
> > 
> > This patch will add a notification about the RTNL locking and
> > the mac80211 workqueue to prevent driver developers from
> > blindly using it.
> > 
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> > index 19f1e41..02c79e6 100644
> > --- a/include/net/mac80211.h
> > +++ b/include/net/mac80211.h
> > @@ -738,8 +738,11 @@ enum ieee80211_hw_flags {
> >   * @conf: &struct ieee80211_conf, device configuration, don't use.
> >   *
> >   * @workqueue: single threaded workqueue available for driver use,
> > - *	allocated by mac80211 on registration and flushed on
> > - *	unregistration.
> > + *	allocated by mac80211 on registration and flushed when an
> > + *	interface is removed.
> 
> Interesting point. Should it be there or rather be moved down a bit so
> that it is actually only flushed when _all_ interfaces are stopped, i.e.
> before ->stop is invoked?

Personally I think it makes most sense when all interfaces are gone,
and thus either before or after ->stop(). But I am not sure which
drivers currently rely on the current position of flush_workqueue().

Ivo
