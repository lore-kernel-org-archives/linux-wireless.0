Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44634 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755887AbeDWPuS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 11:50:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        govinds@codeaurora.org, pillair@codeaurora.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v2 4/4] ath10k: Enable sta idle power save
References: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
        <1523966821-21903-5-git-send-email-pillair@codeaurora.org>
        <946e582c-2438-872b-eec8-25d9dcb994d9@dd-wrt.com>
        <7a06a34a5fcb97e07a8d79b4d689e781@codeaurora.org>
        <87604oodt4.fsf@kamboji.qca.qualcomm.com>
        <a7dd1b94951725c61034f5be6744b725@codeaurora.org>
        <8736zrjgq6.fsf@kamboji.qca.qualcomm.com>
        <c48c1bae-04c9-55d0-fdb9-d9ae8f7cb843@dd-wrt.com>
        <5AD9A1DF.6060007@broadcom.com>
Date: Mon, 23 Apr 2018 18:50:12 +0300
In-Reply-To: <5AD9A1DF.6060007@broadcom.com> (Arend van Spriel's message of
        "Fri, 20 Apr 2018 10:16:31 +0200")
Message-ID: <87wowxdirv.fsf@kamboji.qca.qualcomm.com> (sfid-20180423_175027_829831_652893C8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 4/20/2018 9:21 AM, Sebastian Gottschall wrote:
>>
>>>> Yes this is WIFI chip set level power-save(based on idleness) and not
>>>> related to protocol power save. FW will turn off/scale down the
>>>> resources(clock/rails) based on opportunity(when ever idle mode is
>>>> detected). This power save is mostly done in disconnected state. I am
>>>> not really sure when framework/user-space triggers power-save
>>>> config(iw dev <devname> set power_save on/off). Then doing this from
>>>> user-space will be unnecessarily toggling this config or may not be
>>>> setting at disconnected state.
>>> I think that 'set power_save' commands affects struct
>>> ieee80211_bss_conf::ps parameter and I don't think it should be used in
>>> this case. We already have ath10k_config_ps() for 802.11 level of power
>>> saving.
>>>
>>> Arend again proposed runtime-pm with which I'm not very familiar. But
>>> why would we want to disable this? Doesn't it make sense to have this
>>> feature always enabled to save power? wcn3990 is a chip for a mobile
>>> device anyway.
>>
>> it might be made for mobile devices but who knows how it is used by the
>> market.

Sure, and this does parameter prevent that. You can still connect
wcn3990 to any power source you want, but the driver is just optimised
power consumption in focus.

> Reading the explanation above it does not make sense to use
> runtime-pm. That would only come into play if the host driver would
> actually control the resources being turned off/scaled down.

Exactly.

> So this is purely reducing power-consumption of the chip. However, it
> would be good to know the consequences in terms of responsiveness to
> firmware commands for instance when requesting a scan operation.
> Another thing to consider is to provide user-space with possibility to
> change this configuration (maybe through debugfs?).

Adrian was also commenting something similar about adding a debugfs
interface but I don't really see the point right now while we are adding
initial wcn3990 support. If someone wants to run measurements with and
without this parameter it's very easy to edit it out from the sources.
Later on we can consider making it dynamic if there's really the need
for that, but I'm very skeptic that anyone would even need that.

-- 
Kalle Valo
