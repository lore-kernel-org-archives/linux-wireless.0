Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:34679 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753Ab0JML7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 07:59:36 -0400
From: "Premi, Sanjeev" <premi@ti.com>
To: "csanjay@mistralsolutions.com" <csanjay@mistralsolutions.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 13 Oct 2010 17:29:30 +0530
Subject: RE: [WL1271 DC supprot on OMAP3EVM 4/5] ARM: Added ALSA audio
 support for WL1271 DC over the PCM interface (OMAP37XX)
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930234405C39@dbde02.ent.ti.com>
References: <1286967077-20071-1-git-send-email-csanjay@mistralsolutions.com>
 <1286967077-20071-5-git-send-email-csanjay@mistralsolutions.com>
In-Reply-To: <1286967077-20071-5-git-send-email-csanjay@mistralsolutions.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org 
> [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of 
> csanjay@mistralsolutions.com
> Sent: Wednesday, October 13, 2010 4:21 PM
> To: linux-omap@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org; Sanjay Kumar Champati
> Subject: [WL1271 DC supprot on OMAP3EVM 4/5] ARM: Added ALSA 
> audio support for WL1271 DC over the PCM interface (OMAP37XX)
[sp] There is no OMAP37xx. It is AM37xx.

> 
> From: Sanjay Kumar Champati <csanjay@mistralsolutions.com>
> 
> * Add "wl1271bt.c" & "wl1271bt.h" in the PS kernel to support 
> PCM interface for OMAP37XX
> * Modified "Makefile" file to compile "wl1271bt.c" & 
> "wl1271bt.h" files
> * Modified "omap3evm.c" file to support Audio codec for WL1271 DC
> 
> Signed-off-by: Sanjay Kumar Champati <csanjay@mistralsolutions.com>
> ---
>  sound/soc/omap/Kconfig    |    6 +++
>  sound/soc/omap/Makefile   |    2 +
>  sound/soc/omap/omap3evm.c |   81 
> +++++++++++++++++++++++++++++++++++++++++++-
>  sound/soc/omap/wl1271bt.c |   59 ++++++++++++++++++++++++++++++++
>  sound/soc/omap/wl1271bt.h |   16 +++++++++
>  5 files changed, 162 insertions(+), 2 deletions(-)
>  create mode 100644 sound/soc/omap/wl1271bt.c
>  create mode 100644 sound/soc/omap/wl1271bt.h
> 
> diff --git a/sound/soc/omap/Kconfig b/sound/soc/omap/Kconfig
> index 61952aa..68054c2 100644
> --- a/sound/soc/omap/Kconfig
> +++ b/sound/soc/omap/Kconfig
> @@ -116,3 +116,9 @@ config SND_OMAP_SOC_IGEP0020
>  	select SND_SOC_TWL4030
>  	help
>  	  Say Y if you want to add support for Soc audio on 
> IGEP v2 board.
> +
> +config SND_OMAP_SOC_WL1271BT
> +	tristate "WL1271 Bluetooth Codec support"
> +	default n
> +	help
> +	Say Y if you want to add support for WL1271 on OMAP3EVM board.
> diff --git a/sound/soc/omap/Makefile b/sound/soc/omap/Makefile
> index 19283e5..684b8f2 100644
> --- a/sound/soc/omap/Makefile
> +++ b/sound/soc/omap/Makefile
> @@ -18,6 +18,7 @@ snd-soc-omap3pandora-objs := omap3pandora.o
>  snd-soc-omap3beagle-objs := omap3beagle.o
>  snd-soc-zoom2-objs := zoom2.o
>  snd-soc-igep0020-objs := igep0020.o
> +snd-soc-wl1271bt-objs := wl1271bt.o
>  
>  obj-$(CONFIG_SND_OMAP_SOC_N810) += snd-soc-n810.o
>  obj-$(CONFIG_SND_OMAP_SOC_AMS_DELTA) += snd-soc-ams-delta.o
> @@ -31,3 +32,4 @@ obj-$(CONFIG_SND_OMAP_SOC_OMAP3_PANDORA) += 
> snd-soc-omap3pandora.o
>  obj-$(CONFIG_SND_OMAP_SOC_OMAP3_BEAGLE) += snd-soc-omap3beagle.o
>  obj-$(CONFIG_SND_OMAP_SOC_ZOOM2) += snd-soc-zoom2.o
>  obj-$(CONFIG_SND_OMAP_SOC_IGEP0020) += snd-soc-igep0020.o
> +obj-$(CONFIG_SND_OMAP_SOC_WL1271BT) += snd-soc-wl1271bt.o
> diff --git a/sound/soc/omap/omap3evm.c b/sound/soc/omap/omap3evm.c
> index dfcb344..6731ad3 100644
> --- a/sound/soc/omap/omap3evm.c
> +++ b/sound/soc/omap/omap3evm.c
> @@ -32,6 +32,10 @@
>  #include "omap-mcbsp.h"
>  #include "omap-pcm.h"
>  #include "../codecs/twl4030.h"
> +#if defined(CONFIG_SND_OMAP_SOC_WL1271BT)
> +#include <plat/control.h>
> +#include "wl1271bt.h"
> +#endif
>  
>  static int omap3evm_hw_params(struct snd_pcm_substream *substream,
>  	struct snd_pcm_hw_params *params)
> @@ -72,11 +76,58 @@ static int omap3evm_hw_params(struct 
> snd_pcm_substream *substream,
>  	return 0;
>  }
>  
> +#if defined(CONFIG_SND_OMAP_SOC_WL1271BT)
> +static int omap3evm_wl1271bt_pcm_hw_params(struct 
> snd_pcm_substream *substream,
> +					struct 
> snd_pcm_hw_params *params)
> +{
> +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> +	struct snd_soc_dai *cpu_dai = rtd->dai->cpu_dai;
> +	int ret;
> +
> +	/* Set cpu DAI configuration for WL1271 Bluetooth codec */
> +	ret = snd_soc_dai_set_fmt(cpu_dai,
> +				SND_SOC_DAIFMT_DSP_B |
> +				SND_SOC_DAIFMT_NB_NF |
> +				SND_SOC_DAIFMT_CBM_CFM);
> +	if (ret < 0) {
> +		printk(KERN_ERR "Can't set cpu DAI configuration for " \
> +						"WL1271 
> Bluetooth codec \n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct snd_soc_ops omap3evm_wl1271bt_pcm_ops = {
> +       .hw_params = omap3evm_wl1271bt_pcm_hw_params,
> +};
> +#endif
> +
>  static struct snd_soc_ops omap3evm_ops = {
> +
>  	.hw_params = omap3evm_hw_params,
>  };
>  
>  /* Digital audio interface glue - connects codec <--> CPU */
> +#if defined(CONFIG_SND_OMAP_SOC_WL1271BT)
> +static struct snd_soc_dai_link omap3evm_dai[] = {
> +	{
> +		.name = "TWL4030",
> +		.stream_name = "TWL4030",
> +		.cpu_dai = &omap_mcbsp_dai[0],
> +		.codec_dai = &twl4030_dai[TWL4030_DAI_HIFI],
> +		.ops = &omap3evm_ops,
> +	},
> +	/* Connects WL1271 Bluetooth codec <--> CPU */
> +	{
> +		.name = "WL1271BTPCM",
> +		.stream_name = "WL1271 BT PCM",
> +		.cpu_dai = &omap_mcbsp_dai[1],
> +		.codec_dai = &wl1271bt_dai,
> +		.ops = &omap3evm_wl1271bt_pcm_ops,
> +	},
> +};
> +#else
>  static struct snd_soc_dai_link omap3evm_dai = {
>  	.name 		= "TWL4030",
>  	.stream_name 	= "TWL4030",
> @@ -84,13 +135,18 @@ static struct snd_soc_dai_link omap3evm_dai = {
>  	.codec_dai 	= &twl4030_dai[TWL4030_DAI_HIFI],
>  	.ops 		= &omap3evm_ops,
>  };
> -
> +#endif
>  /* Audio machine driver */
>  static struct snd_soc_card snd_soc_omap3evm = {
>  	.name = "omap3evm",
>  	.platform = &omap_soc_platform,
> +#if defined(CONFIG_SND_OMAP_SOC_WL1271BT)
> +	.dai_link = &omap3evm_dai[0],
> +	.num_links = ARRAY_SIZE(omap3evm_dai),
> +#else
>  	.dai_link = &omap3evm_dai,
>  	.num_links = 1,
> +#endif
>  };
>  
>  /* twl4030 setup */
> @@ -111,7 +167,10 @@ static struct platform_device 
> *omap3evm_snd_device;
>  static int __init omap3evm_soc_init(void)
>  {
>  	int ret;
> -
> +#if defined(CONFIG_SND_OMAP_SOC_WL1271BT)
> +	u16 reg;
> +	u32 val;
> +#endif
>  	if (!machine_is_omap3evm()) {
>  		pr_err("Not OMAP3 EVM!\n");
>  		return -ENODEV;
> @@ -124,9 +183,27 @@ static int __init omap3evm_soc_init(void)
>  		return -ENOMEM;
>  	}
>  
> +#if defined(CONFIG_SND_OMAP_SOC_WL1271BT)
> +/*
> + * Set DEVCONF0 register to connect
> + * MCBSP1_CLKR -> MCBSP1_CLKX & MCBSP1_FSR -> MCBSP1_FSX
> + */
> +	reg = OMAP2_CONTROL_DEVCONF0;
> +	val = omap_ctrl_readl(reg);
> +	val = val | 0x18;
> +	omap_ctrl_writel(val, reg);
> +#endif

[sp] I am not conversant with McBSP configuration, but isn't there
     a better way than directly manipulating on DEVCONF0?

     How is it done for other devices using McBSP? e.g. default
     audio on omap3evm.

> +
>  	platform_set_drvdata(omap3evm_snd_device, 
> &omap3evm_snd_devdata);
>  	omap3evm_snd_devdata.dev = &omap3evm_snd_device->dev;
> +#if defined(CONFIG_SND_OMAP_SOC_WL1271BT)
> +	/* McBSP2 */
> +	*(unsigned int *)omap3evm_dai[0].cpu_dai->private_data = 1;
> +	/* McBSP1 */
> +	*(unsigned int *)omap3evm_dai[1].cpu_dai->private_data = 0;
> +#else
>  	*(unsigned int *)omap3evm_dai.cpu_dai->private_data = 1;
> +#endif
>  
>  	ret = platform_device_add(omap3evm_snd_device);
>  	if (ret)
> diff --git a/sound/soc/omap/wl1271bt.c b/sound/soc/omap/wl1271bt.c
> new file mode 100644
> index 0000000..b41895b
> --- /dev/null
> +++ b/sound/soc/omap/wl1271bt.c
> @@ -0,0 +1,59 @@
> +/*
> + * wl1271bt.c  --  ALSA SoC WL1271 Bluetooth codec driver 
> for omap3evm board
> + *
> + * Author: Sinoj M. Issac, <sinoj at mistralsolutions.com>
> + *
> + * Based on sound/soc/codecs/twl4030.c by Steve Sakoman
> + *
> + * This file provides stub codec that can be used on OMAP3530 evm to
> + * send/receive voice samples to/from WL1271 Bluetooth chip 
> over PCM interface.
> + * The Bluetoothchip codec interface is configured by HCI 
> commands. ALSA is
> + * configured and aligned to the codec interface.
> + *
> + * This program is free software; you can redistribute it 
> and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <sound/soc.h>
> +#include <sound/pcm.h>
> +
> +/*
> + * Since WL1271 PCM interface is intended for Voice,
> + * Support sampling rate 8K only
> + */
> +#define WL1271BT_RATES		SNDRV_PCM_RATE_8000
> +#define WL1271BT_FORMATS	SNDRV_PCM_FMTBIT_S16_LE
> +
> +struct snd_soc_dai wl1271bt_dai = {
> +	.name = "wl1271bt",
> +	.playback = {
> +		.stream_name = "Playback",
> +		.channels_min = 1,
> +		.channels_max = 2,
> +		.rates = WL1271BT_RATES,
> +		.formats = WL1271BT_FORMATS,},
> +	.capture = {
> +		.stream_name = "Capture",
> +		.channels_min = 1,
> +		.channels_max = 2,
> +		.rates = WL1271BT_RATES,
> +		.formats = WL1271BT_FORMATS,},
> +};
> +
> +static int __init wl1271bt_modinit(void)
> +{
> +	/* Register number of DAIs (wl1271bt_dai) with the ASoC core */
> +	return snd_soc_register_dais(&wl1271bt_dai, 1);
> +}
> +
> +static void __exit wl1271bt_modexit(void)
> +{
> +	/* Unregister number of DAIs (wl1271bt_dai) from the 
> ASoC core */
> +	snd_soc_unregister_dais(&wl1271bt_dai, 1);
> +}
> +
> +module_init(wl1271bt_modinit);
> +module_exit(wl1271bt_modexit);
> diff --git a/sound/soc/omap/wl1271bt.h b/sound/soc/omap/wl1271bt.h
> new file mode 100644
> index 0000000..769f9a9
> --- /dev/null
> +++ b/sound/soc/omap/wl1271bt.h
> @@ -0,0 +1,16 @@
> +/*
> + * wl1271bt.h  --  ALSA SoC WL1271 Bluetooth codec driver header
> + *
> + * Author: Sinoj M. Issac, <sinoj at mistralsolutions.com>
> + *
> + * This program is free software; you can redistribute it 
> and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef WL1271BT_H
> +#define WL1271BT_H
> +
> +extern struct snd_soc_dai wl1271bt_dai;
> +
> +#endif /* WL1271BT_H */
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 