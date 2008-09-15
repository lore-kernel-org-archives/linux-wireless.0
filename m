Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbYIOHZc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 03:25:32 -0400
Subject: Re: [PATCH] libertas: Reduce the WPA key installation time.
From: Dan Williams <dcbw@redhat.com>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <1221461196.27102.77.camel@localhost.localdomain>
References: <48c9b342.081b600a.61cf.fffffdb5@mx.google.com>
	 <1221461196.27102.77.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 03:26:11 -0400
Message-Id: <1221463571.27102.94.camel@localhost.localdomain> (sfid-20080915_092536_039864_C5F80B2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-15 at 02:46 -0400, Dan Williams wrote:
> On Thu, 2008-09-11 at 15:32 -0700, Javier Cardona wrote:
> > WPA requires that the PTK is installed immediately after the 4-way handshake
> > in order to properly decrypt the subsequent incoming EAPOL-GTK frame.  If the
> > PTK is not enabled by the time the EAPOL-GTK frame arrives, the frame is
> > dropped and the supplicant does not receive the group key.
> > 
> > This will happen with fast Access Points that send the EAPOL-GTK frame before
> > the suplicant has successfully installed and enabled the PTK.  To mitigate
> > this situation, this patch simplifies and accelerates the SIOCSIWENCODEEXT
> > execution.
> 
> Good catch though this would break ordering of iwconfig commands like:
> 
> iwconfig eth0 essid foobar key 235232363632 mode managed channel 11
> 
> which would punt the mode + channel arguments to another association
> request, thus causing the first one to either fail (because the mode
> wouldn't be switched yet) or to get the wrong AP on the wrong channel
> (because the channel lock request wouldn't come until after it had tried
> to associate on channels 1 - 10, and if it found a matching AP not on
> channel 11 it would use that first).
> 
> The problem is of course that the patch unconditionally sets the key
> immediately, but that was also the solution to the OLPC bug.
> Unfortunately this is something we can't really handle well with WEXT,
> but we can try to work around it by testing the following:
> 
> 1) in infrastructure mode AND one or both of (2) or (3)
> 2) WPA is on 
> 3) key management (via SIWAUTH) is one of
> 	a) IW_AUTH_KEY_MGMT_802_1X
> 	b) IW_AUTH_KEY_MGMT_PSK
> 
> and if this is true, set keys immediately, otherwise punt to the
> association handler.
> 
> Does something like the following (based off your patch) still fix the
> bug?
> 
> Dan
> 
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index fd59e18..6d2bf5c 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -58,6 +58,7 @@ struct lbs_802_11_security {
>  	u8 WPA2enabled;
>  	u8 wep_enabled;
>  	u8 auth_mode;
> +	u32 key_mgmt;
>  };
>  
>  /** Current Basic Service Set State Structure */
> diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
> index 426f1fe..43ba998 100644
> --- a/drivers/net/wireless/libertas/wext.c
> +++ b/drivers/net/wireless/libertas/wext.c
> @@ -30,6 +30,14 @@ static inline void lbs_postpone_association_work(struct lbs_private *priv)
>  	queue_delayed_work(priv->work_thread, &priv->assoc_work, HZ / 2);
>  }
>  
> +static inline void lbs_do_association_work(struct lbs_private *priv)
> +{
> +	if (priv->surpriseremoved)
> +		return;
> +	cancel_delayed_work(&priv->assoc_work);
> +	queue_delayed_work(priv->work_thread, &priv->assoc_work, 0);
> +}
> +
>  static inline void lbs_cancel_association_work(struct lbs_private *priv)
>  {
>  	cancel_delayed_work(&priv->assoc_work);
> @@ -1578,12 +1586,27 @@ static int lbs_set_encodeext(struct net_device *dev,
>  			set_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags);
>  		}
>  
> +		/* Only disable wep if necessary: can't waste time here. */
> +		if (priv->mac_control & CMD_ACT_MAC_WEP_ENABLE)
> +			disable_wep(assoc_req);
>  		disable_wep (assoc_req);

It's late; this second disable_wep() slipped through.  Remove it of
course :)

>  	}
>  
>  out:
>  	if (ret == 0) {
> -		lbs_postpone_association_work(priv);
> +		/* 802.1x and WPA rekeying must happen as quickly as possible,
> +		 * especially during the 4-way handshake; thus if in
> +		 * infrastructure mode, and either (a) 802.1x is enabled or
> +		 * (b) WPA is being used, set the key right away.
> +		 */
> +		if (assoc_req->mode == IW_MODE_INFRA &&
> +		    ((assoc_req->secinfo.key_mgmt & IW_AUTH_KEY_MGMT_802_1X) ||
> +		     (assoc_req->secinfo.key_mgmt & IW_AUTH_KEY_MGMT_PSK) ||
> +		      assoc_req->secinfo.WPAenabled ||
> +		      assoc_req->secinfo.WPA2enabled)) {
> +			lbs_do_association_work(priv);
> +		} else
> +			lbs_postpone_association_work(priv);
>  	} else {
>  		lbs_cancel_association_work(priv);
>  	}
> @@ -1691,13 +1714,17 @@ static int lbs_set_auth(struct net_device *dev,
>  	case IW_AUTH_TKIP_COUNTERMEASURES:
>  	case IW_AUTH_CIPHER_PAIRWISE:
>  	case IW_AUTH_CIPHER_GROUP:
> -	case IW_AUTH_KEY_MGMT:
>  	case IW_AUTH_DROP_UNENCRYPTED:
>  		/*
>  		 * libertas does not use these parameters
>  		 */
>  		break;
>  
> +	case IW_AUTH_KEY_MGMT:
> +		assoc_req->secinfo.key_mgmt = dwrq->value;
> +		updated = 1;
> +		break;
> +
>  	case IW_AUTH_WPA_VERSION:
>  		if (dwrq->value & IW_AUTH_WPA_VERSION_DISABLED) {
>  			assoc_req->secinfo.WPAenabled = 0;
> @@ -1777,6 +1804,10 @@ static int lbs_get_auth(struct net_device *dev,
>  	lbs_deb_enter(LBS_DEB_WEXT);
>  
>  	switch (dwrq->flags & IW_AUTH_INDEX) {
> +	case IW_AUTH_KEY_MGMT:
> +		dwrq->value = priv->secinfo.key_mgmt;
> +		break;
> +
>  	case IW_AUTH_WPA_VERSION:
>  		dwrq->value = 0;
>  		if (priv->secinfo.WPAenabled)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

