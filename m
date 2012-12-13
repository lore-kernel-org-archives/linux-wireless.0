Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63100 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab2LMX5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 18:57:45 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so4959855ieb.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 15:57:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355442070.25160.2.camel@jlt4.sipsolutions.net>
References: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
	<1355439573-13206-6-git-send-email-johannes@sipsolutions.net>
	<CAB3XZEcz-qywVdb5OFG38Kdk8Vue4bS8zxAfuKs_FxFGaisd9w@mail.gmail.com>
	<1355442070.25160.2.camel@jlt4.sipsolutions.net>
Date: Fri, 14 Dec 2012 01:57:44 +0200
Message-ID: <CAB3XZEfKKXcy9GFk_fJcnA6y_5uG05gnzCsr1C52P+qT1WYDiw@mail.gmail.com> (sfid-20121214_005748_954687_607D7D2E)
Subject: Re: [PATCH 5/5] mac80211: optimise roaming time again
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 14, 2012 at 1:41 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-12-14 at 01:32 +0200, Eliad Peller wrote:
>> On Fri, Dec 14, 2012 at 12:59 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > From: Johannes Berg <johannes.berg@intel.com>
>> >
>> > The last fixes re-added the RCU synchronize penalty
>> > on roaming to fix the races. Split up sta_info_flush()
>> > now to get rid of that again, and let managed mode
>> > (and only it) delay the actual destruction.
>> >
>> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> > ---

>> > +static inline int sta_info_flush(struct ieee80211_sub_if_data *sdata)
>> > +{
>> > +       int ret = sta_info_flush_defer(sdata);
>> > +
>> > +       if (ret)
>> > +               sta_info_flush_cleanup(sdata);
>> > +
>> > +       return ret;
>> > +}
>> > +
>>
>> but i think this is wrong - there might already be stations in the cleanup list.
>> you should always call sta_info_flush_cleanup.
>
> I don't think so? I thought about this for a while, but I see only the
> case where there are stations being added to the list in the
> sta_info_flush_defer() call -- then the return value is bigger than zero
> and when we return, nothing is on the cleanup list.
>
> The other case is that there's something on the cleanup list for managed
> mode, but that only needs to be guaranteed to be cleaned up when the
> interface goes down (nothing in the destroy calls back to the driver) so
> there the explicit call to sta_info_flush_cleanup() should be enough?
>
well, i didn't delve into the exact use cases, but semantically, after
calling sta_info_flush(), i'd expect all the vif's stations to get
flushed.
this might be redundant right now (as there are no
sta_info_flush_defer calls followed by sta_info_flush), but it sounds
more correct to me.

Eliad.
