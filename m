Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39230 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbdG0GPZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 02:15:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Daniel Stone <daniels@collabora.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        James Hughes <james.hughes@raspberrypi.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Subject: Re: [PATCH for-v4.13 V4] brcmfmac: Don't grow SKB by negative size
References: <20170726084924.27546-1-daniels@collabora.com>
        <20170726112410.22353-1-daniels@collabora.com>
Date: Thu, 27 Jul 2017 09:15:20 +0300
In-Reply-To: <20170726112410.22353-1-daniels@collabora.com> (Daniel Stone's
        message of "Wed, 26 Jul 2017 12:24:10 +0100")
Message-ID: <87d18mxv5z.fsf@purkki.adurom.net> (sfid-20170727_081529_565758_3A80CCC0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Stone <daniels@collabora.com> writes:

> The commit to rework the headroom check in start_xmit() now calls
> pxskb_expand_head() unconditionally if the header is CoW. Unfortunately,
> it does so with the delta between the extant headroom and the header
> length, which may be negative if there is already sufficient headroom.
>
> pskb_expand_head() does allow for size being 0, in which case it just
> copies, so clamp the header delta to zero.
>
> Opening Chrome (and all my tabs) on a PCIE device was enough to reliably
> hit this.
>
> Fixes: 270a6c1f65fe ("brcmfmac: rework headroom check in .start_xmit()")
> Signed-off-by: Daniel Stone <daniels@collabora.com>
> Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>
> Cc: James Hughes <james.hughes@raspberrypi.org>
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Cc: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Cc: Franky Lin <franky.lin@broadcom.com>

I'll queue this for 4.13.

-- 
Kalle Valo
