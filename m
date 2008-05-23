Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbYEWNkp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 09:40:45 -0400
Subject: Re: [PATCH] libertas: use lbs_pr_XX instead of printk
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200805231216.51953.hs4233@mail.mn-solutions.de>
References: <200805231216.51953.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 23 May 2008 09:40:25 -0400
Message-Id: <1211550025.31559.2.camel@localhost.localdomain> (sfid-20080523_154047_270183_11CE075A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-23 at 12:16 +0200, Holger Schurig wrote:
> ... because lbs_pr_XXX prefixes all messages with "libertas: "
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> --- linux.orig/drivers/net/wireless/libertas/cmd.c
> +++ linux/drivers/net/wireless/libertas/cmd.c
> @@ -110,7 +110,7 @@
>  	 * CF card    firmware 5.0.16p0:   cap 0x00000303
>  	 * USB dongle firmware 5.110.17p2: cap 0x00000303
>  	 */
> -	printk("libertas: %s, fw %u.%u.%up%u, cap 0x%08x\n",
> +	lbs_pr_info("%s, fw %u.%u.%up%u, cap 0x%08x\n",
>  		print_mac(mac, cmd.permanentaddr),
>  		priv->fwrelease >> 24 & 0xff,
>  		priv->fwrelease >> 16 & 0xff,
> --- linux.orig/drivers/net/wireless/libertas/persistcfg.c
> +++ linux/drivers/net/wireless/libertas/persistcfg.c
> @@ -188,7 +188,7 @@
>  		return ret;
>  
>  	if (defs.meshie.val.mesh_id_len > IW_ESSID_MAX_SIZE) {
> -		printk(KERN_ERR "Inconsistent mesh ID length");
> +		lbs_pr_err("inconsistent mesh ID length");
>  		defs.meshie.val.mesh_id_len = IW_ESSID_MAX_SIZE;
>  	}
>  

