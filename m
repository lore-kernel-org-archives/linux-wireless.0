Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab1COSlf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 14:41:35 -0400
Subject: Re: bug: iwlwifi, aggregation, and mac80211's reorder buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTinfEU2HNAg7aTmMgSrR6vVyVwLbFmpcP9TL4GyK@mail.gmail.com>
References: <AANLkTi=taszKd9-kyijN100oEegnFi=0u5L4WCp7R_sJ@mail.gmail.com>
	 <1299831238.5082.185.camel@wwguy-huron>
	 <AANLkTikYJQcpOnE+Q3=VFioEfpdB+8j+x7+-K_eSU7kd@mail.gmail.com>
	 <1300063647.24333.7.camel@wwguy-ubuntu>
	 <AANLkTin_=k=7Y0XmEtZc952pm=wuCawJAXgq6fKFWZM+@mail.gmail.com>
	 <1300189917.5596.10.camel@jlt3.sipsolutions.net>
	 <1300193550.5596.16.camel@jlt3.sipsolutions.net>
	 <AANLkTinfEU2HNAg7aTmMgSrR6vVyVwLbFmpcP9TL4GyK@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 19:41:26 +0100
Message-ID: <1300214486.4139.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-15 at 11:16 -0700, Daniel Halperin wrote:

> There's still something off about the window size: unlike with ath9k,
> the receiver does continually print out warnings about advancing its
> window. There's something very fishy here: for any given aggregation
> session, the part of the sequence number space this happens is always
> the same! Really weird. Here's a log from 3 agg sessions in a row,
> just running simple TCP iperf:
> 
> [341221.679710] New seq exceeds buffering window: 283, 250

Ok thanks for the patch, I'll still reply here though.


> [341398.950019] iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra =
> 00:16:ea:c3:b3:8e tid = 0
> [341401.790964] New seq exceeds buffering window: 2335, 2304

So the delta is always 31, it seems? Is iwlwifi consistently sending
batches of 32 instead of the advertised 31?

Also -- don't get confused, the tx_agg_start is on its own TX agg
session, but the new seq stuff is on its RX agg session.

johannes

