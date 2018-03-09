Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:12582 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbeCII1N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 03:27:13 -0500
Subject: Re: [PATCH 10/10] staging: wilc1000: fix line over 80 char in
 cfg_scan_result()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
 <1520386350-31607-11-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <b24958e8-5a56-bfde-f0bd-1476bd47bd11@microchip.com> (sfid-20180309_092718_009149_A24B1A4F)
Date: Fri, 9 Mar 2018 10:27:09 +0200
MIME-Version: 1.0
In-Reply-To: <1520386350-31607-11-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07.03.2018 03:32, Ajay Singh wrote:
> Refactor cfg_scan_result() API to avoid 'line over 80 chars' issue
> reported by checkpatch.pl script.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 148 +++++++++++-----------
>  1 file changed, 77 insertions(+), 71 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index 9da686b..5395648 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -374,91 +374,97 @@ static void cfg_scan_result(enum scan_event scan_event,
>  	struct cfg80211_bss *bss = NULL;
>  
>  	priv = user_void;
> -	if (priv->cfg_scanning) {
> -		if (scan_event == SCAN_EVENT_NETWORK_FOUND) {
> -			wiphy = priv->dev->ieee80211_ptr->wiphy;
> +	if (!priv->cfg_scanning)
> +		return;
> +
> +	if (scan_event == SCAN_EVENT_NETWORK_FOUND) {
> +		wiphy = priv->dev->ieee80211_ptr->wiphy;
> +
> +		if (!wiphy || !network_info)
> +			return;
>  
> -			if (!wiphy)
> +		if (wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC &&
> +		    (((s32)network_info->rssi * 100) < 0 ||
> +		    ((s32)network_info->rssi * 100) > 100))
> +			return;
> +
> +		s32Freq = ieee80211_channel_to_frequency((s32)network_info->ch,
> +							 NL80211_BAND_2GHZ);
> +		channel = ieee80211_get_channel(wiphy, s32Freq);
> +
> +		if (!channel)
> +			return;
> +
> +		if (network_info->new_network) {
> +			if (priv->rcvd_ch_cnt >= MAX_NUM_SCANNED_NETWORKS)
>  				return;
>  
> -			if (wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC &&
> -			    (((s32)network_info->rssi * 100) < 0 ||
> -			    ((s32)network_info->rssi * 100) > 100))
> +			priv->rcvd_ch_cnt++;
> +
> +			add_network_to_shadow(network_info, priv, join_params);
> +
> +			if (memcmp("DIRECT-", network_info->ssid, 7))
>  				return;
>  
> -			if (network_info) {
> -				s32Freq = ieee80211_channel_to_frequency((s32)network_info->ch, NL80211_BAND_2GHZ);
> -				channel = ieee80211_get_channel(wiphy, s32Freq);
> -
> -				if (!channel)
> -					return;
> -
> -				if (network_info->new_network) {
> -					if (priv->rcvd_ch_cnt < MAX_NUM_SCANNED_NETWORKS) {
> -						priv->rcvd_ch_cnt++;
> -
> -						add_network_to_shadow(network_info, priv, join_params);
> -
> -						if (!(memcmp("DIRECT-", network_info->ssid, 7))) {
> -							bss = cfg80211_inform_bss(wiphy,
> -										  channel,
> -										  CFG80211_BSS_FTYPE_UNKNOWN,
> -										  network_info->bssid,
> -										  network_info->tsf_hi,
> -										  network_info->cap_info,
> -										  network_info->beacon_period,
> -										  (const u8 *)network_info->ies,
> -										  (size_t)network_info->ies_len,
> -										  (s32)network_info->rssi * 100,
> -										  GFP_KERNEL);
> -							cfg80211_put_bss(wiphy, bss);
> -						}
> -					}
> -				} else {
> -					u32 i;
> +			bss = cfg80211_inform_bss(wiphy,
> +						  channel,
> +						  CFG80211_BSS_FTYPE_UNKNOWN,
> +						  network_info->bssid,
> +						  network_info->tsf_hi,
> +						  network_info->cap_info,
> +						  network_info->beacon_period,
> +						  (const u8 *)network_info->ies,
> +						  (size_t)network_info->ies_len,
> +						  (s32)network_info->rssi * 100,
> +						  GFP_KERNEL);
> +			cfg80211_put_bss(wiphy, bss);
> +		} else {
> +			u32 i;
>  
> -					for (i = 0; i < priv->rcvd_ch_cnt; i++) {
> -						if (memcmp(last_scanned_shadow[i].bssid, network_info->bssid, 6) == 0) {
> -							last_scanned_shadow[i].rssi = network_info->rssi;
> -							last_scanned_shadow[i].time_scan = jiffies;
> -							break;
> -						}
> -					}
> -				}
> +			for (i = 0; i < priv->rcvd_ch_cnt; i++) {
> +				if (memcmp(last_scanned_shadow[i].bssid,
> +					   network_info->bssid, 6) == 0)
> +					break;
>  			}
> -		} else if (scan_event == SCAN_EVENT_DONE) {
> -			refresh_scan(priv, false);
>  
> -			mutex_lock(&priv->scan_req_lock);
> +			if (i >= priv->rcvd_ch_cnt)
> +				return;
This complicates a little the logic... I don't now if it's worth...
>  
> -			if (priv->scan_req) {
> -				struct cfg80211_scan_info info = {
> -					.aborted = false,
> -				};
> +			last_scanned_shadow[i].rssi = network_info->rssi;
> +			last_scanned_shadow[i].time_scan = jiffies;
> +		}
> +	} else if (scan_event == SCAN_EVENT_DONE) {
> +		refresh_scan(priv, false);
>  
> -				cfg80211_scan_done(priv->scan_req, &info);
> -				priv->rcvd_ch_cnt = 0;
> -				priv->cfg_scanning = false;
> -				priv->scan_req = NULL;
> -			}
> -			mutex_unlock(&priv->scan_req_lock);
> -		} else if (scan_event == SCAN_EVENT_ABORTED) {
> -			mutex_lock(&priv->scan_req_lock);
> +		mutex_lock(&priv->scan_req_lock);
>  
> -			if (priv->scan_req) {
> -				struct cfg80211_scan_info info = {
> -					.aborted = false,
> -				};
> +		if (priv->scan_req) {
> +			struct cfg80211_scan_info info = {
> +				.aborted = false,
> +			};
>  
> -				update_scan_time();
> -				refresh_scan(priv, false);
> +			cfg80211_scan_done(priv->scan_req, &info);
> +			priv->rcvd_ch_cnt = 0;
> +			priv->cfg_scanning = false;
> +			priv->scan_req = NULL;
> +		}
> +		mutex_unlock(&priv->scan_req_lock);
> +	} else if (scan_event == SCAN_EVENT_ABORTED) {
> +		mutex_lock(&priv->scan_req_lock);
>  
> -				cfg80211_scan_done(priv->scan_req, &info);
> -				priv->cfg_scanning = false;
> -				priv->scan_req = NULL;
> -			}
> -			mutex_unlock(&priv->scan_req_lock);
> +		if (priv->scan_req) {
> +			struct cfg80211_scan_info info = {
> +				.aborted = false,
> +			};
> +
> +			update_scan_time();
> +			refresh_scan(priv, false);
> +
> +			cfg80211_scan_done(priv->scan_req, &info);
> +			priv->cfg_scanning = false;
> +			priv->scan_req = NULL;
>  		}
> +		mutex_unlock(&priv->scan_req_lock);
>  	}
>  }
>  
> 
