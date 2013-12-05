Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52263 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472Ab3LEOna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 09:43:30 -0500
Message-ID: <1386254607.4182.5.camel@jlt4.sipsolutions.net> (sfid-20131205_154334_365931_CEE6886D)
Subject: Re: [PATCH 4/4] cfg80211: prevent race condition on scan request
 cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 05 Dec 2013 15:43:27 +0100
In-Reply-To: <CAB3XZEcpM9PAQCGQ99X2A-bqYXoPEmE=Cg29CDKY7=s8QquwUA@mail.gmail.com> (sfid-20131205_153628_734285_E05F0247)
References: <1386235289-27278-1-git-send-email-eliad@wizery.com>
	 <1386235289-27278-4-git-send-email-eliad@wizery.com>
	 <1386253879.4182.4.camel@jlt4.sipsolutions.net>
	 <CAB3XZEcpM9PAQCGQ99X2A-bqYXoPEmE=Cg29CDKY7=s8QquwUA@mail.gmail.com>
	 (sfid-20131205_153628_734285_E05F0247)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 16:36 +0200, Eliad Peller wrote:
> On Thu, Dec 5, 2013 at 4:31 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2013-12-05 at 11:21 +0200, Eliad Peller wrote:
> >
> >> @@ -219,8 +221,13 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
> >>        * the scan request or not ... if it accesses the dev
> >>        * in there (it shouldn't anyway) then it may crash.
> >>        */
> >> -     if (!leak)
> >> -             kfree(request);
> >> +     if (leak) {
> >> +             request->pending_cleanup = true;
> >> +             return;
> >
> > This seems insufficient, if the driver never indicates completion, we'd
> > never clear rdev->scan_req?
> >
> right, but i think it somehow makes sense (i.e. the driver must
> indicate completion...)?

But the whole thing was intended to catch buggy drivers :)

Btw, should any of this go to 3.13?

johannes

