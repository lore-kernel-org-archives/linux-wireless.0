Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33273 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbdAMM6z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 07:58:55 -0500
Received: by mail-pf0-f175.google.com with SMTP id y143so31530730pfb.0
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 04:58:55 -0800 (PST)
Subject: Re: [RFC 4/5] cfg80211: add request id to
 cfg80211_sched_scan_results() api
To: Johannes Berg <johannes@sipsolutions.net>
References: <1484311664-4840-1-git-send-email-arend.vanspriel@broadcom.com>
 <1484311664-4840-5-git-send-email-arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <da6a2094-c828-8325-0374-e183588cee5e@broadcom.com> (sfid-20170113_135900_022665_838664C4)
Date: Fri, 13 Jan 2017 13:58:48 +0100
MIME-Version: 1.0
In-Reply-To: <1484311664-4840-5-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13-1-2017 13:47, Arend van Spriel wrote:
> Have proper request id filled in the SCHED_SCAN_RESULTS notification
> toward user-space by having the driver provide it through the api.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>  drivers/net/wireless/ath/ath6kl/wmi.c              |  2 +-
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  2 +-
>  drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  2 +-
>  include/net/cfg80211.h                             |  4 ++-
>  net/mac80211/scan.c                                |  2 +-
>  net/wireless/core.c                                |  1 -
>  net/wireless/core.h                                |  1 -
>  net/wireless/nl80211.c                             |  2 ++
>  net/wireless/scan.c                                | 30 +++++++++++-----------
>  net/wireless/trace.h                               | 17 +++++++++---
>  10 files changed, 37 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
> index 84a6d12..04df853 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> @@ -1082,7 +1082,7 @@ void ath6kl_wmi_sscan_timer(unsigned long ptr)
>  {
>  	struct ath6kl_vif *vif = (struct ath6kl_vif *) ptr;
>  
> -	cfg80211_sched_scan_results(vif->ar->wiphy);
> +	cfg80211_sched_scan_results(vif->ar->wiphy, 0);
>  }
>  
>  static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len,
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 8280f19..34d318e 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -766,7 +766,7 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
>  		brcmf_dbg(SCAN, "scheduled scan completed\n");
>  		cfg->internal_escan = false;
>  		if (!aborted)
> -			cfg80211_sched_scan_results(cfg_to_wiphy(cfg));
> +			cfg80211_sched_scan_results(cfg_to_wiphy(cfg), 0);
>  	} else if (scan_request) {
>  		struct cfg80211_scan_info info = {
>  			.aborted = aborted,
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> index 8548027..12b471f 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> @@ -1201,7 +1201,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
>  		break;
>  	case HostCmd_CMD_802_11_BG_SCAN_QUERY:
>  		ret = mwifiex_ret_802_11_scan(priv, resp);
> -		cfg80211_sched_scan_results(priv->wdev.wiphy);
> +		cfg80211_sched_scan_results(priv->wdev.wiphy, 0);
>  		mwifiex_dbg(adapter, CMD,
>  			    "info: CMD_RESP: BG_SCAN result is ready!\n");
>  		break;
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 880a57a..17c78c4 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1677,6 +1677,7 @@ struct cfg80211_sched_scan_request {
>  	u8 mac_addr_mask[ETH_ALEN] __aligned(2);
>  
>  	/* internal */
> +	struct work_struct results_wk;

When this worker is queued I suppose we should avoid the scheduled scan
request to be freed. Probable need cancel_work_sync() in
cfg80211_del_sched_scan_req().

Regards,
Arend
