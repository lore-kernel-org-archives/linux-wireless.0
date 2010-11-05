Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:39325 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754849Ab0KETqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 15:46:51 -0400
Subject: Re: [RFC 06/15] mac80211: add support for HW periodic scan
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288885537.3659.4.camel@jlt3.sipsolutions.net>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
	 <1288612336-2830-7-git-send-email-luciano.coelho@nokia.com>
	 <1288885537.3659.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 21:59:37 +0200
Message-ID: <1288987177.25600.15.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-04 at 16:45 +0100, ext Johannes Berg wrote:
> On Mon, 2010-11-01 at 13:52 +0200, Luciano Coelho wrote:
> 
> > +	.periodic_start= ieee80211_periodic_start,
> > +	.periodic_stop= ieee80211_periodic_stop,
> 
> whitespace ... also, _scan really ...

Yeah, you're totally right.  I was thinking more about this and Oz said
he discussed this with you a bit.

I think the idea of using background is good.  Something like bg_scan or
something.  The original idea was to call it background scan, but since
wl1271 doesn't support this while connected, I thought calling it
periodic scan would be slightly clearer about that.  Background scan
sounds like you do it while connected (to me at least).

We should be able to do real background scans, connected or not.  If
wl1271 doesn't support it while connected, too bad, it should return
-EBUSY.  We shouldn't restrict other drivers from doing it while
connected just because wl1271 doesn't support it.

Actually I should try (again) to have TI change the firmware so that it
is possible while connected too.


> > +	trace_drv_periodic_stop(local, sdata);
> > +	ret = local->ops->periodic_stop(&local->hw, &sdata->vif);
> > +	trace_drv_return_int(local, ret);
> > +	return ret;
> 
> why does this have a return value?

Good point.  No need for it.


> > @@ -812,6 +812,7 @@ struct ieee80211_local {
> >  	struct cfg80211_ssid scan_ssid;
> >  	struct cfg80211_scan_request *int_scan_req;
> >  	struct cfg80211_scan_request *scan_req, *hw_scan_req;
> > +	struct cfg80211_periodic_request *periodic_req;
> 
> what do you need to store this for?

Ahmmm... Nothing? :) This seems unnecessary indeed and I'll recheck
this.


-- 
Cheers,
Luca.

