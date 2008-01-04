Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:53395 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbYADWSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2008 17:18:09 -0500
Date: Fri, 4 Jan 2008 14:15:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Miguel =?ISO-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	yi.zhu@intel.com, linville@tuxdriver.com
Subject: Re: [PATCH] iwlwifi: fix compilation warning in 'iwl-4965.c'
Message-Id: <20080104141510.c7e80964.randy.dunlap@oracle.com> (sfid-20080104_221819_495514_0B1DADE7)
In-Reply-To: <200801042305.55188.mboton@gmail.com>
References: <200801042305.55188.mboton@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 4 Jan 2008 23:05:54 +0100 Miguel Bot=F3n wrote:

> This patch fixes a compilation warning in 'iwl-4965.c'.

It would be helpful to have the warning message right here.<---

> Signed-off-by: Miguel Bot=F3n <mboton@gmail.com>
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
>  		return;
>  	}

sizeof() (or size_t) normally needs %zd.

---
~Randy
desserts:  http://www.xenotime.net/linux/recipes/
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
