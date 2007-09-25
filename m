Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60676
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbXIYVac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 17:30:32 -0400
Date: Tue, 25 Sep 2007 14:30:10 -0700 (PDT)
Message-Id: <20070925.143010.112603042.davem@davemloft.net>
To: mb@bu3sch.de
Cc: johannes@sipsolutions.net, kune@deine-taler.de, dsd@gentoo.org,
	linux-wireless@vger.kernel.org
Subject: Re: zd1211 or mac80211: SKB invalid truesize
From: David Miller <davem@davemloft.net>
In-Reply-To: <200709252325.03360.mb@bu3sch.de>
References: <200709252242.12331.mb@bu3sch.de>
	<20070925.141816.71108553.davem@davemloft.net>
	<200709252325.03360.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Buesch <mb@bu3sch.de>
Date: Tue, 25 Sep 2007 23:25:02 +0200

> Yeah, well. But how can this happen? Someone assigning to skb->len?
> zd1211 doesn't do this.
> Any slight idea which (kind of) code could trigger this?

Anything which modifies skb->truesize directly would be
suspect.

Most modifications of skb->len go through the standard
interfaces like skb_put(), skb_pull() etc. and those
assert whether we go over and under the limits.

Therefore something that modifies skb->len directly would
be suspect as well.
