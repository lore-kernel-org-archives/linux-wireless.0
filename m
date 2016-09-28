Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40384 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932155AbcI1N7n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 09:59:43 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Rajat Jain <rajatja@google.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Wei-Ning Huang <wnhuang@google.com>,
        Brian Norris <briannorris@google.com>,
        Eric Caruso <ejcaruso@chromium.org>,
        "rajatxjain@gmail.com" <rajatxjain@gmail.com>
Subject: RE: [PATCH v2] mwifiex: report wakeup for wowlan
Date: Wed, 28 Sep 2016 13:59:35 +0000
Message-ID: <014d46607eb34a3cbf61faafd7586905@SC-EXCH04.marvell.com> (sfid-20160928_155951_789115_2C3D8C5E)
References: <1474995364-123069-1-git-send-email-rajatja@google.com>
 <1475027104-17423-1-git-send-email-rajatja@google.com>
In-Reply-To: <1475027104-17423-1-git-send-email-rajatja@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Rajat Jain [mailto:rajatja@google.com]
> Sent: Wednesday, September 28, 2016 7:15 AM
> To: Amitkumar Karwar; Nishant Sarmukadam; Kalle Valo; linux-
> wireless@vger.kernel.org; netdev@vger.kernel.org
> Cc: Rajat Jain; Wei-Ning Huang; Brian Norris; Eric Caruso;
> rajatxjain@gmail.com
> Subject: [PATCH v2] mwifiex: report wakeup for wowlan
> 
> Enable notifying wakeup source to the PM core in case of a wake on
> wireless LAN event.
> 
> Signed-off-by: Wei-Ning Huang <wnhuang@google.com>
> Signed-off-by: Rajat Jain <rajatja@google.com>
> Tested-by: Wei-Ning Huang <wnhuang@chromium.org>
> Reviewed-by: Eric Caruso <ejcaruso@chromium.org>
> ---
> v2: Fix the commit log
> 
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 8 ++++++++
> drivers/net/wireless/marvell/mwifiex/sdio.h | 1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c
> b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index d3e1561..a5f63e4 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -89,6 +89,9 @@ static irqreturn_t mwifiex_wake_irq_wifi(int irq, void
> *priv)
>  		disable_irq_nosync(irq);
>  	}
> 
> +	/* Notify PM core we are wakeup source */
> +	pm_wakeup_event(cfg->dev, 0);
> +
>  	return IRQ_HANDLED;
>  }
> 
> @@ -112,6 +115,7 @@ static int mwifiex_sdio_probe_of(struct device *dev,
> struct sdio_mmc_card *card)
>  					  GFP_KERNEL);
>  	cfg = card->plt_wake_cfg;
>  	if (cfg && card->plt_of_node) {
> +		cfg->dev = dev;
>  		cfg->irq_wifi = irq_of_parse_and_map(card->plt_of_node, 0);
>  		if (!cfg->irq_wifi) {
>  			dev_dbg(dev,
> @@ -130,6 +134,10 @@ static int mwifiex_sdio_probe_of(struct device
> *dev, struct sdio_mmc_card *card)
>  		}
>  	}
> 
> +	ret = device_init_wakeup(dev, true);
> +	if (ret)
> +		dev_err(dev, "fail to init wakeup for mwifiex");
> +
>  	return 0;
>  }
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h
> b/drivers/net/wireless/marvell/mwifiex/sdio.h
> index db837f1..07cdd23 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.h
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
> @@ -155,6 +155,7 @@
>  } while (0)
> 
>  struct mwifiex_plt_wake_cfg {
> +	struct device *dev;
>  	int irq_wifi;
>  	bool wake_by_wifi;
>  };
> --
> 2.8.0.rc3.226.g39d4020

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
