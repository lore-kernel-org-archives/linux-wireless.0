Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:54412 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab3LCQAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 11:00:10 -0500
Received: by mail-la0-f51.google.com with SMTP id ec20so9184694lab.38
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 08:00:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386080437.4393.26.camel@jlt4.sipsolutions.net>
References: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com>
	<1386060648-6020-2-git-send-email-janusz.dziedzic@tieto.com>
	<1386080437.4393.26.camel@jlt4.sipsolutions.net>
Date: Tue, 3 Dec 2013 17:00:06 +0100
Message-ID: <CALhHN=otvEjKAWxRvX4KAC4DY39BSeqm-v8mOfyL+M2XLQezYw@mail.gmail.com> (sfid-20131203_170014_816287_29629017)
Subject: Re: [PATCH 2/4] nl80211: back to default bitrate_mask correctly
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 December 2013 15:20, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2013-12-03 at 09:50 +0100, Janusz Dziedzic wrote:
>> In case of empty NL80211_ATTR_TX_RATES attribute
>> in nl80211_set_tx_bitrate_mask() function back to
>> default bitrate mask.
>
> Err what?
>
>> +++ b/net/wireless/nl80211.c
>> @@ -7311,9 +7311,6 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
>>       struct nlattr *tx_rates;
>>       struct ieee80211_supported_band *sband;
>>
>> -     if (info->attrs[NL80211_ATTR_TX_RATES] == NULL)
>> -             return -EINVAL;
>
> Why?
In case we will execute:
iw wlanX set bitrate
with this patch we will back to default - defined by capabilities
(driver) startup values for both legacy and ht (and VHT with last
patch).

Without this patch I don't see an option how to do that from iw. Or I
miss something

BR
Janusz
