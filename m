Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:58473 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102Ab1APNiD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 08:38:03 -0500
Received: by mail-fx0-f54.google.com with SMTP id 16so4959910fxm.41
        for <linux-wireless@vger.kernel.org>; Sun, 16 Jan 2011 05:38:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimNRzc9M0wKZsQLMh4ihSHEeycFJ-S34CA=jPAc@mail.gmail.com>
References: <1294062164-3459-1-git-send-email-shahar_levi@ti.com>
	<1294062164-3459-3-git-send-email-shahar_levi@ti.com>
	<1294674256.1992.141.camel@pimenta>
	<AANLkTimNRzc9M0wKZsQLMh4ihSHEeycFJ-S34CA=jPAc@mail.gmail.com>
Date: Sun, 16 Jan 2011 15:38:01 +0200
Message-ID: <AANLkTikuPg3FSmSuNq-gD04r_k5cmdyBQ2sr0h_eD__8@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] wl12xx: BA receiver support
From: "Levi, Shahar" <shahar_levi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 11, 2011 at 2:54 AM, Levi, Shahar <shahar_levi@ti.com> wrote:
>>> diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
>>> index 54fd68d..f33ab50 100644
>>> --- a/drivers/net/wireless/wl12xx/acx.c
>>> +++ b/drivers/net/wireless/wl12xx/acx.c
>>> @@ -1359,6 +1359,42 @@ out:
>>>       return ret;
>>>  }
>>>
>>> +/* setup BA session receiver setting in the FW. */
>>> +int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
>>> +                                    u16 *ssn, u8 policy)
>>
>> You don't modify ssn here, so why pass it as a pointer? Use u16 directly
>> here instead.
>>
>> Actually it's even worse.  As stated in mac80211.h, ssn can be NULL
>> here, so you would be accessing a NULL pointer in that case.
>>
>> I see that you check "policy", which indicates whether ssn is valid or
>> not, but why not make it cleaner by checking if ssn is NULL and setting
>> it to zero before passing instead?
> good chtch. it was left from previous implantation. will be fix.
There is two options from you suggestion:
a) move ssn directly and then check policy if it is valid
b) keep ssn as pointer and check it to validate it is valid.

I will use a option.
Thanks,
Shahar
