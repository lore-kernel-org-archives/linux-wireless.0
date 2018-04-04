Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:48028 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750736AbeDDGjD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Apr 2018 02:39:03 -0400
Subject: Re: [PATCH 3/3] wcn36xx: don't delete invalid bss indices
To: Ramon Fried <rfried@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: loic.poulain@linaro.org, bjorn.andersson@linaro.org,
        kvalo@codeaurora.org, wcn36xx@lists.infradead.org
References: <20180403165154.18775-1-daniel@zonque.org>
 <20180403165154.18775-3-daniel@zonque.org>
 <8ee8943c-ff58-60a1-75da-eaf795ff3234@codeaurora.org>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <0b1db61d-a8a2-1099-1dbd-aee67ec5cd63@zonque.org> (sfid-20180404_083907_454226_D849BBEB)
Date: Wed, 4 Apr 2018 08:39:01 +0200
MIME-Version: 1.0
In-Reply-To: <8ee8943c-ff58-60a1-75da-eaf795ff3234@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, April 04, 2018 07:40 AM, Ramon Fried wrote:
> On 4/3/2018 7:51 PM, Daniel Mack wrote:
>> The firmware code cannot cope with requests to remove BSS indices that have
>> not previously been added. This primarily happens when the device is
>> suspended and then resumed. ieee80211_reconfig() then calls into
>> wcn36xx_bss_info_changed() with an empty bssid and BSS_CHANGED_BSSID set,
>> which subsequently leads to a firmware crash:
>>
>> [   43.647928] qcom-wcnss-pil a204000.wcnss: fatal error received: halMsg.c:4964:halMsg_DelBss: Invalid BSSIndex 0
>> [   43.647959] remoteproc remoteproc0: crash detected in a204000.wcnss: type fatal error
>>
>> To fix this, set bss_index to WCN36XX_HAL_BSS_INVALID_IDX for all bss
>> that have not been configured in the firmware, and don't call into the
>> firmware with invalid indices.
>>
>> Signed-off-by: Daniel Mack <daniel@zonque.org>

> Interesting. I have never seen this bug before.
> Do you have a way of recreating it so I can test it on my side ?

I tested this by putting the machine to suspend with

  # echo freeze >/sys/power/state

right after boot, without connecting to a network before. Resume will
then fail without this patch. I haven't see it in any other cases either
though.


Thanks,
Daniel
