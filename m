Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56482 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab2KQJ1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 04:27:39 -0500
Message-ID: <1353144493.9543.30.camel@jlt4.sipsolutions.net> (sfid-20121117_102743_239795_574E10C7)
Subject: Re: [RFC 10/14] mac80211: enable frame buffering for PS STA
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org
Date: Sat, 17 Nov 2012 10:28:13 +0100
In-Reply-To: <1353134886-13256-11-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353134886-13256-11-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 22:48 -0800, Marco Porsch wrote:

> @@ -1189,7 +1190,8 @@ int ieee80211_sta_ps_transition(struct ieee80211_sta *sta, bool start)
>  	struct sta_info *sta_inf = container_of(sta, struct sta_info, sta);
>  	bool in_ps;
>  
> -	WARN_ON(!(sta_inf->local->hw.flags & IEEE80211_HW_AP_LINK_PS));
> +	WARN_ON(!(sta_inf->local->hw.flags & IEEE80211_HW_AP_LINK_PS) &&
> +		!ieee80211_vif_is_mesh(&sta_inf->sdata->vif));

NACK. This is a public function for *driver* use, don't randomly use and
modify it.

johannes

