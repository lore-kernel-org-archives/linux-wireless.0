Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59634 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2GSSl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 14:41:57 -0400
Received: by yhmm54 with SMTP id m54so3112607yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jul 2012 11:41:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342594528.5310.5.camel@jlt3.sipsolutions.net>
References: <1342586570-522-1-git-send-email-ashok@cozybit.com> <1342594528.5310.5.camel@jlt3.sipsolutions.net>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Thu, 19 Jul 2012 11:41:35 -0700
Message-ID: <CACcxo+pMN3puxCQs7RLcn-3DihUMbvD6J6mNDcvhQ6cHGLy5KA@mail.gmail.com> (sfid-20120719_204200_804382_08E48F9A)
Subject: Re: [PATCH V2 1/2] {cfg,mac}80211: utility function for calculating
 mandatory rates
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, thomas@cozybit.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 17, 2012 at 11:55 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-07-17 at 21:42 -0700, Ashok Nagarajan wrote:
>
>> + */
>> +
>> +u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
>
> Please remove the blank line and document the return value.
>
Noted.
>
>> +u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
>> +                           enum ieee80211_band band)
>
> Passing both the band enum and the sband doesn't make a lot of sense.
>
Noted.
>> +{
>> +     struct ieee80211_rate *bitrates;
>> +     u32 mandatory_rates = 0;
>> +     enum ieee80211_rate_flags mandatory_flag;
>> +     int i;
>> +
>> +     if (WARN_ON(!sband))
>> +             return 1;
>> +
>> +     bitrates = sband->bitrates;
>> +     if (band == IEEE80211_BAND_5GHZ)
>> +             mandatory_flag = IEEE80211_RATE_MANDATORY_A;
>> +     else {
>> +             mandatory_flag = IEEE80211_RATE_MANDATORY_B;
>> +             for (i = 0; i < sband->n_bitrates; i++)
>> +                     if (bitrates[i].bitrate > 110) {
>> +                             mandatory_flag =
>> +                                     IEEE80211_RATE_MANDATORY_G;
>> +                             break;
>> +                     }
>> +     }
>
> You're not just moving the function but also changing the logic in it,
> it'd be better to do in separate patches I think.
>
I will split the patch into two, one for moving the function and
another patch for changing the logic in v3.

Thanks,
Ashok
> johannes
>
