Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab0IJNd3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 09:33:29 -0400
Date: Fri, 10 Sep 2010 15:34:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Matthieu CASTET <castet.matthieu@free.fr>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] airo: remove pointless check
Message-ID: <20100910133401.GF2398@redhat.com>
References: <20100910115714.GE5959@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100910115714.GE5959@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 10, 2010 at 01:57:14PM +0200, Dan Carpenter wrote:
> It doesn't make sense to check "!ai->config.rates" here.
> "ai->config.rates" is the address of an eight bytes array and it
> can't ever be null here.  Also if it were NULL then trying to set:
> 	ai->config.rates[i] = basic_rate | 0x80;
> would cause an oops.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
> index 1d05445..d806497 100644
> --- a/drivers/net/wireless/airo.c
> +++ b/drivers/net/wireless/airo.c
> @@ -3886,8 +3886,7 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
>  		}
>  		if ( basic_rate > 0 ) {
>  			for( i = 0; i < 8; i++ ) {
> -				if ( ai->config.rates[i] == basic_rate ||
> -				     !ai->config.rates ) {
> +				if (ai->config.rates[i] == basic_rate) {
>  					ai->config.rates[i] = basic_rate | 0x80;
>  					break;
>  				}

I think code author wonted to do "!ai->config.rates[i], what mean "if
rate is invalid use basic rate". 

I'm not sure if basic_rate module parameter is used by anyone. It's not
described, seems it was created for development purpose. I think we can
remove it ...

Stanislaw
