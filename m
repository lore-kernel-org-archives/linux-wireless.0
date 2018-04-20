Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:44182 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753923AbeDTIQd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 04:16:33 -0400
Received: by mail-wr0-f174.google.com with SMTP id o15-v6so20563977wro.11
        for <linux-wireless@vger.kernel.org>; Fri, 20 Apr 2018 01:16:33 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] ath10k: Enable sta idle power save
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Kalle Valo <kvalo@codeaurora.org>, govinds@codeaurora.org
References: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
 <1523966821-21903-5-git-send-email-pillair@codeaurora.org>
 <946e582c-2438-872b-eec8-25d9dcb994d9@dd-wrt.com>
 <7a06a34a5fcb97e07a8d79b4d689e781@codeaurora.org>
 <87604oodt4.fsf@kamboji.qca.qualcomm.com>
 <a7dd1b94951725c61034f5be6744b725@codeaurora.org>
 <8736zrjgq6.fsf@kamboji.qca.qualcomm.com>
 <c48c1bae-04c9-55d0-fdb9-d9ae8f7cb843@dd-wrt.com>
Cc: pillair@codeaurora.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AD9A1DF.6060007@broadcom.com> (sfid-20180420_101642_153991_0BE5244F)
Date: Fri, 20 Apr 2018 10:16:31 +0200
MIME-Version: 1.0
In-Reply-To: <c48c1bae-04c9-55d0-fdb9-d9ae8f7cb843@dd-wrt.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/20/2018 9:21 AM, Sebastian Gottschall wrote:
>
>>> Yes this is WIFI chip set level power-save(based on idleness) and not
>>> related to protocol power save. FW will turn off/scale down the
>>> resources(clock/rails) based on opportunity(when ever idle mode is
>>> detected). This power save is mostly done in disconnected state. I am
>>> not really sure when framework/user-space triggers power-save
>>> config(iw dev <devname> set power_save on/off). Then doing this from
>>> user-space will be unnecessarily toggling this config or may not be
>>> setting at disconnected state.
>> I think that 'set power_save' commands affects struct
>> ieee80211_bss_conf::ps parameter and I don't think it should be used in
>> this case. We already have ath10k_config_ps() for 802.11 level of power
>> saving.
>>
>> Arend again proposed runtime-pm with which I'm not very familiar. But
>> why would we want to disable this? Doesn't it make sense to have this
>> feature always enabled to save power? wcn3990 is a chip for a mobile
>> device anyway.
> it might be made for mobile devices but who knows how it is used by the
> market.

Reading the explanation above it does not make sense to use runtime-pm. 
That would only come into play if the host driver would actually control 
the resources being turned off/scaled down.

So this is purely reducing power-consumption of the chip. However, it 
would be good to know the consequences in terms of responsiveness to 
firmware commands for instance when requesting a scan operation. Another 
thing to consider is to provide user-space with possibility to change 
this configuration (maybe through debugfs?).

Regards,
Arend
