Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:57638 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbYJTRgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 13:36:52 -0400
Received: by yw-out-2324.google.com with SMTP id 9so317485ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 10:36:51 -0700 (PDT)
Message-ID: <314b98fa0810201036l1c610e91icde8ee48b43e36dc@mail.gmail.com> (sfid-20081020_193657_256085_A7743B1E)
Date: Mon, 20 Oct 2008 10:36:51 -0700
From: "Colin McCabe" <colin@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] Add nl80211 commands to get and set o11s mesh networking parameters.
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1224341637.6324.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48f7dedf.16098e0a.7692.537e@mx.google.com>
	 <1224341637.6324.29.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 18, 2008 at 7:53 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-10-16 at 17:05 -0700, colin@cozybit.com wrote:
>> + * @NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL: The minimum interval of time (in
>> + * TUs) during which an MP can send only one action frame containing a PREQ
>> + * reference element
>
> Why are some in TU and some in ms? Are there any restrictions between
> these?

All but two of these configuration parameters are specified in the
draft 802.11s standard as MIB objects. I pretty much copied the
descriptions directly from there.

A time units is 1024 microseconds.  Since the different between a time
unit and a millisecond is only 24 microseconds, all of the 80211s code
that I've looked at simply treats these parameters as milliseconds.
That is ok, because these parameters are timeouts and minimum
intervals, rather than exact values.

Still, I wanted to use the same language to describe the parameters
that the standard does.

>
>> + * @NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME: The interval of time (in TUs)
>> + * that it takes for an HWMP information element to propagate across the mesh
>
> How does userspace know this one?

The recommended value is 10 TUs. Increasing the value will increase
the minimum timeout for PREQs.

One way to tune this parameter would be to analyze incoming network
traffic at a mesh point, measuring the maximum time it takes to
receive a PREQ from a mesh point. Then you would set this parameter to
half of that value.
I haven't tried this in the lab, though.

>
>> +static int ieee80211_get_mesh_params(struct wiphy *wiphy,
>> +                             struct net_device *dev,
>> +                             struct mesh_config *conf)
>> +{
>> +     struct ieee80211_sub_if_data *sdata;
>> +     sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +
>> +     if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
>> +             return -ENOTSUPP;
>> +     memcpy(conf, &(sdata->u.mesh.mshcfg), sizeof(struct mesh_config));
>> +     return 0;
>> +}
>> +
>> +static inline bool _chg_mesh_attr(enum nl80211_attrs attr, u32 mask)
>> +{
>> +     /* This makes sure that there aren't more than 32 mesh config
>> +      * parameters (otherwise our bitfield scheme would not work.) */
>> +     BUILD_BUG_ON(NL80211_MESHCONF_ATTR_MAX > 32);
>
> That BUILD_BUG_ON should be somewhere in cfg80211/nl80211 (core code)
> rather than mac80211 I think.
>
> The attr parameter looks weird, are you sure it should be that enum and
> not the mesh config one?

Fixed.

> For good measure, you could #undef the macro again at the end of the
> function. Maybe even declare it within the function, but I don't care
> much.

Fixed.

>
> But this is all fairly minor stuff, looks good to me, thanks for doing
> this. Do you have a corresponding patch for iw?

Yeah... I'll post it in just a bit.

Regards,
Colin McCabe

>
> johannes
>
