Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:14136 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752541Ab0HBEN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 00:13:56 -0400
Received: from vs3007.wh2.ocn.ne.jp (125.206.180.235)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0622542434
	for <linux-wireless@vger.kernel.org>; Mon,  2 Aug 2010 13:13:55 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH v5] cfg80211: Add nl80211 antenna configuration
Date: Mon, 2 Aug 2010 13:13:54 +0900
Cc: johannes@sipsolutions.net, linville@tuxdriver.com, nbd@openwrt.org,
	linux-wireless@vger.kernel.org
References: <20100729035820.5930.29864.stgit@tt-desk> <201007291812.28639.br1@einfach.org> <AANLkTi=ihY=pAmKaEp7Pga=DOxwASZqSxqmURbgnks-d@mail.gmail.com>
In-Reply-To: <AANLkTi=ihY=pAmKaEp7Pga=DOxwASZqSxqmURbgnks-d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201008021313.54850.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri July 30 2010 00:04:49 Luis R. Rodriguez wrote:
> >> I don't want to do any work myself on drivers for this, can we have
> >> cfg80211/mac80211 do this for us?
> > 
> > is this not a separate issue from defining the API? you could have it do
> > this for you even now, with or without the antenna API, no?
> 
> It depends on the consumer and at what level we think the consumer
> should be doing whatever checks or changes it should. For starters I
> would expect at least a check for association within cfg80211 which
> disallows hw config changes. 

for ath5k at least, it's o.k. to change antenna configuration during 
association.

if 802.11n devices cannot change antenna setup during association, the driver 
could simply reject the configuration. but i can see that it can make sense to 
handle some of this in cfg80211 or mac80211. it should be possible to add that 
on top of my patches.

i think you are expecting to much. for now i just want to define an API which 
1) can be used right now and 2) is flexible enough to support 802.11n devices. 
as i don't work with 802.11n devices right now, please don't expect me to 
solve all 802.11n related antenna problems. as long as the API is flexible 
enough i think it can be added later as 802.11n devices are going to accept 
antenna configuration.

bruno
