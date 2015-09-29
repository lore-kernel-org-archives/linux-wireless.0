Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43915 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965474AbbI2N6x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 09:58:53 -0400
Message-ID: <1443535128.7642.1.camel@sipsolutions.net> (sfid-20150929_155909_927255_97CA7109)
Subject: Re: [PATCH] mac80211: fix oops in ieee80211_beacon_get_tim
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Cc: helmut.schaa@googlemail.com
Date: Tue, 29 Sep 2015 15:58:48 +0200
In-Reply-To: <1673287.PfdWxMzLgk@debian64> (sfid-20150928_205842_634580_234F439A)
References: <1673287.PfdWxMzLgk@debian64>
	 (sfid-20150928_205842_634580_234F439A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-09-28 at 20:58 +0200, Christian Lamparter wrote:
> This patch fixes a crash which is triggered
> by __ieee80211_beacon_get returning NULL.
> This causes sky_copy to crash later unless
> the hardware supports BEACON_TX_STATUS
> feature.
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> "mac80211: Copy tx'ed beacons to monitor mode" added the skb_copy.
> There are few other possibilities to do this. This is just one.

Thanks, I rebased this in ...

johannes
