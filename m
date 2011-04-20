Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1DTTAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 15:00:07 -0400
Subject: RE: [PATCH v2] wireless: mwifiex: initial commit for Marvell
 mwifiex driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Ramesh Radhakrishnan <rramesh@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F704307FAAC2955@SC-VEXCH1.marvell.com>
References: <1299873746-29484-1-git-send-email-bzhao@marvell.com>
	 <1299874885.4320.5.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307FA4C2D82@SC-VEXCH1.marvell.com>
	 <1300190698.5596.15.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307FAAC2955@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 21:00:02 +0200
Message-ID: <1303326002.3619.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-04-20 at 11:44 -0700, Bing Zhao wrote:
> > In mac80211 have a module parameter "ieee80211_disable_40mhz_24ghz"
> > which, for backward compatibility reasons, actually defaults to false,
> > so you need to set it to true to get a compliant system. When a system
> > is integrated, this parameter can be set as default.
> > 
> > I don't think it really is necessary to set this at runtime.
> > 
> > I guess I see two options:
> >  1) move the module parameter to cfg80211, and check the sdata HT config
> >     in the driver again when this is needed
> 
> Hi Johannes,
> 
> The change below adopts your idea of moving ieee80211_disable_40mhz_24ghz from mac80211 to cfg80211. Could you please review it? I will resend the patch if it looks OK for you.
>  
> ---
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index d30eada..1cdc43e 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1974,6 +1974,7 @@ extern int ieee80211_radiotap_iterator_next(
>  
>  extern const unsigned char rfc1042_header[6];
>  extern const unsigned char bridge_tunnel_header[6];
> +extern bool cfg80211_disable_40mhz_24ghz;
>  
>  /**
>   * ieee80211_get_hdrlen_from_skb - get header length from data
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 0ab2a8d..4290b50 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -33,12 +33,6 @@
>  #include "cfg.h"
>  #include "debugfs.h"
>  
> -
> -static bool ieee80211_disable_40mhz_24ghz;
> -module_param(ieee80211_disable_40mhz_24ghz, bool, 0644);
> -MODULE_PARM_DESC(ieee80211_disable_40mhz_24ghz,
> -		 "Disable 40MHz support in the 2.4GHz band");
> -
>  static struct lock_class_key ieee80211_rx_skb_queue_class;
>  
>  void ieee80211_configure_filter(struct ieee80211_local *local)
> @@ -729,11 +723,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  		channels += sband->n_channels;
>  
>  		/*
> -		 * Since ieee80211_disable_40mhz_24ghz is global, we can
> +		 * Since cfg80211_disable_40mhz_24ghz is global, we can
>  		 * modify the sband's ht data even if the driver uses a
>  		 * global structure for that.
>  		 */
> -		if (ieee80211_disable_40mhz_24ghz &&
> +		if (cfg80211_disable_40mhz_24ghz &&
>  		    band == IEEE80211_BAND_2GHZ &&
>  		    sband->ht_cap.ht_supported) {
>  			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;

Well, I think in that case this code should also be moved.

johannes

