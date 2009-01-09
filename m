Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33074 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756253AbZAIUxR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 15:53:17 -0500
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 09 Jan 2009 21:53:15 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20090108091055.GA7009@jm.kir.nu>
Message-ID: <20090109205315.277310@gmx.net> (sfid-20090109_215331_410082_C14D1BB6)
MIME-Version: 1.0
References: <20090106020130.302750@gmx.net> <20090108091055.GA7009@jm.kir.nu>
Subject: Re: [PATCH] Fixed BSSID step 3: Don't merge with the same BSSID
To: Jouni Malinen <j@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni!

> I agree that merge part (updating Beacon/ProbeRsp data) can be skippe=
d
> for same BSSID, but this change seems to break timesync by removing c=
all
> to local->ops->reset_tsf(). I don't think that that should be removed
> unconditionally.

Thanks for your comment.

> I would like to know whether that operation is causing
> any problems in citywide networks and if yes, it might be better to
> provide a configuration option to allow the timesync for IBSS to be
> disabled since not doing that could cause problems to power saving in
> IBSS (not that it is really implemented that widely).

As I see, only the sta_info_flush_delayed() call causes the problems. I=
 can only disable this call in the ieee80211_sta_join_ibss() function, =
if the BSSID is the same. Do you think this would be better?

> In other words, I would be fine if the calls to
> ieee80211_sta_join_ibss() and ieee80211_ibss_add_sta() are replaced w=
ith
> local->ops->reset_tsf() if BSSIDs are the same when
> beacon_timestamp>rx_timestamp.

This would be a way, too.

Regards
Alina

--=20
Sensationsangebot verl=E4ngert: GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K1308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
