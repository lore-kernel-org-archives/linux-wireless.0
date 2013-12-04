Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab3LDWvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 17:51:54 -0500
Message-ID: <1386197511.7669.6.camel@jlt4.sipsolutions.net> (sfid-20131204_235157_936716_440F37D1)
Subject: Re: question for mac80211 driver maintainers - RCU usage in drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 04 Dec 2013 23:51:51 +0100
In-Reply-To: <3284918.YsYQbnYjhH@blech> (sfid-20131204_234714_914088_FAFC5473)
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
	 <1409469.QTj73PAUiY@blech> <1386195829.7669.3.camel@jlt4.sipsolutions.net>
	 <3284918.YsYQbnYjhH@blech> (sfid-20131204_234714_914088_FAFC5473)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-12-04 at 23:47 +0100, Christian Lamparter wrote:
> On Wednesday, December 04, 2013 11:23:49 PM Johannes Berg wrote:
> > On Wed, 2013-12-04 at 23:16 +0100, Christian Lamparter wrote:
> > > > Is there any other driver that assumes it is safe to delete a station
> > > > pointer in the sta_state callback and not use synchronize_rcu()? From
> > > > looking at the code, I don't see any, but I can't really be sure that
> > > > everyone uses __rcu annotations correctly ... :)
> > 
> > > No, carl9170 doesn't use sta_state but it uses sta_remove. 
> > 
> > Yeah, I actually saw this. But I think you use it for aggregation
> > sessions only? And the code didn't look like it could still get to the
> > station pointer after it was removed with sta_remove() callback, but I
> > may be wrong.
> no, you are not wrong. The code gets its sta pointers either from 
> callback-parameters or via ieee80211_get_sta. [But would it even be
> possible to do it any other way? After all, this should crash "sooner
> or later" otherwise].

Yeah that's what I thought. Both of those are obviously fine. In iwlmvm,
we have something like this:

 struct ieee80211_sta __rcu *our_stations[16];

and then just set it to NULL (well, simplifying a bit) on sta_remove
(actually sta_state.)

This is safe because after sta_state/sta_remove, mac80211 still does
call_rcu() to really free the station, but it's kinda pointless. By
adding the callback I'd suggested before to set this to NULL before the
synchronize_net() in mac80211, I think we can get rid of the whole
call_rcu() stuff.

Anyway, right now my patch is breaking iwlmvm, I'll try to sort that out
tomorrow and then post patches.

johannes

