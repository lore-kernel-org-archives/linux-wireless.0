Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10808 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbYJTItu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 04:49:50 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 01:49:50 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18684.17816.702853.44986@gargle.gargle.HOWL> (sfid-20081020_104954_022341_6148C640)
Date: Mon, 20 Oct 2008 14:17:20 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
In-Reply-To: <1224492335.18024.34.camel@johannes.berg>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	<1224491480.18024.32.camel@johannes.berg>
	<43e72e890810200135o1581c904i456a35298f8a56a9@mail.gmail.com>
	<1224492335.18024.34.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
 > On Mon, 2008-10-20 at 01:35 -0700, Luis R. Rodriguez wrote:
 > 
 > > >> + *   @is_part_ampdu: set to indicate that the wireless core should should
 > > >> + *           treat this frame as part of an AMPDU
 > > >
 > > > I thought we said we could keep the flag instead of moving to the skb
 > > > here?
 > > 
 > > That was just because the changes required to add this was too much
 > > for 2.6.27 but since we don't care about this fix in 2.6.27 we can do
 > > whatever is needed to fix this properly.
 > 
 > Right, but adding random stuff into skb isn't really "properly" imho.
 > And we don't really need this afaict.
 > 

Sorry, just saw that Tomas had fixed it by setting the flag in ieee80211_tx_h_sequence().
Will fix that.

Sujith
