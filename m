Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15538 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750949AbaGVDaw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 23:30:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andreas Fenkart <afenkart@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "daniel@zonque.org" <daniel@zonque.org>
Date: Mon, 21 Jul 2014 20:30:48 -0700
Subject: RE: [PATCH v2 1/1] mwifiex: card reset: enable rescan of
 non-removable card
Message-ID: <477F20668A386D41ADCC57781B1F7043122FE2CBA3@SC-VEXCH1.marvell.com> (sfid-20140722_053056_050360_252D3D1E)
References: <CALtMJEAwvMrZcFW7+ACgDNRVi+O5LE0p8gRUTUN3pNh8N1Eiog@mail.gmail.com>
 <1405929712-27268-1-git-send-email-afenkart@gmail.com>
 <1405929712-27268-2-git-send-email-afenkart@gmail.com>
In-Reply-To: <1405929712-27268-2-git-send-email-afenkart@gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

> mmc_rescan will scan for non-removable cards only once, hence the card
> will not be rediscovered.
> 
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> 
> diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
> index 4ce3d7b..ef22d59 100644
> --- a/drivers/net/wireless/mwifiex/sdio.c
> +++ b/drivers/net/wireless/mwifiex/sdio.c
> @@ -1931,6 +1931,7 @@ static void sdio_card_reset_worker(struct work_struct *work)
>  	mmc_remove_host(target);
>  	/* 20ms delay is based on experiment with sdhci controller */
>  	mdelay(20);
> +	target->rescan_entered = 0; /* rescan non-removable cards */
>  	mmc_add_host(target);
>  }
>  static DECLARE_WORK(card_reset_work, sdio_card_reset_worker);
> --
> 2.0.1

