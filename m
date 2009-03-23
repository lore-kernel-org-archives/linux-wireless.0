Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2734 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264AbZCWTx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 15:53:59 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@iki.fi>
Cc: "Alexander E. Patrakov" <patrakov@gmail.com>,
	linux-wireless@vger.kernel.org, mb@bu3sch.de
Subject: Re: Kernel panic with zd1211rw and today's compat-wireless
Date: Mon, 23 Mar 2009 14:52:07 -0500
Message-Id: <20090323194523.M76544@bobcopeland.com> (sfid-20090323_205401_848589_F5053897)
In-Reply-To: <1237836988.6147.18.camel@johannes.local>
References: <20090322174515.22f11d92@home.aephome.ru> <1237726612.19647.2.camel@johannes.local> <b6c5339f0903220749j5373d132gdf24edc4d6ac610c@mail.gmail.com> <87iqm0s2dy.fsf@litku.valot.fi> (sfid-20090323_160900_704015_CEA0ADD2) <1237836988.6147.18.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 23 Mar 2009 20:36:28 +0100, Johannes Berg wrote
> I think I'm in favour of "downgrading" that to a WARN_ON, like this:
> 	if (WARN_ON(...))
> 		info->control.rates[0].idx = rate_lowest()
> 
> johannes

How about the similar WARN_ON() in ieee80211_get_tx_rate()?  Does
it make sense to try and tx a frame but return null for the rate
structure?

-- 
Bob Copeland %% www.bobcopeland.com


