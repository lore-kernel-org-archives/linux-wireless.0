Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab1E3JVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 05:21:55 -0400
Subject: Re: [rt2x00-users] [PATCH 1/3] rt2x00: Serialize TX operations on
 a queue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
In-Reply-To: <201105300955.43779.helmut.schaa@googlemail.com> (sfid-20110530_095755_602931_64334292)
References: <cover.1306586311.git.gwingerde@gmail.com>
	 <201105281647.35855.helmut.schaa@googlemail.com>
	 <4DE288DB.7040309@gmail.com>
	 <201105300955.43779.helmut.schaa@googlemail.com>
	 (sfid-20110530_095755_602931_64334292)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 11:03:06 +0200
Message-ID: <1306746186.3745.1.camel@jlt3.sipsolutions.net> (sfid-20110530_112159_004767_2BB9F128)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-30 at 09:55 +0200, Helmut Schaa wrote:

> > >> AFAICT not all tx calls from mac80211 are protected by local_bh_disable/enable. I believe
> > >> that this is the case for the "process" context tx calls from
> > > 
> > >> ieee80211_subif_start_xmit
> > > 
> > > This should only be called from the network softirq and thus doesn't require bottom halves
> > > to be disabled (AFAIK).
> > > 
> > >> and
> > >> ieee80211_monitor_start_xmit.
> > > 
> > > Same here.
> > 
> > Hmm, are you sure about this?
> 
> Maybe Johannes can clarify this for us ;)

The above assertion ("not all TX calls are protected") is wrong.

> Johannes, are all calls to the drivers tx callback done in softirq context or
> adequately protected by local_bh_disable/enable? Or is this presumption wrong?

All of them are invoked with BHs disabled.

Cf. ieee80211_tx_skb(), which is the only function that can be called
from process context. The _start_xmit functions listed above are called
by the networking layer and always invoked with BHs disabled.

johannes

