Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752387AbdFMG6p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 02:58:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V5,1/3] brcmfmac: add support multi-scheduled scan
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1497007162-13013-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1497007162-13013-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170613065844.6D4096076B@smtp.codeaurora.org> (sfid-20170613_085942_808185_6FC07D3E)
Date: Tue, 13 Jun 2017 06:58:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> From: Arend Van Spriel <arend.vanspriel@broadcom.com>
> 
> This change adds support for multi-scheduled scan in the driver. It
> currently relies on g-scan support in firmware and will set struct
> wiphy::max_sched_scan_reqs accordingly. This is limited to 16 concurrent
> requests.
> 
> The firmware currently has a limit of 64 channels that can be configured
> for all requests in total regardless whether there are duplicates. So if
> a request uses 35 channels there are 29 channels left for another request.
> When user-space does not specify any channels cfg80211 will add all
> channels defined by the wiphy instance to the request, which makes
> reaching the limit rather easy for dual-band devices.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

3 patches applied to wireless-drivers-next.git, thanks.

efc2c1fa8e14 brcmfmac: add support multi-scheduled scan
42596f761449 brcmfmac: add mutex to protect pno requests
69897f390b00 brcmfmac: add scheduled scan support for specified BSSIDs

-- 
https://patchwork.kernel.org/patch/9778103/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
