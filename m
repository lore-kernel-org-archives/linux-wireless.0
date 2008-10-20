Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19998 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbYJTJO3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 05:14:29 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 02:14:29 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18684.19295.102997.125484@gargle.gargle.HOWL> (sfid-20081020_111456_999985_5C326883)
Date: Mon, 20 Oct 2008 14:41:59 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
In-Reply-To: <1224493469.18024.38.camel@johannes.berg>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	<1224491480.18024.32.camel@johannes.berg>
	<43e72e890810200135o1581c904i456a35298f8a56a9@mail.gmail.com>
	<1224492335.18024.34.camel@johannes.berg>
	<18684.17816.702853.44986@gargle.gargle.HOWL>
	<43e72e890810200155wbe01660xe3f53de80dc7357d@mail.gmail.com>
	<1224493038.18024.36.camel@johannes.berg>
	<43e72e890810200201l49eea95h2f67615b536311aa@mail.gmail.com>
	<1224493469.18024.38.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
 > On Mon, 2008-10-20 at 02:01 -0700, Luis R. Rodriguez wrote:
 > 
 > > > Well the fact that it's in tx_h_sequence is a bit weird, but we should
 > > > be able to get around not using an extra bit in skb I think. Especially
 > > > for this since it's only really between the driver and mac80211, and
 > > > after a requeue the ampdu status might actually change.
 > > 
 > > Good point. I failed to see that. So in that case it should be as
 > > sujith had it before my suggestion and just handle it as he had it in
 > > the tx handlers. The problem though is that the RC algorithm should be
 > > the one to determine if an skb is part of an ampdu for aggregation or
 > > not IMHO. Actually this is the real question and hot topic.
 > > 
 > > When should we aggregate and should mac80211 decide that or be left to the RC.
 > 
 > No, the RC algorithm cannot decided that, the RC algorithm can merely
 > decide when to set up/tear down aggregation sessions. When a session is
 > up all packet belonging to that TID should go into it, surely?

Right, ath9k currently tries to open an aggregation session for
each station that it is associated with. RC doesn't determine anything now.

Sujith

