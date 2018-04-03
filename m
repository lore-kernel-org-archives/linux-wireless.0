Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54166 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752661AbeDCKFC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 06:05:02 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: fix firmware request processing if nvram load fails
References: <1522743495-13004-1-git-send-email-arend.vanspriel@broadcom.com>
Date: Tue, 03 Apr 2018 13:04:58 +0300
In-Reply-To: <1522743495-13004-1-git-send-email-arend.vanspriel@broadcom.com>
        (Arend van Spriel's message of "Tue, 3 Apr 2018 10:18:15 +0200")
Message-ID: <87o9j0ip11.fsf@kamboji.qca.qualcomm.com> (sfid-20180403_120506_640755_2F935410)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> When nvram loading fails a double free occurred. Fix this and reorg the
> code a little.
>
> Fixes: commit d09ae51a4b67 ("brcmfmac: pass struct in brcmf_fw_get_firmwares()")

This should be:

Fixes: d09ae51a4b67 ("brcmfmac: pass struct in brcmf_fw_get_firmwares()")

I can fix that during commit.

> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
> Hi Kalle,
>
> This fix is for code currently(?) in linux-next in error path caused
> a double free.

Ok, I'll queue this to wireless-drivers (after I have fast forwarded it)
for 4.17.

-- 
Kalle Valo
