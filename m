Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53602 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934935AbcKQR0R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 12:26:17 -0500
Subject: Re: cfg80211: add set/get link loss profile
To: Kalle Valo <kvalo@codeaurora.org>
References: <7742335b-f05e-edcd-ad80-fd09fb295eab@codeaurora.org>
 <8737izqw0q.fsf@purkki.adurom.net>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
From: "Lazar, Alexei Avshalom" <ailizaro@codeaurora.org>
Message-ID: <b1ab1406-d996-fc03-d0a2-b8028c7c0044@codeaurora.org> (sfid-20161117_182624_351411_01BDF6FB)
Date: Thu, 17 Nov 2016 15:50:35 +0200
MIME-Version: 1.0
In-Reply-To: <8737izqw0q.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

In this context the term "link" does mean connection to AP.
There are scenarios that require to lose connection faster once
reduced link quality detected in order maintain better user experience
(from both sides - AP and STA).
Example case is FST (Fast Session Transfer), where we have a fast 11ad
connection but close-range and a backup 11ac connection which is
"always on".
in such cases if we detect poor link quality in the active band we
prefer to disconnect and switch to the backup connection with the good
link quality.
This will be reached by setting "aggressive" profile that will cause
more rapid disconnect in such cases.

Alexei Lazar
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc. 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum a Linux Foundation Collaborative Project


On 11/10/2016 3:55 PM, Kalle Valo wrote:
> "Lazar, Alexei Avshalom" <ailizaro@codeaurora.org> writes:
>
>> >From b739abb6f29dc43a86b8b2b60e893b4441f8aa1f Mon Sep 17 00:00:00 2001
>> From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
>> Date: Sun, 6 Nov 2016 16:21:20 +0200
>> Subject: [PATCH] cfg80211: add set/get link loss profile
>>
>> Introduce NL80211_CMD_SET_LINK_LOSS_PROFILE and
>> NL80211_CMD_GET_LINK_LOSS_PROFILE as it required by the user space
>> to configure the link loss profile.
>> The link loss profile represents the priority of maintaining link up
>> in different link quality environments.
>> Three types of behavior for link loss defined:
>> LINK_LOSS_PROFILE_RELAXED: prefer maintaining link up even in poor
>> link quality environment.
>> LINK_LOSS_PROFILE_DEFAULT: The default behavior for maintaining link
>> up vs link quality.
>> LINK_LOSS_PROFILE_AGGRESSIVE: prefer losing link up in poor link
>> quality environment.
>> New cfg80211 API also been added, set/get_link_loss_profile.
>>
>> Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
> What does the term "link" mean in this context? A connection to the AP
> or something else? The documentation doesn't give me any detailed
> information nor any examples and lefts me guessing what this is supposed
> to do.
>
