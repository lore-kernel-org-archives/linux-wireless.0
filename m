Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f115.google.com ([209.85.222.115]:49621 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZENSGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 14:06:09 -0400
Received: by pzk13 with SMTP id 13so715546pzk.33
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 11:06:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890905131537m3d8026k4e430d2593e3f64e@mail.gmail.com>
References: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com>
	<1242248682-22051-5-git-send-email-lrodriguez@atheros.com>
	<1242252539.10076.2.camel@johannes.local> <43e72e890905131529s5e8d6421pde9b80a92f807160@mail.gmail.com>
	<1242254121.10076.11.camel@johannes.local> <43e72e890905131537m3d8026k4e430d2593e3f64e@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 14 May 2009 11:05:48 -0700
Message-ID: <43e72e890905141105m1a7b2fadhb99fd02cf3037704@mail.gmail.com>
Subject: Re: [PATCH 4/4] cfg80211: fix race between core hint and driver's
	custom apply
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 3:37 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, May 13, 2009 at 3:35 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Wed, 2009-05-13 at 15:29 -0700, Luis R. Rodriguez wrote:
>>
>>> >>       queue_regulatory_request(request);
>>> >>
>>> >> +     /*
>>> >> +      * This ensures last_request is populated once modules
>>> >> +      * come swinging in and calling regulatory hints and
>>> >> +      * wiphy_apply_custom_regulatory().
>>> >> +      */
>>> >> +     flush_scheduled_work();
>>> >> +
>>> >
>>> > Umm, this is a little stupid, first you queue it and then you flush the
>>> > workqueue... Why not call the function that runs off the workqueue
>>> > directly?
>>>
>>> That was the original approach -- but then we went on a bagwagon on
>>> getting all these regulatory hints through the workqueue. I can
>>> address for for wireless-testing but not sure what path we prefer for
>>> stable. The above one liner seems small enough and would be nice to
>>> get confirmation from a user on stable.
>>
>> Yeah definitely the way to go for stable, and we can als put it into
>> wireless-testing. But I think ultimately we should just refactor what is
>> necessary and just call the function that would otherwise run off the
>> workqueue. Can do that after this patch though.
>
> OK -- will work on that next.

BTW please feel free to add:

Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

  Luis
