Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab0ITWNy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 18:13:54 -0400
Subject: Re: mac80211: Why probe after each scan?
From: Dan Williams <dcbw@redhat.com>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Sam Leffler <sleffler@chromium.org>,
	"Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <AANLkTimYa4A=WFoY_sv-iMOPeZ37u8Hcy9wbsZO5eNun@mail.gmail.com>
References: <AANLkTimYa4A=WFoY_sv-iMOPeZ37u8Hcy9wbsZO5eNun@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 17:13:21 -0500
Message-ID: <1285020801.30653.5.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-17 at 20:01 -0700, Paul Stewart wrote:
> I found a small bit of behavior related in some vague way to
> connection monitoring:  During the scan-completed notification
> (ieee80211_mlme_notify_scan_completed) we call
> ieee80211_restart_sta_timer() on all our interfaces, which in turn
> queues up the &ifmgd->monitor_work, which does a probe request of our
> AP.  Why should we do a probe request of your associated AP every time
> a scan completes?  Wouldn't the other active monitoring schemes (like
> beacon loss) be sufficient for a "scan finished" condition?

One reason I can think of is to quickly determine whether your AP is
still around and active given that you may have just been off-channel
for a significant period of time.  Not all drivers background scan yet.
But with any sane driver, you'd have already sent your "no longer in
powersave mode" NULL packet to the AP right after finishing the scan, so
perhaps the probe is redundant.

Dan


