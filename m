Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43128 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753948AbeDSQgi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 12:36:38 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: govinds@codeaurora.org
Cc: pillair@codeaurora.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        arend.vanspriel@broadcom.com
Subject: Re: [PATCH v2 4/4] ath10k: Enable sta idle power save
References: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
        <1523966821-21903-5-git-send-email-pillair@codeaurora.org>
        <946e582c-2438-872b-eec8-25d9dcb994d9@dd-wrt.com>
        <7a06a34a5fcb97e07a8d79b4d689e781@codeaurora.org>
        <87604oodt4.fsf@kamboji.qca.qualcomm.com>
        <a7dd1b94951725c61034f5be6744b725@codeaurora.org>
Date: Thu, 19 Apr 2018 19:36:33 +0300
In-Reply-To: <a7dd1b94951725c61034f5be6744b725@codeaurora.org>
        (govinds@codeaurora.org's message of "Thu, 19 Apr 2018 10:02:47
        +0530")
Message-ID: <8736zrjgq6.fsf@kamboji.qca.qualcomm.com> (sfid-20180419_183642_576740_3E152C2D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

govinds@codeaurora.org writes:

> On 2018-04-18 18:46, Kalle Valo wrote:
>> (fixing top posting)
>>
>> govinds@codeaurora.org writes:
>>
>>> On 2018-04-18 12:36, Sebastian Gottschall wrote:
>>>> from my point of view powersave should be optional and not forced.
>>>>
>>>> consider :
>>>> iw dev <devname> set power_save on/off
>>>>
>>>> so there is already a config option made for that purpose,
>>>
>>> Thanks Sebastian for your review. Agree this should not be forced with
>>> in driver.
>>>
>>> I will check if i can set the idle ps at the end of
>>> ath10k_mac_vif_setup_ps by checking arvif->ps.
>>> I will update the patch accordingly.
>>
>> So what power save is this exactly? I assumed it's some bus level power
>> save (turning of clocks etc) but is it actually 802.11 power save?
>
> Yes this is WIFI chip set level power-save(based on idleness) and not
> related to protocol power save. FW will turn off/scale down the
> resources(clock/rails) based on opportunity(when ever idle mode is
> detected). This power save is mostly done in disconnected state. I am
> not really sure when framework/user-space triggers power-save
> config(iw dev <devname> set power_save on/off). Then doing this from
> user-space will be unnecessarily toggling this config or may not be
> setting at disconnected state.

I think that 'set power_save' commands affects struct
ieee80211_bss_conf::ps parameter and I don't think it should be used in
this case. We already have ath10k_config_ps() for 802.11 level of power
saving.

Arend again proposed runtime-pm with which I'm not very familiar. But
why would we want to disable this? Doesn't it make sense to have this
feature always enabled to save power? wcn3990 is a chip for a mobile
device anyway.

-- 
Kalle Valo
