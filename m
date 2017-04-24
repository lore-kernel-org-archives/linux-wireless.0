Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33491 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S976572AbdDXSJo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 14:09:44 -0400
Message-ID: <1493057382.6453.39.camel@edumazet-glaptop3.roam.corp.google.com> (sfid-20170424_201050_463327_F6CCFC02)
Subject: Re: [PATCH v2] brcmfmac: Make skb header writable before use
From: Eric Dumazet <eric.dumazet@gmail.com>
To: James Hughes <james.hughes@raspberrypi.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
Date: Mon, 24 Apr 2017 11:09:42 -0700
In-Reply-To: <20170424130322.476-1-james.hughes@raspberrypi.org>
References: <20170424130322.476-1-james.hughes@raspberrypi.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-04-24 at 14:03 +0100, James Hughes wrote:
> The driver was making changes to the skb_header without
> ensuring it was writable (i.e. uncloned).
> This patch also removes some boiler plate header size
> checking/adjustment code as that is also handled by the
> skb_cow_header function used to make header writable.
> 
> This patch depends on
> brcmfmac: Ensure pointer correctly set if skb data location changes
> 
> Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
> ---
> Changes in v2
>   Makes the _cow_ call at the entry point of the skb in to the
>   stack, means only needs to be done once, and error handling
>   is easier.
>   Split a separate minor bug fix off to a separate patch (which
>   this patch depends on)

Best way to handle dependencies is to send a patch series.

1/2 brcmfmac: Ensure pointer correctly set if skb data location changes
2/2 brcmfmac: Make skb header writable before use
