Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:56371 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946474AbXBIOZ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 09:25:56 -0500
Date: Fri, 9 Feb 2007 15:25:40 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: fix authentication issues
Message-ID: <20070209152540.32a23571@griffin.suse.cz>
In-Reply-To: <200702081448.19664.flamingice@sourmilk.net>
References: <200702081448.19664.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 8 Feb 2007 14:48:15 -0500, Michael Wu wrote:
> @@ -2355,7 +2358,7 @@ int ieee80211_sta_set_bssid(struct net_d
>  		ifsta->bssid_set = 0;
>  	else
>  		ifsta->bssid_set = 1;
> -	if (ifsta->ssid_set && ifsta->state != IEEE80211_AUTHENTICATE)
> +	if (ifsta->ssid_set)
>  		ieee80211_sta_new_auth(dev, ifsta);

How do you protect against already running ieee80211_associate (called
from ieee80211_sta_work)?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
