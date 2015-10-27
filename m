Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbJ0F3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 01:29:43 -0400
Date: Tue, 27 Oct 2015 14:29:05 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Punit Vara <punitvara@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wilc1000: Fix warning prefer eth_broadcast_addr
 over memset()
Message-ID: <20151027052905.GA27242@kroah.com> (sfid-20151027_063044_298762_9B8548CC)
References: <1445889106-6737-1-git-send-email-punitvara@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445889106-6737-1-git-send-email-punitvara@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 27, 2015 at 01:21:46AM +0530, Punit Vara wrote:
> This patch is to the host_interface.c that fixes up following
> warning by checkpatch.pl:
> 
> -Prefer eth_broadcast_addr() over memset()
> 
> Signed-off-by: Punit Vara <punitvara@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 09a6c98..87b4eb8 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -4688,7 +4688,7 @@ s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
>  	msg.drv = hif_drv;
>  
>  	if (pu8MacAddr == NULL)
> -		memset(pstrDelStationMsg->mac_addr, 255, ETH_ALEN);
> +		eth_broadcast_addr(pstrDelStationMsg->mac_addr);
>  	else
>  		memcpy(pstrDelStationMsg->mac_addr, pu8MacAddr, ETH_ALEN);
>  

Doesn't apply to my staging.git tree at all :(
