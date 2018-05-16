Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54720 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751151AbeEPMJW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 08:09:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Pkshih <pkshih@realtek.com>
Cc: "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 00/19] rtlwifi: halmac: Add new module halmac
References: <20180425020820.6141-1-pkshih@realtek.com>
        <87lgdbagb2.fsf@kamboji.qca.qualcomm.com>
        <5B2DA6FDDF928F4E855344EE0A5C39D13BEBF231@RTITMBSV07.realtek.com.tw>
Date: Wed, 16 May 2018 15:09:17 +0300
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D13BEBF231@RTITMBSV07.realtek.com.tw>
        (pkshih@realtek.com's message of "Fri, 27 Apr 2018 05:44:16 +0000")
Message-ID: <87603nkdjm.fsf@codeaurora.org> (sfid-20180516_140925_662994_1F5572E8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pkshih <pkshih@realtek.com> writes:

>> And I even read all 19 commit logs and there was no mention of why this
>> is needed either. I cannot just blindly apply patches without knowing
>> what they do.
>> 
>
> This new module halmac is an abstract layer for Realtek WiFi MAC to provide
> common interfaces to access WiFi MAC and register set. If driver (I use 'driver'
> in this mail indicates part of rtlwifi excluded from this module.) uses the API,
> it's not necessary to control related register directly. If API isn't implemented,
> driver can use the registers defined by halmac to manipulate MAC function.
>
> The registers reside in driver causes error frequently, because MAC register
> is maintained by Realtek's MAC team so they create this module to avoid mistakes.
> Another benefit is to make it possible to become a thin driver, because many
> common functions are provided, so duplicate code will be reduced.
>
> Currently, this module is aim to rtl8822be, and it will extend to support
> more chips so hierarchical directory is adopted. It looks like
>    rtlwifi/halmac/halmac_88xx
>    rtlwifi/halmac/halmac_88xx/halmac_8822b
>    rtlwifi/halmac/halmac_88xx/halmac_8821c (future chip)

IMHO the directory structure contains redundant information, it's enough
to have halmac only once in the path. So I would instead use this kind
of naming:

rtlwifi/halmac/88xx/8822b

-- 
Kalle Valo
