Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab0JAIN5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 04:13:57 -0400
Subject: Re: [PATCH] mac80211: Add WME information element for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <201010011415.33117.br1@einfach.org>
References: <20100916083431.14175.90366.stgit@tt-desk>
	 <1284629853.3731.0.camel@jlt3.sipsolutions.net>
	 <201010011415.33117.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 10:13:53 +0200
Message-ID: <1285920833.3739.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 14:15 +0900, Bruno Randolf wrote:

> +                       if (elems->wmm_info)
> +                               set_sta_flags(sta, WLAN_STA_WME);
>                         rcu_read_unlock();
>                 } else {
>                         rcu_read_unlock();
> -                       ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
> -                                              supp_rates, GFP_KERNEL);
> +
> +                       sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
> +                                       mgmt->sa, supp_rates, GFP_KERNEL);
> +                       if (sta && elems->wmm_info)
> +                               set_sta_flags(sta, WLAN_STA_WME);

If you want to use the sta pointer, you need this code to be before
rcu_read_unlock(), not after.

johannes

