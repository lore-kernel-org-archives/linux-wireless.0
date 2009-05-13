Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:41710 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758876AbZEMW32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 18:29:28 -0400
Received: by wf-out-1314.google.com with SMTP id 26so598073wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 15:29:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242252539.10076.2.camel@johannes.local>
References: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com>
	<1242248682-22051-5-git-send-email-lrodriguez@atheros.com>
	<1242252539.10076.2.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 13 May 2009 15:29:08 -0700
Message-ID: <43e72e890905131529s5e8d6421pde9b80a92f807160@mail.gmail.com>
Subject: Re: [PATCH 4/4] cfg80211: fix race between core hint and driver's
	custom apply
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 3:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-05-13 at 17:04 -0400, Luis R. Rodriguez wrote:
>
>> =C2=A0 =C2=A0 =C2=A0 queue_regulatory_request(request);
>>
>> + =C2=A0 =C2=A0 /*
>> + =C2=A0 =C2=A0 =C2=A0* This ensures last_request is populated once =
modules
>> + =C2=A0 =C2=A0 =C2=A0* come swinging in and calling regulatory hint=
s and
>> + =C2=A0 =C2=A0 =C2=A0* wiphy_apply_custom_regulatory().
>> + =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 flush_scheduled_work();
>> +
>
> Umm, this is a little stupid, first you queue it and then you flush t=
he
> workqueue... Why not call the function that runs off the workqueue
> directly?

That was the original approach -- but then we went on a bagwagon on
getting all these regulatory hints through the workqueue. I can
address for for wireless-testing but not sure what path we prefer for
stable. The above one liner seems small enough and would be nice to
get confirmation from a user on stable.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
