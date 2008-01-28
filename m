Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbYA1Qo1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 11:44:27 -0500
Subject: Re: [PATCH] libertas: make association debug output nicer
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200801281725.53260.hs4233@mail.mn-solutions.de>
References: <200801281725.53260.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 11:39:19 -0500
Message-Id: <1201538359.14441.5.camel@localhost.localdomain> (sfid-20080128_164430_537143_AE7278A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-01-28 at 17:25 +0100, Holger Schurig wrote:
> This also fixes a bug where should_deauth_infrastructure() always
> returned 0.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-2.6/drivers/net/wireless/libertas/assoc.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/assoc.c	2008-01-16 14:15:07.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/assoc.c	2008-01-16 15:19:16.000000000 +0100
> @@ -403,11 +403,10 @@ static int should_deauth_infrastructure(
>  {
>  	int ret = 0;
>  
> -	lbs_deb_enter(LBS_DEB_ASSOC);
> -
>  	if (priv->connect_status != LBS_CONNECTED)
>  		return 0;
>  
> +	lbs_deb_enter(LBS_DEB_ASSOC);
>  	if (test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)) {
>  		lbs_deb_assoc("Deauthenticating due to new SSID\n");
>  		ret = 1;
> @@ -446,7 +445,7 @@ static int should_deauth_infrastructure(
>  
>  out:
>  	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
> -	return 0;
> +	return ret;
>  }
>  
> 
> @@ -633,9 +642,7 @@ void lbs_association_worker(struct work_
>  		}
>  
>  		if (success) {
> -			lbs_deb_assoc("ASSOC: associated to '%s', %s\n",
> -				escape_essid(priv->curbssparams.ssid,
> -				             priv->curbssparams.ssid_len),
> +			lbs_deb_assoc("associated to %s\n",
>  				print_mac(mac, priv->curbssparams.bssid));
>  			lbs_prepare_and_send_command(priv,
>  				CMD_802_11_RSSI,
> Index: wireless-2.6/drivers/net/wireless/libertas/cmdresp.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/cmdresp.c	2008-01-16 14:37:41.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/cmdresp.c	2008-01-16 14:37:47.000000000 +0100
> @@ -74,7 +74,7 @@ void lbs_mac_event_disconnected(struct l
>  		lbs_deb_cmd("disconnected, so exit PS mode\n");
>  		lbs_ps_wakeup(priv, 0);
>  	}
> -	lbs_deb_leave(LBS_DEB_CMD);
> +	lbs_deb_leave(LBS_DEB_ASSOC);
>  }
>  
>  /**
> Index: wireless-2.6/drivers/net/wireless/libertas/join.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/join.c	2008-01-16 15:19:49.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/join.c	2008-01-16 15:19:54.000000000 +0100
> @@ -769,9 +769,6 @@ int lbs_ret_80211_associate(struct lbs_p
>  	priv->curbssparams.ssid_len = bss->ssid_len;
>  	memcpy(priv->curbssparams.bssid, bss->bssid, ETH_ALEN);
>  
> -	lbs_deb_assoc("ASSOC_RESP: currentpacketfilter is 0x%x\n",
> -		priv->currentpacketfilter);
> -
>  	priv->SNR[TYPE_RXPD][TYPE_AVG] = 0;
>  	priv->NF[TYPE_RXPD][TYPE_AVG] = 0;
>  

