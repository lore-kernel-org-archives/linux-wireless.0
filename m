Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:38731 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab3KFQyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 11:54:50 -0500
Received: by mail-lb0-f179.google.com with SMTP id w6so7949203lbh.38
        for <linux-wireless@vger.kernel.org>; Wed, 06 Nov 2013 08:54:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1383732921.14307.20.camel@jlt4.sipsolutions.net>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
 <1383671897-7746-2-git-send-email-mcgrof@do-not-panic.com> <1383732921.14307.20.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 6 Nov 2013 08:54:28 -0800
Message-ID: <CAB=NE6W+m0EkJPz90QyRxGWy8hyOXir7YZ3jGC7=Y9UH3unqLw@mail.gmail.com> (sfid-20131106_175453_167827_AFAA3ACA)
Subject: Re: [PATCH 01/19] cfg80211: enforce disabling channels by custom or
 strict settings
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 6, 2013 at 2:15 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2013-11-05 at 09:17 -0800, Luis R. Rodriguez wrote:
>
>> @@ -1251,7 +1261,7 @@ static void handle_channel_custom(struct wiphy *wiphy,
>>       if (IS_ERR(reg_rule)) {
>>               REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits it\n",
>>                             chan->center_freq);
>> -             chan->flags = IEEE80211_CHAN_DISABLED;
>> +             chan->flags = chan->orig_flags |= IEEE80211_CHAN_DISABLED;
>
> Are you sure the |= is right?

It works but I think its best to split this in retrospect to make it
clear, I'll send a v2 and I don't think the v2 would interfere with
the series.

  Luis
