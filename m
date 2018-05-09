Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:1820 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934630AbeEINoE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 09:44:04 -0400
Subject: Re: [PATCH 07/30] staging: wilc1000: fix line over 80 characters in
 host_int_parse_join_bss_param()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-8-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <41b47474-9dad-05c8-aa1b-0da661de3caf@microchip.com> (sfid-20180509_154407_136705_010D8172)
Date: Wed, 9 May 2018 16:43:59 +0300
MIME-Version: 1.0
In-Reply-To: <1525682614-3824-8-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07.05.2018 11:43, Ajay Singh wrote:
> Split host_int_parse_join_bss_param() to avoid the line over 80
> character issue reported by checkpatch.pl script.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 247 ++++++++++++++++--------------
>  1 file changed, 131 insertions(+), 116 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 0d84af9..c9c5d352 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -3856,150 +3856,165 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
>  	return result;
>  }
>  
> -static void *host_int_parse_join_bss_param(struct network_info *info)
> +static void host_int_fill_join_bss_param(struct join_bss_param *param, u8 *ies,
> +					 u16 *out_index, u8 *pcipher_tc,
> +					 u8 *auth_total_cnt, u32 tsf_lo)
>  {
> -	struct join_bss_param *param = NULL;
> -	u8 *ies;
> -	u16 ies_len;
> -	u16 index = 0;
>  	u8 rates_no = 0;
>  	u8 ext_rates_no;
>  	u16 offset;
>  	u8 pcipher_cnt;
>  	u8 auth_cnt;
> -	u8 pcipher_total_cnt = 0;
> -	u8 auth_total_cnt = 0;
>  	u8 i, j;
> +	u16 index = *out_index;

Why not having a single index, the one passed as argument?

>  
> -	ies = info->ies;
> -	ies_len = info->ies_len;
> +	if (ies[index] == SUPP_RATES_IE) {
> +		rates_no = ies[index + 1];
> +		param->supp_rates[0] = rates_no;
> +		index += 2;
>  
> -	param = kzalloc(sizeof(*param), GFP_KERNEL);
> -	if (!param)
> -		return NULL;
> +		for (i = 0; i < rates_no; i++)
> +			param->supp_rates[i + 1] = ies[index + i];
>  
> -	param->dtim_period = info->dtim_period;
> -	param->beacon_period = info->beacon_period;
> -	param->cap_info = info->cap_info;
> -	memcpy(param->bssid, info->bssid, 6);
> -	memcpy((u8 *)param->ssid, info->ssid, info->ssid_len + 1);
> -	param->ssid_len = info->ssid_len;
> -	memset(param->rsn_pcip_policy, 0xFF, 3);
> -	memset(param->rsn_auth_policy, 0xFF, 3);
> +		index += rates_no;
> +	} else if (ies[index] == EXT_SUPP_RATES_IE) {
> +		ext_rates_no = ies[index + 1];
> +		if (ext_rates_no > (MAX_RATES_SUPPORTED - rates_no))
> +			param->supp_rates[0] = MAX_RATES_SUPPORTED;
> +		else
> +			param->supp_rates[0] += ext_rates_no;
> +		index += 2;
> +		for (i = 0; i < (param->supp_rates[0] - rates_no); i++)
> +			param->supp_rates[rates_no + i + 1] = ies[index + i];
> +
> +		index += ext_rates_no;
> +	} else if (ies[index] == HT_CAPABILITY_IE) {
> +		param->ht_capable = true;
> +		index += ies[index + 1] + 2;
> +	} else if ((ies[index] == WMM_IE) &&
> +		   (ies[index + 2] == 0x00) && (ies[index + 3] == 0x50) &&
> +		   (ies[index + 4] == 0xF2) && (ies[index + 5] == 0x02) &&
> +		   ((ies[index + 6] == 0x00) || (ies[index + 6] == 0x01)) &&
> +		   (ies[index + 7] == 0x01)) {
> +		param->wmm_cap = true;
> +
> +		if (ies[index + 8] & BIT(7))
> +			param->uapsd_cap = true;
> +		index += ies[index + 1] + 2;
> +	} else if ((ies[index] == P2P_IE) &&
> +		 (ies[index + 2] == 0x50) && (ies[index + 3] == 0x6f) &&
> +		 (ies[index + 4] == 0x9a) &&
> +		 (ies[index + 5] == 0x09) && (ies[index + 6] == 0x0c)) {
> +		u16 p2p_cnt;
> +
> +		param->tsf = tsf_lo;
> +		param->noa_enabled = 1;
> +		param->idx = ies[index + 9];
> +
> +		if (ies[index + 10] & BIT(7)) {
> +			param->opp_enabled = 1;
> +			param->ct_window = ies[index + 10];
> +		} else {
> +			param->opp_enabled = 0;
> +		}
>  
> -	while (index < ies_len) {
> -		if (ies[index] == SUPP_RATES_IE) {
> -			rates_no = ies[index + 1];
> -			param->supp_rates[0] = rates_no;
> -			index += 2;
> +		param->cnt = ies[index + 11];
> +		p2p_cnt = index + 12;
>  
> -			for (i = 0; i < rates_no; i++)
> -				param->supp_rates[i + 1] = ies[index + i];
> +		memcpy(param->duration, ies + p2p_cnt, 4);
> +		p2p_cnt += 4;
>  
> -			index += rates_no;
> -		} else if (ies[index] == EXT_SUPP_RATES_IE) {
> -			ext_rates_no = ies[index + 1];
> -			if (ext_rates_no > (MAX_RATES_SUPPORTED - rates_no))
> -				param->supp_rates[0] = MAX_RATES_SUPPORTED;
> -			else
> -				param->supp_rates[0] += ext_rates_no;
> -			index += 2;
> -			for (i = 0; i < (param->supp_rates[0] - rates_no); i++)
> -				param->supp_rates[rates_no + i + 1] = ies[index + i];
> -
> -			index += ext_rates_no;
> -		} else if (ies[index] == HT_CAPABILITY_IE) {
> -			param->ht_capable = true;
> -			index += ies[index + 1] + 2;
> -		} else if ((ies[index] == WMM_IE) &&
> -			   (ies[index + 2] == 0x00) && (ies[index + 3] == 0x50) &&
> -			   (ies[index + 4] == 0xF2) &&
> -			   (ies[index + 5] == 0x02) &&
> -			   ((ies[index + 6] == 0x00) || (ies[index + 6] == 0x01)) &&
> -			   (ies[index + 7] == 0x01)) {
> -			param->wmm_cap = true;
> -
> -			if (ies[index + 8] & BIT(7))
> -				param->uapsd_cap = true;
> -			index += ies[index + 1] + 2;
> -		} else if ((ies[index] == P2P_IE) &&
> -			 (ies[index + 2] == 0x50) && (ies[index + 3] == 0x6f) &&
> -			 (ies[index + 4] == 0x9a) &&
> -			 (ies[index + 5] == 0x09) && (ies[index + 6] == 0x0c)) {
> -			u16 p2p_cnt;
> -
> -			param->tsf = info->tsf_lo;
> -			param->noa_enabled = 1;
> -			param->idx = ies[index + 9];
> -
> -			if (ies[index + 10] & BIT(7)) {
> -				param->opp_enabled = 1;
> -				param->ct_window = ies[index + 10];
> -			} else {
> -				param->opp_enabled = 0;
> -			}
> +		memcpy(param->interval, ies + p2p_cnt, 4);
> +		p2p_cnt += 4;
>  
> -			param->cnt = ies[index + 11];
> -			p2p_cnt = index + 12;
> +		memcpy(param->start_time, ies + p2p_cnt, 4);
>  
> -			memcpy(param->duration, ies + p2p_cnt, 4);
> -			p2p_cnt += 4;
> +		index += ies[index + 1] + 2;
> +	} else if ((ies[index] == RSN_IE) ||
> +		 ((ies[index] == WPA_IE) && (ies[index + 2] == 0x00) &&
> +		  (ies[index + 3] == 0x50) && (ies[index + 4] == 0xF2) &&
> +		  (ies[index + 5] == 0x01))) {
> +		u16 rsn_idx = index;
>  
> -			memcpy(param->interval, ies + p2p_cnt, 4);
> -			p2p_cnt += 4;
> +		if (ies[rsn_idx] == RSN_IE) {
> +			param->mode_802_11i = 2;
> +		} else {
> +			if (param->mode_802_11i == 0)
> +				param->mode_802_11i = 1;
> +			rsn_idx += 4;
> +		}
>  
> -			memcpy(param->start_time, ies + p2p_cnt, 4);
> +		rsn_idx += 7;
> +		param->rsn_grp_policy = ies[rsn_idx];
> +		rsn_idx++;
> +		offset = ies[rsn_idx] * 4;
> +		pcipher_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
> +		rsn_idx += 2;
>  
> -			index += ies[index + 1] + 2;
> -		} else if ((ies[index] == RSN_IE) ||
> -			 ((ies[index] == WPA_IE) && (ies[index + 2] == 0x00) &&
> -			  (ies[index + 3] == 0x50) && (ies[index + 4] == 0xF2) &&
> -			  (ies[index + 5] == 0x01)))	{
> -			u16 rsn_idx = index;
> +		i = *pcipher_tc;
> +		j = 0;
> +		for (; i < (pcipher_cnt + *pcipher_tc) && i < 3; i++, j++) {
> +			u8 *policy =  &param->rsn_pcip_policy[i];
>  
> -			if (ies[rsn_idx] == RSN_IE)	{
> -				param->mode_802_11i = 2;
> -			} else {
> -				if (param->mode_802_11i == 0)
> -					param->mode_802_11i = 1;
> -				rsn_idx += 4;
> -			}
> +			*policy = ies[rsn_idx + ((j + 1) * 4) - 1];
> +		}
>  
> -			rsn_idx += 7;
> -			param->rsn_grp_policy = ies[rsn_idx];
> -			rsn_idx++;
> -			offset = ies[rsn_idx] * 4;
> -			pcipher_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
> -			rsn_idx += 2;
> +		*pcipher_tc += pcipher_cnt;
> +		rsn_idx += offset;
>  
> -			for (i = pcipher_total_cnt, j = 0; i < pcipher_cnt + pcipher_total_cnt && i < 3; i++, j++)
> -				param->rsn_pcip_policy[i] = ies[rsn_idx + ((j + 1) * 4) - 1];
> +		offset = ies[rsn_idx] * 4;
>  
> -			pcipher_total_cnt += pcipher_cnt;
> -			rsn_idx += offset;
> +		auth_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
> +		rsn_idx += 2;
> +		i = *auth_total_cnt;
> +		j = 0;

I prefer keeping these inside for (). I think some of the "line over 80" should 
be fixed by refactoring code not introducing new variables and so on.

> +		for (; i < (*auth_total_cnt + auth_cnt); i++, j++) {
> +			u8 *policy =  &param->rsn_auth_policy[i];
>  
> -			offset = ies[rsn_idx] * 4;
> +			*policy = ies[rsn_idx + ((j + 1) * 4) - 1];
> +		}
> +
> +		auth_total_cnt += auth_cnt;
> +		rsn_idx += offset;
>  
> -			auth_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
> +		if (ies[index] == RSN_IE) {
> +			param->rsn_cap[0] = ies[rsn_idx];
> +			param->rsn_cap[1] = ies[rsn_idx + 1];
>  			rsn_idx += 2;
> +		}
> +		param->rsn_found = true;
> +		index += ies[index + 1] + 2;
> +	} else {
> +		index += ies[index + 1] + 2;
> +	}
>  
> -			for (i = auth_total_cnt, j = 0; i < auth_total_cnt + auth_cnt; i++, j++)
> -				param->rsn_auth_policy[i] = ies[rsn_idx + ((j + 1) * 4) - 1];
> +	*out_index = index;
> +}
>  
> -			auth_total_cnt += auth_cnt;
> -			rsn_idx += offset;
> +static void *host_int_parse_join_bss_param(struct network_info *info)
> +{
> +	struct join_bss_param *param = NULL;
> +	u16 index = 0;
> +	u8 pcipher_total_cnt = 0;
> +	u8 auth_total_cnt = 0;
>  
> -			if (ies[index] == RSN_IE) {
> -				param->rsn_cap[0] = ies[rsn_idx];
> -				param->rsn_cap[1] = ies[rsn_idx + 1];
> -				rsn_idx += 2;
> -			}
> -			param->rsn_found = true;
> -			index += ies[index + 1] + 2;
> -		} else {
> -			index += ies[index + 1] + 2;
> -		}
> -	}
> +	param = kzalloc(sizeof(*param), GFP_KERNEL);
> +	if (!param)
> +		return NULL;
> +
> +	param->dtim_period = info->dtim_period;
> +	param->beacon_period = info->beacon_period;
> +	param->cap_info = info->cap_info;
> +	memcpy(param->bssid, info->bssid, 6);
> +	memcpy((u8 *)param->ssid, info->ssid, info->ssid_len + 1);
> +	param->ssid_len = info->ssid_len;
> +	memset(param->rsn_pcip_policy, 0xFF, 3);
> +	memset(param->rsn_auth_policy, 0xFF, 3);
> +
> +	while (index < info->ies_len)
> +		host_int_fill_join_bss_param(param, info->ies, &index,
> +					     &pcipher_total_cnt,
> +					     &auth_total_cnt, info->tsf_lo);
>  
>  	return (void *)param;
>  }
> 
