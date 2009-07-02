Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43169 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbZGBM3R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 08:29:17 -0400
Subject: Re: [PATCH hostap/wpa_supplicant] Allow wpa_supplicant to use
 libnl-2.0
From: Dan Williams <dcbw@redhat.com>
To: Jon Loeliger <jdl@bigfootnetworks.com>
Cc: jouni.malinen@atheros.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1246481949.11632.36.camel@jdl-desktop>
References: <1246481949.11632.36.camel@jdl-desktop>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 08:29:15 -0400
Message-Id: <1246537755.16543.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-01 at 15:59 -0500, Jon Loeliger wrote:
> Introduce CONFIG_LIBNL20 .config parameter and propogate
> that as a CFLAG in the Makefile.
> 
> Add forward-compatibility code to allow the existing code
> to also use libnl-2.0.
> 
> Signed-off-by: Jon Loeliger <jdl@bigfootnetworks.com>

You might actually want to post this to the hostap/wpa_supplicant
mailing list instead.  While developers involved in both projects are
subscribed to both lists, linux-wireless isn't the right place for
patches against hostap and wpa_supplicant.

http://lists.shmoo.com/mailman/listinfo/hostap

Dan

> ---
> 
> This patch applies to:
>     git://w1.fi/srv/git/hostap-06.git
>     fa4e296f542af01da135d997358d6d45a32dd59e
> 
> Also, I suspect that this define:
> 
>     +#define nl_handle nl_sock
> 
> may need to be added to the hostapd side as well, but
> I'm not using that and haven't investigated or tested that.
> 
> jdl
> 
> 
>  src/drivers/driver_nl80211.c |   17 +++++++++++++++++
>  wpa_supplicant/Makefile      |    4 ++++
>  2 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
> index a7b351a..66288f6 100644
> --- a/src/drivers/driver_nl80211.c
> +++ b/src/drivers/driver_nl80211.c
> @@ -47,6 +47,15 @@
>  #endif
>  
> 
> +#ifdef CONFIG_LIBNL20
> +/* libnl 2.0 compatibility code */
> +
> +#define nl_handle nl_sock
> +#define nl_handle_alloc_cb nl_socket_alloc_cb
> +#define nl_handle_destroy nl_socket_free
> +#endif /* CONFIG_LIBNL20 */
> +
> +
>  struct wpa_driver_nl80211_data {
>  	void *ctx;
>  	int wext_event_sock;
> @@ -1441,12 +1450,20 @@ static void * wpa_driver_nl80211_init(void *ctx, const char *ifname)
>  		goto err3;
>  	}
>  
> +#ifdef CONFIG_LIBNL20
> +	if (genl_ctrl_alloc_cache(drv->nl_handle, &drv->nl_cache) < 0) {
> +	    wpa_printf(MSG_ERROR, "nl80211: Failed to allocate generic "
> +			   "netlink cache");
> +		goto err3;
> +	}
> +#else
>  	drv->nl_cache = genl_ctrl_alloc_cache(drv->nl_handle);
>  	if (drv->nl_cache == NULL) {
>  		wpa_printf(MSG_ERROR, "nl80211: Failed to allocate generic "
>  			   "netlink cache");
>  		goto err3;
>  	}
> +#endif
>  
>  	drv->nl80211 = genl_ctrl_search_by_name(drv->nl_cache, "nl80211");
>  	if (drv->nl80211 == NULL) {
> diff --git a/wpa_supplicant/Makefile b/wpa_supplicant/Makefile
> index 45d6ada..fa43a0c 100644
> --- a/wpa_supplicant/Makefile
> +++ b/wpa_supplicant/Makefile
> @@ -135,6 +135,10 @@ ifdef CONFIG_DRIVER_NL80211
>  CFLAGS += -DCONFIG_DRIVER_NL80211
>  OBJS_d += ../src/drivers/driver_nl80211.o
>  LIBS += -lnl
> +ifdef CONFIG_LIBNL20
> +LIBS += -lnl-genl
> +CFLAGS += -DCONFIG_LIBNL20
> +endif
>  ifdef CONFIG_CLIENT_MLME
>  OBJS_d += ../src/drivers/radiotap.o
>  endif

