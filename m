Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759666AbXKTW1D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 17:27:03 -0500
Subject: Re: [PATCH 1/4] libertas: drop useless default_fw_name variable
From: Dan Williams <dcbw@redhat.com>
To: Andres Salomon <dilinger@queued.net>
Cc: libertas-dev@lists.infradead.org,
	Marcelo Tosatti <marcelo@kvack.org>,
	David Woodhouse <dwmw2@infradead.org>,
	akpm@linux-foundation.org, linux-wireless@vger.kernel.org
In-Reply-To: <20071116131157.29c7227a@ephemeral>
References: <20071116131157.29c7227a@ephemeral>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 17:23:14 -0500
Message-Id: <1195597394.32309.3.camel@localhost.localdomain> (sfid-20071120_222708_495441_A588CA4D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-11-16 at 13:11 -0500, Andres Salomon wrote:
> Signed-off-by: Andres Salomon <dilinger@debian.org>

As discussed on IRC, I'll clean this series of 4 patches up for 2.6.25
and the unified libertas namespace and resubmit.  Thanks!

Dan

> ---
>  drivers/net/wireless/libertas/if_usb.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> index 063572f..3cf9379 100644
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c
> @@ -20,9 +20,8 @@
>  #define MESSAGE_HEADER_LEN	4
>  
>  static const char usbdriver_name[] = "usb8xxx";
> -static u8 *default_fw_name = "usb8388.bin";
>  
> -static char *libertas_fw_name = NULL;
> +static char *libertas_fw_name = "usb8388.bin";
>  module_param_named(fw_name, libertas_fw_name, charp, 0644);
>  
>  /*
> @@ -1129,10 +1128,6 @@ static int if_usb_init_module(void)
>  
>  	lbs_deb_enter(LBS_DEB_MAIN);
>  
> -	if (libertas_fw_name == NULL) {
> -		libertas_fw_name = default_fw_name;
> -	}
> -
>  	ret = usb_register(&if_usb_driver);
>  
>  	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);

