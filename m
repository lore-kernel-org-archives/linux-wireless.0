Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:5959 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934110AbeEINmY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 09:42:24 -0400
Subject: Re: [PATCH 30/30] staging: wilc1000: rename s8idxarray to avoid
 datatype in variable name
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-31-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <9f4adf70-9c0a-18f7-750d-1dfa8c19f91e@microchip.com> (sfid-20180509_154228_301023_82F532A3)
Date: Wed, 9 May 2018 16:42:20 +0300
MIME-Version: 1.0
In-Reply-To: <1525682614-3824-31-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07.05.2018 11:43, Ajay Singh wrote:
> Cleanup patch to have variable names as per linux coding style.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index ad9270e..e27010c 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -1543,7 +1543,7 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
>  	struct wid wid;
>  	struct wid wid_list[5];
>  	u8 *key_buf;
> -	s8 s8idxarray[1];
> +	s8 idxarray[1];
>  	struct host_if_drv *hif_drv = vif->hif_drv;
>  
>  	switch (hif_key->type) {
> @@ -1610,8 +1610,8 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
>  			wid.id = (u16)WID_REMOVE_WEP_KEY;
>  			wid.type = WID_STR;
>  
> -			s8idxarray[0] = (s8)hif_key->attr.wep.index;
> -			wid.val = s8idxarray;
> +			idxarray[0] = (s8)hif_key->attr.wep.index;

I think you can get rid of idxarray at all.

> +			wid.val = idxarray;>  			wid.size = 1;
>  
>  			result = wilc_send_config_pkt(vif, SET_CFG,
> 
