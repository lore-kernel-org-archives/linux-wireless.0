Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbYEWNmA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 09:42:00 -0400
Subject: Re: [PATH] libertas: speeds up downloading of CF firmware
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200805231018.26751.hs4233@mail.mn-solutions.de>
References: <200805231018.26751.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 23 May 2008 09:41:55 -0400
Message-Id: <1211550115.31559.5.camel@localhost.localdomain> (sfid-20080523_154204_206052_64B982DD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-23 at 10:18 +0200, Holger Schurig wrote:
> Keep the timeout the same (1000*500 == 100000 * 5), but take shorter
> naps. Makes downloading the firmware slightly faster.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> --- linux.orig/drivers/net/wireless/libertas/if_cs.c
> +++ linux/drivers/net/wireless/libertas/if_cs.c
> @@ -148,11 +148,11 @@
>  {
>  	int i;
>  
> -	for (i = 0; i < 1000; i++) {
> +	for (i = 0; i < 100000; i++) {
>  		u8 val = if_cs_read8(card, addr);
>  		if (val == reg)
>  			return i;
> -		udelay(500);
> +		udelay(5);
>  	}
>  	return -ETIME;
>  }

