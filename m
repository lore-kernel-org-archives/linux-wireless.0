Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:57220 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaAVGLt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 01:11:49 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so4256360eak.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jan 2014 22:11:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390318897.6199.49.camel@jlt4.sipsolutions.net>
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
	<1390226968-18928-3-git-send-email-michal.kazior@tieto.com>
	<1390318897.6199.49.camel@jlt4.sipsolutions.net>
Date: Wed, 22 Jan 2014 07:11:48 +0100
Message-ID: <CA+BoTQ=DYBrE=XBn6R4Y2=ag605bLxKq2AfMTOnWZKyTprg04g@mail.gmail.com> (sfid-20140122_071153_051503_667ABF64)
Subject: Re: [PATCH 2/3] cfg80211: implement multi-vif interface combination validation
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 January 2014 16:41, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-01-20 at 15:09 +0100, Michal Kazior wrote:
>
>> +             /* sanity check - make sure all wdevs in params[] are unique */
>> +             for (j = 0; j < num_params; j++)
>> +                     if (WARN_ON(i != j && params[i].wdev == params[j].wdev))
>> +                             return -EINVAL;
>> +
>> +             if (params[i].wdev && params[i].wdev->wiphy != &rdev->wiphy)
>> +                     return -EINVAL;
>
> How could you ever have a param without a wdev? That seems like a bug as
> well?

cfg80211_can_add_interface() calls with wdev == NULL.


>> +             used_iftypes |= BIT(params[i].iftype);
>> +             num[params[i].iftype]++;
>> +
>> +             err = cfg80211_is_radar_required(params[i].iftype,
>> +                                              params[i].chan,
>> +                                              params[i].chanmode,
>> +                                              params[i].radar_detect_width);
>> +             if (err < 0)
>> +                     return err;
>> +             else if (err && !params[i].radar_detect_width)
>> +                     return -EINVAL;
>
> That's a bit confusing - why do you pass the radar_detect_width in, and
> then check it again? Couldn't you just do all the checks in the
> function, perhaps renamed a bit?

I can move this into the helper function. Any suggestions for the
rename? cfg80211_validate_radar_params() and it would return a 0 or an
errno?


Michał
