Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41448 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbeDSEcs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 00:32:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 19 Apr 2018 10:02:47 +0530
From: govinds@codeaurora.org
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        linux-wireless@vger.kernel.org, pillair@codeaurora.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 4/4] ath10k: Enable sta idle power save
In-Reply-To: <87604oodt4.fsf@kamboji.qca.qualcomm.com>
References: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
 <1523966821-21903-5-git-send-email-pillair@codeaurora.org>
 <946e582c-2438-872b-eec8-25d9dcb994d9@dd-wrt.com>
 <7a06a34a5fcb97e07a8d79b4d689e781@codeaurora.org>
 <87604oodt4.fsf@kamboji.qca.qualcomm.com>
Message-ID: <a7dd1b94951725c61034f5be6744b725@codeaurora.org> (sfid-20180419_063252_344873_3DA8F8CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-18 18:46, Kalle Valo wrote:
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

Yes this is WIFI chip set level power-save(based on idleness) and not 
related to protocol power save.
FW will turn off/scale down the resources(clock/rails) based on 
opportunity(when ever idle mode is detected).
This power save is mostly done in disconnected state. I am not really 
sure when framework/user-space
triggers power-save config(iw dev <devname> set power_save on/off).
Then doing this from user-space will be unnecessarily toggling this 
config or may not be setting at disconnected state.

May be you can suggest better here.

BR,
Govind
