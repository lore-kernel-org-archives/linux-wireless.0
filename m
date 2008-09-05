Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:5607 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbYIETLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 15:11:50 -0400
Received: by yx-out-2324.google.com with SMTP id 8so344846yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Sep 2008 12:11:49 -0700 (PDT)
Message-ID: <43e72e890809051211r3db3ca12m671c9ed9615b9e1b@mail.gmail.com> (sfid-20080905_211157_560757_56BB7D1E)
Date: Fri, 5 Sep 2008 12:11:49 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2 v4] cfg80211: Add new wireless regulatory infrastructure
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1220640389.11109.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1220636669-8153-1-git-send-email-lrodriguez@atheros.com>
	 <1220640389.11109.15.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 5, 2008 at 11:46 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> +enum nl80211_reg_rule_flags {
>> +     NL80211_RRF_NO_OFDM             = 1<<0,
>> +     NL80211_RRF_NO_CCK              = 1<<1,
>> +     NL80211_RRF_NO_INDOOR           = 1<<2,
>> +     NL80211_RRF_NO_OUTDOOR          = 1<<3,
>
>> +     NL80211_RRF_DFS                 = 1<<4,
>> +     NL80211_RRF_PTP_ONLY            = 1<<4,
>> +     NL80211_RRF_PTMP_ONLY           = 1<<4,
>> +     NL80211_RRF_PASSIVE_SCAN        = 1<<4,
>
> That seems a bit wrong?

You got it.

>> +     NL80211_RRF_NO_IBSS             = 1<<8,
>> +     /* hole at 9, used to be NO_HT20  */
>> +     NL80211_RRF_NO_HT40             = 1<<10,
>
> and I'm still not sure we should be using the same bit assignments as in
> the userspace part, that'll just make people think we have to do that,
> while we don't really, I'd rather see a clean set here and have the
> userspace code contain an internal mapping from its values to the kernel
> values.

This is not merged yet so technically we can start fresh and just
modify regdb.h. What do you think.

>> +struct ieee80211_freq_range {
>> +     u32 start_freq;
>> +     u32 end_freq;
>> +     u32 max_bandwidth;
>
> u32 seems excessive for the bandwidth, no?

I think its fine, remember this is in KHz.

>> +struct ieee80211_reg_rule {
>> +     struct ieee80211_freq_range freq_range;
>> +     struct ieee80211_power_rule power_rule;
>> +     u32 flags;
>
> a note what those flags are would probably be good.

Sure.

>>       u16 center_freq;
>> +     u8 max_bandwidth;
>
> and here you're using u8 anyway :)

and this is in MHz

>> +extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
>> +             const char *alpha2, struct ieee80211_regdomain *rd);
>
> generally extern is left out at least in code I did, but I don't care
> much; however, why is this one exported in the global header file?
>
>> +             /* IEEE 802.11b/g, channels 1..11 */
>> +             REG_RULE(2412-40, 2462+40, 40, 6, 27, 0),
>
> that's wrong, should be -20/+20, same for all the others. Also, doesn't
> it have to be in KHz? I can't really tell right now.

Dah yes.

>> + * In addition to all this we provide an extra layer of regulatory
>> + * comformance. For drivers which do not have any regulatory
>
> typo, conformance

Thanks.

>> + * Note: When number of rules --> infinity we will not be able to
>> + * index on alpha2 any more, instead we'll probably have to
>> + * rely on some SHA1 checksum of the regdomain for example.
>
> don't understand?

Well my crystal ball tells me we may have dynamic regulatory domains
in the future to enhance communication on the fly, an sha1sum of the
regdomain would seem fit then to identify it. I don't expect to see
this for a while though.

>> +     /* ASCII 0 */
>> +     if (alpha2[0] == 48 && alpha2[1] == 48)
>
> You could use '0' instead of 48 and save the comment :)

Sure.

>> +                             if (alpha2_equal(alpha2,
>> +                                             cfg80211_regdomain->alpha2))
>> +                                     return -EALREADY;
>> +                             /* Driver should not be trying to hint
>> +                              * different regulatory domains! */
>> +                             BUG_ON(!alpha2_equal(alpha2,
>> +                                             cfg80211_regdomain->alpha2));
>
> Huh? Doesn't that like always trigger due to the if above?

Yes, seemed better then BUG_ON(1) though.

>> +EXPORT_SYMBOL(__regulatory_hint);
>
> For whom does that need to be exported?

For 11d work which is not in place yet, for example. This allows other
parts of the kernel regulatory_hint() other than drivers.

  Luis
