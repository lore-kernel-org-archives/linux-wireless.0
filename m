Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:33667 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbeDROo2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 10:44:28 -0400
Received: by mail-wr0-f176.google.com with SMTP id z73-v6so5589340wrb.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2018 07:44:27 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] ath10k: Enable sta idle power save
To: Kalle Valo <kvalo@codeaurora.org>, govinds@codeaurora.org
References: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
 <1523966821-21903-5-git-send-email-pillair@codeaurora.org>
 <946e582c-2438-872b-eec8-25d9dcb994d9@dd-wrt.com>
 <7a06a34a5fcb97e07a8d79b4d689e781@codeaurora.org>
 <87604oodt4.fsf@kamboji.qca.qualcomm.com>
Cc: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        linux-wireless@vger.kernel.org, pillair@codeaurora.org,
        ath10k@lists.infradead.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AD759C7.2070104@broadcom.com> (sfid-20180418_164440_114554_AC4C924E)
Date: Wed, 18 Apr 2018 16:44:23 +0200
MIME-Version: 1.0
In-Reply-To: <87604oodt4.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/18/2018 3:16 PM, Kalle Valo wrote:
> (fixing top posting)
>
> govinds@codeaurora.org writes:
>
>> On 2018-04-18 12:36, Sebastian Gottschall wrote:
>>> from my point of view powersave should be optional and not forced.
>>>
>>> consider :
>>> iw dev <devname> set power_save on/off
>>>
>>> so there is already a config option made for that purpose,
>>
>> Thanks Sebastian for your review. Agree this should not be forced with
>> in driver.
>>
>> I will check if i can set the idle ps at the end of
>> ath10k_mac_vif_setup_ps by checking arvif->ps.
>> I will update the patch accordingly.
>
> So what power save is this exactly? I assumed it's some bus level power
> save (turning of clocks etc) but is it actually 802.11 power save?

I also suspected bus level power save and I would say runtime-pm 
framework should be considered for that.

Regards,
Arend
