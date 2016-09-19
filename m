Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36054 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbcISQmI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 12:42:08 -0400
Received: by mail-pf0-f176.google.com with SMTP id q2so32495472pfj.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2016 09:42:07 -0700 (PDT)
Subject: Re: [PATCH 0/9] brcmfmac: coverity fixes
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <765f762c-ae93-68f2-287b-9e20b3db04c0@gmail.com> (sfid-20160919_184212_116896_03EF9859)
Date: Mon, 19 Sep 2016 09:42:05 -0700
MIME-Version: 1.0
In-Reply-To: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2016 04:09 AM, Arend van Spriel wrote:
> This series consist of:
> * fixes for several issues found by Coverity.
> * ignore 802.11d configuration if not supported in firmware.
> * remove worker from netdev callback.

Thanks for doing this, can you also provide the coverity id when
relevant? Something like:

Reported-by: coverity (CID #12345678)

Which can help with automated tools hooking to coverity for managing the
lifecycle of the report.

Thanks!

> 
> This is intended for 4.9 and applies to the master branch of
> the wireless-drivers-next repository.
> 
> Arend van Spriel (4):
>   brcmfmac: rework pointer trickery in brcmf_proto_bcdc_query_dcmd()
>   brcmfmac: fix memory leak in brcmf_flowring_add_tdls_peer()
>   brcmfmac: initialize variable in brcmf_sdiod_regrl()
>   brcmfmac: remove worker from .ndo_set_mac_address() callback
> 
> Hante Meuleman (5):
>   brcmfmac: ignore 11d configuration errors
>   brcmfmac: remove unnecessary null pointer check
>   brcmfmac: fix clearing entry IPv6 address
>   brcmfmac: fix out of bound access on clearing wowl wake indicator
>   brcmfmac: simplify mapping of auth type
> 
>  .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |  2 +-
>  .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  2 +-
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 41 +++++++++---------
>  .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 49 +++++++++-------------
>  .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 -
>  .../broadcom/brcm80211/brcmfmac/flowring.c         |  8 +++-
>  6 files changed, 47 insertions(+), 57 deletions(-)
> 


-- 
Florian
