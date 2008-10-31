Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.245]:11244 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYJaStO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 14:49:14 -0400
Received: by hs-out-0708.google.com with SMTP id 4so734566hsl.5
        for <linux-wireless@vger.kernel.org>; Fri, 31 Oct 2008 11:49:11 -0700 (PDT)
Message-ID: <43e72e890810311149g8c76ce5xb86768c2ba05b18e@mail.gmail.com> (sfid-20081031_194919_577649_D2A11794)
Date: Fri, 31 Oct 2008 11:49:11 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] wireless: Add 802.11d support
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225448143.3535.17.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225428211-17353-1-git-send-email-lrodriguez@atheros.com>
	 <1225448143.3535.17.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 31, 2008 at 3:15 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-10-30 at 21:43 -0700, Luis R. Rodriguez wrote:
>
>> +struct ieee80211_regdomain *ieee80211_country_ie_2_rd(
>> +                             u8 *country_ie, u8 country_ie_len)
>> +{
>> +     struct ieee80211_regdomain *rd = NULL;
>> +     u32 flags = 0;
>> +     u32 num_rules = 0, size_of_regd = 0;
>> +     u8 *triplets_start = NULL;
>> +     u8 len_at_triplet = 0;
>> +     unsigned int i = 0;
>> +     /* Used too often */
>> +     int triplet_size = sizeof(struct ieee80211_country_ie_triplet);
>> +
>> +     rd->alpha2[0] = country_ie[0];
>> +     rd->alpha2[1] = country_ie[1];

typo, this is supposed to be alpha2[0] etc using the stack, and then
later we copy to the rd after it is kzalloc()'d.

>> +     /*
>> +      * Third octet can be:
>> +      *    'I' - Indoor
>> +      *    'O' - Outdoor
>> +      *
>> +      *  anything else we assume is no restrictions
>> +      */
>> +     if (country_ie[2] == 'I')
>> +             flags = NL80211_RRF_NO_OUTDOOR;
>> +     else if (country_ie[2] == 'O')
>> +             flags = NL80211_RRF_NO_INDOOR;
>> +
>> +     country_ie += 3;
>> +     country_ie_len -= 3;
>
> This needs to verify that the country IE is valid to start with, i.e. >=
> 3 bytes long.

Sure, I added a check before the call but I'll also add one here the
first few bytes we gobble up for initial parsing.

> <snipped, will review algorithm and stuff later>
>
>> +#ifdef CONFIG_WIRELESS_OLD_REGULATORY
>> +             /* We can't expect to have anything to intersect with...
>> +              * so use standard low values */
>> +             freq_range->max_bandwidth_khz = MHZ_TO_KHZ(40);
>> +             power_rule->max_antenna_gain = DBI_TO_MBI(6);
>> +             power_rule->max_eirp = DBM_TO_MBM(20);
>> +#else
>> +             /* Large arbitrary values, we intersect later */
>> +             /* Increment this if we ever support >= 40 MHz channels
>> +              * in IEEE 802.11 */
>> +             freq_range->max_bandwidth_khz = MHZ_TO_KHZ(40);
>> +             power_rule->max_antenna_gain = DBI_TO_MBI(100);
>> +             power_rule->max_eirp = DBM_TO_MBM(100);
>> +#endif
>
> Why is this necessary? In case of OLD_REGULATORY we _do_ have values to
> intersect with, from the old hardcoded stuff. Please don't treat that so
> special, just treat old regulatory as though we had pre-loaded some
> regulatory information into the kernel.

Good point.

>> +#ifdef CONFIG_WIRELESS_OLD_REGULATORY
>> +     /* If the userspace regulatory agent is installed when
>> +      * OLD_REGULATORY is enabled then great, if not then oh well,
>> +      * we'll use low ball values */
>> +     return 0;
>> +#endif
>
> Same here.

Sure.

>> +     if (!r) {
>> +             printk(KERN_ERR "cfg80211: calling CRDA failed - "
>> +                     "unable to get country regulatory information "
>> +                     "for country IE\n");
>> +             return -EINVAL;
>> +     }
>
> This printk is misplaced, if it should be there at all it should be in
> cfg80211, mac80211 need not know anything about crda. Also, !r is
> incorrect, just remove the whole code block and do
>
> return regulatory_hint_ie(...);

Sure, thanks.

> Also, the printk shouldn't be there at all because otherwise it'll
> happen all the time when a country IE is received w/o crda installed,
> flooding the logs.

ACK

>> +     if (elems.country_elem) {
>> +             r = ieee80211_sta_process_country_ie(ifsta, local,
>> +                     elems.country_elem, elems.country_elem_len);
>
> Some code here or in the processing function should compare the country
> element and only process it if it changed to avoid calling crda 10 times
> per second....

Yeah I had that in mind, and will add it, I'll export a routine on
cfg80211 to check the alpha2. Keep in mind though that the country may
already be "CR" but the IE may be different than what was there if the
user was the one who last set it. I'll add an early check though.

>> +#ifdef CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG
>> +             if (!r)
>
> !r is wrong again

Thanks for the early review.

  Luis
