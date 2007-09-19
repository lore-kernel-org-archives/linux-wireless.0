Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42368
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbXISRt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 13:49:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH 3/3] adm8211: Adapt to filter configuration API
Date: Wed, 19 Sep 2007 19:46:43 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <20070918213833.8850.90828.stgit@magic.sourmilk.net> <200709181742.33948.flamingice@sourmilk.net>
In-Reply-To: <200709181742.33948.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709191946.43300.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 18 September 2007 23:42:33 Michael Wu wrote:
> From: Michael Wu <flamingice@sourmilk.net>
> 
> This makes adm8211 use the new filter configuration API in mac80211.
> 
> Signed-off-by: Michael Wu <flamingice@sourmilk.net>
> ---

>  static int adm8211_add_interface(struct ieee80211_hw *dev,
>  				 struct ieee80211_if_init_conf *conf)
>  {
>  	struct adm8211_priv *priv = dev->priv;
> -	/* NOTE: using IEEE80211_IF_TYPE_MGMT to indicate no mode selected */
> -	if (priv->mode != IEEE80211_IF_TYPE_MGMT)
> -		return -1;
> +	if (priv->mode != IEEE80211_IF_TYPE_MNTR)
> +		return -EOPNOTSUPP;
>  
>  	switch (conf->type) {
>  	case IEEE80211_IF_TYPE_STA:
> -	case IEEE80211_IF_TYPE_MNTR:
>  		priv->mode = conf->type;
>  		break;
>  	default:
>  		return -EOPNOTSUPP;
>  	}
>  
> -	priv->mac_addr = conf->mac_addr;
> +	ADM8211_IDLE();
> +
> +	ADM8211_CSR_WRITE(PAR0, *(u32 *)conf->mac_addr);
> +	ADM8211_CSR_WRITE(PAR1, *(u16 *)(conf->mac_addr + 4));

This is broken on BigEndian platforms.
use cpu_to_leX().
You can also replace the handcoded endianness conversion in
adm8211_set_bssid by cpu_to_leX().

> +	adm8211_update_mode(dev);
> +
> +	ADM8211_RESTORE();
>  
>  	return 0;
>  }


-- 
Greetings Michael.
