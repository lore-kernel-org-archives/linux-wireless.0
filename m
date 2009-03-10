Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:33129 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZCJIns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 04:43:48 -0400
Received: by rv-out-0506.google.com with SMTP id g37so2108949rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 01:43:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1236669329.9658.30.camel@johannes.local>
References: <1236650699-30538-1-git-send-email-lrodriguez@atheros.com>
	 <1236650699-30538-4-git-send-email-lrodriguez@atheros.com>
	 <1236669329.9658.30.camel@johannes.local>
Date: Tue, 10 Mar 2009 01:43:46 -0700
Message-ID: <43e72e890903100143i76015377x31529b26b638275c@mail.gmail.com> (sfid-20090310_094350_665407_5723B16E)
Subject: Re: [PATCH 3/4] mac80211: disallow HT40 if max channel bandwidth is
	less than 40 MHz
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 10, 2009 at 12:15 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-03-09 at 22:04 -0400, Luis R. Rodriguez wrote:
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>> =C2=A0net/mac80211/util.c | =C2=A0 =C2=A03 +++
>> =C2=A01 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
>> index 32610a0..a891d7e 100644
>> --- a/net/mac80211/util.c
>> +++ b/net/mac80211/util.c
>> @@ -796,6 +796,9 @@ int ieee80211_set_freq(struct ieee80211_sub_if_d=
ata *sdata, int freqMHz)
>> =C2=A0 =C2=A0 =C2=A0 if (!chan || (chan->flags & IEEE80211_CHAN_DISA=
BLED))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
>>
>> + =C2=A0 =C2=A0 if (conf_is_ht40(&local->hw.conf) && chan->max_bandw=
idth < 40)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
>> +
>
> You just made nl80211 check this, why bother adding it here too?

Wext crap.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
