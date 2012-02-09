Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57792 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758476Ab2BIXLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 18:11:40 -0500
Received: by iacb35 with SMTP id b35so3166015iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 15:11:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK80WHZpAAG_NWcuGUK2FJ_UwOhFXraVVkugR3W5FZEHCb6Z0A@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
 <1327581484-22047-8-git-send-email-victorg@ti.com> <4F27819A.1030200@sipsolutions.net>
 <CAK80WHZpAAG_NWcuGUK2FJ_UwOhFXraVVkugR3W5FZEHCb6Z0A@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 9 Feb 2012 15:11:20 -0800
Message-ID: <CAB=NE6WkArbBkiT6A4eEKEo6k2EJ2SsxjoNoPHp5BDWZNR3t8g@mail.gmail.com> (sfid-20120210_001143_262665_E9A04E8A)
Subject: Re: [RFC 7/9] nl80211/cfg80211: add DFS feature flag
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 2, 2012 at 8:08 AM, Goldenshtein, Victor <victorg@ti.com> wrote:
> On Tue, Jan 31, 2012 at 7:52 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On 1/26/2012 4:38 AM, Victor Goldenshtein wrote:
>>>
>>> +static int nl80211_put_feature_flags(struct wiphy *wiphy,
>>> +                                    struct sk_buff *msg)
>>> +{
>>> +       if (wiphy->flags&  WIPHY_FLAG_SUPPORTS_DFS)
>>>
>>> +               wiphy->features |= NL80211_FEATURE_DFS;
>>> +
>>> +
>>> +       NLA_PUT_U32(msg, NL80211_ATTR_FEATURE_FLAGS, wiphy->features);
>>> +
>>> +       return 0;
>>> +nla_put_failure:
>>> +       return -ENOBUFS;
>>> +}
>>
>>
>> I think you misunderstood the new feature flags -- they're supposed to be
>> set by the driver directly, not indirectly via wiphy->flags.
>>
>
> yep, I guess you're right.

While a it, consider adding one for the requirement of sending the
channel switch announcement within mac80211, not the driver. In that
case, although a DFS feature may be available in the driver, DFS
should not be enabled on the driver through nl80211 unless that
feature gets implemented in mac80211.

  Luis
