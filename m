Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbIUEiP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 00:38:15 -0400
Date: Sun, 20 Sep 2015 19:00:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 06/18] staging: wilc1000: replace PRINT_D with netdev_info
Message-ID: <20150921020007.GA22262@kroah.com> (sfid-20150921_063821_846139_1B2DDBB8)
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
 <1442731885-4344-6-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442731885-4344-6-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 20, 2015 at 03:51:13PM +0900, Chaehyun Lim wrote:
> This patch replaces PRINT_D with netdev_info in wilc_free_wiphy function.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index fbe8643..216da0c 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -3691,7 +3691,7 @@ int WILC_WFI_DeInitHostInt(struct net_device *net)
>   */
>  void wilc_free_wiphy(struct net_device *net)
>  {
> -	PRINT_D(CFG80211_DBG, "Unregistering wiphy\n");
> +	netdev_info(net, "Unregistering wiphy\n");

these were only getting printed out if you had a specific debug flag
set.  But you just changed it to always print this message, which isn't
good.

As this really is just a debugging statement, can you make it
netdev_debug() instead?

thanks,

greg k-h
