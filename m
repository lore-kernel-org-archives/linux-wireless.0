Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:3723 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751163Ab0G2CLS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 22:11:18 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0311209475
	for <linux-wireless@vger.kernel.org>; Thu, 29 Jul 2010 11:11:16 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH v4 1/3] cfg80211: Add nl80211 antenna configuration
Date: Thu, 29 Jul 2010 11:11:27 +0900
Cc: Felix Fietkau <nbd@openwrt.org>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20100727094732.27186.30900.stgit@tt-desk> <201007281106.06813.br1@einfach.org> <AANLkTimBu2=9XhzKwUi1ZpRmGWA+C4GCDgXqp-YJVLxt@mail.gmail.com>
In-Reply-To: <AANLkTimBu2=9XhzKwUi1ZpRmGWA+C4GCDgXqp-YJVLxt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201007291111.27417.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu July 29 2010 02:24:46 Luis R. Rodriguez wrote:
> So if you want to define an API I do believe its best to treat these
> separately, for legacy I think your API can be fine tuned to consider
> FIXED_A, FIXED_B, or DIVERSITY. 

hi luis, 

i already tried to explain several times why FIXED_A, FIXED_B, or DIVERSITY is 
not enough even for "legacy". please re-read the mails and the description of 
the first patch - i really don't want to re-iterate it *again*. thanks :)

as felix pointed out, it's best to think of this as the antenna mask, which 
can be used to mask out antennas which are not attached or should not be used. 
it does not matter if the device is "legacy" or 802.11n or "802.11xyz" - we 
can always use this API to inform mac80211 / the driver about the available 
antennas if they are in fact different from the default HW settings. based on 
this information 802.11n drivers can derive which chainmasks to use, and in 
some cases wether diversity should be used; "legacy" drivers can derive wether 
to use diversity or not.

actually thinking about it like this, i would like to remove the special 
casing of "0" for tx diversity (which means go back to my original proposal): 
if an antenna can be used for TX it should be set to one in the mask, and the 
driver can enable diversity or mulitple chainmasks as suitable.

> Would we keep two values for some of these settings, an "actual hw"
> capablity and then also a "configured" values? Would this be exposed
> and visible through iw?

the actual HW capability could be exported via the wiphy info as well, but i 
think this could be dealt with in a seperate patch, as well as other 
improvements. for now let's just define an API for an antenna mask, which can 
be used to mask out antennas seperately for RX and TX.

i'll try to make that more clear in the descriptions and re-send my proposal.

bruno
