Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:60802 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbaA1TXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 14:23:48 -0500
Received: by mail-lb0-f172.google.com with SMTP id c11so739192lbj.17
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jan 2014 11:23:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140125003418.GF28512@garbanzo.do-not-panic.com>
References: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
	<20140125003418.GF28512@garbanzo.do-not-panic.com>
Date: Tue, 28 Jan 2014 20:23:46 +0100
Message-ID: <CALhHN=p11A-kA3S=ESz85OUSfHr5t+Qqka24wwbvfJuA-bksXQ@mail.gmail.com> (sfid-20140128_202403_475496_04DF1BC0)
Subject: Re: [PATCH v2 1/3] cfg80211: add helper reg_get_regdomain() function
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzi@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 January 2014 01:34, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> On Wed, Jan 22, 2014 at 01:43:42PM +0100, Janusz Dziedzic wrote:
>> Add helper function that will return regdomain.
>> Follow the driver's regulatory domain, if present,
>> unless a country IE has been processed or a user
>> wants to help complaince further.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzi@tieto.com>
>> ---
>>  net/wireless/reg.c |   31 ++++++++++++++++++++-----------
>>  1 file changed, 20 insertions(+), 11 deletions(-)
>>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index 9b897fc..d58a09c 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -522,6 +522,25 @@ bool reg_is_valid_request(const char *alpha2)
>>       return alpha2_equal(lr->alpha2, alpha2);
>>  }
>>
>> +static const struct ieee80211_regdomain *reg_get_regdomain(struct wiphy *wiphy)
>> +{
>> +     const struct ieee80211_regdomain *regd;
>> +     struct regulatory_request *lr = get_last_request();
>> +
>> +     /*
>> +      * Follow the driver's regulatory domain, if present, unless a country
>> +      * IE has been processed or a user wants to help complaince further
>> +      */
>> +     if (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
>> +         lr->initiator != NL80211_REGDOM_SET_BY_USER &&
>> +         wiphy->regd)
>> +             regd = get_wiphy_regdom(wiphy);
>> +     else
>> +             regd = get_cfg80211_regdom();
>> +
>> +     return regd;
>> +}
>> +
>>  /* Sanity check on a regulatory rule */
>>  static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
>>  {
>> @@ -821,18 +840,8 @@ const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
>>                                              u32 center_freq)
>>  {
>>       const struct ieee80211_regdomain *regd;
>> -     struct regulatory_request *lr = get_last_request();
>>
>> -     /*
>> -      * Follow the driver's regulatory domain, if present, unless a country
>> -      * IE has been processed or a user wants to help complaince further
>> -      */
>> -     if (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
>> -         lr->initiator != NL80211_REGDOM_SET_BY_USER &&
>> -         wiphy->regd)
>> -             regd = get_wiphy_regdom(wiphy);
>> -     else
>> -             regd = get_cfg80211_regdom();
>> +     regd = reg_get_regdomain(wiphy);
>
> Nice! I welcome this -- can you also add nl80211 API to expose when
> a wiphy has its own wiphy->regd and send that to userspace too?
>
You mean we should introduce:
iw wlanX reg get?
while in last_request we have only last wiphy(lr->wiphy_idx).


BR
Janusz
