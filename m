Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:37760 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbdIJSuk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Sep 2017 14:50:40 -0400
Received: by mail-qt0-f172.google.com with SMTP id b1so5780631qtc.4
        for <linux-wireless@vger.kernel.org>; Sun, 10 Sep 2017 11:50:40 -0700 (PDT)
Subject: Re: [PATCH V2 1/3] brcmfmac: Avoid possible out-of-bounds read
To: Kevin Cernekee <cernekee@chromium.org>, franky.lin@broadcom.com
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
References: <20170909193020.19061-1-cernekee@chromium.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <deff51ff-40f0-ffa4-afd0-b95465c66a8e@broadcom.com> (sfid-20170910_205044_504637_343F487F)
Date: Sun, 10 Sep 2017 20:50:35 +0200
MIME-Version: 1.0
In-Reply-To: <20170909193020.19061-1-cernekee@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09-09-17 21:30, Kevin Cernekee wrote:
> In brcmf_p2p_notify_rx_mgmt_p2p_probereq(), chanspec is assigned before
> the length of rxframe is validated.  This could lead to uninitialized
> data being accessed (but not printed).  Since we already have a
> perfectly good endian-swapped copy of rxframe->chanspec in ch.chspec,
> and ch.chspec is not modified by decchspec(), avoid the extra
> assignment and use ch.chspec in the debug print.
> 
> Suggested-by: Mattias Nissler <mnissler@chromium.org>
> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> 
> V1->V2: Clarify changelog re: whether the uninitialized data is printed.

This patch and the others in this series look fine to me.

Thanks,
Arend
