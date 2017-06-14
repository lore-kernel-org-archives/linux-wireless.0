Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57932 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751988AbdFNJVL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 05:21:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, "Peter S. Housel" <housel@acm.org>
Subject: Re: [V3] brcmfmac: Fix glom_skb leak in brcmf_sdiod_recv_chain
References: <1497264382-2290-1-git-send-email-arend.vanspriel@broadcom.com>
        <20170613070028.5F9CB606DC@smtp.codeaurora.org>
        <6a8d5627-1d7c-a448-6657-0e1a2bb5ed9a@broadcom.com>
Date: Wed, 14 Jun 2017 12:21:06 +0300
In-Reply-To: <6a8d5627-1d7c-a448-6657-0e1a2bb5ed9a@broadcom.com> (Arend van
        Spriel's message of "Tue, 13 Jun 2017 13:29:52 +0200")
Message-ID: <87vany3oxp.fsf@kamboji.qca.qualcomm.com> (sfid-20170614_112120_814470_A39542D1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 13-06-17 09:00, Kalle Valo wrote:
>> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>> 
>>> From: "Peter S. Housel" <housel@acm.org>
>>>
>>> An earlier change to this function (3bdae810721b) fixed a leak in the
>>> case of an unsuccessful call to brcmf_sdiod_buffrw(). However, the
>>> glom_skb buffer, used for emulating a scattering read, is never used
>>> or referenced after its contents are copied into the destination
>>> buffers, and therefore always needs to be freed by the end of the
>>> function.
>>>
>>> Fixes: 3bdae810721b ("brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain")
>>> Fixes: a413e39a38573 ("brcmfmac: fix brcmf_sdcard_recv_chain() for
>>> host without sg support")
>>> Cc: stable@vger.kernel.org # 4.9.x-
>>> Signed-off-by: Peter S. Housel <housel@acm.org>
>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> 
>> Patch applied to wireless-drivers-next.git, thanks.
>
> Yikes. You say wireless-drivers-next? I should have tagged it better,
> but I would like to get this fix in 4.12 and stable.

Yes, always document clearly your intentions. I have so many patches
(and emails) to go through that I do not have much time for each patch
to figure out which tree it should go. And in this case the commit log
didn't mention any major breakage so I assumed this is for -next.

In theory I could cherry-pick the commit to wireless-drivers, but as
this doesn't look like a serious issue (no crashes or anything like
that), is it enough that this goes to 4.12 via stable tree? Just takes a
little longer, nothing else.

-- 
Kalle Valo
