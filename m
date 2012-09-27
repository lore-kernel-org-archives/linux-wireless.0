Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab2I0Oux (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 10:50:53 -0400
Message-ID: <1348757655.32301.6.camel@dcbw.foobar.com> (sfid-20120927_165057_299662_1EBEF057)
Subject: Re: [PATCH 3/3] cfg80211: add support for flushing old scan results
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sam Leffler <sleffler@chromium.org>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 27 Sep 2012 09:54:15 -0500
In-Reply-To: <1348737359.10353.8.camel@jlt4.sipsolutions.net>
References: <20120926165952.BC0E71E051D@sleffler.sfo.corp.google.com>
	 (sfid-20120926_185956_248675_62A4C8CC) <1348737359.10353.8.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-27 at 11:15 +0200, Johannes Berg wrote:
> On Fri, 2012-09-21 at 11:08 -0700, Sam Leffler wrote:
> 
> >  void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
> >  {
> >  	struct cfg80211_scan_request *request;
> > @@ -47,8 +50,16 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
> >  
> >  	if (request->aborted)
> >  		nl80211_send_scan_aborted(rdev, wdev);
> > -	else
> > +	else {
> > +		if (request->flags & CFG80211_SCAN_FLAG_FLUSH) {
> > +			/* flush entries from previous scans */
> > +			spin_lock_bh(&rdev->bss_lock);
> > +			__cfg80211_bss_expire(rdev,
> > +				jiffies - request->scan_start);
> 
> I wonder if we should pass an absolute time instead? jiffies will
> continue to advance while we iterate the list etc., if we pass the
> absolute time in both cases we can avoid this small race condition.
> 
> The race really isn't important, but it still seems a bit cleaner to me
> overall.

jiffies are also complicated by suspend/resume.  Absolute time would be
better.

Dan

