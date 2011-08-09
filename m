Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56210 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab1HIMsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 08:48:35 -0400
Received: by gxk21 with SMTP id 21so1278666gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 05:48:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312892020.4109.26.camel@jlt3.sipsolutions.net>
References: <1311607763-12603-1-git-send-email-eliad@wizery.com>
	<1311607763-12603-2-git-send-email-eliad@wizery.com>
	<1312892020.4109.26.camel@jlt3.sipsolutions.net>
Date: Tue, 9 Aug 2011 15:48:34 +0300
Message-ID: <CAB3XZEeFZ-1Ne2gyZSUtHsZz8vMHX7HYxyWZLBd1-v7yTi5mRQ@mail.gmail.com> (sfid-20110809_144841_041857_2661FA93)
Subject: Re: [RFC 1/2] mac80211: fix remain_off_channel regression
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 9, 2011 at 3:13 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2011-07-25 at 18:29 +0300, Eliad Peller wrote:
>> i'm not familiar enough with the off_channel flow,
>> but this one looks completely broken - we should
>> remain_off_channel if the work was started, and
>> the work's channel and channel_type are the same
>> as local->tmp_channel and local->tmp_channel_type.
>>
>> however, if wk->chan_type and local->tmp_channel_type
>> coexist (e.g. have the same channel type), we won't
>> remain_off_channel.
>>
>> this behavior was introduced by commit da2fd1f
>> ("mac80211: Allow work items to use existing
>> channel type.")
>
> Yeah this seems obvious.
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>
> Now that I look at ieee80211_work_ct_coexists() itself again though it
> seems to do HT20 wrong?
>
hmm... yeah.
and also HT40 seems wrong (e.g. HT40 + NO_HT).
