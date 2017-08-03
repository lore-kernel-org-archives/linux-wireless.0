Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:48049 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751188AbdHCB5d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 21:57:33 -0400
Subject: Re: [PATCH 3/3] brcmfmac: fix wrong num_different_channels when mchan
 feature enabled
To: Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
 <1501577287-28904-3-git-send-email-wright.feng@cypress.com>
 <87mv7i48nx.fsf@codeaurora.org> <5981A6D4.4030805@broadcom.com>
 <87lgn2rsuh.fsf@kamboji.qca.qualcomm.com>
From: Wright Feng <wright.feng@cypress.com>
Message-ID: <55749a5c-3c53-3ed6-a66d-f6eb8c17168d@cypress.com> (sfid-20170803_035737_052722_9ED2E9E2)
Date: Thu, 3 Aug 2017 09:57:27 +0800
MIME-Version: 1.0
In-Reply-To: <87lgn2rsuh.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2017/8/2 下午 09:40, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> 
>> On 8/2/2017 11:32 AM, Kalle Valo wrote:
>>> Wright Feng <wright.feng@cypress.com> writes:
>>>
>>>> The num_different_channels in wiphy info is not correct when firmware
>>>> supports mchan. When mchan is on, num_different_channels is always
>>>> overridden to 1 in brcmf_setup_ifmodes. Correct the logic by moving
>>>> num_different_channels setting forward.
>>>>
>>>> Signed-off-by: Wright Feng <wright.feng@cypress.com>
>>>
>>> Does this fix a user visible bug? If yes, it would be nice to document
>>> that.
>>
>> Hi Kalle,
>>
>> Depends on the users expectation ;-) When the device/firmware supports
>> multi-channel (better not use mchan abbreviation) it can have P2P
>> connection and regular connection with AP simultaneous. So the current
>> state is that this is not possible regardless whether mchan is
>> supported. So the device is not used to fullest extent.
> 
> Thanks, I understand now and I think your description should be also in
> the commit log so that others will also :)
> 
> My usual mantra: the commit log should ALWAYS answer the question "_why_
> the change is made?" and describe the reason what motivated to implement
> the patch. This is the most important part. It helps maintainers,
> backports, distros etc to make decisions if the patch is important for
> them or not.

Hi Kalle and Arend,
Thanks for your comment and suggestion, I will put them into commit 
message and resend v2 later.
> 
