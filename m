Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:23327 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbeAVLNH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 06:13:07 -0500
Subject: Re: [PATCH v2 04/14] staging: wilc1000: rename
 host_int_ParseJoinBssParam() and it's variable using camelCase
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
 <1516616547-24654-5-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <5309767d-89a5-0a91-078e-52eda8a4f087@microchip.com> (sfid-20180122_121311_011567_4D571477)
Date: Mon, 22 Jan 2018 13:13:04 +0200
MIME-Version: 1.0
In-Reply-To: <1516616547-24654-5-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 22.01.2018 12:22, Ajay Singh wrote:
> Fix "Avoid CamelCase:" issue reported by checkpatch.pl script
Forgot a dot here?
> Rename host_int_ParseJoinBssParam() & its variables name using
> camelCase.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 230 +++++++++++++++---------------
>  1 file changed, 115 insertions(+), 115 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 358354b..8f8e727 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -265,7 +265,7 @@ static struct wilc_vif *join_req_vif;
>  #define FLUSHED_JOIN_REQ 1
>  #define FLUSHED_BYTE_POS 79
>  
> -static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo);
> +static void *host_int_parse_join_bss_param(struct network_info *info);
>  static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
>  static s32 Handle_ScanDone(struct wilc_vif *vif, enum scan_event enuEvent);
>  static void host_if_work(struct work_struct *work);
> @@ -1288,7 +1288,7 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
>  				hif_drv->usr_scan_req.rcvd_ch_cnt++;
>  
>  				pstrNetworkInfo->new_network = true;
> -				pJoinParams = host_int_ParseJoinBssParam(pstrNetworkInfo);
> +				pJoinParams = host_int_parse_join_bss_param(pstrNetworkInfo);
>  
>  				hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
>  								  hif_drv->usr_scan_req.arg,
> @@ -3870,152 +3870,152 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
>  	return result;
>  }
>  
> -static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo)
> +static void *host_int_parse_join_bss_param(struct network_info *info)
>  {
> -	struct join_bss_param *pNewJoinBssParam = NULL;
> -	u8 *pu8IEs;
> -	u16 u16IEsLen;
> +	struct join_bss_param *param = NULL;
> +	u8 *ies;
> +	u16 ies_len;
>  	u16 index = 0;
> -	u8 suppRatesNo = 0;
> -	u8 extSuppRatesNo;
> -	u16 jumpOffset;
> -	u8 pcipherCount;
> -	u8 authCount;
> -	u8 pcipherTotalCount = 0;
> -	u8 authTotalCount = 0;
> +	u8 rates_no = 0;
> +	u8 ext_rates_no;
> +	u16 offset;
> +	u8 pcipher_cnt;
> +	u8 auth_cnt;
> +	u8 pcipher_total_cnt = 0;
> +	u8 auth_total_cnt = 0;
>  	u8 i, j;
>  
> -	pu8IEs = ptstrNetworkInfo->ies;
> -	u16IEsLen = ptstrNetworkInfo->ies_len;
> -
> -	pNewJoinBssParam = kzalloc(sizeof(*pNewJoinBssParam), GFP_KERNEL);
> -	if (pNewJoinBssParam) {
> -		pNewJoinBssParam->dtim_period = ptstrNetworkInfo->dtim_period;
> -		pNewJoinBssParam->beacon_period = ptstrNetworkInfo->beacon_period;
> -		pNewJoinBssParam->cap_info = ptstrNetworkInfo->cap_info;
> -		memcpy(pNewJoinBssParam->bssid, ptstrNetworkInfo->bssid, 6);
> -		memcpy((u8 *)pNewJoinBssParam->ssid, ptstrNetworkInfo->ssid,
> -		       ptstrNetworkInfo->ssid_len + 1);
> -		pNewJoinBssParam->ssid_len = ptstrNetworkInfo->ssid_len;
> -		memset(pNewJoinBssParam->rsn_pcip_policy, 0xFF, 3);
> -		memset(pNewJoinBssParam->rsn_auth_policy, 0xFF, 3);
> -
> -		while (index < u16IEsLen) {
> -			if (pu8IEs[index] == SUPP_RATES_IE) {
> -				suppRatesNo = pu8IEs[index + 1];
> -				pNewJoinBssParam->supp_rates[0] = suppRatesNo;
> +	ies = info->ies;
> +	ies_len = info->ies_len;
> +
> +	param = kzalloc(sizeof(*param), GFP_KERNEL);
> +	if (param) {
> +		param->dtim_period = info->dtim_period;
> +		param->beacon_period = info->beacon_period;
> +		param->cap_info = info->cap_info;
> +		memcpy(param->bssid, info->bssid, 6);
> +		memcpy((u8 *)param->ssid, info->ssid,
> +		       info->ssid_len + 1);
> +		param->ssid_len = info->ssid_len;
> +		memset(param->rsn_pcip_policy, 0xFF, 3);
> +		memset(param->rsn_auth_policy, 0xFF, 3);
> +
> +		while (index < ies_len) {
> +			if (ies[index] == SUPP_RATES_IE) {
> +				rates_no = ies[index + 1];
> +				param->supp_rates[0] = rates_no;
>  				index += 2;
>  
> -				for (i = 0; i < suppRatesNo; i++)
> -					pNewJoinBssParam->supp_rates[i + 1] = pu8IEs[index + i];
> +				for (i = 0; i < rates_no; i++)
> +					param->supp_rates[i + 1] = ies[index + i];
>  
> -				index += suppRatesNo;
> -			} else if (pu8IEs[index] == EXT_SUPP_RATES_IE) {
> -				extSuppRatesNo = pu8IEs[index + 1];
> -				if (extSuppRatesNo > (MAX_RATES_SUPPORTED - suppRatesNo))
> -					pNewJoinBssParam->supp_rates[0] = MAX_RATES_SUPPORTED;
> +				index += rates_no;
> +			} else if (ies[index] == EXT_SUPP_RATES_IE) {
> +				ext_rates_no = ies[index + 1];
> +				if (ext_rates_no > (MAX_RATES_SUPPORTED - rates_no))
> +					param->supp_rates[0] = MAX_RATES_SUPPORTED;
>  				else
> -					pNewJoinBssParam->supp_rates[0] += extSuppRatesNo;
> +					param->supp_rates[0] += ext_rates_no;
>  				index += 2;
> -				for (i = 0; i < (pNewJoinBssParam->supp_rates[0] - suppRatesNo); i++)
> -					pNewJoinBssParam->supp_rates[suppRatesNo + i + 1] = pu8IEs[index + i];
> -
> -				index += extSuppRatesNo;
> -			} else if (pu8IEs[index] == HT_CAPABILITY_IE) {
> -				pNewJoinBssParam->ht_capable = true;
> -				index += pu8IEs[index + 1] + 2;
> -			} else if ((pu8IEs[index] == WMM_IE) &&
> -				   (pu8IEs[index + 2] == 0x00) && (pu8IEs[index + 3] == 0x50) &&
> -				   (pu8IEs[index + 4] == 0xF2) &&
> -				   (pu8IEs[index + 5] == 0x02) &&
> -				   ((pu8IEs[index + 6] == 0x00) || (pu8IEs[index + 6] == 0x01)) &&
> -				   (pu8IEs[index + 7] == 0x01)) {
> -				pNewJoinBssParam->wmm_cap = true;
> -
> -				if (pu8IEs[index + 8] & BIT(7))
> -					pNewJoinBssParam->uapsd_cap = true;
> -				index += pu8IEs[index + 1] + 2;
> -			} else if ((pu8IEs[index] == P2P_IE) &&
> -				 (pu8IEs[index + 2] == 0x50) && (pu8IEs[index + 3] == 0x6f) &&
> -				 (pu8IEs[index + 4] == 0x9a) &&
> -				 (pu8IEs[index + 5] == 0x09) && (pu8IEs[index + 6] == 0x0c)) {
> -				u16 u16P2P_count;
> -
> -				pNewJoinBssParam->tsf = ptstrNetworkInfo->tsf_lo;
> -				pNewJoinBssParam->noa_enabled = 1;
> -				pNewJoinBssParam->idx = pu8IEs[index + 9];
> -
> -				if (pu8IEs[index + 10] & BIT(7)) {
> -					pNewJoinBssParam->opp_enabled = 1;
> -					pNewJoinBssParam->ct_window = pu8IEs[index + 10];
> +				for (i = 0; i < (param->supp_rates[0] - rates_no); i++)
> +					param->supp_rates[rates_no + i + 1] = ies[index + i];
> +
> +				index += ext_rates_no;
> +			} else if (ies[index] == HT_CAPABILITY_IE) {
> +				param->ht_capable = true;
> +				index += ies[index + 1] + 2;
> +			} else if ((ies[index] == WMM_IE) &&
> +				   (ies[index + 2] == 0x00) && (ies[index + 3] == 0x50) &&
> +				   (ies[index + 4] == 0xF2) &&
> +				   (ies[index + 5] == 0x02) &&
> +				   ((ies[index + 6] == 0x00) || (ies[index + 6] == 0x01)) &&
> +				   (ies[index + 7] == 0x01)) {
> +				param->wmm_cap = true;
> +
> +				if (ies[index + 8] & BIT(7))
> +					param->uapsd_cap = true;
> +				index += ies[index + 1] + 2;
> +			} else if ((ies[index] == P2P_IE) &&
> +				 (ies[index + 2] == 0x50) && (ies[index + 3] == 0x6f) &&
> +				 (ies[index + 4] == 0x9a) &&
> +				 (ies[index + 5] == 0x09) && (ies[index + 6] == 0x0c)) {
> +				u16 p2p_cnt;
> +
> +				param->tsf = info->tsf_lo;
> +				param->noa_enabled = 1;
> +				param->idx = ies[index + 9];
> +
> +				if (ies[index + 10] & BIT(7)) {
> +					param->opp_enabled = 1;
> +					param->ct_window = ies[index + 10];
>  				} else {
> -					pNewJoinBssParam->opp_enabled = 0;
> +					param->opp_enabled = 0;
>  				}
>  
> -				pNewJoinBssParam->cnt = pu8IEs[index + 11];
> -				u16P2P_count = index + 12;
> +				param->cnt = ies[index + 11];
> +				p2p_cnt = index + 12;
>  
> -				memcpy(pNewJoinBssParam->duration, pu8IEs + u16P2P_count, 4);
> -				u16P2P_count += 4;
> +				memcpy(param->duration, ies + p2p_cnt, 4);
> +				p2p_cnt += 4;
>  
> -				memcpy(pNewJoinBssParam->interval, pu8IEs + u16P2P_count, 4);
> -				u16P2P_count += 4;
> +				memcpy(param->interval, ies + p2p_cnt, 4);
> +				p2p_cnt += 4;
>  
> -				memcpy(pNewJoinBssParam->start_time, pu8IEs + u16P2P_count, 4);
> +				memcpy(param->start_time, ies + p2p_cnt, 4);
>  
> -				index += pu8IEs[index + 1] + 2;
> -			} else if ((pu8IEs[index] == RSN_IE) ||
> -				 ((pu8IEs[index] == WPA_IE) && (pu8IEs[index + 2] == 0x00) &&
> -				  (pu8IEs[index + 3] == 0x50) && (pu8IEs[index + 4] == 0xF2) &&
> -				  (pu8IEs[index + 5] == 0x01)))	{
> -				u16 rsnIndex = index;
> +				index += ies[index + 1] + 2;
> +			} else if ((ies[index] == RSN_IE) ||
> +				 ((ies[index] == WPA_IE) && (ies[index + 2] == 0x00) &&
> +				  (ies[index + 3] == 0x50) && (ies[index + 4] == 0xF2) &&
> +				  (ies[index + 5] == 0x01)))	{
> +				u16 rsn_idx = index;
>  
> -				if (pu8IEs[rsnIndex] == RSN_IE)	{
> -					pNewJoinBssParam->mode_802_11i = 2;
> +				if (ies[rsn_idx] == RSN_IE)	{
> +					param->mode_802_11i = 2;
>  				} else {
> -					if (pNewJoinBssParam->mode_802_11i == 0)
> -						pNewJoinBssParam->mode_802_11i = 1;
> -					rsnIndex += 4;
> +					if (param->mode_802_11i == 0)
> +						param->mode_802_11i = 1;
> +					rsn_idx += 4;
>  				}
>  
> -				rsnIndex += 7;
> -				pNewJoinBssParam->rsn_grp_policy = pu8IEs[rsnIndex];
> -				rsnIndex++;
> -				jumpOffset = pu8IEs[rsnIndex] * 4;
> -				pcipherCount = (pu8IEs[rsnIndex] > 3) ? 3 : pu8IEs[rsnIndex];
> -				rsnIndex += 2;
> +				rsn_idx += 7;
> +				param->rsn_grp_policy = ies[rsn_idx];
> +				rsn_idx++;
> +				offset = ies[rsn_idx] * 4;
> +				pcipher_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
> +				rsn_idx += 2;
>  
> -				for (i = pcipherTotalCount, j = 0; i < pcipherCount + pcipherTotalCount && i < 3; i++, j++)
> -					pNewJoinBssParam->rsn_pcip_policy[i] = pu8IEs[rsnIndex + ((j + 1) * 4) - 1];
> +				for (i = pcipher_total_cnt, j = 0; i < pcipher_cnt + pcipher_total_cnt && i < 3; i++, j++)
> +					param->rsn_pcip_policy[i] = ies[rsn_idx + ((j + 1) * 4) - 1];
>  
> -				pcipherTotalCount += pcipherCount;
> -				rsnIndex += jumpOffset;
> +				pcipher_total_cnt += pcipher_cnt;
> +				rsn_idx += offset;
>  
> -				jumpOffset = pu8IEs[rsnIndex] * 4;
> +				offset = ies[rsn_idx] * 4;
>  
> -				authCount = (pu8IEs[rsnIndex] > 3) ? 3 : pu8IEs[rsnIndex];
> -				rsnIndex += 2;
> +				auth_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
> +				rsn_idx += 2;
>  
> -				for (i = authTotalCount, j = 0; i < authTotalCount + authCount; i++, j++)
> -					pNewJoinBssParam->rsn_auth_policy[i] = pu8IEs[rsnIndex + ((j + 1) * 4) - 1];
> +				for (i = auth_total_cnt, j = 0; i < auth_total_cnt + auth_cnt; i++, j++)
> +					param->rsn_auth_policy[i] = ies[rsn_idx + ((j + 1) * 4) - 1];
>  
> -				authTotalCount += authCount;
> -				rsnIndex += jumpOffset;
> +				auth_total_cnt += auth_cnt;
> +				rsn_idx += offset;
>  
> -				if (pu8IEs[index] == RSN_IE) {
> -					pNewJoinBssParam->rsn_cap[0] = pu8IEs[rsnIndex];
> -					pNewJoinBssParam->rsn_cap[1] = pu8IEs[rsnIndex + 1];
> -					rsnIndex += 2;
> +				if (ies[index] == RSN_IE) {
> +					param->rsn_cap[0] = ies[rsn_idx];
> +					param->rsn_cap[1] = ies[rsn_idx + 1];
> +					rsn_idx += 2;
>  				}
> -				pNewJoinBssParam->rsn_found = true;
> -				index += pu8IEs[index + 1] + 2;
> +				param->rsn_found = true;
> +				index += ies[index + 1] + 2;
>  			} else {
> -				index += pu8IEs[index + 1] + 2;
> +				index += ies[index + 1] + 2;
>  			}
>  		}
>  	}
>  
> -	return (void *)pNewJoinBssParam;
> +	return (void *)param;
>  }
>  
>  int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
> 
