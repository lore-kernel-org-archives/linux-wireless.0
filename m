Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56690 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751783AbdLBPXZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 10:23:25 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [for-4.15] brcmfmac: change driver unbind order of the sdio
 function devices
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1511642376-16279-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1511642376-16279-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20171202152325.5969A607EB@smtp.codeaurora.org> (sfid-20171202_162329_555924_D1A36765)
Date: Sat,  2 Dec 2017 15:23:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> In the function brcmf_sdio_firmware_callback() the driver is
> unbound from the sdio function devices in the error path.
> However, the order in which it is done resulted in a use-after-free
> issue (see brcmf_ops_sdio_remove() in bcmsdh.c). Hence change
> the order and first unbind sdio function #2 device and then
> unbind sdio function #1 device.
> 
> Cc: stable@vger.kernel.org # v4.12.x
> Fixes: 7a51461fc2da ("brcmfmac: unbind all devices upon failure in firmware callback")
> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers.git, thanks.

5c3de777bdaf brcmfmac: change driver unbind order of the sdio function devices

-- 
https://patchwork.kernel.org/patch/10075091/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
