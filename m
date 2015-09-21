Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbbIUEiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 00:38:16 -0400
Date: Sun, 20 Sep 2015 19:00:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 07/18] staging: wilc1000: replaces PRINT_D with netdev_err
Message-ID: <20150921020024.GB22262@kroah.com> (sfid-20150921_063823_267238_2178940E)
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
 <1442731885-4344-7-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442731885-4344-7-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 20, 2015 at 03:51:14PM +0900, Chaehyun Lim wrote:
> This patch replaces PRINT_D with netdev_err which is used at error
> checking.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index 216da0c..bf9d9ee 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -3694,17 +3694,17 @@ void wilc_free_wiphy(struct net_device *net)
>  	netdev_info(net, "Unregistering wiphy\n");
>  
>  	if (!net) {
> -		PRINT_D(INIT_DBG, "net_device is NULL\n");
> +		netdev_err(net, "net_device is NULL\n");

Same comment as the previous one, this conversion is not correct.

thanks,

greg k-h
