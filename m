Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f179.google.com ([209.85.213.179]:42515 "EHLO
        mail-yb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752298AbdLLNSI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 08:18:08 -0500
Received: by mail-yb0-f179.google.com with SMTP id t127so8380927ybf.9
        for <linux-wireless@vger.kernel.org>; Tue, 12 Dec 2017 05:18:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <877etsqftz.fsf@kamboji.qca.qualcomm.com>
References: <1512982342-10343-1-git-send-email-loic.poulain@linaro.org>
 <87bmj4qhkm.fsf@kamboji.qca.qualcomm.com> <877etsqftz.fsf@kamboji.qca.qualcomm.com>
From: Loic Poulain <loic.poulain@linaro.org>
Date: Tue, 12 Dec 2017 14:17:27 +0100
Message-ID: <CAMZdPi_1METJ8+_dM-UWm8bT3-GfUkACMDBFF0_WoO6v5GBxvQ@mail.gmail.com> (sfid-20171212_141815_912783_575B9DC2)
Subject: Re: [PATCH v2] wcn36xx: Fix dynamic power saving
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "wcn36xx@lists.infradead.org" <wcn36xx@lists.infradead.org>,
        "k.eugene.e@gmail.com" <k.eugene.e@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On 12 December 2017 at 13:40, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>
>> Loic Poulain <loic.poulain@linaro.org> writes:
>>
>>> Since driver does not report hardware dynamic power saving cap,
>>> this is up to the mac80211 to manage power saving timeout and
>>> state machine, using the ieee80211 config callback to report
>>> PS changes. This patch enables/disables PS mode according to
>>> the new configuration.
>>>
>>> Remove old behaviour enabling PS mode in a static way, this make
>>> the device unusable when power save is enabled since device is
>>> forced to PS regardless RX/TX traffic.
>>>
>>> Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>>> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
>>
>> A fixes line would be nice for backporters. I can add that but need the
>> commit id.
>
> Or maybe this actually isn't a regression? Then of course a fixes line
> is not needed.

Yes, not really a regression since the issue came with the driver
itself (8e84c258).

>
> Should I push this to v4.15 or v4.16, any preference?

4.15 would be great.

Thanks,
Loic
