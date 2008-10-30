Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:14856 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYJ3TkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 15:40:06 -0400
Received: by yw-out-2324.google.com with SMTP id 9so339191ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 12:40:04 -0700 (PDT)
Message-ID: <43e72e890810301240p602b5e99gd2ba0984f078dea4@mail.gmail.com> (sfid-20081030_204014_772191_F61C5593)
Date: Thu, 30 Oct 2008 12:40:03 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/6] cfg80211: a reg rule is invalid if freq diff is 0
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <be0976f315094fc29b6d0ee915f8026a.squirrel@secure.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225329594-21704-1-git-send-email-lrodriguez@atheros.com>
	 <1225329594-21704-2-git-send-email-lrodriguez@atheros.com>
	 <be0976f315094fc29b6d0ee915f8026a.squirrel@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 30, 2008 at 2:22 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Luis R. Rodriguez wrote:
>> A regulatory rule is invalid when the frequency difference
>> between the end of the frequency range and the start is 0.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  net/wireless/reg.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index 9dff716..ff706f9 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -321,7 +321,7 @@ static bool is_valid_reg_rule(const struct
>> ieee80211_reg_rule *rule)
>>
>>       freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
>>
>> -     if (freq_range->max_bandwidth_khz > freq_diff)
>> +     if (freq_diff == 0 || freq_range->max_bandwidth_khz > freq_diff)
>
> Might want to make that <= 0 just in case?

Absolutely, thanks.

  Luis
