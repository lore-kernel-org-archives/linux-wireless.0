Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:39102 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab2LMWAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:00:55 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2239220lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 14:00:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355434516.9463.24.camel@jlt4.sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
 <1354812468-15709-19-git-send-email-johannes@sipsolutions.net>
 <CAB=NE6WVa8bqbe2oyfpEaEJ84s6+C=9wM9+wzgtm6HUNaqm4DQ@mail.gmail.com> <1355434516.9463.24.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 14:00:34 -0800
Message-ID: <CAB=NE6VLEQVag=orfvLGhoFbCtBkt2+wuAPtvSYw=cZoEkYKBw@mail.gmail.com> (sfid-20121213_230058_438686_B6800ECD)
Subject: Re: [PATCH 18/24] regulatory: fix reg_is_valid_request handling
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 13, 2012 at 1:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-12-13 at 13:27 -0800, Luis R. Rodriguez wrote:
>
>> > diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> > index 260b5d8..370cd31 100644
>> > --- a/net/wireless/nl80211.c
>> > +++ b/net/wireless/nl80211.c
>> > @@ -4333,6 +4326,8 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
>> >                 }
>> >         }
>> >
>> > +       mutex_lock(&cfg80211_mutex);
>> > +
>> >         r = set_regdom(rd);
>> >         rd = NULL;
>>
>> Unless you removed it from previous patches in the series the
>> "bad_reg" goto label has an unlock but above you removed the top
>> locking call so I think you just forgot to remove the unlock on the
>> goto label.
>
> Good catch. Wonder why smatch didn't complain? Fixed.


>> > @@ -1471,6 +1475,7 @@ new_request:
>
>         if (last_request != &core_request_world)
>                 kfree(last_request);
>
>> >
>> >         last_request = pending_request;
>> >         last_request->intersect = intersect;
>> > +       last_request->processed = false;
>>
>> The clearing you are doing is on the last_request but it comes from
>> the pending regulatory request which is always false given that the
>> request is kzalloc'd, not sure if that was needed or how that helped.
>
> Not necessarily, I added a bit more context above -- if it's
> core_request_world the clearing is needed I believe.

Good catch yes, upon reset only if we actually run the core request
upon reset and I do think we do. Yeap:

static void reset_regdomains(bool full_reset)
...
     last_request = &core_request_world;
}

With your fix in place:

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis
