Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:46269 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755020AbeASLUW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 06:20:22 -0500
Subject: Re: [PATCH 10/14] staging: wilc1000: rename ptstrJoinBssParam
 variable to avoid camelCase
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1516281432-7724-1-git-send-email-ajay.kathat@microchip.com>
 <1516281432-7724-11-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <9a155299-ee4e-f2c7-1a32-26e70881c183@microchip.com> (sfid-20180119_122026_731017_EDEA3D88)
Date: Fri, 19 Jan 2018 13:20:18 +0200
MIME-Version: 1.0
In-Reply-To: <1516281432-7724-11-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 18.01.2018 15:17, Ajay Singh wrote:
> fix "Avoid camelCase" issue reported by checkpatch.pl script.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 78 +++++++++++++++----------------
>  1 file changed, 39 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 4ddd1a8..cc27b5a 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -909,7 +909,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
>  	struct wid wid_list[8];
>  	u32 wid_cnt = 0, dummyval = 0;
>  	u8 *cur_byte = NULL;
> -	struct join_bss_param *ptstrJoinBssParam;
> +	struct join_bss_param *j_bss_param;
I would choose either join_bss_param or bss_param for the name.

>  	struct host_if_drv *hif_drv = vif->hif_drv;
>  
>  	if (memcmp(attr->bssid, wilc_connected_ssid, ETH_ALEN) == 0) {
> @@ -918,8 +918,8 @@ static s32 Handle_Connect(struct wilc_vif *vif,
>  		return result;
>  	}
>  
> -	ptstrJoinBssParam = attr->params;
> -	if (!ptstrJoinBssParam) {
> +	j_bss_param = attr->params;
> +	if (!j_bss_param) {
>  		netdev_err(vif->ndev, "Required BSSID not found\n");
>  		result = -ENOENT;
>  		goto ERRORHANDLER;
> @@ -1027,8 +1027,8 @@ static s32 Handle_Connect(struct wilc_vif *vif,
>  		netdev_err(vif->ndev, "Channel out of range\n");
>  		*(cur_byte++) = 0xFF;
>  	}
> -	*(cur_byte++)  = (ptstrJoinBssParam->cap_info) & 0xFF;
> -	*(cur_byte++)  = ((ptstrJoinBssParam->cap_info) >> 8) & 0xFF;
> +	*(cur_byte++)  = (j_bss_param->cap_info) & 0xFF;
> +	*(cur_byte++)  = ((j_bss_param->cap_info) >> 8) & 0xFF;
>  
>  	if (attr->bssid)
>  		memcpy(cur_byte, attr->bssid, 6);
> @@ -1038,57 +1038,57 @@ static s32 Handle_Connect(struct wilc_vif *vif,
>  		memcpy(cur_byte, attr->bssid, 6);
>  	cur_byte += 6;
>  
> -	*(cur_byte++)  = (ptstrJoinBssParam->beacon_period) & 0xFF;
> -	*(cur_byte++)  = ((ptstrJoinBssParam->beacon_period) >> 8) & 0xFF;
> -	*(cur_byte++)  =  ptstrJoinBssParam->dtim_period;
> +	*(cur_byte++)  = (j_bss_param->beacon_period) & 0xFF;
> +	*(cur_byte++)  = ((j_bss_param->beacon_period) >> 8) & 0xFF;
> +	*(cur_byte++)  =  j_bss_param->dtim_period;
>  
> -	memcpy(cur_byte, ptstrJoinBssParam->supp_rates, MAX_RATES_SUPPORTED + 1);
> +	memcpy(cur_byte, j_bss_param->supp_rates, MAX_RATES_SUPPORTED + 1);
>  	cur_byte += (MAX_RATES_SUPPORTED + 1);
>  
> -	*(cur_byte++)  =  ptstrJoinBssParam->wmm_cap;
> -	*(cur_byte++)  = ptstrJoinBssParam->uapsd_cap;
> +	*(cur_byte++)  =  j_bss_param->wmm_cap;
> +	*(cur_byte++)  = j_bss_param->uapsd_cap;
>  
> -	*(cur_byte++)  = ptstrJoinBssParam->ht_capable;
> -	hif_drv->usr_conn_req.ht_capable = ptstrJoinBssParam->ht_capable;
> +	*(cur_byte++)  = j_bss_param->ht_capable;
> +	hif_drv->usr_conn_req.ht_capable = j_bss_param->ht_capable;
>  
> -	*(cur_byte++)  =  ptstrJoinBssParam->rsn_found;
> -	*(cur_byte++)  =  ptstrJoinBssParam->rsn_grp_policy;
> -	*(cur_byte++) =  ptstrJoinBssParam->mode_802_11i;
> +	*(cur_byte++)  =  j_bss_param->rsn_found;
> +	*(cur_byte++)  =  j_bss_param->rsn_grp_policy;
> +	*(cur_byte++) =  j_bss_param->mode_802_11i;
>  
> -	memcpy(cur_byte, ptstrJoinBssParam->rsn_pcip_policy, sizeof(ptstrJoinBssParam->rsn_pcip_policy));
> -	cur_byte += sizeof(ptstrJoinBssParam->rsn_pcip_policy);
> +	memcpy(cur_byte, j_bss_param->rsn_pcip_policy, sizeof(j_bss_param->rsn_pcip_policy));> +	cur_byte += sizeof(j_bss_param->rsn_pcip_policy);
>  
> -	memcpy(cur_byte, ptstrJoinBssParam->rsn_auth_policy, sizeof(ptstrJoinBssParam->rsn_auth_policy));
> -	cur_byte += sizeof(ptstrJoinBssParam->rsn_auth_policy);
> +	memcpy(cur_byte, j_bss_param->rsn_auth_policy, sizeof(j_bss_param->rsn_auth_policy));
> +	cur_byte += sizeof(j_bss_param->rsn_auth_policy);
>  
> -	memcpy(cur_byte, ptstrJoinBssParam->rsn_cap, sizeof(ptstrJoinBssParam->rsn_cap));
> -	cur_byte += sizeof(ptstrJoinBssParam->rsn_cap);
> +	memcpy(cur_byte, j_bss_param->rsn_cap, sizeof(j_bss_param->rsn_cap));
> +	cur_byte += sizeof(j_bss_param->rsn_cap);
>  
>  	*(cur_byte++) = REAL_JOIN_REQ;
> -	*(cur_byte++) = ptstrJoinBssParam->noa_enabled;
> +	*(cur_byte++) = j_bss_param->noa_enabled;
>  
> -	if (ptstrJoinBssParam->noa_enabled) {
> -		*(cur_byte++) = (ptstrJoinBssParam->tsf) & 0xFF;
> -		*(cur_byte++) = ((ptstrJoinBssParam->tsf) >> 8) & 0xFF;
> -		*(cur_byte++) = ((ptstrJoinBssParam->tsf) >> 16) & 0xFF;
> -		*(cur_byte++) = ((ptstrJoinBssParam->tsf) >> 24) & 0xFF;
> +	if (j_bss_param->noa_enabled) {
> +		*(cur_byte++) = (j_bss_param->tsf) & 0xFF;
> +		*(cur_byte++) = ((j_bss_param->tsf) >> 8) & 0xFF;
> +		*(cur_byte++) = ((j_bss_param->tsf) >> 16) & 0xFF;
> +		*(cur_byte++) = ((j_bss_param->tsf) >> 24) & 0xFF;
>  
> -		*(cur_byte++) = ptstrJoinBssParam->opp_enabled;
> -		*(cur_byte++) = ptstrJoinBssParam->idx;
> +		*(cur_byte++) = j_bss_param->opp_enabled;
> +		*(cur_byte++) = j_bss_param->idx;
>  
> -		if (ptstrJoinBssParam->opp_enabled)
> -			*(cur_byte++) = ptstrJoinBssParam->ct_window;
> +		if (j_bss_param->opp_enabled)
> +			*(cur_byte++) = j_bss_param->ct_window;
>  
> -		*(cur_byte++) = ptstrJoinBssParam->cnt;
> +		*(cur_byte++) = j_bss_param->cnt;
>  
> -		memcpy(cur_byte, ptstrJoinBssParam->duration, sizeof(ptstrJoinBssParam->duration));
> -		cur_byte += sizeof(ptstrJoinBssParam->duration);
> +		memcpy(cur_byte, j_bss_param->duration, sizeof(j_bss_param->duration));
> +		cur_byte += sizeof(j_bss_param->duration);
>  
> -		memcpy(cur_byte, ptstrJoinBssParam->interval, sizeof(ptstrJoinBssParam->interval));
> -		cur_byte += sizeof(ptstrJoinBssParam->interval);
> +		memcpy(cur_byte, j_bss_param->interval, sizeof(j_bss_param->interval));
> +		cur_byte += sizeof(j_bss_param->interval);
>  
> -		memcpy(cur_byte, ptstrJoinBssParam->start_time, sizeof(ptstrJoinBssParam->start_time));
> -		cur_byte += sizeof(ptstrJoinBssParam->start_time);
> +		memcpy(cur_byte, j_bss_param->start_time, sizeof(j_bss_param->start_time));
> +		cur_byte += sizeof(j_bss_param->start_time);
>  	}
>  
>  	cur_byte = wid_list[wid_cnt].val;
> 
