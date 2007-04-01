Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbXDAArE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2007 20:47:04 -0400
Subject: Re: mac80211 does not support WPA when used with wext
From: Dan Williams <dcbw@redhat.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: dragoran dragoran <drago01@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@redhat.com>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <200703311700.52792.flamingice@sourmilk.net>
References: <460E2B8C.4030002@gmail.com>
	 <200703311503.53445.flamingice@sourmilk.net>
	 <f6ca9fed0703311256m1b14ec35p836a62de532dd804@mail.gmail.com>
	 <200703311700.52792.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 20:50:24 -0400
Message-Id: <1175388624.10282.0.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-03-31 at 17:00 -0400, Michael Wu wrote:
> On Saturday 31 March 2007 15:56, dragoran dragoran wrote:
> > also networkmanager and hal think that the card only supports wep...
> > thx for the patch...
> > does it adress this issues?
> No, this has nothing to do with that. The following patch should address that 
> issue, but my copy of networkmanager already does WPA fine so I can't say for 
> sure whether it will help or not. A quick look through the networkmanager 
> code seems to suggest this will work.

Correct; NM won't allow WPA unless the driver explicitly advertises
support for it.

Acked-by: Dan Williams <dcbw@redhat.com>

> --
> 
> mac80211: set enc_capa
> 
> From: Michael Wu <flamingice@sourmilk.net>
> 
> Update we_version_source and set enc_capa in iw_range.
> 
> Signed-off-by: Michael Wu <flamingice@sourmilk.net>
> ---
> 
>  net/mac80211/ieee80211_ioctl.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
> index b28e794..d139d97 100644
> --- a/net/mac80211/ieee80211_ioctl.c
> +++ b/net/mac80211/ieee80211_ioctl.c
> @@ -1583,7 +1583,7 @@ static int ieee80211_ioctl_giwrange(struct net_device 
> *dev,
>  	memset(range, 0, sizeof(struct iw_range));
>  
>  	range->we_version_compiled = WIRELESS_EXT;
> -	range->we_version_source = 14;
> +	range->we_version_source = 21;
>  	range->retry_capa = IW_RETRY_LIMIT;
>  	range->retry_flags = IW_RETRY_LIMIT;
>  	range->min_retry = 0;
> @@ -1603,6 +1603,9 @@ static int ieee80211_ioctl_giwrange(struct net_device 
> *dev,
>  	range->avg_qual.noise = 0;
>  	range->avg_qual.updated = local->wstats_flags;
>  
> +	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
> +			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
> +
>  	return 0;
>  }
>  

