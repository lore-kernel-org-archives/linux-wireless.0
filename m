Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f115.google.com ([209.85.222.115]:40009 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758AbZEMR1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 13:27:52 -0400
Received: by pzk13 with SMTP id 13so319262pzk.33
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 10:27:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242208705.29288.3.camel@johannes.local>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	<1242206461-30793-4-git-send-email-lrodriguez@atheros.com>
	<1242208705.29288.3.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 13 May 2009 10:27:33 -0700
Message-ID: <43e72e890905131027u2d6acb91t34d414df5332c072@mail.gmail.com>
Subject: Re: [RFC v2 3/5] cfg80211: add WoW support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 2:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-05-13 at 05:20 -0400, Luis R. Rodriguez wrote:
>
>> =C2=A0/**
>> + * struct cfg80211_wow - Wake on Wireless-LAN support info
>> + *
>> + * This structure defines the WoW triggers supported by the device
>> + * and also what specific WoW triggers the user wants enabled. To u=
se
>> + * WoW you can use standard ethernet utilities as you would with
>> + * Wake-on-LAN.
>> + *
>> + * @triggers_supported: supported bitmask of WoW triggers.
>> + * =C2=A0 The flags for this bitmask are %NL80211_WOW_TRIGGER_*.
>> + * @triggers_enabled: enabled triggers by the user. Default
>> + * =C2=A0 is to disable all triggers. The flags for this bitmask
>> + * =C2=A0 are %NL80211_WOW_TRIGGER_*.
>> + */
>> +struct cfg80211_wow {
>> + =C2=A0 =C2=A0 u32 triggers_supported;
>> + =C2=A0 =C2=A0 u32 triggers_enabled;
>> +};
>> +
>> +/**
>> =C2=A0 * struct cfg80211_ops - backend description for wireless conf=
iguration
>> =C2=A0 *
>> =C2=A0 * This struct is registered by fullmac card drivers and/or wi=
reless stacks
>> @@ -849,6 +868,8 @@ enum wiphy_params_flags {
>> =C2=A0 * =C2=A0 @changed bitfield (see &enum wiphy_params_flags) des=
cribes which values
>> =C2=A0 * =C2=A0 have changed. The actual parameter values are availa=
ble in
>> =C2=A0 * =C2=A0 struct wiphy. If returning an error, no value should=
 be changed.
>> + *
>> + * @set_wow: used to inform the device which WoW triggers should be=
 enabled.
>> =C2=A0 */
>> =C2=A0struct cfg80211_ops {
>> =C2=A0 =C2=A0 =C2=A0 int =C2=A0 =C2=A0 (*suspend)(struct wiphy *wiph=
y);
>> @@ -940,6 +961,7 @@ struct cfg80211_ops {
>> =C2=A0 =C2=A0 =C2=A0 int =C2=A0 =C2=A0 (*leave_ibss)(struct wiphy *w=
iphy, struct net_device *dev);
>>
>> =C2=A0 =C2=A0 =C2=A0 int =C2=A0 =C2=A0 (*set_wiphy_params)(struct wi=
phy *wiphy, u32 changed);
>> + =C2=A0 =C2=A0 int =C2=A0 =C2=A0 (*set_wow)(struct wiphy *wiphy, u3=
2 triggers);
>> =C2=A0};
>>
>> =C2=A0/*
>> @@ -965,6 +987,11 @@ struct cfg80211_ops {
>> =C2=A0 * =C2=A0 channels at a later time. This can be used for devic=
es which do not
>> =C2=A0 * =C2=A0 have calibration information gauranteed for frequenc=
ies or settings
>> =C2=A0 * =C2=A0 outside of its regulatory domain.
>> + * @wow: Wake-on-Wireless-LAN configuration struct. The driver shou=
ld
>> + * =C2=A0 set the capabilities before registering the wiphy. When w=
e
>> + * =C2=A0 get a request to enable certain WoW events we will inform
>> + * =C2=A0 the driver through the set_wow() callback. If this is suc=
cessfull
>> + * =C2=A0 we then set the passed triggers as enabled on the wiphy'w=
 wow struct.
>
> I'm not sure that makes sense. Why keep track of both the enabled and
> the possible triggers, _and_ have a set_wow callback? The latter migh=
t
> make sense to verify some of the information, but I think we shouldn'=
t
> keep track of the enabled triggers here but rather do that in the dri=
ver
> then.
>
> Alternatively, how about we push the stuff I suggested for mac80211 a=
ll
> the way through to cfg80211? The cfg80211 suspend() method could pass
> through the wow parameters.

Sure, makes sense.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
