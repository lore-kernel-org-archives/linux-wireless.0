Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41814 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754711AbeDTMnk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 08:43:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 20 Apr 2018 18:13:39 +0530
From: govinds@codeaurora.org
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Kalle Valo <kvalo@codeaurora.org>, pillair@codeaurora.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v2 4/4] ath10k: Enable sta idle power save
In-Reply-To: <5AD9A1DF.6060007@broadcom.com>
References: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
 <1523966821-21903-5-git-send-email-pillair@codeaurora.org>
 <946e582c-2438-872b-eec8-25d9dcb994d9@dd-wrt.com>
 <7a06a34a5fcb97e07a8d79b4d689e781@codeaurora.org>
 <87604oodt4.fsf@kamboji.qca.qualcomm.com>
 <a7dd1b94951725c61034f5be6744b725@codeaurora.org>
 <8736zrjgq6.fsf@kamboji.qca.qualcomm.com>
 <c48c1bae-04c9-55d0-fdb9-d9ae8f7cb843@dd-wrt.com>
 <5AD9A1DF.6060007@broadcom.com>
Message-ID: <0c70fb177d5ca9be7b81384b06d60949@codeaurora.org> (sfid-20180420_144344_891287_31535B84)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-20 13:46, Arend van Spriel wrote:
> On 4/20/2018 9:21 AM, Sebastian Gottschall wrote:
>> 
>>>> Yes this is WIFI chip set level power-save(based on idleness) and 
>>>> not
>>>> related to protocol power save. FW will turn off/scale down the
>>>> resources(clock/rails) based on opportunity(when ever idle mode is
>>>> detected). This power save is mostly done in disconnected state. I 
>>>> am
>>>> not really sure when framework/user-space triggers power-save
>>>> config(iw dev <devname> set power_save on/off). Then doing this from
>>>> user-space will be unnecessarily toggling this config or may not be
>>>> setting at disconnected state.
>>> I think that 'set power_save' commands affects struct
>>> ieee80211_bss_conf::ps parameter and I don't think it should be used 
>>> in
>>> this case. We already have ath10k_config_ps() for 802.11 level of 
>>> power
>>> saving.
>>> 
>>> Arend again proposed runtime-pm with which I'm not very familiar. But
>>> why would we want to disable this? Doesn't it make sense to have this
>>> feature always enabled to save power? wcn3990 is a chip for a mobile
>>> device anyway.
>> it might be made for mobile devices but who knows how it is used by 
>> the
>> market.

I guess having this enabled by default is safe as 
WMI_PDEV_PARAM_UNSUPPORTED
protects for those version which does not support this pdev param.


> Reading the explanation above it does not make sense to use
> runtime-pm. That would only come into play if the host driver would
> actually control the resources being turned off/scaled down.
> 
> So this is purely reducing power-consumption of the chip. However, it
> would be good to know the consequences in terms of responsiveness to
> firmware commands for instance when requesting a scan operation.

Exit latency is around 8-10 ms, so i guess this delta should be ok.

> Another thing to consider is to provide user-space with possibility to
> change this configuration (maybe through debugfs?).


In case any one wants to measure power no's with/without this config, 
just giving
provision to disable may be useful.


BR,
Govind
