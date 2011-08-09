Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:35831 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906Ab1HITMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 15:12:06 -0400
Received: by mail-fx0-f42.google.com with SMTP id 23so713784fxe.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 12:12:04 -0700 (PDT)
Subject: Re: [PATCH 06/40] wl12xx: wl12xx-fw-3 - Update fw status struct
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-7-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-7-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 22:12:01 +0300
Message-ID: <1312917121.2407.237.camel@cumari> (sfid-20110809_211213_801686_8550C8BD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index a1608f1..1ac1762 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -824,71 +824,57 @@ static void wl1271_irq_update_links_status(struct wl1271 *wl,
>  					    wl->links[hlid].allocated_blks);
>  	}
>  }
>  #endif
>  
>  static void wl1271_fw_status(struct wl1271 *wl,
> -			     struct wl1271_fw_full_status *full_status)
> +			     struct wl1271_fw_status *status)

Can you change this function to wl12xx_fw_status(), as we discussed
before, to slowly move into using wl12xx instead of wl1271?


> @@ -1167,13 +1153,13 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
>  	 */
>  	if (!wl1271_ps_elp_wakeup(wl))
>  		wl12xx_cmd_stop_fwlog(wl);
>  
>  	/* Read the first memory block address */
>  	wl1271_fw_status(wl, wl->fw_status);
> -	first_addr = __le32_to_cpu(wl->fw_status->sta.log_start_addr);
> +	first_addr = __le32_to_cpu(wl->fw_status->log_start_addr);

why do you have to use __le32_to_cpu() here instead of le32_to_cpu()?


> diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
> index 1a957d6..4ed23a1 100644
> --- a/drivers/net/wireless/wl12xx/rx.c
> +++ b/drivers/net/wireless/wl12xx/rx.c
> @@ -27,20 +27,20 @@
>  #include "wl12xx.h"
>  #include "acx.h"
>  #include "reg.h"
>  #include "rx.h"
>  #include "io.h"
>  
> -static u8 wl1271_rx_get_mem_block(struct wl1271_fw_common_status *status,
> +static u8 wl1271_rx_get_mem_block(struct wl1271_fw_status *status,
>  				  u32 drv_rx_counter)

Again, please s/wl1271/wl12xx/ in the function names.



> {
>  	return le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]) &
>  		RX_MEM_BLOCK_MASK;
>  }
>  
> -static u32 wl1271_rx_get_buf_size(struct wl1271_fw_common_status *status,
> +static u32 wl1271_rx_get_buf_size(struct wl1271_fw_status *status,
>  				 u32 drv_rx_counter)

Same as above.


> @@ -160,13 +160,13 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
>  	skb_queue_tail(&wl->deferred_rx_queue, skb);
>  	queue_work(wl->freezable_wq, &wl->netstack_work);
>  
>  	return is_data;
>  }
>  
> -void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
> +void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
>  {

Same thing.


> diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
> index 094fff8..5ca482b 100644
> --- a/drivers/net/wireless/wl12xx/rx.h
> +++ b/drivers/net/wireless/wl12xx/rx.h
> @@ -124,10 +124,10 @@ struct wl1271_rx_descriptor {
>  		u8  hlid; /* AP FW */
>  	} __packed;
>  	u8  pad_len;
>  	u8  reserved;
>  } __packed;
>  
> -void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status);
> +void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status);

Ditto.


> diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
> index 360f3d2..260b78c 100644
> --- a/drivers/net/wireless/wl12xx/wl12xx.h
> +++ b/drivers/net/wireless/wl12xx/wl12xx.h
> @@ -134,12 +134,13 @@ extern u32 wl12xx_debug_level;
>  #define WL1271_ELP_HW_STATE_ASLEEP 0
>  #define WL1271_ELP_HW_STATE_IRQ    1
>  
>  #define WL1271_DEFAULT_BEACON_INT  100
>  #define WL1271_DEFAULT_DTIM_PERIOD 1
>  
> +#define WL1271_MAX_LINKS           8

Can we use WL12XX_MAX_LINKS here too?


> @@ -227,59 +228,51 @@ struct wl1271_stats {
>  
>  #define AP_MAX_STATIONS            5
>  
>  /* Broadcast and Global links + links to stations */
>  #define AP_MAX_LINKS               (AP_MAX_STATIONS + 2)
>  
> -/* FW status registers common for AP/STA */
> -struct wl1271_fw_common_status {
> +/* FW status registers */
> +struct wl1271_fw_status {

Same thing here, can we change this to wl12xx_fw_status?


-- 
Cheers,
Luca.

