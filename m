Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:45846 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbeAVLHx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 06:07:53 -0500
Subject: Re: [PATCH v2 12/14] staging: wilc1000: rename Handle_ScanDone() to
 avoid camelCase
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
 <1516616547-24654-13-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <422e8a89-21f8-e52b-d061-4a6f44e7108e@microchip.com> (sfid-20180122_120757_005615_76CC21C6)
Date: Mon, 22 Jan 2018 13:07:50 +0200
MIME-Version: 1.0
In-Reply-To: <1516616547-24654-13-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 22.01.2018 12:22, Ajay Singh wrote:
> Fix "Avoid camelCase" issue reported by checkpatch.pl
> script.
Same here as in patch 02 of this series.

> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 0eaf6c6..b34243c 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -267,7 +267,7 @@ static struct wilc_vif *join_req_vif;
>  
>  static void *host_int_parse_join_bss_param(struct network_info *info);
>  static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
> -static s32 Handle_ScanDone(struct wilc_vif *vif, enum scan_event enuEvent);
> +static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event enuEvent);
>  static void host_if_work(struct work_struct *work);
>  
>  /*!
> @@ -847,7 +847,7 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
>  ERRORHANDLER:
>  	if (result) {
>  		del_timer(&hif_drv->scan_timer);
> -		Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
> +		handle_scan_done(vif, SCAN_EVENT_ABORTED);
>  	}
>  
>  	kfree(scan_info->ch_freq_list);
> @@ -863,8 +863,8 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
>  	return result;
>  }
>  
> -static s32 Handle_ScanDone(struct wilc_vif *vif,
> -			   enum scan_event enuEvent)
> +static s32 handle_scan_done(struct wilc_vif *vif,
> +			    enum scan_event enuEvent)
>  {
>  	s32 result = 0;
>  	u8 u8abort_running_scan;
> @@ -1460,7 +1460,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
>  
>  			if (hif_drv->usr_scan_req.scan_result) {
>  				del_timer(&hif_drv->scan_timer);
> -				Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
> +				handle_scan_done(vif, SCAN_EVENT_ABORTED);
>  			}
>  
>  			strDisconnectNotifInfo.reason = 0;
> @@ -1508,7 +1508,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
>  			   (hif_drv->usr_scan_req.scan_result)) {
>  			del_timer(&hif_drv->scan_timer);
>  			if (hif_drv->usr_scan_req.scan_result)
> -				Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
> +				handle_scan_done(vif, SCAN_EVENT_ABORTED);
>  		}
>  	}
>  
> @@ -2525,7 +2525,7 @@ static void host_if_work(struct work_struct *work)
>  		if (!wilc_wlan_get_num_conn_ifcs(wilc))
>  			wilc_chip_sleep_manually(wilc);
>  
> -		Handle_ScanDone(msg->vif, SCAN_EVENT_DONE);
> +		handle_scan_done(msg->vif, SCAN_EVENT_DONE);
>  
>  		if (msg->vif->hif_drv->remain_on_ch_pending)
>  			Handle_RemainOnChan(msg->vif,
> @@ -2567,7 +2567,7 @@ static void host_if_work(struct work_struct *work)
>  		break;
>  
>  	case HOST_IF_MSG_SCAN_TIMER_FIRED:
> -		Handle_ScanDone(msg->vif, SCAN_EVENT_ABORTED);
> +		handle_scan_done(msg->vif, SCAN_EVENT_ABORTED);
>  		break;
>  
>  	case HOST_IF_MSG_CONNECT_TIMER_FIRED:
> 
