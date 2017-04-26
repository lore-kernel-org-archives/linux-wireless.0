Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35335 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1957301AbdDZIy4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 04:54:56 -0400
Received: by mail-wm0-f53.google.com with SMTP id w64so43819320wma.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 01:54:55 -0700 (PDT)
Subject: Re: [PATCH 4/9] cfg80211: unify cfg80211_roamed() and
 cfg80211_roamed_bss()
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
References: <20170426075854.13546-1-luca@coelho.fi>
 <20170426075854.13546-5-luca@coelho.fi>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <56ed3d17-cdcd-c90b-8ed5-0f948b8adaa0@broadcom.com> (sfid-20170426_105530_747519_A065964D)
Date: Wed, 26 Apr 2017 10:54:51 +0200
MIME-Version: 1.0
In-Reply-To: <20170426075854.13546-5-luca@coelho.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/26/2017 9:58 AM, Luca Coelho wrote:
> From: Avraham Stern <avraham.stern@intel.com>
> 
> cfg80211_roamed() and cfg80211_roamed_bss() take the same arguments
> except that cfg80211_roamed() requires the BSSID and
> cfg80211_roamed_bss() requires the bss entry.
> 
> Unify the two functions by using a struct for driver initiated
> roaming information so that either the BSSID or the bss entry can be
> passed as an argument to the unified function.
> 
> Signed-off-by: Avraham Stern <avraham.stern@intel.com>
> [modified the ath6k, brcm80211, rndis and wlan-ng drivers accordingly]
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>   drivers/net/wireless/ath/ath6kl/cfg80211.c         | 10 ++-
>   .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 13 +++-
>   drivers/net/wireless/rndis_wlan.c                  | 19 +++--
>   drivers/staging/wlan-ng/cfg80211.c                 |  7 +-
>   include/net/cfg80211.h                             | 58 +++++++-------
>   net/wireless/core.h                                | 12 +--
>   net/wireless/nl80211.c                             | 18 +++--
>   net/wireless/nl80211.h                             |  5 +-
>   net/wireless/sme.c                                 | 90 +++++++++-------------
>   net/wireless/util.c                                |  4 +-
>   10 files changed, 115 insertions(+), 121 deletions(-)
> 

[...]

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 8c7f1ef288c6..a36bccbb40e5 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -5359,6 +5359,7 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
>   	struct ieee80211_supported_band *band;
>   	struct brcmf_bss_info_le *bi;
>   	struct brcmu_chan ch;
> +	struct cfg80211_roam_info roam_info = {};
>   	u32 freq;
>   	s32 err = 0;
>   	u8 *buf;
> @@ -5397,9 +5398,15 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
>   
>   done:
>   	kfree(buf);
> -	cfg80211_roamed(ndev, notify_channel, (u8 *)profile->bssid,
> -			conn_info->req_ie, conn_info->req_ie_len,
> -			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
> +
> +	roam_info.channel = notify_channel;
> +	roam_info.bssid = (u8*)profile->bssid;

I know it was there before, but this cast seem useless.

Regards,
Arend

> +	roam_info.req_ie = conn_info->req_ie;
> +	roam_info.req_ie_len = conn_info->req_ie_len;
> +	roam_info.resp_ie = conn_info->resp_ie;
> +	roam_info.resp_ie_len = conn_info->resp_ie_len;
> +
> +	cfg80211_roamed(ndev, &roam_info, GFP_KERNEL);
>   	brcmf_dbg(CONN, "Report roaming result\n");
