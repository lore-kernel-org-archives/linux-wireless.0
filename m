Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39033 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1AJPAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 10:00:53 -0500
Subject: Re: [PATCH v5 1/2] wl12xx: BA initiator support
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <1294062164-3459-2-git-send-email-shahar_levi@ti.com>
References: <1294062164-3459-1-git-send-email-shahar_levi@ti.com>
	 <1294062164-3459-2-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 17:00:55 +0200
Message-ID: <1294671655.1992.103.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-03 at 14:42 +0100, Shahar Levi wrote:
> Add 80211n BA initiator session support wl1271 driver.
> Include BA supported FW version auto detection mechanism.
> BA initiator session management included in FW independently.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Some comments...


> diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
> index cc4068d..54fd68d 100644
> --- a/drivers/net/wireless/wl12xx/acx.c
> +++ b/drivers/net/wireless/wl12xx/acx.c
> @@ -1309,6 +1309,56 @@ out:
>         return ret;
>  }
> 
> +/* Configure BA session initiator\receiver parameters setting in the FW. */

Please use forward slash here instead of backslash, ie. use
"initiator/receiver".


> diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
> index 9cbc3f4..df48468 100644
> --- a/drivers/net/wireless/wl12xx/acx.h
> +++ b/drivers/net/wireless/wl12xx/acx.h
> @@ -1051,6 +1051,40 @@ struct wl1271_acx_ht_information {
>         u8 padding[3];
>  } __packed;
> 
> +#define BA_WIN_SIZE 8

Should this be DEFAULT_BA_WIN_SIZE?


> diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
> index 4a9f929..cd42e12 100644
> --- a/drivers/net/wireless/wl12xx/boot.c
> +++ b/drivers/net/wireless/wl12xx/boot.c
> @@ -101,6 +101,39 @@ static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
>         wl1271_write32(wl, ACX_REG_ECPU_CONTROL, cpu_ctrl);
>  }
> 
> +static void wl1271_save_fw_ver(struct wl1271 *wl)

This function name is not very informative.  Why not call it
wl1271_parse_fw_ver() instead?


> +{
> +       char fw_ver_str[ETHTOOL_BUSINFO_LEN];

This is weird, but it seem to be what is used in cfg80211 (as Shahar
pointed out on IRC).  IMHO it should be ETHTOOL_FWVERS_LEN instead, both
here and in cfg80211.

In any case, this is a bit confusing here, because we don't use the
fw_version in the wiphy struct (we probably should).  Let's keep it like
this for now and maybe later we can change.

Also, I don't see why you need a local copy here.

> +       char *fw_ver_point;
> +       int ret, i;
> +
> +       /* copy the fw version to temp str */
> +       strncpy(fw_ver_str, wl->chip.fw_ver_str, sizeof(fw_ver_str));
> +
> +       for (i = (WL12XX_NUM_FW_VER - 1); i > 0; --i) {
> +               /* find the last '.' */
> +               fw_ver_point = strrchr(fw_ver_str, '.');
> +
> +               /* read version number */
> +               ret = strict_strtoul(fw_ver_point+1, 10, &(wl->chip.fw_ver[i]));
> +               if (ret < 0) {
> +                       wl1271_warning("fw version incorrect value");
> +                       memset(wl->chip.fw_ver, 0, sizeof(wl->chip.fw_ver));
> +                       return;
> +               }
> +
> +               /* clean '.' */
> +               *fw_ver_point = '\0';
> +       }
> +
> +       ret = strict_strtoul(fw_ver_point-1, 10, &(wl->chip.fw_ver[0]));
> +       if (ret < 0) {
> +               wl1271_warning("fw version incorrect value");
> +               memset(wl->chip.fw_ver, 0, sizeof(wl->chip.fw_ver));
> +               return;
> +       }
> +}

Instead of all this manual parsing, why don't you use sscanf? I think
the following could do the work very nicely:

	ret = sscanf(wl->chip.fw_ver_str + WL12XX_FW_VER_OFFSET,
		     "%lu.%lu.%lu.%lu.%lu", &wl->chip.fw_ver[0],
		     &wl->chip.fw_ver[1], &wl->chip.fw_ver[2]
		     &wl->chip.fw_ver[3], &wl->chip.fw_ver[4]);

Wouldn't something like this be much simpler? (or you could use %u if
you agree on using unsigned int, see below)


>  static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
> diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
> index a16b361..41df771 100644
> --- a/drivers/net/wireless/wl12xx/conf.h
> +++ b/drivers/net/wireless/wl12xx/conf.h
> @@ -1090,6 +1090,12 @@ struct conf_rf_settings {
>         u8 tx_per_channel_power_compensation_5[CONF_TX_PWR_COMPENSATION_LEN_5];
>  };
> 
> +#define CONF_BA_INACTIVITY_TIMEOUT 10000

If this is a CONFigurable value, it should be in conf.h and in the
configuration parameters in main.c, shouldn't it?


> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 062247e..c44462d 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -233,7 +233,7 @@ static struct conf_drv_settings default_conf = {
>                 .avg_weight_rssi_beacon       = 20,
>                 .avg_weight_rssi_data         = 10,
>                 .avg_weight_snr_beacon        = 20,
> -               .avg_weight_snr_data          = 10
> +               .avg_weight_snr_data          = 10,
>         },
>         .scan = {
>                 .min_dwell_time_active        = 7500,
> @@ -252,6 +252,9 @@ static struct conf_drv_settings default_conf = {
>                         0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>                 },
>         },
> +       .ht = {
> +               .inactivity_timeout = CONF_BA_INACTIVITY_TIMEOUT,
> +       },

Ah, I see.  You are using that macro here, but I guess you could use the
value directly, since this is all configuration stuff, so no need to use
defines, unless the values mean something specific.  Here it is just a
measure of time, so a number can be used directly (like in the
min_dwell_time_active).


> diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
> index 01711fe..7b34393 100644
> --- a/drivers/net/wireless/wl12xx/wl12xx.h
> +++ b/drivers/net/wireless/wl12xx/wl12xx.h
> @@ -38,6 +38,11 @@
>  #define DRIVER_NAME "wl1271"
>  #define DRIVER_PREFIX DRIVER_NAME ": "
> 
> +#define WL12XX_BA_SUPPORT_FW_SUB_VER           339
> +#define WL12XX_BA_SUPPORT_FW_COST_VER1          33
> +#define WL12XX_BA_SUPPORT_FW_COST_VER2_START    50
> +#define WL12XX_BA_SUPPORT_FW_COST_VER2_END      60

This defines are very confusing.  Can you explain a bit? What about
"COST" version 0 (like 6.0.0.0.343), will that branch never support BA?
Where do the 50 to 60 come from? And what is 33? This kind of magic
should be explained.


> @@ -161,10 +166,13 @@ struct wl1271_partition_set {
> 
>  struct wl1271;
> 
> +#define WL12XX_NUM_FW_VER 5
> +

WL12XX_FW_VER_OFFSET sounds better to me.  And it shouldn't it be 4,
which is the "Rev " prefix?


>  /* FIXME: I'm not sure about this structure name */
>  struct wl1271_chip {
>         u32 id;
> -       char fw_ver[21];
> +       char fw_ver_str[ETHTOOL_BUSINFO_LEN];
> +       unsigned long fw_ver[WL12XX_NUM_FW_VER];

Why not unsigned int? (and then use %u.%u... as I mentioned earlier).


-- 
Cheers,
Luca.

