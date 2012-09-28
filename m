Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47692 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067Ab2I1UgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 16:36:10 -0400
Received: by ieak13 with SMTP id k13so8342713iea.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2012 13:36:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348830066.13298.21.camel@jlt4.sipsolutions.net>
References: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
	<1348772354-15936-2-git-send-email-bzhao@marvell.com>
	<1348830066.13298.21.camel@jlt4.sipsolutions.net>
Date: Fri, 28 Sep 2012 13:36:09 -0700
Message-ID: <CA+yqC4bMwqLr8oMuWYKWz+QhVscBe_KGnzHLEORKLVh2Ruj3bw@mail.gmail.com> (sfid-20120928_223619_372518_296BEACF)
Subject: Re: [PATCH v2 1/5] {nl,cfg}80211: add a flags word to scan requests
From: Sam Leffler <sleffler@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 28, 2012 at 4:01 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-09-27 at 11:59 -0700, Bing Zhao wrote:
>> From: Sam Leffler <sleffler@chromium.org>
>>
>> Add a flags word to direct and scheduled scan requests; it will
>> be used for control of optional behaviours such as flushing the
>> bss cache prior to doing a scan.
>
> Why for scheduled scan as well?

Because I thought the scheduled scan mechanism is used to trigger
periodic scans w/o involving user space and so might be used to do
bgscan's.  Please enlighten me.

>
>> + * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)
>
> One thing that might be useful is to advertise which flags are even
> supported at all by a driver, if we add different ones? We might then
> ignore the flags that we don't support anyway, but at least userspace
> would know that it can't expect flushing (for example) on an older
> kernel version and might have to use some workarounds or whatever.

Yes I considered this. I don't know what the model is for nl80211 in
this regard (think we've talked about this in the past).  The low
priority scan flag is somewhat advisory so applications should be able
to deal w/ it being ignored.  The flush flag however may be cause some
misbehaviour--e.g. you wakeup, scan, and then act on stale results
that may cause you try and associate to an ap that's out of range in
which case you'll end up doing the equivalent to the flush in user
space to make sure the right thing happens.

>
>> +/**
>> + * enum nl80211_scan_flags -  scan request control flags
>> + *
>> + * Scan request control flags are used to control the handling
>> + * of NL80211_CMD_TRIGGER_SCAN and NL80211_CMD_START_SCHED_SCAN
>> + * requests.
>> + */
>> +enum nl80211_scan_flags {
>> +};
>> +
>
>>  /**
>> + * enum cfg80211_scan_flags -  scan request control flags
>> + */
>> +enum cfg80211_scan_flags {
>> +};
>
> That doesn't make a lot of sense? A single enum seems sufficient?

I thought cfg80211's name space was separate from nl80211's?  Was just
trying to follow what I found elsewhere...

>
>> +     nla_put_u32(msg, NL80211_ATTR_SCAN_FLAGS, req->flags);
>
> Missing error check, also, is there nothing that re-publishes
> information about scheduled scans?
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
