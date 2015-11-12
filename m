Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33433 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbbKLEuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 23:50:10 -0500
Received: by lbbkw15 with SMTP id kw15so28526504lbb.0
        for <linux-wireless@vger.kernel.org>; Wed, 11 Nov 2015 20:50:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151109154040.GD5395@localhost>
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
	<1447063362-27322-5-git-send-email-fengwei.yin@linaro.org>
	<20151109154040.GD5395@localhost>
Date: Wed, 11 Nov 2015 20:50:08 -0800
Message-ID: <CAJAp7OhJyj4qEU+quqs3RLr10FB1D+XUCsSsH04DaQ8bVWsd_A@mail.gmail.com> (sfid-20151112_055015_603381_D6B2F9B2)
Subject: Re: [PATCH 4/5] wcn3620: use new response format for wcn3620 trigger_ba
From: Bjorn Andersson <bjorn@kryo.se>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Yin, Fengwei" <fengwei.yin@linaro.org>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	Andy Green <andy.green@linaro.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bjorn Andersson <bjorn.andersson@sonymobile.com>,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 9, 2015 at 7:40 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Mon, Nov 09, 2015 at 05:02:41AM -0500, Yin, Fengwei wrote:
>> From: Andy Green <andy.green@linaro.org>
>>
>> From: Andy Green <andy.green@linaro.org>
>>
>> On wcn3620, firmware response to trigger_ba uses the new, larger
>> "v2" format
>
>> -     ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
>> +     ret = wcn36xx_smd_rsp_status_check_v2(wcn, wcn->hal_buf,
>> +                                             wcn->hal_rsp_len);
>
> It's unclear from the changelog -- is it safe to call
> wcn36xx_smd_rsp_status_check_v2 on the 3660/3680 as well?
>
> Is wcn36xx_smd_rsp_status_check() still needed?
>

I had to introduce this on one of my 3680 devices recently to silence
the error described originally by Andy. So it not only seems safe but
seems required. But still, based on how the code was written this
doesn't seem to be the case on all versions of the firmware or all
chips(?)

Regards,
Bjorn
