Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab2DPSLp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 14:11:45 -0400
Message-ID: <1334597386.10194.35.camel@dcbw.foobar.com> (sfid-20120416_201148_682282_AD6FAD3A)
Subject: Re: [PATCH] libertas: fix signedness bug in lbs_auth_to_authtype()
From: Dan Williams <dcbw@redhat.com>
To: Kiran Divekar <dkiran@marvell.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 16 Apr 2012 12:29:46 -0500
In-Reply-To: <1332959881-31278-1-git-send-email-dkiran@marvell.com>
References: <1332959881-31278-1-git-send-email-dkiran@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-28 at 11:38 -0700, Kiran Divekar wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Return type for lbs_auth_to_authtype() is changed from "u8" to
> "int" to return negative error code correctly.
> Also an error check is added in connect handler for invalid auth
> type.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Kiran Divekar <dkiran@marvell.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/cfg.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index 3fa1ece..2fa879b 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -103,7 +103,7 @@ static const u32 cipher_suites[] = {
>   * Convert NL80211's auth_type to the one from Libertas, see chapter 5.9.1
>   * in the firmware spec
>   */
> -static u8 lbs_auth_to_authtype(enum nl80211_auth_type auth_type)
> +static int lbs_auth_to_authtype(enum nl80211_auth_type auth_type)
>  {
>  	int ret = -ENOTSUPP;
>  
> @@ -1411,7 +1411,12 @@ static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
>  		goto done;
>  	}
>  
> -	lbs_set_authtype(priv, sme);
> +	ret = lbs_set_authtype(priv, sme);
> +	if (ret == -ENOTSUPP) {
> +		wiphy_err(wiphy, "unsupported authtype 0x%x\n", sme->auth_type);
> +		goto done;
> +	}
> +
>  	lbs_set_radio(priv, preamble, 1);
>  
>  	/* Do the actual association */


