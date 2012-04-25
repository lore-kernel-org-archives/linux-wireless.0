Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55016 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2DYGkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:40:33 -0400
Message-ID: <1335335998.16897.406.camel@aeonflux> (sfid-20120425_084037_991356_F4E64B75)
Subject: Re: [PATCH RESEND 2/2] Bluetooth: btmrvl: add support for SDIO
 suspend/resume callbacks
From: Marcel Holtmann <marcel@holtmann.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 25 Apr 2012 08:39:58 +0200
In-Reply-To: <1335310301-11600-2-git-send-email-bzhao@marvell.com>
References: <1335310301-11600-1-git-send-email-bzhao@marvell.com>
	 <1335310301-11600-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

> Host sleep is activated using already configured host sleep
> parameters in suspend handler and it is cancelled in resume
> handler.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
> Last 2 patches were sent to Gustavo's old e-mail address.
> Resending...
> 
>  drivers/bluetooth/btmrvl_drv.h  |    2 +
>  drivers/bluetooth/btmrvl_main.c |    3 +-
>  drivers/bluetooth/btmrvl_sdio.c |  100 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 104 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/bluetooth/btmrvl_drv.h b/drivers/bluetooth/btmrvl_drv.h
> index 2c79e76..94f2d65 100644
> --- a/drivers/bluetooth/btmrvl_drv.h
> +++ b/drivers/bluetooth/btmrvl_drv.h
> @@ -67,6 +67,7 @@ struct btmrvl_adapter {
>  	u8 wakeup_tries;
>  	wait_queue_head_t cmd_wait_q;
>  	u8 cmd_complete;
> +	bool is_suspended;
>  };
>  
>  struct btmrvl_private {
> @@ -142,6 +143,7 @@ int btmrvl_send_module_cfg_cmd(struct btmrvl_private *priv, int subcmd);
>  int btmrvl_send_hscfg_cmd(struct btmrvl_private *priv);
>  int btmrvl_enable_ps(struct btmrvl_private *priv);
>  int btmrvl_prepare_command(struct btmrvl_private *priv);
> +int btmrvl_enable_hs(struct btmrvl_private *priv);
>  
>  #ifdef CONFIG_DEBUG_FS
>  void btmrvl_debugfs_init(struct hci_dev *hdev);
> diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
> index a880537..681ca9d 100644
> --- a/drivers/bluetooth/btmrvl_main.c
> +++ b/drivers/bluetooth/btmrvl_main.c
> @@ -262,7 +262,7 @@ int btmrvl_enable_ps(struct btmrvl_private *priv)
>  }
>  EXPORT_SYMBOL_GPL(btmrvl_enable_ps);
>  
> -static int btmrvl_enable_hs(struct btmrvl_private *priv)
> +int btmrvl_enable_hs(struct btmrvl_private *priv)
>  {
>  	struct sk_buff *skb;
>  	struct btmrvl_cmd *cmd;
> @@ -298,6 +298,7 @@ static int btmrvl_enable_hs(struct btmrvl_private *priv)
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(btmrvl_enable_hs);
>  
>  int btmrvl_prepare_command(struct btmrvl_private *priv)
>  {
> diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
> index f93a7a2..35a3e7c 100644
> --- a/drivers/bluetooth/btmrvl_sdio.c
> +++ b/drivers/bluetooth/btmrvl_sdio.c
> @@ -1051,11 +1051,111 @@ static void btmrvl_sdio_remove(struct sdio_func *func)
>  	}
>  }
>  
> +static int btmrvl_sdio_suspend(struct device *dev)
> +{
> +	struct sdio_func *func = dev_to_sdio_func(dev);
> +	struct btmrvl_sdio_card *card;
> +	struct btmrvl_private *priv;
> +	mmc_pm_flag_t pm_flags;
> +	struct hci_dev *hcidev;
> +
> +	if (func) {
> +		pm_flags = sdio_get_host_pm_caps(func);
> +		BT_DBG("%s: suspend: PM flags = 0x%x\n", sdio_func_id(func),
> +		       pm_flags);
> +		if (!(pm_flags & MMC_PM_KEEP_POWER)) {
> +			BT_ERR("%s: cannot remain alive while host is "
> +			       "suspended\n", sdio_func_id(func));
> +			return -ENOSYS;
> +		}
> +		card = sdio_get_drvdata(func);
> +		if (!card || !card->priv) {
> +			BT_ERR("Card or priv structure is not valid\n");

you do not need the \n at the end of BT_DBG, BT_ERR etc. Please fix
this.

Regards

Marcel


