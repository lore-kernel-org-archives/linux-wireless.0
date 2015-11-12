Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35014 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbbKLGh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 01:37:26 -0500
Received: by pasz6 with SMTP id z6so57356704pas.2
        for <linux-wireless@vger.kernel.org>; Wed, 11 Nov 2015 22:37:26 -0800 (PST)
Subject: Re: [PATCH 4/5] wcn3620: use new response format for wcn3620
 trigger_ba
To: Bjorn Andersson <bjorn@kryo.se>, Bob Copeland <me@bobcopeland.com>
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
 <1447063362-27322-5-git-send-email-fengwei.yin@linaro.org>
 <20151109154040.GD5395@localhost>
 <CAJAp7OhJyj4qEU+quqs3RLr10FB1D+XUCsSsH04DaQ8bVWsd_A@mail.gmail.com>
Cc: wcn36xx <wcn36xx@lists.infradead.org>,
	Andy Green <andy.green@linaro.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bjorn Andersson <bjorn.andersson@sonymobile.com>,
	Eugene Krasnikov <k.eugene.e@gmail.com>
From: "fengwei.yin" <fengwei.yin@linaro.org>
Message-ID: <564433A2.1080407@linaro.org> (sfid-20151112_073730_377724_22D86912)
Date: Thu, 12 Nov 2015 14:37:22 +0800
MIME-Version: 1.0
In-Reply-To: <CAJAp7OhJyj4qEU+quqs3RLr10FB1D+XUCsSsH04DaQ8bVWsd_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bjorn,

On 2015/11/12 12:50, Bjorn Andersson wrote:
> On Mon, Nov 9, 2015 at 7:40 AM, Bob Copeland <me@bobcopeland.com> wrote:
>> On Mon, Nov 09, 2015 at 05:02:41AM -0500, Yin, Fengwei wrote:
>>> From: Andy Green <andy.green@linaro.org>
>>>
>>> From: Andy Green <andy.green@linaro.org>
>>>
>>> On wcn3620, firmware response to trigger_ba uses the new, larger
>>> "v2" format
>>
>>> -     ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
>>> +     ret = wcn36xx_smd_rsp_status_check_v2(wcn, wcn->hal_buf,
>>> +                                             wcn->hal_rsp_len);
>>
>> It's unclear from the changelog -- is it safe to call
>> wcn36xx_smd_rsp_status_check_v2 on the 3660/3680 as well?
>>
>> Is wcn36xx_smd_rsp_status_check() still needed?
>>
>
> I had to introduce this on one of my 3680 devices recently to silence
> the error described originally by Andy. So it not only seems safe but
> seems required. But still, based on how the code was written this
> doesn't seem to be the case on all versions of the firmware or all
> chips(?)
>
Thanks for the information. It confirm my thought that the change sticks
to new firmware instead of specific platform.

But we couldn't tell which version of firmware need this new format. Andy's
original change has two conditions to use the new format:
1. The platform is 3620. - this should be removed because you need the same
    change for 3680. And patch v2 already remove it.

2. The packet size from firmware is larger than old response size. I suppose
    this one works in most case.

Regards
Yin, Fengwei

> Regards,
> Bjorn
>
