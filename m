Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:36577 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752168AbdFML3z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 07:29:55 -0400
Received: by mail-lf0-f46.google.com with SMTP id o83so68340233lff.3
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 04:29:54 -0700 (PDT)
Subject: Re: [V3] brcmfmac: Fix glom_skb leak in brcmf_sdiod_recv_chain
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, "Peter S. Housel" <housel@acm.org>
References: <1497264382-2290-1-git-send-email-arend.vanspriel@broadcom.com>
 <20170613070028.5F9CB606DC@smtp.codeaurora.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6a8d5627-1d7c-a448-6657-0e1a2bb5ed9a@broadcom.com> (sfid-20170613_132958_233782_E5001302)
Date: Tue, 13 Jun 2017 13:29:52 +0200
MIME-Version: 1.0
In-Reply-To: <20170613070028.5F9CB606DC@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13-06-17 09:00, Kalle Valo wrote:
> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> 
>> From: "Peter S. Housel" <housel@acm.org>
>>
>> An earlier change to this function (3bdae810721b) fixed a leak in the
>> case of an unsuccessful call to brcmf_sdiod_buffrw(). However, the
>> glom_skb buffer, used for emulating a scattering read, is never used
>> or referenced after its contents are copied into the destination
>> buffers, and therefore always needs to be freed by the end of the
>> function.
>>
>> Fixes: 3bdae810721b ("brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain")
>> Fixes: a413e39a38573 ("brcmfmac: fix brcmf_sdcard_recv_chain() for host without sg support")
>> Cc: stable@vger.kernel.org # 4.9.x-
>> Signed-off-by: Peter S. Housel <housel@acm.org>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> Patch applied to wireless-drivers-next.git, thanks.

Yikes. You say wireless-drivers-next? I should have tagged it better,
but I would like to get this fix in 4.12 and stable.

Regards,
Arend

> 5ea59db8a375 brcmfmac: Fix glom_skb leak in brcmf_sdiod_recv_chain
> 
