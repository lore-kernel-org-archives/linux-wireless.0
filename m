Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37321 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752388AbXBHSKs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 13:10:48 -0500
Date: Thu, 8 Feb 2007 19:10:46 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Michael Wu <flamingice@sourmilk.net>, netdev@vger.kernel.org,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] d80211: Add control structure for beacontemplates
Message-ID: <20070208191046.457f17ed@griffin.suse.cz>
In-Reply-To: <200702060046.45560.IvDoorn@gmail.com>
References: <200702031725.19080.IvDoorn@gmail.com>
	<20070205212802.36477fd4@griffin.suse.cz>
	<200702060046.45560.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 6 Feb 2007 00:46:45 +0100, Ivo van Doorn wrote:
> --- dscape/net/d80211/ieee80211.c	2007-02-06 00:19:38.000000000 +0100
> +++ dscape.control/net/d80211/ieee80211.c	2007-02-06 00:25:26.000000000 +0100
> @@ -1857,7 +1857,8 @@ ieee80211_get_buffered_bc(struct ieee802
>  EXPORT_SYMBOL(ieee80211_get_buffered_bc);
>  
>  static int __ieee80211_if_config(struct net_device *dev,
> -				 struct sk_buff *beacon)
> +				 struct sk_buff *beacon,
> +				 struct ieee80211_tx_control *control)
>  {
>  	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>  	struct ieee80211_local *local = dev->ieee80211_ptr;
> @@ -1881,6 +1882,7 @@ static int __ieee80211_if_config(struct 
>  		conf.generic_elem = sdata->u.ap.generic_elem;
>  		conf.generic_elem_len = sdata->u.ap.generic_elem_len;
>  		conf.beacon = beacon;
> +		memcpy(&conf.beacon_control, control, sizeof(*control));

We can save this memcpy if ieee80211_if_conf.beacon_control is just a
pointer.

With the exception of this, the patch looks good now.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
