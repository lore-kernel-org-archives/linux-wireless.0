Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:3340 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbaLWQFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 11:05:23 -0500
Message-ID: <549992C0.4080708@broadcom.com> (sfid-20141223_170526_162519_7EF9E51A)
Date: Tue, 23 Dec 2014 17:05:20 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>,
	Avinash Patil <patila@marvell.com>
Subject: Re: [PATCH] cfg80211: add extensible feature flag attribute
References: <1419350119-29166-1-git-send-email-arend@broadcom.com> <1419350316.6091.9.camel@sipsolutions.net>
In-Reply-To: <1419350316.6091.9.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/23/14 16:58, Johannes Berg wrote:
> On Tue, 2014-12-23 at 16:55 +0100, Arend van Spriel wrote:
>> From: Gautam Kumar Shukla<gautams@broadcom.com>
>>
>> With the wiphy::features flag being used up this patch adds a
>> new field wiphy::ext_features. Considering extensibility this
>> new field is declared as a byte array. This extensible flag is
>> exposed to user-space by NL80211_ATTR_EXT_FEATURES.
>
> Ah, I guess this will compile without even any flags defined, so
> Avinash, you can just build on top of this and define the first flag,
> and for the sake of attribution I'll apply it as two separate patches.

If Avinash keeps my signed-off-by and add note of what he changed below 
that I feel sufficiently attributed. Either way is fine by me.

It compiles, but I guess nla_put() will fail for u8[0+8-1/8] field.

Gr. AvS

> Thanks Arend.
>
> johannes
>

