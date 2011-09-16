Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58930 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab1IPM7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 08:59:46 -0400
Subject: Re: [RFC 2/5] mac80211: handle TDLS high-level commands and frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
In-Reply-To: <1316082334-7664-3-git-send-email-arik@wizery.com> (sfid-20110915_122551_202876_5B22F090)
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
	 <1316082334-7664-3-git-send-email-arik@wizery.com>
	 (sfid-20110915_122551_202876_5B22F090)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 14:59:45 +0200
Message-ID: <1316177985.4130.29.camel@jlt3.sipsolutions.net> (sfid-20110916_145949_299193_E0237752)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:

> +	case NL80211_TDLS_ENABLE_LINK:
> +		rcu_read_lock();
> +		sta = sta_info_get(sdata, peer);
> +		if (sta) {
> +			set_sta_flags(sta, WLAN_STA_AUTHORIZED);
> +			sta->tdls_link_enabled = true;
> +		}
> +		rcu_read_unlock();
> +		break;

This seems to require the station already having been added, but
couldn't this create the data race you were worried about? Could you not
simply just create the station once it is authorized?

> +	case NL80211_TDLS_DISABLE_LINK:
> +		rcu_read_lock();
> +		sta = sta_info_get(sdata, peer);
> +		if (sta) {
> +			sta->tdls_link_enabled = false;
> +			sta_info_destroy_addr(sdata, peer);
> +		}
> +		rcu_read_unlock();
> +		break;

Isn't that equivalent to just deleting the station?

johannes

