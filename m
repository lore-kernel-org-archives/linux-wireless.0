Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:37204 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752487AbYA0Q35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 11:29:57 -0500
From: David Brownell <david-b@pacbell.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH 11/14] [rndis_host] Add link_change function pointer to 'struct rndis_data'.
Date: Sun, 27 Jan 2008 08:15:16 -0800
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	bjd@jooz.net
References: <20080125225032.11716.77713.stgit@fate.lan> <20080125225134.11716.2264.stgit@fate.lan>
In-Reply-To: <20080125225134.11716.2264.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801270815.16812.david-b@pacbell.net> (sfid-20080127_163029_492853_93BFB3C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2008, Jussi Kivilinna wrote:
> Callback to signal link state changes from minidriver to 
> 'subminidrivers'.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
> 
>  drivers/net/usb/rndis_host.c |   24 ++++++++++++++++++++----
>  drivers/net/usb/usbnet.h     |    4 ++++
>  2 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
> index 0813903..800c9d0 100644
> --- a/drivers/net/usb/rndis_host.c
> +++ b/drivers/net/usb/rndis_host.c
> @@ -148,10 +148,26 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf)
>  					request_id, xid);
>  				/* then likely retry */
>  			} else switch (buf->msg_type) {
> -			case RNDIS_MSG_INDICATE: {	/* fault */
> -				// struct rndis_indicate *msg = (void *)buf;
> -				dev_info(&info->control->dev,
> -					"rndis fault indication\n");
> +			case RNDIS_MSG_INDICATE: {	/* fault/event */
> +				struct rndis_indicate *msg = (void *)buf;
> +				int state = 0;
> +
> +				switch (msg->status) {
> +				case RNDIS_STATUS_MEDIA_CONNECT:
> +					state = 1;
> +				case RNDIS_STATUS_MEDIA_DISCONNECT:
> +					dev_info(&info->control->dev,
> +						"rndis media %sconnect\n",
> +						!state?"dis":"");
> +					if (dev->driver_info->link_change)
> +						dev->driver_info->link_change(
> +							dev, state);
> +					break;
> +				default:
> +					dev_info(&info->control->dev,
> +						"rndis indication: 0x%08x\n",
> +						le32_to_cpu(msg->status));
> +				}
>  				}
>  				break;
>  			case RNDIS_MSG_KEEPALIVE: {	/* ping */
> diff --git a/drivers/net/usb/usbnet.h b/drivers/net/usb/usbnet.h
> index 25b63d3..e0501da 100644
> --- a/drivers/net/usb/usbnet.h
> +++ b/drivers/net/usb/usbnet.h
> @@ -121,6 +121,10 @@ struct driver_info {
>  	 * right after minidriver have initialized hardware. */
>  	int	(*early_init)(struct usbnet *dev);
>  
> +	/* called by minidriver when link state changes, state: 0=disconnect,
> +	 * 1=connect */
> +	void	(*link_change)(struct usbnet *dev, int state);
> +
>  	/* for new devices, use the descriptor-reading code instead */
>  	int		in;		/* rx endpoint */
>  	int		out;		/* tx endpoint */
> 


