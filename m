Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56501 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756973AbZEWAPz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 20:15:55 -0400
Subject: Re: [PATCH 5/5] libertas: fix WPA adhoc network creation
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1243037398.2495.14.camel@localhost.localdomain>
References: <1243037398.2495.14.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 22 May 2009 20:16:01 -0400
Message-Id: <1243037761.2495.15.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-05-22 at 20:09 -0400, Dan Williams wrote:
> Oddly enough, the firmware's JOIN/START commands don't appear to have
> any facility for setting custom IEs, thus the started adhoc network
> doesn't advertise its WPA capability in the beacon.  Whee!

Turns out v10 firmware now has this capability, but v9 and lower do not.
Just for the record.

Dan

> Signed-off-by: Dan Williams <dcbw@redhat.com>
> 
> diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
> index cb73720..b9b3741 100644
> --- a/drivers/net/wireless/libertas/assoc.c
> +++ b/drivers/net/wireless/libertas/assoc.c
> @@ -711,11 +711,13 @@ static int lbs_adhoc_start(struct lbs_private *priv,
>  
>  	/* set capability info */
>  	tmpcap = WLAN_CAPABILITY_IBSS;
> -	if (assoc_req->secinfo.wep_enabled) {
> -		lbs_deb_join("ADHOC_START: WEP enabled, setting privacy on\n");
> +	if (assoc_req->secinfo.wep_enabled ||
> +	    assoc_req->secinfo.WPAenabled ||
> +	    assoc_req->secinfo.WPA2enabled) {
> +		lbs_deb_join("ADHOC_START: WEP/WPA enabled, privacy on\n");
>  		tmpcap |= WLAN_CAPABILITY_PRIVACY;
>  	} else
> -		lbs_deb_join("ADHOC_START: WEP disabled, setting privacy off\n");
> +		lbs_deb_join("ADHOC_START: WEP disabled, privacy off\n");
>  
>  	cmd.capability = cpu_to_le16(tmpcap);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

