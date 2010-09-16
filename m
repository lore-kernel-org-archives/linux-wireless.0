Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42853 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab0IPJig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 05:38:36 -0400
Subject: Re: [PATCH] mac80211: Add WME information element for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20100916083431.14175.90366.stgit@tt-desk>
References: <20100916083431.14175.90366.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 11:37:33 +0200
Message-ID: <1284629853.3731.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-16 at 17:34 +0900, Bruno Randolf wrote:
> Enable WME QoS in IBSS mode by adding a WME information element to beacons and
> probe respones and by checking for it and marking stations as WME capable if it
> is present.

>  			rcu_read_unlock();
> -			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
> -					       supp_rates, GFP_KERNEL);
> +
> +			sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
> +					mgmt->sa, supp_rates, GFP_KERNEL);
>  		}
> +		if (sta && elems->wmm_info)
> +			set_sta_flags(sta, WLAN_STA_WME);

NACK, this is obviously racy.

johannes

