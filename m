Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:40201 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816Ab1FTQwo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 12:52:44 -0400
From: Yogesh Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
Date: Mon, 20 Jun 2011 09:49:44 -0700
Subject: RE: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
Message-ID: <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com> (sfid-20110620_185247_442296_7AA735A4)
References: <20110616102138.GA24447@hertz.marvell.com>
	 <20110616102707.GB24458@hertz.marvell.com>
	 <d38dc36c1ab9a4bd819b9bcbbda181da@secure.sipsolutions.net>
	 <20110617132527.GA27436@hertz.marvell.com>
	 <1308331485.7329.2.camel@Nokia-N900-51-1>
	 <20110620143051.GA31035@hertz.marvell.com>,<1308583799.4322.9.camel@jlt3.sipsolutions.net>
In-Reply-To: <1308583799.4322.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>No, they're not, the mutex trickery seems completely pointless, and the
>conditional (on _is_locked no less) locking is horrible.
Ok.

Will spend some more time on exploring solutions using rcu primitives only
(synchronize_net or something similar).

If nothing  of only-RCU is feasible then, I think, we need to resize the skb if it has
already skipped the tailroom instead of WARN_ON. This will come in to picuture
only during the race cases. But this wont get rid of race.

Thanks
Yogesh
