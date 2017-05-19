Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17971 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbdESHsb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 03:48:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath6kl: assure headroom of skbuff is writable in .start_xmit()
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <eabfeaed1b2b4873bef7b293e512d847@euamsexm01a.eu.qualcomm.com> (sfid-20170519_094840_872296_F845A1AC)
Date: Fri, 19 May 2017 09:48:05 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> An issue was found brcmfmac driver in which a skbuff in .start_xmit()
> callback was actually cloned. So instead of checking for sufficient
> headroom it should also be writable. Hence use skb_cow_head() to
> check and expand the headroom appropriately.
> 
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Tested-by: Steve deRosier <derosier@gmail.com>

Patch applied to ath-next branch of ath.git, thanks.

1ed760c9aca0 ath6kl: assure headroom of skbuff is writable in .start_xmit()

-- 
https://patchwork.kernel.org/patch/9697757/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
