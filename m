Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1HaFLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 01:11:42 -0400
Subject: Re: [PATCH] mac80211: Defer tranmission of mesh path errors
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <CAPjQAd-CLvvn_1efsC_FjgoPSkyxiXC3c9yDGFzgPC4ts9Ay3w@mail.gmail.com> (sfid-20110831_035119_097014_0B067F99)
References: <1314706867.4011.25.camel@jlt3.sipsolutions.net>
	 <1314728954-22646-1-git-send-email-javier@cozybit.com>
	 <1314729813.4011.43.camel@jlt3.sipsolutions.net>
	 <CAPjQAd9Fyu-MQSvi+aa4VwwWBTo_Brf=jCvAEnLdQZaJvjvu=Q@mail.gmail.com>
	 <CAPjQAd-CLvvn_1efsC_FjgoPSkyxiXC3c9yDGFzgPC4ts9Ay3w@mail.gmail.com>
	 (sfid-20110831_035119_097014_0B067F99)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 07:11:34 +0200
Message-ID: <1314767494.4161.2.camel@jlt3.sipsolutions.net> (sfid-20110831_071148_081369_68DC4780)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-30 at 18:50 -0700, Javier Cardona wrote:

> The stress tests do trigger perrs and, with this change, we see a
> warning due to missing info->control.vif
> 
> [14202.988077] ------------[ cut here ]------------
> [14202.988351] WARNING: at net/mac80211/util.c:358
> ieee80211_add_pending_skb+0x97/0xa0()

Interesting. Ok, that means we can't just use add_pending_skb(), we need
to do some setup before, all the setup that ieee80211_tx_skb() and
ieee80211_xmit() would do up to ieee80211_tx()...

I guess we need a little bit of helper code to enable this.

johannes

