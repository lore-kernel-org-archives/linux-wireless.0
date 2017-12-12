Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:24068 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752048AbdLLMlC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 07:41:02 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Loic Poulain <loic.poulain@linaro.org>
CC: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "wcn36xx@lists.infradead.org" <wcn36xx@lists.infradead.org>,
        "k.eugene.e@gmail.com" <k.eugene.e@gmail.com>
Subject: Re: [PATCH v2] wcn36xx: Fix dynamic power saving
Date: Tue, 12 Dec 2017 12:40:57 +0000
Message-ID: <877etsqftz.fsf@kamboji.qca.qualcomm.com> (sfid-20171212_134105_715579_F05B5229)
References: <1512982342-10343-1-git-send-email-loic.poulain@linaro.org>
        <87bmj4qhkm.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87bmj4qhkm.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Tue, 12 Dec 2017 14:03:21 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Loic Poulain <loic.poulain@linaro.org> writes:
>
>> Since driver does not report hardware dynamic power saving cap,
>> this is up to the mac80211 to manage power saving timeout and
>> state machine, using the ieee80211 config callback to report
>> PS changes. This patch enables/disables PS mode according to
>> the new configuration.
>>
>> Remove old behaviour enabling PS mode in a static way, this make
>> the device unusable when power save is enabled since device is
>> forced to PS regardless RX/TX traffic.
>>
>> Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
>
> A fixes line would be nice for backporters. I can add that but need the
> commit id.

Or maybe this actually isn't a regression? Then of course a fixes line
is not needed.

Should I push this to v4.15 or v4.16, any preference?

--=20
Kalle Valo=
