Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:36761 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696Ab1D2E0R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 00:26:17 -0400
Received: by mail-ey0-f172.google.com with SMTP id 13so1183336eye.3
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 21:26:15 -0700 (PDT)
Subject: Re: [PATCH 10/10] wl12xx: export driver state to debugfs
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1303125329-27214-10-git-send-email-arik@wizery.com>
References: <1303125329-27214-1-git-send-email-arik@wizery.com>
	 <1303125329-27214-10-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 16:21:55 +0300
Message-ID: <1303996915.12586.116.camel@cumari> (sfid-20110429_062620_443287_D0A691D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-18 at 14:15 +0300, Arik Nemtsov wrote:
> By reading the "driver_state" debugfs value we get all the important
> state information from the wl12xx driver. This helps testing and
> debugging, particularly in situations where the driver seems "stuck".
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/debugfs.c |   87 +++++++++++++++++++++++++++++++++
>  1 files changed, 87 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
> index 6eb48b7..6970455 100644
> --- a/drivers/net/wireless/wl12xx/debugfs.c
> +++ b/drivers/net/wireless/wl12xx/debugfs.c
> @@ -310,6 +310,92 @@ static const struct file_operations start_recovery_ops = {
>  	.llseek = default_llseek,
>  };
>  
> +static ssize_t driver_state_read(struct file *file, char __user *user_buf,
> +				 size_t count, loff_t *ppos)
> +{
> +	struct wl1271 *wl = file->private_data;
> +	int res = 0;
> +	char buf[1024];
> +
> +	mutex_lock(&wl->mutex);
> +
> +#define DRIVER_STATE_PRINT(x, fmt)   \
> +	(res += scnprintf(buf + res, sizeof(buf) - res,\
> +			  #x " = " fmt "\n", wl->x))
> +
> +#define DRIVER_STATE_PRINT_LONG(x) DRIVER_STATE_PRINT(x, "%ld")
> +#define DRIVER_STATE_PRINT_INT(x)  DRIVER_STATE_PRINT(x, "%d")
> +#define DRIVER_STATE_PRINT_STR(x)  DRIVER_STATE_PRINT(x, "%s")
> +#define DRIVER_STATE_PRINT_LHEX(x) DRIVER_STATE_PRINT(x, "0x%lx")
> +#define DRIVER_STATE_PRINT_HEX(x)  DRIVER_STATE_PRINT(x, "0x%x")
> +
> +	DRIVER_STATE_PRINT_INT(tx_blocks_available);
> +	DRIVER_STATE_PRINT_INT(tx_allocated_blocks);
> +	DRIVER_STATE_PRINT_INT(tx_frames_cnt);
> +	DRIVER_STATE_PRINT_LHEX(tx_frames_map[0]);
> +	DRIVER_STATE_PRINT_INT(tx_queue_count);
> +	DRIVER_STATE_PRINT_INT(tx_packets_count);
> +	DRIVER_STATE_PRINT_INT(tx_results_count);
> +	DRIVER_STATE_PRINT_LHEX(flags);
> +	DRIVER_STATE_PRINT_INT(tx_blocks_freed[0]);
> +	DRIVER_STATE_PRINT_INT(tx_blocks_freed[1]);
> +	DRIVER_STATE_PRINT_INT(tx_blocks_freed[2]);
> +	DRIVER_STATE_PRINT_INT(tx_blocks_freed[3]);
> +	DRIVER_STATE_PRINT_INT(tx_security_last_seq);
> +	DRIVER_STATE_PRINT_INT(rx_counter);
> +	DRIVER_STATE_PRINT_INT(session_counter);
> +	DRIVER_STATE_PRINT_INT(state);
> +	DRIVER_STATE_PRINT_INT(bss_type);
> +	DRIVER_STATE_PRINT_INT(channel);
> +	DRIVER_STATE_PRINT_HEX(rate_set);
> +	DRIVER_STATE_PRINT_HEX(basic_rate_set);
> +	DRIVER_STATE_PRINT_HEX(basic_rate);
> +	DRIVER_STATE_PRINT_INT(band);
> +	DRIVER_STATE_PRINT_INT(beacon_int);
> +	DRIVER_STATE_PRINT_INT(psm_entry_retry);
> +	DRIVER_STATE_PRINT_INT(ps_poll_failures);
> +	DRIVER_STATE_PRINT_HEX(filters);
> +	DRIVER_STATE_PRINT_HEX(rx_config);
> +	DRIVER_STATE_PRINT_HEX(rx_filter);
> +	DRIVER_STATE_PRINT_INT(power_level);
> +	DRIVER_STATE_PRINT_INT(rssi_thold);
> +	DRIVER_STATE_PRINT_INT(last_rssi_event);
> +	DRIVER_STATE_PRINT_INT(sg_enabled);
> +	DRIVER_STATE_PRINT_INT(enable_11a);
> +	DRIVER_STATE_PRINT_INT(noise);
> +	DRIVER_STATE_PRINT_LHEX(ap_hlid_map[0]);
> +	DRIVER_STATE_PRINT_INT(last_tx_hlid);
> +	DRIVER_STATE_PRINT_INT(ba_support);
> +	DRIVER_STATE_PRINT_HEX(ba_rx_bitmap);
> +	DRIVER_STATE_PRINT_HEX(ap_fw_ps_map);
> +	DRIVER_STATE_PRINT_LHEX(ap_ps_map);
> +	DRIVER_STATE_PRINT_HEX(quirks);
> +	DRIVER_STATE_PRINT_HEX(irq);
> +	DRIVER_STATE_PRINT_HEX(ref_clock);
> +	DRIVER_STATE_PRINT_HEX(tcxo_clock);
> +	DRIVER_STATE_PRINT_HEX(hw_pg_ver);
> +	DRIVER_STATE_PRINT_HEX(platform_quirks);
> +	DRIVER_STATE_PRINT_HEX(chip.id);
> +	DRIVER_STATE_PRINT_STR(chip.fw_ver_str);

I'd prefer to have each of these values in separate files, like the FW
stats.  If you print this all out in one file, it's hard to know which
value means what.  With separate files it's easy to know and you can
achieve the same thing as having in one file by doing something like
this:

cat driver_state/*

-- 
Cheers,
Luca.

