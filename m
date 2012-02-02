Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:58119 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab2BBQIa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 11:08:30 -0500
Received: by mail-wi0-f171.google.com with SMTP id hm2so3290403wib.16
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 08:08:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F27819A.1030200@sipsolutions.net>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-8-git-send-email-victorg@ti.com>
	<4F27819A.1030200@sipsolutions.net>
Date: Thu, 2 Feb 2012 18:08:24 +0200
Message-ID: <CAK80WHZpAAG_NWcuGUK2FJ_UwOhFXraVVkugR3W5FZEHCb6Z0A@mail.gmail.com> (sfid-20120202_170833_247732_B4F22C98)
Subject: Re: [RFC 7/9] nl80211/cfg80211: add DFS feature flag
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2012 at 7:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On 1/26/2012 4:38 AM, Victor Goldenshtein wrote:
>>
>> +static int nl80211_put_feature_flags(struct wiphy *wiphy,
>> +                                    struct sk_buff *msg)
>> +{
>> +       if (wiphy->flags&  WIPHY_FLAG_SUPPORTS_DFS)
>>
>> +               wiphy->features |= NL80211_FEATURE_DFS;
>> +
>> +
>> +       NLA_PUT_U32(msg, NL80211_ATTR_FEATURE_FLAGS, wiphy->features);
>> +
>> +       return 0;
>> +nla_put_failure:
>> +       return -ENOBUFS;
>> +}
>
>
> I think you misunderstood the new feature flags -- they're supposed to be
> set by the driver directly, not indirectly via wiphy->flags.
>

yep, I guess you're right.



-- 
Thanks,
Victor.
