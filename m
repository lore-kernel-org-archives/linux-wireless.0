Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45302 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZHJSBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 14:01:08 -0400
Date: Mon, 10 Aug 2009 13:57:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: wireless <linux-wireless@vger.kernel.org>,
	Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH 2.6.31] ar9170: fix read & write outside array bounds
Message-ID: <20090810175755.GG2733@tuxdriver.com>
References: <200908091424.09712.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200908091424.09712.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 09, 2009 at 02:24:09PM +0200, Christian Lamparter wrote:
> From: Dan Carpenter <error27@gmail.com>
> 
> queue == __AR9170_NUM_TXQ would cause a bug on the next line.
> 
> found by Smatch ( http://repo.or.cz/w/smatch.git ).
> 
> Cc: stable@kernel.org
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
> index 4fc389a..ea8c941 100644
> --- a/drivers/net/wireless/ath/ar9170/main.c
> +++ b/drivers/net/wireless/ath/ar9170/main.c
> @@ -2458,13 +2458,14 @@ static int ar9170_conf_tx(struct ieee80211_hw *hw, u16 queue,
>  	int ret;
>  
>  	mutex_lock(&ar->mutex);
> -	if ((param) && !(queue > __AR9170_NUM_TXQ)) {
> +	if (queue < __AR9170_NUM_TXQ) {
>  		memcpy(&ar->edcf[ar9170_qos_hwmap[queue]],
>  		       param, sizeof(*param));
>  
>  		ret = ar9170_set_qos(ar);
> -	} else
> +	} else {
>  		ret = -EINVAL;
> +	}
>  
>  	mutex_unlock(&ar->mutex);
>  	return ret;

The p54 version of this patch used hw->queues instead of a constant.
Wouldn't that be better here?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
