Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbXGSUKJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 16:10:09 -0400
Subject: Re: [PATCH] drivers/net/wireless/libertas/cmd.c: fix  adapter->driver_lock dereference
From: Dan Williams <dcbw@redhat.com>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070719135923.GA29142@kernel.sg>
References: <20070719135923.GA29142@kernel.sg>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 16:07:28 -0400
Message-Id: <1184875649.3179.32.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-07-19 at 21:59 +0800, Eugene Teo wrote:
> adapter is NULL if cmdnode is not.

Applied, thanks!

Dan

> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> ---
>  drivers/net/wireless/libertas/cmd.c |   10 +---------
>  1 files changed, 1 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> index 4a8f5dc..03af8bb 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -941,7 +941,7 @@ static int DownloadcommandToStation(wlan_private * priv,
>  	unsigned long flags;
>  	struct cmd_ds_command *cmdptr;
>  	wlan_adapter *adapter = priv->adapter;
> -	int ret = 0;
> +	int ret = -1;
>  	u16 cmdsize;
>  	u16 command;
>  
> @@ -950,12 +950,6 @@ static int DownloadcommandToStation(wlan_private * priv,
>  	if (!adapter || !cmdnode) {
>  		lbs_deb_cmd("DNLD_CMD: adapter = %p, cmdnode = %p\n",
>  		       adapter, cmdnode);
> -		if (cmdnode) {
> -			spin_lock_irqsave(&adapter->driver_lock, flags);
> -			__libertas_cleanup_and_insert_cmd(priv, cmdnode);
> -			spin_unlock_irqrestore(&adapter->driver_lock, flags);
> -		}
> -		ret = -1;
>  		goto done;
>  	}
>  
> @@ -968,7 +962,6 @@ static int DownloadcommandToStation(wlan_private * priv,
>  		       "Not sending\n");
>  		__libertas_cleanup_and_insert_cmd(priv, cmdnode);
>  		spin_unlock_irqrestore(&adapter->driver_lock, flags);
> -		ret = -1;
>  		goto done;
>  	}
>  
> @@ -993,7 +986,6 @@ static int DownloadcommandToStation(wlan_private * priv,
>  		__libertas_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
>  		adapter->cur_cmd = NULL;
>  		spin_unlock_irqrestore(&adapter->driver_lock, flags);
> -		ret = -1;
>  		goto done;
>  	}
>  

