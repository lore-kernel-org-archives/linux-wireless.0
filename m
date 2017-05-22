Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38278 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934647AbdEVPQu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 11:16:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V4,1/3] brcmfmac: add support multi-scheduled scan
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1495180659-12406-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1495180659-12406-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170522151649.B5F1060AC8@smtp.codeaurora.org> (sfid-20170522_171654_821593_8756AB5A)
Date: Mon, 22 May 2017 15:16:49 +0000 (UTC)
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

I see new warnings:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c: In function ‘brcmf_pno_config_sched_scans’:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c:166:6: warning: ‘mac_mask’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  u8 *mac_mask;
      ^
drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c:183:2: warning: ‘mac_addr’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  memcpy(pfn_mac.mac, mac_addr, ETH_ALEN);
  ^
drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c:165:6: note: ‘mac_addr’ was declared here
  u8 *mac_addr;
      ^

3 patches set to Changes Requested.

9736151 [V4,1/3] brcmfmac: add support multi-scheduled scan
9736147 [V4,2/3] brcmfmac: add mutex to protect pno requests
9736149 [V4,3/3] brcmfmac: add scheduled scan support for specified BSSIDs

-- 
https://patchwork.kernel.org/patch/9736151/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
