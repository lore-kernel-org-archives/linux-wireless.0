Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:10504 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932341AbdKPKww (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Nov 2017 05:52:52 -0500
Subject: Re: [PATCH] staging: wilc1000: Fix bssid buffer offset in Txq
To: Aditya Shankar <aditya.shankar@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <ganesh.krishna@microchip.com>,
        <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
References: <1509699387-6916-1-git-send-email-aditya.shankar@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <6f9884a1-22d6-b076-f34c-0bcbe5c8af20@microchip.com> (sfid-20171116_115257_450293_B74DC724)
Date: Thu, 16 Nov 2017 12:52:36 +0200
MIME-Version: 1.0
In-Reply-To: <1509699387-6916-1-git-send-email-aditya.shankar@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Aditya,

My problem is fixed with this patch. WILC1000 connects to AP,
IP is retrieved from DHCP server and ping works. You can add my

Tested-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Thanks,
Claudiu

On 03.11.2017 10:56, Aditya Shankar wrote:
> Commit 46949b48568b ("staging: wilc1000: New cfg packet
> format in handle_set_wfi_drv_handler") updated the frame
> format sent from host to the firmware. The code to update
> the bssid offset in the new frame was part of a second
> patch in the series which did not make it in and thus
> causes connection problems after associating to an AP.
> 
> This fix adds the proper offset of the bssid value in the
> Tx queue buffer to fix the connection issues.
> 
> Fixes: Commit 46949b48568b ("staging: wilc1000: New cfg packet format in handle_set_wfi_drv_handler")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aditya Shankar <Aditya.Shankar@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index 9addef1..f49dfa8 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -714,7 +714,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
>  					char *bssid = ((struct tx_complete_data *)(tqe->priv))->bssid;
>  
>  					buffer_offset = ETH_ETHERNET_HDR_OFFSET;
> -					memcpy(&txb[offset + 4], bssid, 6);
> +					memcpy(&txb[offset + 8], bssid, 6);
>  				} else {
>  					buffer_offset = HOST_HDR_OFFSET;
>  				}
> 
