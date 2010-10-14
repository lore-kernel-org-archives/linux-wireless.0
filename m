Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:55877 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab0JNOYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 10:24:43 -0400
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id o9EEOglb031871
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 07:24:42 -0700
Received: from gyh3 (gyh3.prod.google.com [10.243.50.195])
	by wpaz37.hot.corp.google.com with ESMTP id o9EEOC0O012329
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 07:24:41 -0700
Received: by gyh3 with SMTP id 3so2285597gyh.35
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 07:24:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287064265.4641.435.camel@jlt3.sipsolutions.net>
References: <20101013224851.B8E5D20465@glenhelen.mtv.corp.google.com>
	<1287064265.4641.435.camel@jlt3.sipsolutions.net>
Date: Thu, 14 Oct 2010 07:24:40 -0700
Message-ID: <AANLkTinq=B13gPd3obqAkBDQv4Ufz5Upp2UPVw9bpED2@mail.gmail.com>
Subject: Re: [PATCH 3/6] Add a function for evaluating rate changes for
 possible notification
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 6:51 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-10-13 at 15:13 -0700, Paul Stewart wrote:
>> Called from a work proc, this examines the last transmit rate change
>> to see if it warrants an event transmission.
>
>> +        list_for_each_entry(sdata, &local->interfaces, list) {
>> +                if (!netif_running(sdata->dev) ||
>
> ieee80211_sdata_running
>
>> +             if (!(ifmgd->flags & IEEE80211_STA_TX_RATE_CHANGED) ||
>> +                 bss_conf->cqm_bitrate_thold == 0)
>> +                     continue;
>
> why would this work item even be running with a threshold of zero?

This would be in the case where the userspace reset the threshold back
to zero (no longer interested in bitrate change events) but a work
task was already scheduled it's a small window and I can remove that
conditional if it suits.

> Again, this won't compile without the next patch.

I'll fix.

> However, I think all of this is really expensive. For many devices,
> you'll effectively be triggering an evaluation of the bitrate for every
> packet. This will work well with minstrel, since it properly uses and
> advertises the "best throughput" rate, but not necessarily with other
> algorithms.

I could throttle-down the execution rate of this work proc to a
minimum periodicity, at the expense of timely information.  Is this
along the lines of what you'd like done?

--
Paul
