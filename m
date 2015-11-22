Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:36631 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbbKVUNz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 15:13:55 -0500
Received: by qgcc31 with SMTP id c31so61018012qgc.3
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2015 12:13:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <564433A2.1080407@linaro.org>
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
	<1447063362-27322-5-git-send-email-fengwei.yin@linaro.org>
	<20151109154040.GD5395@localhost>
	<CAJAp7OhJyj4qEU+quqs3RLr10FB1D+XUCsSsH04DaQ8bVWsd_A@mail.gmail.com>
	<564433A2.1080407@linaro.org>
Date: Sun, 22 Nov 2015 20:13:54 +0000
Message-ID: <CAFSJ42bGR1EFrve0+g3VkqObm5hG=Hy01oaZE-mcgLBNyohYjQ@mail.gmail.com> (sfid-20151122_211358_744286_8CE6A048)
Subject: Re: [PATCH 4/5] wcn3620: use new response format for wcn3620 trigger_ba
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: "fengwei.yin" <fengwei.yin@linaro.org>
Cc: Bjorn Andersson <bjorn@kryo.se>, Bob Copeland <me@bobcopeland.com>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	Andy Green <andy.green@linaro.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bjorn Andersson <bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yin,

Yes, it seems like response is FW specific other than chip spesific.

2015-11-12 6:37 GMT+00:00 fengwei.yin <fengwei.yin@linaro.org>:
> Hi Bjorn,
>
> On 2015/11/12 12:50, Bjorn Andersson wrote:
>>
>> On Mon, Nov 9, 2015 at 7:40 AM, Bob Copeland <me@bobcopeland.com> wrote:
>>>
>>> On Mon, Nov 09, 2015 at 05:02:41AM -0500, Yin, Fengwei wrote:
>>>>
>>>> From: Andy Green <andy.green@linaro.org>
>>>>
>>>> From: Andy Green <andy.green@linaro.org>
>>>>
>>>> On wcn3620, firmware response to trigger_ba uses the new, larger
>>>> "v2" format
>>>
>>>
>>>> -     ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf,
>>>> wcn->hal_rsp_len);
>>>> +     ret = wcn36xx_smd_rsp_status_check_v2(wcn, wcn->hal_buf,
>>>> +                                             wcn->hal_rsp_len);
>>>
>>>
>>> It's unclear from the changelog -- is it safe to call
>>> wcn36xx_smd_rsp_status_check_v2 on the 3660/3680 as well?
>>>
>>> Is wcn36xx_smd_rsp_status_check() still needed?
>>>
>>
>> I had to introduce this on one of my 3680 devices recently to silence
>> the error described originally by Andy. So it not only seems safe but
>> seems required. But still, based on how the code was written this
>> doesn't seem to be the case on all versions of the firmware or all
>> chips(?)
>>
> Thanks for the information. It confirm my thought that the change sticks
> to new firmware instead of specific platform.
>
> But we couldn't tell which version of firmware need this new format. Andy's
> original change has two conditions to use the new format:
> 1. The platform is 3620. - this should be removed because you need the same
>    change for 3680. And patch v2 already remove it.
>
> 2. The packet size from firmware is larger than old response size. I suppose
>    this one works in most case.
>
> Regards
> Yin, Fengwei
>
>> Regards,
>> Bjorn
>>
>



-- 
Best regards,
Eugene
