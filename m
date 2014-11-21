Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53673 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758415AbaKUJeC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 04:34:02 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so11378412wiv.6
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2014 01:33:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141120205459.GR24486@wotan.suse.de>
References: <1415895219-19848-1-git-send-email-arik@wizery.com>
 <1415895219-19848-4-git-send-email-arik@wizery.com> <20141113231323.GG24486@wotan.suse.de>
 <CA+XVXfeqfHHDh6AcgkuBW9BwUo-s77+pnbDtP_y=e0dZQVBitg@mail.gmail.com>
 <1416496922.8557.7.camel@sipsolutions.net> <CA+XVXffq5h-5=wvPQ1PY0CoSa5zgi9j-kNCw5RbWjd0zDLigfA@mail.gmail.com>
 <20141120205459.GR24486@wotan.suse.de>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 21 Nov 2014 11:33:43 +0200
Message-ID: <CA+XVXfc2-9Q+2AYj_GwyYN_agawk3LqLGssibzaxA6taszo4NQ@mail.gmail.com> (sfid-20141121_103419_329907_4AD307C6)
Subject: Re: [PATCH v2 4/4] cfg80211: Allow usermode to query wiphy specific
 regd info
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jonathan Doron <jond@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2014 at 10:54 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>>
>> Then it gets the global one, and it knows it via a wiphy attribute:
>>
>>       (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) &&
>> +                   (nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG)))
>> +                       goto nla_put_failure;
>>
>> (we won't do this put_flag if it's global)
>
> You can still follow this on wpa_s for REGULATORY_WIPHY_SELF_MANAGED, and
> the other type that uses wiphy->regd would still follow the global regdomain.
> The other flag I'm looking for is more informational for userspace in particular
> 'iw reg get' (for central and all devices) or 'iw reg get dev wlan0'.

I'm not sure why another flag is needed for userspace. If we have
SELF_MANAGED, we'll return the per-wiphy one (if a wiphy_idx is given
to us of course). For validation purposes, the global one is used in
other cases. And for CUSTOM_REG, we'll return the global one (we don't
have the per-wiphy information in cfg80211).

Arik
