Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:47397 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751501AbZJTPyb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 11:54:31 -0400
Received: from chimera.site ([96.253.169.185]) by xenotime.net for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 08:54:31 -0700
Date: Tue, 20 Oct 2009 08:54:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: move mic failure event to wext.c
Message-Id: <20091020085431.e26cce67.rdunlap@xenotime.net>
In-Reply-To: <200910201505.14283.hs4233@mail.mn-solutions.de>
References: <200910201505.14283.hs4233@mail.mn-solutions.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 20 Oct 2009 15:05:14 +0200 Holger Schurig wrote:

> ... because for cfg80211 we'll need a completely different
> implementation.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> 
> --- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
> +++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
> @@ -73,32 +73,6 @@
>  	lbs_deb_leave(LBS_DEB_ASSOC);
>  }
>  
> -/**
> - *  @brief This function handles MIC failure event.
> - *
> - *  @param priv    A pointer to struct lbs_private structure
> - *  @para  event   the event id
> - *  @return 	   n/a
> - */
> -static void handle_mic_failureevent(struct lbs_private *priv, u32 event)
> -{
> -	char buf[50];
> -
> -	lbs_deb_enter(LBS_DEB_CMD);
> -	memset(buf, 0, sizeof(buf));
> -
> -	sprintf(buf, "%s", "MLME-MICHAELMICFAILURE.indication ");
> -
> -	if (event == MACREG_INT_CODE_MIC_ERR_UNICAST) {
> -		strcat(buf, "unicast ");
> -	} else {
> -		strcat(buf, "multicast ");
> -	}
> -
> -	lbs_send_iwevcustom_event(priv, buf);
> -	lbs_deb_leave(LBS_DEB_CMD);
> -}
> -
>  static int lbs_ret_reg_access(struct lbs_private *priv,
>  			       u16 type, struct cmd_ds_command *resp)
>  {
> @@ -477,12 +451,12 @@
>  
>  	case MACREG_INT_CODE_MIC_ERR_UNICAST:
>  		lbs_deb_cmd("EVENT: UNICAST MIC ERROR\n");
> -		handle_mic_failureevent(priv, MACREG_INT_CODE_MIC_ERR_UNICAST);
> +		lbs_send_mic_failureevent(priv, event);
>  		break;
>  
>  	case MACREG_INT_CODE_MIC_ERR_MULTICAST:
>  		lbs_deb_cmd("EVENT: MULTICAST MIC ERROR\n");
> -		handle_mic_failureevent(priv, MACREG_INT_CODE_MIC_ERR_MULTICAST);
> +		lbs_send_mic_failureevent(priv, event);
>  		break;
>  
>  	case MACREG_INT_CODE_MIB_CHANGED:
> --- linux-wl.orig/drivers/net/wireless/libertas/wext.c
> +++ linux-wl/drivers/net/wireless/libertas/wext.c
> @@ -54,7 +54,7 @@
>  	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
>  }
>  
> -void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str)
> +static void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str)
>  {
>  	union iwreq_data iwrq;
>  	u8 buf[50];
> @@ -79,6 +79,31 @@
>  }
>  
>  /**
> + *  @brief This function handles MIC failure event.
> + *
> + *  @param priv    A pointer to struct lbs_private structure
> + *  @para  event   the event id
> + *  @return 	   n/a
> + */

argh.  urgh.  This file (or files) need to lose this non-kernel-doc
function notation.  Please.


> +void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event)
> +{
> +	char buf[50];
> +
> +	lbs_deb_enter(LBS_DEB_CMD);
> +	memset(buf, 0, sizeof(buf));
> +
> +	sprintf(buf, "%s", "MLME-MICHAELMICFAILURE.indication ");
> +
> +	if (event == MACREG_INT_CODE_MIC_ERR_UNICAST)
> +		strcat(buf, "unicast ");
> +	else
> +		strcat(buf, "multicast ");
> +
> +	lbs_send_iwevcustom_event(priv, buf);
> +	lbs_deb_leave(LBS_DEB_CMD);
> +}
> +
> +/**
>   *  @brief Find the channel frequency power info with specific channel
>   *
>   *  @param priv 	A pointer to struct lbs_private structure


---
~Randy
