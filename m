Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50462 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbcF2HRj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 03:17:39 -0400
Message-ID: <1467184655.2461.2.camel@sipsolutions.net> (sfid-20160629_091803_915551_59BA2D20)
Subject: Re: [PATCH 3/4] mac80211: mesh: fixed HT ies in beacon template
From: Johannes Berg <johannes@sipsolutions.net>
To: Yaniv Machani <yanivma@ti.com>, linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Meirav Kama <meiravk@ti.com>
Date: Wed, 29 Jun 2016 09:17:35 +0200
In-Reply-To: <20160628111307.8784-4-yanivma@ti.com> (sfid-20160628_131116_981554_64C22D92)
References: <20160628111307.8784-1-yanivma@ti.com>
 <20160628111307.8784-2-yanivma@ti.com>
 <20160628111307.8784-3-yanivma@ti.com>
	 <20160628111307.8784-4-yanivma@ti.com>
	 (sfid-20160628_131116_981554_64C22D92)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-06-28 at 14:13 +0300, Yaniv Machani wrote:
> 
>  net/mac80211/mesh.c | 33 ++++++++++++++++++++++++++++++++-
>  net/mac80211/util.c |  3 ---
>  net/wireless/mesh.c |  2 +-

That's not a good patch - one change is mac80211 and the other
cfg80211.

> -	.ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED,
> +	.ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_NONE,
> 
How are you planning to comply with 802.11 now?


The HT Protection field in a mesh STA may be set to no protection mode
only if
— All STAs detected in the primary or the secondary channel are HT
  STAs, and
— All mesh STA members of this MBSS that are one-hop neighbors of the
  transmitting mesh STA are either:
  — 20/40 MHz HT mesh STAs in a 20/40 MHz MBSS, or
  — 20 MHz HT mesh STAs in a 20 MHz MBSS.

johannes
