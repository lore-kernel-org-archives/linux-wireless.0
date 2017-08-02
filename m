Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43160 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751933AbdHBNkM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 09:40:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 3/3] brcmfmac: fix wrong num_different_channels when mchan feature enabled
References: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
        <1501577287-28904-3-git-send-email-wright.feng@cypress.com>
        <87mv7i48nx.fsf@codeaurora.org> <5981A6D4.4030805@broadcom.com>
Date: Wed, 02 Aug 2017 16:40:06 +0300
In-Reply-To: <5981A6D4.4030805@broadcom.com> (Arend van Spriel's message of
        "Wed, 02 Aug 2017 12:17:56 +0200")
Message-ID: <87lgn2rsuh.fsf@kamboji.qca.qualcomm.com> (sfid-20170802_154015_760447_148BD995)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 8/2/2017 11:32 AM, Kalle Valo wrote:
>> Wright Feng <wright.feng@cypress.com> writes:
>>
>>> The num_different_channels in wiphy info is not correct when firmware
>>> supports mchan. When mchan is on, num_different_channels is always
>>> overridden to 1 in brcmf_setup_ifmodes. Correct the logic by moving
>>> num_different_channels setting forward.
>>>
>>> Signed-off-by: Wright Feng <wright.feng@cypress.com>
>>
>> Does this fix a user visible bug? If yes, it would be nice to document
>> that.
>
> Hi Kalle,
>
> Depends on the users expectation ;-) When the device/firmware supports
> multi-channel (better not use mchan abbreviation) it can have P2P
> connection and regular connection with AP simultaneous. So the current
> state is that this is not possible regardless whether mchan is
> supported. So the device is not used to fullest extent.

Thanks, I understand now and I think your description should be also in
the commit log so that others will also :)

My usual mantra: the commit log should ALWAYS answer the question "_why_
the change is made?" and describe the reason what motivated to implement
the patch. This is the most important part. It helps maintainers,
backports, distros etc to make decisions if the patch is important for
them or not.

-- 
Kalle Valo
