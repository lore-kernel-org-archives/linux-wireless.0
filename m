Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:24621 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbZEKSdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 14:33:47 -0400
Received: by wf-out-1314.google.com with SMTP id 26so2538495wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2009 11:33:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242035604.3284.11.camel@johannes.local>
References: <1242033904-25694-1-git-send-email-lrodriguez@atheros.com>
	<1242033904-25694-5-git-send-email-lrodriguez@atheros.com>
	<1242035604.3284.11.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 11 May 2009 11:33:28 -0700
Message-ID: <43e72e890905111133q55b17da1p441f07fecd05d493@mail.gmail.com>
Subject: Re: [RFC 4/5] mac80211: add a struct for info upon device stop
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 11, 2009 at 2:53 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-05-11 at 05:25 -0400, Luis R. Rodriguez wrote:
>
>> =C2=A0/**
>> + * enum ieee80211_device_stop_reason - device stop reasons
>> + *
>> + * These are reasons why mac80211 would call the driver's stop()
>> + * callback. Devices should probably not care other than when
>> + * we call to stop during suspend, in these cases the device may
>> + * want to leave the radio on for WoW events for example.
>> + * @IEEE80211_DEV_STOP_INVALID_MAC: invalid mac address was detecte=
d for device
>> + * @IEEE80211_DEV_STOP_NO_OPEN_DEV: we were not able to open any
>> + =C2=A0 =C2=A0 netdevice for the current wireless device during use=
r initialization.
>> + * @IEEE80211_DEV_STOP_DEV_CLOSE_REQUEST: user requested the device=
 to be
>> + * =C2=A0 closed.
>> + * @IEEE80211_DEV_STOP_SUSPEND: we are going to suspend
>> + */
>> +enum ieee80211_device_stop_reasons {
>> + =C2=A0 =C2=A0 IEEE80211_DEV_STOP_INVALID_MAC,
>> + =C2=A0 =C2=A0 IEEE80211_DEV_STOP_NO_OPEN_DEV,
>> + =C2=A0 =C2=A0 IEEE80211_DEV_STOP_DEV_CLOSE_REQUEST,
>> + =C2=A0 =C2=A0 IEEE80211_DEV_STOP_SUSPEND,
>> +};
>
>> +struct ieee80211_device_stop_info {
>> + =C2=A0 =C2=A0 =C2=A0 enum ieee80211_device_stop_reasons reason;
>> +};
>
> Hmm. You're creating a code-flow API rather than a do-what-I-want API=
, I
> think it leaves the driver too much choice ;)
>
> The way you're using this here is:
>
> +#ifdef CONFIG_PM
> + =C2=A0 =C2=A0 =C2=A0 if (sc->wow_enable &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stop_info->reason =3D=3D IEEE802=
11_DEV_STOP_SUSPEND) {
>
> So for one, all the other reasons are unnecessary.

=46igured you'd want to nuke the rest, ok, then lets just have a bool f=
or suspend.

> Additionally, as you
> said, you need to stay associated for some WoW modes, so mac80211 nee=
ds
> to be aware of that when going into suspend. It might even need to be
> aware of things like the computer waking up only to cycle keys.
>
> Therefore, IMHO the stop info struct (I would drop _info from the nam=
e,
> seems not very useful and makes the struct name very long) should
> contain the WoW parameters so that devices can program those paramete=
rs
> instead of turning off completely.

Sure, so the reason I used a struct was so that we leave room for this
exact stuff to be added as you had recommended, I just wanted to get
WoW working before finishing the APIs but .. it seems we do need to
work with mac80211 anyway so I might as well just finish the WoW API
stuff..

> At suspend time, mac80211 would fill
> in those parameters, whereas it wouldn't do that at the other times t=
he
> device is stopped.

OK thanks.

>
> Of course, that means adding a WOW_CAPABLE HW flag, and API to mac802=
11
> to program WOW, but that will gain us more uniformity.

Sure well I was thinking of making this a cfg80211 thing.

> Question is
> whether we want to use nl80211 or ethtool.

I think we want to use nl80211 -- there are some things which are
wireless-specific like beacon miss triggers. Plus it just seems silly
to have to have drivers implement two ethtool ops just for WoW -- or
have mac80211 do that (or cfg80211).

I'll just get this properly implemented in cfg80211 then and send a new=
 RFC.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
