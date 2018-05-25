Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45478 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936185AbeEYOok (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 10:44:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: Ben Greear <greearb@candelatech.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v1] ath10k: fix band_center_freq handling for VHT160 in recent firmwares
References: <20180426094357.24358-1-s.gottschall@dd-wrt.com>
        <19b8766e-d474-31d3-ff38-993498ee670d@candelatech.com>
        <da5c7c56-9a41-99f0-28be-3a2c8e9fabbf@dd-wrt.com>
Date: Fri, 25 May 2018 17:44:34 +0300
In-Reply-To: <da5c7c56-9a41-99f0-28be-3a2c8e9fabbf@dd-wrt.com> (Sebastian
        Gottschall's message of "Thu, 26 Apr 2018 17:12:11 +0200")
Message-ID: <87wovr94ml.fsf@kamboji.qca.qualcomm.com> (sfid-20180525_164608_084123_99181AAE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:

> Am 26.04.2018 um 15:44 schrieb Ben Greear:
>>
>>
>> On 04/26/2018 02:43 AM, s.gottschall@dd-wrt.com wrote:
>>> From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>>>
>>> starting with firmware 10.4.3.4.x series QCA changed the handling
>>> of the channel property band_center_freq1 and band_center_freq2 in
>>> vht160 operation mode
>>> likelly for backward compatiblity with vht80 only capable clients.
>>> this patch adjusts the handling to get vht160 to work again with
>>> official qca firmwares newer than 3.3
>>> consider that this patch will not work with older firmwares
>>> anymore. to avoid undefined behaviour this we disable vht160
>>> capability for outdated firmwares
>>
>> We should be able to use a feature-flag or otherwise determine if
>> the firmware needs the old or new
>> API and make the driver able to handle both.
>
> the new firmware must be used as is and it works. the old firmware can
> be detected on the missing vht cap flag.
> but thats not my task. i can only use feature flags if they are
> included within the qca firmwares. but they arent
> the old pre 3.3 firmwares should be treated as obsolete. they are more
> than 2 years old and do not announce vht160 capability
> even if it works with some ignorance, but on the other side the it has
> backward incompatiblies with older vht80 only clients.
> this is why the new way was introduced

I was told ath10k could check for WMI_SERVICE_EXTENDED_NSS_SUPPORT flag.
Can someone test and verify that?

-- 
Kalle Valo
