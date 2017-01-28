Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41275 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750773AbdA1GpX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jan 2017 01:45:23 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Lior David <liord@codeaurora.org>
CC: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        qca_merez <qca_merez@qca.qualcomm.com>,
        qca_liord <qca_liord@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH v2 01/13] wil6210: add sysfs file for FTM calibration
Date: Sat, 28 Jan 2017 06:32:38 +0000
Message-ID: <87ziib3da5.fsf@kamboji.qca.qualcomm.com> (sfid-20170128_074527_443227_B7CFB958)
References: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
        <1484226365-10433-2-git-send-email-qca_merez@qca.qualcomm.com>
        <871svzp79p.fsf@kamboji.qca.qualcomm.com>
        <c066ef7d-f61b-3b3e-1a6c-e2b89de812e9@codeaurora.org>
        <b7a8f918-7d3c-de53-d657-8e2d1c1da4b2@broadcom.com>
        <7da1de20-8040-fc3b-0c1d-77c5fa98d0f5@codeaurora.org>
In-Reply-To: <7da1de20-8040-fc3b-0c1d-77c5fa98d0f5@codeaurora.org> (Lior
        David's message of "Mon, 23 Jan 2017 16:55:26 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lior David <liord@codeaurora.org> writes:

> On 1/19/2017 3:14 PM, Arend Van Spriel wrote:
>> On 19-1-2017 13:36, Lior David wrote:
>>> On 1/19/2017 2:24 PM, Valo, Kalle wrote:
>>>> Maya Erez <qca_merez@qca.qualcomm.com> writes:
>>>>
>>>>> From: Lior David <qca_liord@qca.qualcomm.com>
>>>>>
>>>>> In fine timing measurements, the calculation is affected by
>>>>> 2 parts: timing of packets over the air, which is platform
>>>>> independent, and platform-specific delays, which are dependent
>>>>> on things like antenna cable length and type.
>>>>> Add a sysfs file which allows to get/set these platform specific
>>>>> delays, separated into the TX and RX components.
>>>>> There are 2 key scenarios where the file can be used:
>>>>> 1. Calibration - start with some initial values (for example,
>>>>> the default values at startup), make measurements at a known
>>>>> distance, then iteratively change the values until the
>>>>> measurement results match the known distance.
>>>>> 2. Adjust the delays when platform starts up, based on known
>>>>> values.
>>>>>
>>>>> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
>>>>> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
>>>>
>>>> Can't this go via nl80211? sysfs is not really supposed to be used for
>>>> something like this.
>>>>
>>> There is no nl80211 API for this (yet?).
>>=20
>> So come up with one...?
> I checked this further and had some more internal discussion.
> This change is only about FTM calibration which is highly vendor specific=
 so I
> don't think NL80211 API is appropriate for it. Since it is needed in prod=
uction
> (to calibrate the platform after boot using pre-computed values)

For calibration and manufacturing testing we have NL80211_CMD_TESTMODE,
which is a vendor specific interface.

> I think sysfs is a reasonable place for it.

Wireless drivers really should not use sysfs. I guess there might be
valid cases when using sysfs is ok but I can't really come up with
anything right now.

--=20
Kalle Valo=
