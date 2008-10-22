Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:36787 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225AbYJVS5I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 14:57:08 -0400
Date: Wed, 22 Oct 2008 21:55:58 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rami Rosen <ramirose@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH ] mac80211: check return value of dev_alloc_skb() in
	ieee80211_sta_join_ibss().
Message-ID: <20081022185558.GJ16005@jm.kir.nu> (sfid-20081022_205719_363538_8D14A79C)
References: <eb3ff54b0810220000p71a54f53ped88651b62c6d35c@mail.gmail.com> <1224660978.28639.27.camel@johannes.berg> <eb3ff54b0810220042y43ea248qba1064a3eedf85b1@mail.gmail.com> <20081022081149.GE16005@jm.kir.nu> <1224663453.28639.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1224663453.28639.37.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 10:17:33AM +0200, Johannes Berg wrote:

> Good point. We currently don't try again, but we could put this into a
> new function and call it from when we need it. Then again, we'll need it
> right away, the driver will probably call _get_beacon from
> ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);

Yes.. I forgot about that and only looked at probe_resp references
inside mlme.c. With that in mind, it probably is cleaner to make
ieee80211_sta_join_ibss() fail if it cannot allocate an skb for
ProbeResp. If we are going to be doing some cleanup here, I would
suggest moving the proberesp building into a helper function and just do
skb = ieee80211_sta_build_probe_resp(...); if (!skb) return -ENOMEM; in
ieee80211_sta_join_ibss().

-- 
Jouni Malinen                                            PGP id EFC895FA
