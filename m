Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:35340 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbXHREFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 00:05:31 -0400
Date: Fri, 17 Aug 2007 21:04:23 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/20] mac80211: remove unused ioctls (1)
Message-ID: <20070818040423.GF1415@jm.kir.nu>
References: <20070815144920.135826000@sipsolutions.net> <20070815145043.551508000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070815145043.551508000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 15, 2007 at 04:49:25PM +0200, Johannes Berg wrote:
> The ioctls
> 
>  * PRISM2_PARAM_WIFI_WME_NOACK_TEST
>  * PRISM2_PARAM_HOST_ENCRYPT
>  * PRISM2_PARAM_HOST_DECRYPT
>  * PRISM2_PARAM_ANTENNA_MODE
>  * PRISM2_PARAM_STAT_TIME
>  * PRISM2_PARAM_SCAN_FLAGS
> 
> are not used by hostapd or wpa_supplicant.

No, but some of them can be assumed to be used with iwpriv.. First one
is useful should one be interested in WFA certifications tests. Scan
flags can be useful in filtering out scan results in cases where there
are huge numbers of APs around. I could agree with the other ones being
more or less useless here.

> --- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-08-15 14:04:46.906516958 +0200
> +++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-08-15 14:07:46.486516958 +0200
> @@ -3931,34 +3922,6 @@ ieee80211_sta_scan_result(struct net_dev

> -		if (!(local->scan_flags & IEEE80211_SCAN_EXTRA_INFO))
> -			break;

> -		memset(&iwe, 0, sizeof(iwe));
> -		iwe.cmd = IWEVCUSTOM;
> -		sprintf(buf, "bcn_int=%d", bss->beacon_int);
> -		iwe.u.data.length = strlen(buf);
> -		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,
> -						  buf);
> -
> -		memset(&iwe, 0, sizeof(iwe));
> -		iwe.cmd = IWEVCUSTOM;
> -		sprintf(buf, "capab=0x%04x", bss->capability);
> -		iwe.u.data.length = strlen(buf);
> -		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,
> -						  buf);

Even if you end up removing scan_flags, you could leave these pieces of
information available in scan results.

-- 
Jouni Malinen                                            PGP id EFC895FA
