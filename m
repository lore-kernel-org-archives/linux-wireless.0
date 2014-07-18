Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:45659 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276AbaGRIMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 04:12:13 -0400
Date: Fri, 18 Jul 2014 18:12:00 +1000
From: James Cameron <quozl@laptop.org>
To: Andreas Fenkart <afenkart@gmail.com>
Cc: linux-wireless@vger.kernel.org, bzhao@marvell.com,
	daniel@zonque.org
Subject: Re: [PATCH] mwifiex: card reset: enable rescan of non-removable card
Message-ID: <20140718081200.GQ13892@us.netrek.org> (sfid-20140718_101231_523206_4E1BAFB2)
References: <1405670437-18723-1-git-send-email-afenkart@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405670437-18723-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 18, 2014 at 10:00:37AM +0200, Andreas Fenkart wrote:
> mmc_rescan will scan for non-removable cards only once, hence the card
> will not be rediscovered.
> 
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
> ---
>  drivers/net/wireless/mwifiex/sdio.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
> index 4ce3d7b..eff3d6e 100644
> --- a/drivers/net/wireless/mwifiex/sdio.c
> +++ b/drivers/net/wireless/mwifiex/sdio.c
> @@ -1931,6 +1931,7 @@ static void sdio_card_reset_worker(struct work_struct *work)
>  	mmc_remove_host(target);
>  	/* 20ms delay is based on experiment with sdhci controller */
>  	mdelay(20);
> +	reset_host->rescan_entered = 0; /* rescan non-removable cards */
>  	mmc_add_host(target);
>  }
>  static DECLARE_WORK(card_reset_work, sdio_card_reset_worker);

Thanks!  Maybe that was my problem.

-- 
James Cameron
http://quozl.linux.org.au/
