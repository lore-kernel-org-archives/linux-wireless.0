Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40808 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753161AbcLSK6N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:58:13 -0500
Subject: Re: cfg80211: add set/get link loss profile
To: Johannes Berg <johannes@sipsolutions.net>
References: <7742335b-f05e-edcd-ad80-fd09fb295eab@codeaurora.org>
 <1480344742.8107.63.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
From: "Lazar, Alexei Avshalom" <ailizaro@codeaurora.org>
Message-ID: <58a1b983-6688-8b3e-81cb-83c62b46abbf@codeaurora.org> (sfid-20161219_120024_256957_7D58B89B)
Date: Mon, 19 Dec 2016 12:58:09 +0200
MIME-Version: 1.0
In-Reply-To: <1480344742.8107.63.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/28/2016 4:52 PM, Johannes Berg wrote:
> 
>> Introduce NL80211_CMD_SET_LINK_LOSS_PROFILE and
>> NL80211_CMD_GET_LINK_LOSS_PROFILE as it required by the user space
>> to configure the link loss profile.
> 
> I'm not convinced.
> 
>> The link loss profile represents the priority of maintaining link up
>> in different link quality environments.
>> Three types of behavior for link loss defined:
>> LINK_LOSS_PROFILE_RELAXED: prefer maintaining link up even in poor
>> link quality environment.
>> LINK_LOSS_PROFILE_DEFAULT: The default behavior for maintaining link
>> up vs link quality.
>> LINK_LOSS_PROFILE_AGGRESSIVE: prefer losing link up in poor link
>> quality environment.
> 
> What you're doing here is *extremely* vague. No definitions of what
> this means, no description of how it's intended to be implemented, no
> note even on whether or not this is for full-MAC chips or not, etc.
> 

The patch is intended for full-MAC chips and I will update the commit
message to include more details.

> At least for mac80211, we can define signals to userspace regarding
> "link quality" and make decisions in wpa_s then?
> 

The policy is offloaded today to the FW and the decision being made by the FW.
We are only modifying the behavior and not making the decision.

> 
>> --- a/drivers/net/wireless/ath/wil6210/cfg80211.c
> 
> Those changes obviously don't belong into this patch anyway.
> 
> johannes
> 


-- 
Alexei Lazar
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc. 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum a Linux Foundation Collaborative Project
