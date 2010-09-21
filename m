Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:53293 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab0IUAaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 20:30:14 -0400
Received: from kpbe15.cbf.corp.google.com (kpbe15.cbf.corp.google.com [172.25.105.79])
	by smtp-out.google.com with ESMTP id o8L0UBFj004508
	for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 17:30:12 -0700
Received: from iwn35 (iwn35.prod.google.com [10.241.68.99])
	by kpbe15.cbf.corp.google.com with ESMTP id o8L0Tuk8006662
	for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 17:30:10 -0700
Received: by iwn35 with SMTP id 35so6041516iwn.23
        for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 17:30:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285020801.30653.5.camel@dcbw.foobar.com>
References: <AANLkTimYa4A=WFoY_sv-iMOPeZ37u8Hcy9wbsZO5eNun@mail.gmail.com>
	<1285020801.30653.5.camel@dcbw.foobar.com>
Date: Mon, 20 Sep 2010 17:30:09 -0700
Message-ID: <AANLkTinUAGhi46y2UMJj3nq2yfS4VQOKaDyL4msfJMZ1@mail.gmail.com>
Subject: Re: mac80211: Why probe after each scan?
From: Paul Stewart <pstew@google.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Sam Leffler <sleffler@chromium.org>,
	"Berg, Johannes" <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

But mac80211 also does beacon loss detection.  I'd much prefer more
aggressive (shorter timeout) beacon loss parameters (perhaps
configured that way only after end-of-scan, although I believe in
general the timeout is rather generous even for the normal case) than
to require round-trips with the AP just to find out if it's there.
For the most part, I think beacons do the job of AP presence detection
fairly well.

--
Paul

On Mon, Sep 20, 2010 at 3:13 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Fri, 2010-09-17 at 20:01 -0700, Paul Stewart wrote:
>> I found a small bit of behavior related in some vague way to
>> connection monitoring:  During the scan-completed notification
>> (ieee80211_mlme_notify_scan_completed) we call
>> ieee80211_restart_sta_timer() on all our interfaces, which in turn
>> queues up the &ifmgd->monitor_work, which does a probe request of our
>> AP.  Why should we do a probe request of your associated AP every time
>> a scan completes?  Wouldn't the other active monitoring schemes (like
>> beacon loss) be sufficient for a "scan finished" condition?
>
> One reason I can think of is to quickly determine whether your AP is
> still around and active given that you may have just been off-channel
> for a significant period of time.  Not all drivers background scan yet.
> But with any sane driver, you'd have already sent your "no longer in
> powersave mode" NULL packet to the AP right after finishing the scan, so
> perhaps the probe is redundant.
>
> Dan
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
