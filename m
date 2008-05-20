Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:55425 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689AbYETO7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 10:59:04 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1394049ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 07:58:59 -0700 (PDT)
Message-ID: <69e28c910805200758j72281d34kfaa244e9bbdd8451@mail.gmail.com> (sfid-20080520_165908_919750_554595EE)
Date: Tue, 20 May 2008 10:58:58 -0400
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi injection bug
Cc: "Tomas Winkler" <tomasw@gmail.com>, "Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andy Green" <andy@warmcat.com>
In-Reply-To: <1211293631.6252.98.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210945631.6381.11.camel@johannes.berg>
	 <1211249729.2532.59.camel@debian.sh.intel.com>
	 <69e28c910805200432lbd3790vb925dacaea3aca83@mail.gmail.com>
	 <1211287111.6252.84.camel@johannes.berg>
	 <69e28c910805200614q2232b21ame8ff03fe4156fb3b@mail.gmail.com>
	 <1ba2fa240805200641j4ccc1de4r5572e1321394a526@mail.gmail.com>
	 <69e28c910805200716i3fd16c33x274983ab8e7591e6@mail.gmail.com>
	 <1211293631.6252.98.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2008 at 10:27 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> -     /* drop all data frame if we are not associated */
>> -     if ((!iwl3945_is_associated(priv) ||
>> +     /* drop all data frame if we are not associated and not monitoring */
>> +     if (((!iwl3945_is_associated(priv) && priv->iw_mode !=
>> IEEE80211_IF_TYPE_MNTR) ||
>>            ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id)) &&
>>           ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
>> -             IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
>> +             IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated outside monitor mode\n");
>>               goto drop_unlock;
>>       }
>
> This makes injection not work when you're not exclusively in monitor
> mode. Yes, it may break the spec to be sending frames to an arbitrary
> station, but it's useful for all kinds of things including testing to
> have a monitor and a regular interface working at the same time.
>
> johannes
>

What do you think is a better way to check if we have a monitor
interface? && priv->iw_mode == IEEE80211_IF_TYPE_STA? Or should this
be removed altogether?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
