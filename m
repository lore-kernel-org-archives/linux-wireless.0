Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33810 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750797AbdFPUTu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 16:19:50 -0400
Received: by mail-wm0-f41.google.com with SMTP id d64so6099439wmf.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 13:19:49 -0700 (PDT)
Subject: Re: [PATCH 2/2] brcmfmac: Use separate firmware for revision 0 of the
 brcm43430 chip
To: Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Jelle van der Waa <jelle@vdwaa.nl>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
References: <20170616131449.12108-1-hdegoede@redhat.com>
 <20170616131449.12108-2-hdegoede@redhat.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <462beb25-487c-86a7-e1a0-8c98b1cbaf57@broadcom.com> (sfid-20170616_221953_580508_17F3B127)
Date: Fri, 16 Jun 2017 22:19:47 +0200
MIME-Version: 1.0
In-Reply-To: <20170616131449.12108-2-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 16-06-17 15:14, Hans de Goede wrote:
> The brcm43430 chip needs different firmware files for chip revision 0
> and 1. The file currently in linux-firmware is for revision 1 only.
> 
> This commit makes brcmfmac request brcmfmac43430a0-sdio.bin instead
> of brcmfmac43430-sdio.bin for revision 0 chips.
> 
> Note that the behavior for revision 1 chips is not changed, ideally those
> would load brcmfmac43430a1-sdio.bin, but that will break existing setups.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
