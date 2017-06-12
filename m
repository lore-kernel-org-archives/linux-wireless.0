Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57082 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751954AbdFLNsV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 09:48:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, "Peter S. Housel" <housel@acm.org>
Subject: Re: [PATCH V3] brcmfmac: Fix glom_skb leak in brcmf_sdiod_recv_chain
References: <1497264382-2290-1-git-send-email-arend.vanspriel@broadcom.com>
        <78a8b9d2-4688-051b-26ce-df447530fa30@broadcom.com>
Date: Mon, 12 Jun 2017 16:47:55 +0300
In-Reply-To: <78a8b9d2-4688-051b-26ce-df447530fa30@broadcom.com> (Arend van
        Spriel's message of "Mon, 12 Jun 2017 13:32:52 +0200")
Message-ID: <87h8zl8ghg.fsf@kamboji.qca.qualcomm.com> (sfid-20170612_154824_726206_1F1384F3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 6/12/2017 12:46 PM, Arend van Spriel wrote:
>> From: "Peter S. Housel" <housel@acm.org>
>>
>> An earlier change to this function (3bdae810721b) fixed a leak in the
>> case of an unsuccessful call to brcmf_sdiod_buffrw(). However, the
>> glom_skb buffer, used for emulating a scattering read, is never used
>> or referenced after its contents are copied into the destination
>> buffers, and therefore always needs to be freed by the end of the
>> function.
>>
>
> Kalle,
>
> Can you add stable tag:
>
> Cc: stable@vger.kernel.org # 4.9.x-

Yes, will do.

-- 
Kalle Valo
