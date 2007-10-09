Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbXJIOQW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 10:16:22 -0400
Subject: Re: [PATCH] libertas: let get nick return what set nick has set
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200710091504.14903.hs4233@mail.mn-solutions.de>
References: <200710091504.14903.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 10:16:47 -0400
Message-Id: <1191939407.17254.8.camel@localhost.localdomain> (sfid-20071009_151628_842816_E89C9EA0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-10-09 at 15:04 +0200, Holger Schurig wrote:
> Make the get-nickname wireless extension actually work. Before
> this patch, I could do "iwconfig eth1 nick BLAH" but "iwconfig
> eth1" would have still showed "MRVL-USB8388" to me. Hey, and that
> was wrong anyway, I'm on a CF card, not on USB :-)
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> 
> Index: libertas-2.6/drivers/net/wireless/libertas/wext.c
> ===================================================================
> --- libertas-2.6.orig/drivers/net/wireless/libertas/wext.c	2007-10-09 15:50:49.000000000 +0200
> +++ libertas-2.6/drivers/net/wireless/libertas/wext.c	2007-10-09 16:04:26.000000000 +0200
> @@ -251,37 +251,16 @@ static int wlan_set_nick(struct net_devi
>  static int wlan_get_nick(struct net_device *dev, struct iw_request_info *info,
>  			 struct iw_point *dwrq, char *extra)
>  {
> -	const char *cp;
> -	char comm[6] = { "COMM-" };
> -	char mrvl[6] = { "MRVL-" };
> -	int cnt;
> +	wlan_private *priv = dev->priv;
> +	wlan_adapter *adapter = priv->adapter;
>  
>  	lbs_deb_enter(LBS_DEB_WEXT);
>  
> -	/*
> -	 * Nick Name is not used internally in this mode,
> -	 * therefore return something useful instead. Jean II
> -	 */
> -
> -	strcpy(extra, mrvl);
> -
> -	cp = strstr(libertas_driver_version, comm);
> -	if (cp == libertas_driver_version)	//skip leading "COMM-"
> -		cp = libertas_driver_version + strlen(comm);
> -	else
> -		cp = libertas_driver_version;
> -
> -	cnt = strlen(mrvl);
> -	extra += cnt;
> -	while (cnt < 16 && (*cp != '-')) {
> -		*extra++ = toupper(*cp++);
> -		cnt++;
> -	}
> +	dwrq->length = strlen(adapter->nodename);
> +	memcpy(extra, adapter->nodename, dwrq->length);
> +	extra[dwrq->length] = '\0';
>  
> -	/*
> -	 * Push it out !
> -	 */
> -	dwrq->length = cnt;
> +	dwrq->flags = 1;	/* active */
>  
>  	lbs_deb_leave(LBS_DEB_WEXT);
>  	return 0;
> @@ -311,6 +290,7 @@ static int mesh_get_nick(struct net_devi
>  	lbs_deb_leave(LBS_DEB_WEXT);
>  	return 0;
>  }
> +
>  static int wlan_set_rts(struct net_device *dev, struct iw_request_info *info,
>  			struct iw_param *vwrq, char *extra)
>  {

