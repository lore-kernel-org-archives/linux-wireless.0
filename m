Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3LDWXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 17:23:53 -0500
Message-ID: <1386195829.7669.3.camel@jlt4.sipsolutions.net> (sfid-20131204_232357_063939_DBA72C77)
Subject: Re: question for mac80211 driver maintainers - RCU usage in drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 04 Dec 2013 23:23:49 +0100
In-Reply-To: <1409469.QTj73PAUiY@blech> (sfid-20131204_231634_444573_6B69F370)
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
	 <1409469.QTj73PAUiY@blech> (sfid-20131204_231634_444573_6B69F370)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-12-04 at 23:16 +0100, Christian Lamparter wrote:

> > Is there any other driver that assumes it is safe to delete a station
> > pointer in the sta_state callback and not use synchronize_rcu()? From
> > looking at the code, I don't see any, but I can't really be sure that
> > everyone uses __rcu annotations correctly ... :)

> No, carl9170 doesn't use sta_state but it uses sta_remove. 

Yeah, I actually saw this. But I think you use it for aggregation
sessions only? And the code didn't look like it could still get to the
station pointer after it was removed with sta_remove() callback, but I
may be wrong.

> I'm curious: how you would achieve this feat? After all, mac80211's
> tx- and rx-paths currently relies on RCU protected station pointers 
> too (and all that goes along with it. e.g.: ampdu sessions, keys, ...)?

Oh, that'll stay. But right now we do *two* things:
 a) synchronize_net() to protect against mac80211
 b) rcu_barrier() stuff (see commit b22cfcfca) to protect again

It seems to me if the drivers don't assume RCU grace period after
sta_state/sta_remove, then the second one can go away.

> > PS: I'll probably have to add another callback "sta going away before
> > RCU" so you can invalidate pointers there ... otherwise I'd have to
> > synchronize_rcu() in iwlmvm which would kinda defeat the purpose.
> hm, invalidating ampdu sessions is going to be tricky isn't it?
> But ok, some time ago I played around with moving the complicated
> amdpu scheduler of carl9170 into the (single-threaded) firmware.
> So large parts of carl9170's code which uses rcu in this context would
> become "unnecessary".
> 
> I didn't merge the patch - since there was no obvious benefit - but
> I still have them and they can be revived if needed.

No, don't worry. I'm keeping the aggregation session guarantees even,
right now I'm not touching that so each aggregation session still uses
synchronize_rcu() etc.

johannes

