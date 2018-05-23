Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58086 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932180AbeEWKjV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 06:39:21 -0400
Subject: Re: [PATCH] ath10k: add dynamic vlan support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>
References: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
 <87r2n5auvq.fsf@kamboji.qca.qualcomm.com>
 <aa04534d-9677-f42e-a239-b230093ef2f5@dd-wrt.com>
 <f8d6d13943ccac22f363d7d4f53d645c@codeaurora.org>
 <1526637270.3805.15.camel@sipsolutions.net>
 <59ff8201-fc1b-8579-d5a9-f4b08621f5ec@codeaurora.org>
 <1527069018.3759.15.camel@sipsolutions.net>
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <988f350d-a6eb-1733-4a2f-43a87053e96a@codeaurora.org> (sfid-20180523_124058_268685_158A9137)
Date: Wed, 23 May 2018 16:09:12 +0530
MIME-Version: 1.0
In-Reply-To: <1527069018.3759.15.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>>>> + * @IEEE80211_HW_SUPPORTS_SW_ENCRYPT: Device is capable of transmitting
>>>> + *     frames encrypted in software, only valid when SW_CRYPTO_CONTROL
>>>> + *     is enabled. Based on this flag, mac80211 can allow/disallow VLAN
>>>> + *     operations in the BSS.
>>> Based on the name and initial description, this sounds equivalent to
>>> just turning off SW_CRYPTO_CONTROL. I think that's not the intent, but
>>> would need some renaming.
>> I can rename it to something which is very specific to VLAN support on
>> sw crypto controlled devices if that is okay.
> I don't think that makes sense. If we split the capability of AP_VLAN
> and AP_VLAN_FOR_4ADDR at the "root", then we don't need to play with all
> these things. Yes, this is slightly awkward for userspace, and perhaps
> with the interface combination checks, but I'd like you to look at that.
>

Makes sense, I had this thought to split the VLAN and 4-addr 
functionality, but since we need to fiddle with userspace, I refrained.
Anyways, I will check all the possibilities of splitting these 
functionalities.

Thanks,
Manikanta
