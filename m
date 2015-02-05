Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38564 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbbBELeg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2015 06:34:36 -0500
Message-ID: <54D35545.7010600@linux.intel.com> (sfid-20150205_123456_373844_8EDDFF33)
Date: Thu, 05 Feb 2015 19:34:29 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
MIME-Version: 1.0
To: brudley@broadcom.com, Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>, meuleman@broadcom.com,
	Kalle Valo <kvalo@codeaurora.org>, linville@tuxdriver.com,
	pieterpg@broadcom.com, hdegoede@redhat.com, wens@csie.org,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
References: <54C5AA8C.4010005@linux.intel.com>
In-Reply-To: <54C5AA8C.4010005@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What comments about the new patch?  Can this new patch be accepted?


Thanks,
Zhonghui

On 2015/1/26 10:46, Fu, Zhonghui wrote:
> From ff39ed4af9f1c50358fe92ec4c8eaac9db183e00 Mon Sep 17 00:00:00 2001
> From: Zhonghui Fu <zhonghui.fu@linux.intel.com>
> Date: Mon, 26 Jan 2015 10:13:21 +0800
> Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
>
> WiFi chip has 2 SDIO functions, and PM core will trigger
> twice suspend/resume operations for one WiFi chip to do
> the same things. This patch avoid this case.
>
> Acked-by: Arend van Spriel<arend@broadcom.com>
> Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>
> ---
>  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   17 +++++++++++++++--
>  1 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> index 9880dae..618b545 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> @@ -1139,11 +1139,17 @@ void brcmf_sdio_wowl_config(struct device *dev, bool enabled)
>  static int brcmf_ops_sdio_suspend(struct device *dev)
>  {
>  	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
> -	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
> +	struct brcmf_sdio_dev *sdiodev;
>  	mmc_pm_flag_t sdio_flags;
> +	struct sdio_func *func = dev_to_sdio_func(dev);
>  
>  	brcmf_dbg(SDIO, "Enter\n");
>  
> +	if (func->num == 2)
> +		return 0;
> +
> +	sdiodev = bus_if->bus_priv.sdio;
> +
>  	atomic_set(&sdiodev->suspend, true);
>  
>  	if (sdiodev->wowl_enabled) {
> @@ -1164,9 +1170,16 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
>  static int brcmf_ops_sdio_resume(struct device *dev)
>  {
>  	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
> -	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
> +	struct brcmf_sdio_dev *sdiodev;
> +	struct sdio_func *func = dev_to_sdio_func(dev);
>  
>  	brcmf_dbg(SDIO, "Enter\n");
> +
> +	if (func->num == 2)
> +		return 0;
> +
> +	sdiodev = bus_if->bus_priv.sdio;
> +
>  	if (sdiodev->pdata && sdiodev->pdata->oob_irq_supported)
>  		disable_irq_wake(sdiodev->pdata->oob_irq_nr);
>  	brcmf_sdio_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
> -- 1.7.1
>

