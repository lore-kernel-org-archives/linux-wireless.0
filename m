Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56614 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbdG0LDD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 07:03:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [for-v4.13,V4] brcmfmac: Don't grow SKB by negative size
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170726112410.22353-1-daniels@collabora.com>
References: <20170726112410.22353-1-daniels@collabora.com>
To: Daniel Stone <daniels@collabora.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        James Hughes <james.hughes@raspberrypi.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Message-Id: <20170727110303.105046081B@smtp.codeaurora.org> (sfid-20170727_130307_133457_FFA23F7E)
Date: Thu, 27 Jul 2017 11:03:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Stone <daniels@collabora.com> wrote:

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
> Tested-by: Hans de Goede <hdegoede@redhat.com>

Patch applied to wireless-drivers.git, thanks.

58f36b4526ad brcmfmac: Don't grow SKB by negative size

-- 
https://patchwork.kernel.org/patch/9864575/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
