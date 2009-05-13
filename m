Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:21663 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbZEMRUz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 13:20:55 -0400
Received: by rv-out-0506.google.com with SMTP id f9so489036rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 10:20:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242208388.14227.46.camel@johannes.local>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	<1242206461-30793-3-git-send-email-lrodriguez@atheros.com>
	<1242208388.14227.46.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 13 May 2009 10:20:36 -0700
Message-ID: <43e72e890905131020y66111b1nb89a3f17596efca6@mail.gmail.com>
Subject: Re: [RFC v2 2/5] mac80211: inform devices when we are suspending on
	the stop callback
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 2:53 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-05-13 at 05:20 -0400, Luis R. Rodriguez wrote:
>> We inform the drivers so they can take appropriate actions during
>> suspend for WoW support.
>
>> -static void ar9170_op_stop(struct ieee80211_hw *hw)
>> +static void ar9170_op_stop(struct ieee80211_hw *hw, bool suspend)
>
> Why just a 'suspend' bool? Why not pass the WoW information in here,
> instead of adding a new config and stuff for it? WoW information is o=
nly
> relevant during suspend.
>
> The way you have it, a driver needs to
> =C2=A0* keep track of the wow config
> =C2=A0* check whether a stop is due to suspend
> =C2=A0* apply wow config during stop
>
> If you passed the wow config in some struct to _stop() [and NULL if n=
ot
> for wow] then the driver would only need to
>
> =C2=A0* check if for wow and apply config during stop

Reason for not passing it is its accessible through the wiphy. All we
really need from mac80211 is if it changed (some devices may need
this, and will be more useful for the user pattern handling) and if we
are stopping due to suspend.

What advantage do we have if we stuff a wow struct instead of having
the driver read the wiphy wow info?

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
