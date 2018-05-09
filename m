Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:50856 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934630AbeEINnl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 09:43:41 -0400
Subject: Re: [PATCH 08/30] staging: wilc1000: fix line over 80 chars in
 host_int_parse_assoc_resp_info()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-9-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <aa0033fb-fbf6-80aa-0b58-7e36c5803170@microchip.com> (sfid-20180509_154345_074386_11793D8E)
Date: Wed, 9 May 2018 16:43:37 +0300
MIME-Version: 1.0
In-Reply-To: <1525682614-3824-9-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07.05.2018 11:43, Ajay Singh wrote:
> Fix line over 80 characters issue in host_int_parse_assoc_resp_info() by
> using shorter name for the local variable.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index c9c5d352..b1f67a7 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -1320,18 +1320,19 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
>  	memset(&conn_info, 0, sizeof(struct connect_info));
>  
>  	if (mac_status == MAC_STATUS_CONNECTED) {
> -		u32 rcvd_assoc_resp_info_len;
> +		u32 assoc_resp_info_len;

I would simply use len or size. It is just my preference.

>  
>  		memset(rcv_assoc_resp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
>  
>  		host_int_get_assoc_res_info(vif, rcv_assoc_resp,
>  					    MAX_ASSOC_RESP_FRAME_SIZE,
> -					    &rcvd_assoc_resp_info_len);
> +					    &assoc_resp_info_len);
>  
> -		if (rcvd_assoc_resp_info_len != 0) {
> +		if (assoc_resp_info_len != 0) {
>  			s32 err = 0;
>  
> -			err = wilc_parse_assoc_resp_info(rcv_assoc_resp, rcvd_assoc_resp_info_len,
> +			err = wilc_parse_assoc_resp_info(rcv_assoc_resp,
> +							 assoc_resp_info_len,
>  							 &connect_resp_info);
>  			if (err)
>  				netdev_err(vif->ndev,
> 
