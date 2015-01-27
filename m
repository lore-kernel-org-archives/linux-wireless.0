Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36690 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbbA0Gms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 01:42:48 -0500
Message-ID: <1422360747.20608.5.camel@pe-lt950> (sfid-20150127_074317_400094_27EA2516)
Subject: Re: [PATCH v2] mwifiex: set netif carrier off in ndo_open
From: Avinash Patil <patila@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<kvalo@codeaurora.org>
CC: Stable <stable@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Date: Tue, 27 Jan 2015 17:42:27 +0530
In-Reply-To: <1421663076-32291-1-git-send-email-patila@marvell.com>
References: <1421663076-32291-1-git-send-email-patila@marvell.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-19 at 02:24 -0800, Avinash Patil wrote:
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
> index 6125d1c..a16c293 100644
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

Hi Kalle,

I do not see this patch in master branch as well as in patchworks
pending patchlist. Is this one also dropped?
Do you want me to resend this as well while I am sending rebased DFS
patches?

Thanks,
Avinash


