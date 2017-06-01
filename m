Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbdFAJDl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 05:03:41 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [4.12, REGRESSION,
 fix] brcmfmac: fix alignment configuration on host using 64-bit DMA
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170526110255.21342-1-hdegoede@redhat.com>
References: <20170526110255.21342-1-hdegoede@redhat.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Message-Id: <20170601090340.B7D616073B@smtp.codeaurora.org> (sfid-20170601_110345_335522_197DE0D9)
Date: Thu,  1 Jun 2017 09:03:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans de Goede <hdegoede@redhat.com> wrote:

> From: Arend Van Spriel <arend.vanspriel@broadcom.com>
> 
> For SDIO the alignment requirement for transfers from device to host
> is configured in firmware. This configuration is limited to minimum
> of 4-byte alignment. However, this is not correct for platforms using
> 64-bit DMA when the minimum alignment should be 8 bytes. This issue
> appeared when the ALIGNMENT definition was set according the DMA
> configuration. The configuration in firmware was not using that macro
> defintion, but a hardcoded value of 4. Hence the driver reported
> alignment failures for data coming from the device and causing
> transfers to fail.
> 
> Fixes: 6e84ab604bde ("brcmfmac: properly align buffers on certain platforms
> Reported-by: Hans de Goede <hdegoede@redhat.com>
> Tested-by: Hans de Goede <hdegoede@redhat.com>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Patch applied to wireless-drivers.git, thanks.

1dbf647f3175 brcmfmac: fix alignment configuration on host using 64-bit DMA

-- 
https://patchwork.kernel.org/patch/9750347/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
