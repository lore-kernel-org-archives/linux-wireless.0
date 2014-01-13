Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaAMXlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 18:41:36 -0500
Date: Mon, 13 Jan 2014 15:42:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/6] staging: vt6656:  sparse fixes: device_get_stats
Message-ID: <20140113234212.GA3066@kroah.com> (sfid-20140114_004148_045083_66BC9F68)
References: <1389629930.2590.1.camel@canaries32-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389629930.2590.1.camel@canaries32-MCP7A>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 13, 2014 at 04:18:50PM +0000, Malcolm Priestley wrote:
> sparse warning
> main_usb.c:1442:44: warning: cast removes address space of expression
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/staging/vt6656/main_usb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
> index 4cb7aa7..59c2430 100644
> --- a/drivers/staging/vt6656/main_usb.c
> +++ b/drivers/staging/vt6656/main_usb.c
> @@ -1418,8 +1418,9 @@ static void device_set_multi(struct net_device *dev)
>  static struct net_device_stats *device_get_stats(struct net_device *dev)
>  {
>  	struct vnt_private *pDevice = netdev_priv(dev);
> +	struct net_device_stats *stats = &pDevice->stats;
>  
> -	return &pDevice->stats;
> +	return stats;

This change makes no sense to me.  Why is sparse complaining about this?

Is this a bug in sparse, or am I missing something obvious here?

thanks,

greg k-h
