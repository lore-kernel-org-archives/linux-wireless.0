Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45679 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaHNJYC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 05:24:02 -0400
Message-ID: <53EC802F.3020805@broadcom.com> (sfid-20140814_112407_233502_D3546987)
Date: Thu, 14 Aug 2014 11:23:59 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
CC: <kvalo@adurom.com>, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2/2] cfg80211: allow passing frame type to cfg80211_inform_bss()
References: <1407870219-1720-1-git-send-email-johannes@sipsolutions.net> <1407870219-1720-2-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1407870219-1720-2-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2014 09:03 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> When using the cfg80211_inform_bss[_width]() functions drivers
> cannot currently indicate whether the data was received in a
> beacon or probe response. Fix that by passing a new enum that
> indicates such (or unknown).
>
> For good measure, use it in ath6kl.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   drivers/net/wireless/ath/ath6kl/cfg80211.c         |  1 +
>   drivers/net/wireless/ath/ath6kl/wmi.c              | 43 +++++-----------------
>   drivers/net/wireless/ath/wil6210/wmi.c             |  2 +-
>   .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 18 ++++++---
>   drivers/net/wireless/libertas/cfg.c                |  2 +
>   drivers/net/wireless/mwifiex/cfg80211.c            |  1 +
>   drivers/net/wireless/mwifiex/scan.c                |  3 +-
>   drivers/net/wireless/orinoco/scan.c                | 14 ++++---
>   drivers/net/wireless/rndis_wlan.c                  | 14 ++++---
>   drivers/staging/wlan-ng/cfg80211.c                 |  1 +
>   include/net/cfg80211.h                             | 20 +++++++++-
>   net/wireless/scan.c                                | 21 ++++++++---
>   12 files changed, 78 insertions(+), 62 deletions(-)

[...]

> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> index d8fa276e368b..9a45ef064dd9 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> @@ -2429,9 +2429,13 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
>   	brcmf_dbg(CONN, "Beacon interval: %d\n", notify_interval);
>   	brcmf_dbg(CONN, "Signal: %d\n", notify_signal);
>
> -	bss = cfg80211_inform_bss(wiphy, notify_channel, (const u8 *)bi->BSSID,
> -		0, notify_capability, notify_interval, notify_ie,
> -		notify_ielen, notify_signal, GFP_KERNEL);
> +	bss = cfg80211_inform_bss(wiphy, notify_channel,
> +				  CFG80211_BSS_FTYPE_UNKNOWN,

Checked the firmware API and it does not provide this info.

Acked-by: Arend van Spriel <arend@broadcom.com>

Regards,
Arend
