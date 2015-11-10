Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35821 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbbKJHJA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 02:09:00 -0500
Received: by pasz6 with SMTP id z6so232617679pas.2
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2015 23:09:00 -0800 (PST)
Subject: Re: [PATCH 4/5] wcn3620: use new response format for wcn3620
 trigger_ba
To: Bob Copeland <me@bobcopeland.com>
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
 <1447063362-27322-5-git-send-email-fengwei.yin@linaro.org>
 <20151109154040.GD5395@localhost>
Cc: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com
From: "fengwei.yin" <fengwei.yin@linaro.org>
Message-ID: <56419805.4090902@linaro.org> (sfid-20151110_080917_073895_792BA083)
Date: Tue, 10 Nov 2015 15:08:53 +0800
MIME-Version: 1.0
In-Reply-To: <20151109154040.GD5395@localhost>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob,

On 2015/11/9 23:40, Bob Copeland wrote:
> On Mon, Nov 09, 2015 at 05:02:41AM -0500, Yin, Fengwei wrote:
>> From: Andy Green <andy.green@linaro.org>
>>
>> From: Andy Green <andy.green@linaro.org>
>>
>> On wcn3620, firmware response to trigger_ba uses the new, larger
>> "v2" format
>
>> -	ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
>> +	ret = wcn36xx_smd_rsp_status_check_v2(wcn, wcn->hal_buf,
>> +						wcn->hal_rsp_len);
>
> It's unclear from the changelog -- is it safe to call
> wcn36xx_smd_rsp_status_check_v2 on the 3660/3680 as well?
>
> Is wcn36xx_smd_rsp_status_check() still needed?
Even on 3620, not all cmds switch to wcn36xx_smd_rsp_status_check_v2.
And I don't think wcn36xx_smd_rsp_status_check_v2 should bind to 3620 (it
may be related with firmware).

In patch v2, the wcn36xx_smd_rsp_status_check_v2 is not bind to 3620. If
you could test on none-3620 platform (I don't have none-3620 plafrom), that
will be great.

I will send out patch v2 soon which drive the build error and the comments
from you. Thanks a lot for reviewing.

Regards
Yin, Fengwei

>
