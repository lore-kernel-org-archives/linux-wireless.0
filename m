Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:47184 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbZEMWht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 18:37:49 -0400
Received: by rv-out-0506.google.com with SMTP id f9so563191rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 15:37:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242254121.10076.11.camel@johannes.local>
References: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com>
	<1242248682-22051-5-git-send-email-lrodriguez@atheros.com>
	<1242252539.10076.2.camel@johannes.local> <43e72e890905131529s5e8d6421pde9b80a92f807160@mail.gmail.com>
	<1242254121.10076.11.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 13 May 2009 15:37:31 -0700
Message-ID: <43e72e890905131537m3d8026k4e430d2593e3f64e@mail.gmail.com>
Subject: Re: [PATCH 4/4] cfg80211: fix race between core hint and driver's
	custom apply
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 3:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-05-13 at 15:29 -0700, Luis R. Rodriguez wrote:
>
>> >> =C2=A0 =C2=A0 =C2=A0 queue_regulatory_request(request);
>> >>
>> >> + =C2=A0 =C2=A0 /*
>> >> + =C2=A0 =C2=A0 =C2=A0* This ensures last_request is populated on=
ce modules
>> >> + =C2=A0 =C2=A0 =C2=A0* come swinging in and calling regulatory h=
ints and
>> >> + =C2=A0 =C2=A0 =C2=A0* wiphy_apply_custom_regulatory().
>> >> + =C2=A0 =C2=A0 =C2=A0*/
>> >> + =C2=A0 =C2=A0 flush_scheduled_work();
>> >> +
>> >
>> > Umm, this is a little stupid, first you queue it and then you flus=
h the
>> > workqueue... Why not call the function that runs off the workqueue
>> > directly?
>>
>> That was the original approach -- but then we went on a bagwagon on
>> getting all these regulatory hints through the workqueue. I can
>> address for for wireless-testing but not sure what path we prefer fo=
r
>> stable. The above one liner seems small enough and would be nice to
>> get confirmation from a user on stable.
>
> Yeah definitely the way to go for stable, and we can als put it into
> wireless-testing. But I think ultimately we should just refactor what=
 is
> necessary and just call the function that would otherwise run off the
> workqueue. Can do that after this patch though.

OK -- will work on that next.

 Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
