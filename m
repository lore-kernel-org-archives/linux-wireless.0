Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58796 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbeFLLku (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Jun 2018 07:40:50 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Timur =?utf-8?Q?Krist=C3=B3f?= <timur.kristof@gmail.com>
Cc: Ryan Hsu <ryanhsu@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: Update the phymode along with bandwidth change request
References: <1528482759-12604-1-git-send-email-ryanhsu@codeaurora.org>
        <944989ec907b98716f252524cf55e41807965253.camel@gmail.com>
Date: Tue, 12 Jun 2018 14:40:37 +0300
In-Reply-To: <944989ec907b98716f252524cf55e41807965253.camel@gmail.com>
        ("Timur \=\?utf-8\?Q\?Krist\=C3\=B3f\=22's\?\= message of "Mon, 11 Jun 2018 18:05:53
 +0200")
Message-ID: <87muw0cjwq.fsf@kamboji.qca.qualcomm.com> (sfid-20180612_134054_608794_BF2045E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Timur Krist=C3=B3f <timur.kristof@gmail.com> writes:

> On Fri, 2018-06-08 at 11:32 -0700, Ryan Hsu wrote:
>> In the case of Station connects to AP with narrower bandwidth at
>> beginning.
>> And later the AP changes the bandwidth to winder bandwidth, the AP
>> will
>> beacon with wider bandwidth IE, eg VHT20->VHT40->VHT80 or VHT40-
>> >VHT80.
>>=20
>> Since the supported BANDWIDTH will be limited by the PHYMODE, so
>> while
>> Station receives the bandwidth change request, it will also need to
>> reconfigure the PHYMODE setting to firmware instead of just
>> configuring
>> the BANDWIDTH info, otherwise it'll trigger a firmware crash with
>> non-support bandwidth.
>>=20
>> The issue was observed in WLAN.RM.4.4.1-00051-QCARMSWP-1, QCA6174
>> with
>> below scenario.

[...]

> I can confirm that this patch works on my machine, and prevents the
> crash previously caused by changing the bandwidth.

Great, thanks a lot for working on this. I'll add your Tested-by to the
commit log.

> Can it be accepted, or is there anything I can help with, to get it
> accepted?

Strangely I can't find Timur's version of the patch from patchwork:

https://patchwork.kernel.org/project/linux-wireless/list/?state=3D*

Maybe it got dropped due to some UTF-8 problems? patchwork is known to
be problematic with UTF-8.

Anyway, I'll queue Ryan's v2 to 4.18. It first goes to the pending
branch for build testing and from there to ath-current branch.

--=20
Kalle Valo
