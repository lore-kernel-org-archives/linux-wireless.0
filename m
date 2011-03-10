Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53880 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab1CJHuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 02:50:07 -0500
Subject: Re: [PATCH] mac80211: do not enable ps if 802.1x controlled port
 is unblocked
From: Johannes Berg <johannes@sipsolutions.net>
To: Jason Young <a.young.jason@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimm0umg3rZDwYU4KGLbaCQgAA_QKCpoY9NiscLT@mail.gmail.com>
References: <AANLkTimm0umg3rZDwYU4KGLbaCQgAA_QKCpoY9NiscLT@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 08:51:39 +0100
Message-ID: <1299743499.3819.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-09 at 18:56 -0800, Jason Young wrote:

> +++ b/net/mac80211/cfg.c
> @@ -834,6 +834,9 @@ static int ieee80211_change_station(struct wiphy *wiphy,
> 
>  	rcu_read_unlock();
> 
> +	if (params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED))
> +		ieee80211_recalc_ps(local, -1);
> +

I think we can restrict this to station interfaces too, since for others
powersave will already be off. That way, APs don't need to run the
function all the time.

johannes

