Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37386 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933299AbdIYISR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 04:18:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/7] brcmfmac: handle FWHALT mailbox indication
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1505208143-30166-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1505208143-30166-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170925081816.E31B560C6B@smtp.codeaurora.org> (sfid-20170925_104606_494600_7E63644D)
Date: Mon, 25 Sep 2017 08:18:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> The firmware uses a mailbox to communicate to the host what is going
> on. In the driver we validate the bit received. Various people seen
> the following message:
> 
>  brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012
> 
> Bit 4 is cause of this message, but this actually indicates the firmware
> has halted. Handle this bit by giving a more meaningful error message.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Failed to compile:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c: In function ‘brcmf_p2p_escan’:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:695:23: error: ‘BRCMF_SCANTYPE_ACTIVE’ undeclared (first use in this function)
  sparams->scan_type = BRCMF_SCANTYPE_ACTIVE;
                       ^
drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:695:23: note: each undeclared identifier is reported only once for each function it appears in
make[6]: *** [drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.o] Error 1
make[6]: *** Waiting for unfinished jobs....
make[5]: *** [drivers/net/wireless/broadcom/brcm80211/brcmfmac] Error 2
make[4]: *** [drivers/net/wireless/broadcom/brcm80211] Error 2
make[3]: *** [drivers/net/wireless/broadcom] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

7 patches set to Changes Requested.

9948825 [1/7] brcmfmac: handle FWHALT mailbox indication
9948831 [2/7] brcmfmac: disable packet filtering in promiscuous mode
9948829 [3/7] brcmfmac: cleanup brcmf_cfg80211_escan() function
9948833 [4/7] brcmfmac: use msecs_to_jiffies() instead of calculation using HZ
9948827 [5/7] brcmfmac: get rid of brcmf_cfg80211_escan() function
9948823 [6/7] brcmfmac: get rid of struct brcmf_cfg80211_info::active_scan field
9948835 [7/7] brcmfmac: move configuration of probe request IEs

-- 
https://patchwork.kernel.org/patch/9948825/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
