Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:13666 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755192AbeASLUP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 06:20:15 -0500
Subject: Re: [PATCH 05/14] staging: wilc1000: rename camelCase used in
 Handle_DelAllSta() and its variable
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1516281432-7724-1-git-send-email-ajay.kathat@microchip.com>
 <1516281432-7724-6-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <6740516d-1960-7669-0412-6a1f2cea686a@microchip.com> (sfid-20180119_122019_107661_93C9F088)
Date: Fri, 19 Jan 2018 13:20:11 +0200
MIME-Version: 1.0
In-Reply-To: <1516281432-7724-6-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 18.01.2018 15:17, Ajay Singh wrote:
> fix "Avoid camelCase" issue reported by checkpatch.pl script.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 9f6365a..1ac079a 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -2123,34 +2123,34 @@ static void Handle_AddStation(struct wilc_vif *vif,
>  	kfree(wid.val);
>  }
>  
> -static void Handle_DelAllSta(struct wilc_vif *vif,
> -			     struct del_all_sta *pstrDelAllStaParam)
> +static void handle_del_all_sta(struct wilc_vif *vif,
> +			       struct del_all_sta *param)
>  {
>  	s32 result = 0;
>  	struct wid wid;
> -	u8 *pu8CurrByte;
> +	u8 *curr_byte;
>  	u8 i;
> -	u8 au8Zero_Buff[6] = {0};
> +	u8 zero_buff[6] = {0};
>  
>  	wid.id = (u16)WID_DEL_ALL_STA;
>  	wid.type = WID_STR;
> -	wid.size = (pstrDelAllStaParam->assoc_sta * ETH_ALEN) + 1;
> +	wid.size = (param->assoc_sta * ETH_ALEN) + 1;
>  
> -	wid.val = kmalloc((pstrDelAllStaParam->assoc_sta * ETH_ALEN) + 1, GFP_KERNEL);
> +	wid.val = kmalloc((param->assoc_sta * ETH_ALEN) + 1, GFP_KERNEL);
>  	if (!wid.val)
>  		goto ERRORHANDLER;
>  
> -	pu8CurrByte = wid.val;
> +	curr_byte = wid.val;
>  
> -	*(pu8CurrByte++) = pstrDelAllStaParam->assoc_sta;
> +	*(curr_byte++) = param->assoc_sta;
>  
>  	for (i = 0; i < MAX_NUM_STA; i++) {
> -		if (memcmp(pstrDelAllStaParam->del_all_sta[i], au8Zero_Buff, ETH_ALEN))
> -			memcpy(pu8CurrByte, pstrDelAllStaParam->del_all_sta[i], ETH_ALEN);> +		if (memcmp(param->del_all_sta[i], zero_buff, ETH_ALEN))
For future, you could use is_zero_ether_addr() if you ensure
pstrDelAllStaParam->del_all_sta[i] is alligned to u16.

> +			memcpy(curr_byte, param->del_all_sta[i], ETH_ALEN);
>  		else
>  			continue;
>  
> -		pu8CurrByte += ETH_ALEN;
> +		curr_byte += ETH_ALEN;
>  	}
>  
>  	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
> @@ -2626,7 +2626,7 @@ static void host_if_work(struct work_struct *work)
>  		break;
>  
>  	case HOST_IF_MSG_DEL_ALL_STA:
> -		Handle_DelAllSta(msg->vif, &msg->body.del_all_sta_info);
> +		handle_del_all_sta(msg->vif, &msg->body.del_all_sta_info);
>  		break;
>  
>  	case HOST_IF_MSG_SET_TX_POWER:
> 
