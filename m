Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:35993 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbYJVIMz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 04:12:55 -0400
Date: Wed, 22 Oct 2008 11:11:49 +0300
From: Jouni Malinen <j@w1.fi>
To: Rami Rosen <ramirose@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH ] mac80211: check return value of dev_alloc_skb() in
	ieee80211_sta_join_ibss().
Message-ID: <20081022081149.GE16005@jm.kir.nu> (sfid-20081022_101300_389804_685773F5)
References: <eb3ff54b0810220000p71a54f53ped88651b62c6d35c@mail.gmail.com> <1224660978.28639.27.camel@johannes.berg> <eb3ff54b0810220042y43ea248qba1064a3eedf85b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <eb3ff54b0810220042y43ea248qba1064a3eedf85b1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 09:42:37AM +0200, Rami Rosen wrote:

> Do we want to continue as usual if dev_alloc_skb() in theis method fails?

I think we should continue and as such, I would rather not see the patch
that proposes to abort here go in. The allocated skb is not used at this
point anyway; it is only used as an optimization to prepare a ProbeRsp
frame for possible future use. This could be done at the time when
ProbeReq is received (and we sent the last Beacon), i.e., only when
needed. Or if the optimization of generating this only once is
considered desirable, that place could try to allocate a new skb if the
one here failed (or do it on first need and cache the result).

-- 
Jouni Malinen                                            PGP id EFC895FA
