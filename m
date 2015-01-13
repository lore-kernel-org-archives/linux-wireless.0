Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9296 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757AbbAMMj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 07:39:58 -0500
Message-ID: <1421172581.11512.1.camel@pe-lt950.marvell.com> (sfid-20150113_134001_855475_0F5B9A5F)
Subject: Re: [PATCH] mwifiex: set netif carrier off in ndo_open
From: Avinash Patil <patila@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<kvalo@codeaurora.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 13 Jan 2015 23:39:41 +0530
In-Reply-To: <1421065496-1968-1-git-send-email-patila@marvell.com>
References: <1421065496-1968-1-git-send-email-patila@marvell.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Could you please mark this patch for stable as well?

Thanks,
Avinash

On Mon, 2015-01-12 at 04:24 -0800, Avinash Patil wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> 
> This patch adds fix to set carrier state off during ndo_open.
> Carrier should be set to ON when device is ready to send data.
> In case of station/adhoc interface device is able to transfer
> data after successful association/join operation.
> For AP this would be after bss_active event.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
> index effea6e..48e7c63 100644
> --- a/drivers/net/wireless/mwifiex/main.c
> +++ b/drivers/net/wireless/mwifiex/main.c
> @@ -562,7 +562,8 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
>  static int
>  mwifiex_open(struct net_device *dev)
>  {
> -	netif_tx_start_all_queues(dev);
> +	netif_carrier_off(dev);
> +
>  	return 0;
>  }
>  


