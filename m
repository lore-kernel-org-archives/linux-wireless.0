Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:60356 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbYADWQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2008 17:16:40 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Subject: Re: [PATCH] iwlwifi: fix compilation warning in 'iwl-4965.c'
Date: Fri, 4 Jan 2008 23:15:26 +0100
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	yi.zhu@intel.com, linville@tuxdriver.com
References: <200801042305.55188.mboton@gmail.com>
In-Reply-To: <200801042305.55188.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200801042315.26817.mb@bu3sch.de> (sfid-20080104_221643_587519_CFEBCDA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 04 January 2008 23:05:54 Miguel Bot=C3=B3n wrote:
> This patch fixes a compilation warning in 'iwl-4965.c'.
>=20
> Signed-off-by: Miguel Bot=C3=B3n <mboton@gmail.com>
>=20
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wi=
reless/iwlwifi/iwl-4965.c
> index 74999af..92237cd 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> @@ -3616,7 +3616,7 @@ static void iwl4965_add_radiotap(struct iwl4965=
_priv *priv,
>  	if (skb_headroom(skb) < sizeof(*iwl4965_rt)) {
>  		if (net_ratelimit())
>  			printk(KERN_ERR "not enough headroom [%d] for "
> -			       "radiotap head [%d]\n",
> +			       "radiotap head [%ld]\n",
>  			       skb_headroom(skb), sizeof(*iwl4965_rt));

I think %zu is the correct and portable integer conversion for a size_t=
 type.
The kernel implementation seems to support it.

--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
