Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab3LRRDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 12:03:05 -0500
Message-ID: <1387386179.4694.16.camel@jlt4.sipsolutions.net> (sfid-20131218_180309_391076_C82D529D)
Subject: Re: [PATCH] mac80211: fix iflist_mtx/mtx locking in radar detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Jones Desougi <jones.desougi@27m.se>
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de
Date: Wed, 18 Dec 2013 18:02:59 +0100
In-Reply-To: <52B1D446.9030808@27m.se> (sfid-20131218_175848_996438_4667D057)
References: <1387358026-25741-1-git-send-email-johannes@sipsolutions.net>
	 <52B1D446.9030808@27m.se> (sfid-20131218_175848_996438_4667D057)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-12-18 at 17:58 +0100, Jones Desougi wrote:
> One locking oddness below.

> > @@ -301,6 +302,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
> >  		sdata_info(sdata, "Failed to join IBSS, no channel context\n");
> >  		return;
> >  	}
> > +	mutex_unlock(&local->mtx);
> 
> At least looking at the patch only, the return above without unlock
> seems suspicious.

Indeed. But please trim your quotes in the future :)

johannes

