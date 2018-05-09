Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:25648 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934664AbeEINnR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 09:43:17 -0400
Subject: Re: [PATCH 14/30] staging: wilc1000: fix line over 80 chars in
 add_network_to_shadow()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-15-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <b967c08b-1158-f71a-9976-05c6365af857@microchip.com> (sfid-20180509_154321_067753_E1C97134)
Date: Wed, 9 May 2018 16:43:14 +0300
MIME-Version: 1.0
In-Reply-To: <1525682614-3824-15-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07.05.2018 11:43, Ajay Singh wrote:
> Fix line over 80 characters issue reported by checkpatch in
> add_network_to_shadow() by using temporary variable.

I, personally, don't like this way of fixing line over 80. From my
point of view this introduces a new future patch. Maybe, in future,
somebody will remove this temporary variable stating that there is
no need for it.

> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 52 +++++++++++------------
>  1 file changed, 25 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index f1ebaea..0ae2065 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -300,6 +300,7 @@ static void add_network_to_shadow(struct network_info *nw_info,
>  	int ap_found = is_network_in_shadow(nw_info, user_void);
>  	u32 ap_index = 0;
>  	u8 rssi_index = 0;
> +	struct network_info *shadow_nw_info;
>  
>  	if (last_scanned_cnt >= MAX_NUM_SCANNED_NETWORKS_SHADOW)
>  		return;
> @@ -310,37 +311,34 @@ static void add_network_to_shadow(struct network_info *nw_info,
>  	} else {
>  		ap_index = ap_found;
>  	}
> -	rssi_index = last_scanned_shadow[ap_index].rssi_history.index;
> -	last_scanned_shadow[ap_index].rssi_history.samples[rssi_index++] = nw_info->rssi;
> +	shadow_nw_info = &last_scanned_shadow[ap_index];
> +	rssi_index = shadow_nw_info->rssi_history.index;
> +	shadow_nw_info->rssi_history.samples[rssi_index++] = nw_info->rssi;
>  	if (rssi_index == NUM_RSSI) {
>  		rssi_index = 0;
> -		last_scanned_shadow[ap_index].rssi_history.full = true;
> -	}
> -	last_scanned_shadow[ap_index].rssi_history.index = rssi_index;
> -	last_scanned_shadow[ap_index].rssi = nw_info->rssi;
> -	last_scanned_shadow[ap_index].cap_info = nw_info->cap_info;
> -	last_scanned_shadow[ap_index].ssid_len = nw_info->ssid_len;
> -	memcpy(last_scanned_shadow[ap_index].ssid,
> -	       nw_info->ssid, nw_info->ssid_len);
> -	memcpy(last_scanned_shadow[ap_index].bssid,
> -	       nw_info->bssid, ETH_ALEN);
> -	last_scanned_shadow[ap_index].beacon_period = nw_info->beacon_period;
> -	last_scanned_shadow[ap_index].dtim_period = nw_info->dtim_period;
> -	last_scanned_shadow[ap_index].ch = nw_info->ch;
> -	last_scanned_shadow[ap_index].ies_len = nw_info->ies_len;
> -	last_scanned_shadow[ap_index].tsf_hi = nw_info->tsf_hi;
> +		shadow_nw_info->rssi_history.full = true;
> +	}
> +	shadow_nw_info->rssi_history.index = rssi_index;
> +	shadow_nw_info->rssi = nw_info->rssi;
> +	shadow_nw_info->cap_info = nw_info->cap_info;
> +	shadow_nw_info->ssid_len = nw_info->ssid_len;
> +	memcpy(shadow_nw_info->ssid, nw_info->ssid, nw_info->ssid_len);
> +	memcpy(shadow_nw_info->bssid, nw_info->bssid, ETH_ALEN);
> +	shadow_nw_info->beacon_period = nw_info->beacon_period;
> +	shadow_nw_info->dtim_period = nw_info->dtim_period;
> +	shadow_nw_info->ch = nw_info->ch;
> +	shadow_nw_info->ies_len = nw_info->ies_len;
> +	shadow_nw_info->tsf_hi = nw_info->tsf_hi;
>  	if (ap_found != -1)
> -		kfree(last_scanned_shadow[ap_index].ies);
> -	last_scanned_shadow[ap_index].ies = kmalloc(nw_info->ies_len,
> -						    GFP_KERNEL);
> -	memcpy(last_scanned_shadow[ap_index].ies,
> -	       nw_info->ies, nw_info->ies_len);
> -	last_scanned_shadow[ap_index].time_scan = jiffies;
> -	last_scanned_shadow[ap_index].time_scan_cached = jiffies;
> -	last_scanned_shadow[ap_index].found = 1;
> +		kfree(shadow_nw_info->ies);
> +	shadow_nw_info->ies = kmalloc(nw_info->ies_len, GFP_KERNEL);
> +	memcpy(shadow_nw_info->ies, nw_info->ies, nw_info->ies_len);
> +	shadow_nw_info->time_scan = jiffies;
> +	shadow_nw_info->time_scan_cached = jiffies;
> +	shadow_nw_info->found = 1;
>  	if (ap_found != -1)
> -		kfree(last_scanned_shadow[ap_index].join_params);
> -	last_scanned_shadow[ap_index].join_params = join_params;
> +		kfree(shadow_nw_info->join_params);
> +	shadow_nw_info->join_params = join_params;
>  }
>  
>  static void cfg_scan_result(enum scan_event scan_event,
> 
