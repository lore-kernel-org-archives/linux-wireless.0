Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40145 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab0BHE3j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 23:29:39 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 07 Feb 2010 20:29:39 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19311.38774.617169.606262@gargle.gargle.HOWL>
Date: Mon, 8 Feb 2010 10:17:50 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [RFC/RFT] mac80211: allow station add/remove to sleep
In-Reply-To: <1265201998.29119.91.camel@johannes.local>
References: <1265201998.29119.91.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Many drivers would like to sleep during station
> addition and removal, and currently have a high
> complexity there from not being able to.
> 
> This introduces two new callbacks sta_add() and
> sta_remove() that drivers can implement instead
> of using sta_notify() and that can sleep, and
> the new sta_add() callback is also allowed to
> fail.
> 
> The reason we didn't do this previously is that
> the IBSS code wants to insert stations from the
> RX path, which is a tasklet, so cannot sleep.
> This patch will keep the station allocation in
> that path, but moves adding the station to the
> driver out of line. Since the addition can now
> fail, we can have IBSS peer structs the driver
> rejected -- in that case we still talk to the
> station but never tell the driver about it in
> the control.sta pointer. If there will ever be
> a driver that has a low limit on the number of
> stations and that cannot talk to any stations
> that are not known to it, we need to do come up
> with a new strategy of handling larger IBSSs,
> maybe quicker expiry or rejecting peers.

Tested in STA mode with ath9k_htc.
Thanks.

Sujith
