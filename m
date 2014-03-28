Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42838 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaC1NVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:21:32 -0400
Received: by mail-wg0-f48.google.com with SMTP id l18so3604429wgh.7
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 06:21:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396011945.4175.23.camel@jlt4.sipsolutions.net>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	<1395409651-26120-2-git-send-email-michal.kazior@tieto.com>
	<1396011945.4175.23.camel@jlt4.sipsolutions.net>
Date: Fri, 28 Mar 2014 14:21:30 +0100
Message-ID: <CA+BoTQnpijm3JxXNaCzSf3bDx6OiPDAhseTj7=0Urv4jWav=Wg@mail.gmail.com> (sfid-20140328_142136_134049_F240BC6C)
Subject: Re: [PATCH v2 01/13] cfg80211: allow drivers to iterate over matching combinations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 March 2014 14:05, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-03-21 at 14:47 +0100, Michal Kazior wrote:
>
>> +int cfg80211_iter_combinations(struct wiphy *wiphy,
>> +                            const int num_different_channels,
>> +                            const u8 radar_detect,
>> +                            const int iftype_num[NUM_NL80211_IFTYPES],
>> +                            void (*iter)(const struct ieee80211_iface_combination *c,
>> +                                         void *data),
>> +                            void *data);
>
> Maybe *iter should have a non-void return value and allow aborting the
> loop somehow?

I don't see much of use for that. You can still use *data for that.


>> +static void
>> +cfg80211_iter_sum_ifcombs(const struct ieee80211_iface_combination *c,
>> +                       void *data)
>> +{
>> +     int *num = data;
>> +     (*num)++;
>> +}
>> +
>> +int cfg80211_check_combinations(struct wiphy *wiphy,
>> +                             const int num_different_channels,
>> +                             const u8 radar_detect,
>> +                             const int iftype_num[NUM_NL80211_IFTYPES])
>> +{
>> +     int err, num = 0;
>> +
>> +     err = cfg80211_iter_combinations(wiphy, num_different_channels,
>> +                                      radar_detect, iftype_num,
>> +                                      cfg80211_iter_sum_ifcombs, &num);
>> +     if (err)
>> +             return err;
>> +     if (num == 0)
>> +             return -EBUSY;
>> +
>> +     return 0;
>>  }
>
> This also seems a bit pointless - why not just have an int instead of
> num and set it to -EBUSY outside, and to 0 inside, and then just return
> it? You don't need the number of available combinations.

Hmm.. Well, that works too I guess.


Michał
