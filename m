Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33652 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbcHDAhr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 20:37:47 -0400
Received: by mail-pf0-f196.google.com with SMTP id i6so15672862pfe.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2016 17:37:25 -0700 (PDT)
Subject: Re: [PATCH v2] nl80211: Receive correct value for
 NL80211_MESHCONF_HT_OPMODE command
To: Johannes Berg <johannes@sipsolutions.net>
References: <1468927556-4703-1-git-send-email-masashi.honma@gmail.com>
 <1470138089-6864-1-git-send-email-masashi.honma@gmail.com>
 <9967cc0f-777e-31f6-0c4a-a788e92b9049@gmail.com>
 <1470207156.2638.9.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <d193404d-8a77-8a8e-10eb-f46bd4008384@gmail.com> (sfid-20160804_023750_940195_17D7BA39)
Date: Thu, 4 Aug 2016 09:37:21 +0900
MIME-Version: 1.0
In-Reply-To: <1470207156.2638.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年08月03日 15:52, Johannes Berg wrote:
> I'm actually half thinking that we could just remove all restrictions
> on this and allow any u16 value of this field, and rely on
> wpa_supplicant to do the right thing... Then we don't have to update
> this if we ever want to do something new either.
>
> What do you think? What does the validation actually help us with?

I think checking the bits here is better than allowing all values.

Because if we allow any values for ht_opmode, kernel developer needs to 
care about any bit combination working well. For example, kernel 
developer should test there is not any unexpected thing when non-GF and 
non-HT both flags are enabled. If we check invalid bit at the entrance,
we don't need to care anymore about invalid combination. In any case we
need to care about combination. Then, it is more easy to do it near the
entrance.

And I think checking only in wpa_supplicant is not good idea. Because 
other user application can access to the kernel API. If invalid flag
combination causes kernel panic, it could be kernel vulnerability.

Masashi Honma.
