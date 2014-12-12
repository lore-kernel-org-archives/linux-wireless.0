Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33482 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966281AbaLLOBK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 09:01:10 -0500
Message-ID: <1418392866.2470.49.camel@sipsolutions.net> (sfid-20141212_150114_156061_5BFEEE1A)
Subject: Re: [PATCH] mac80211: add an intermediate software queue
 implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Dec 2014 15:01:06 +0100
In-Reply-To: <548AF047.9080404@openwrt.org>
References: <1416352495-82172-1-git-send-email-nbd@openwrt.org>
	 <1418390516.2470.46.camel@sipsolutions.net> <548AF047.9080404@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-12-12 at 14:40 +0100, Felix Fietkau wrote:

> > Then
> > again what even sets vif->txq? Shouldn't those be per-AC? Do you really
> > want to mix 'normal' and txq-TX?
> Are we even using multiple ACs for packets that don't belong to a
> particular sta? I thought normal mcast data frames only use non-QoS
> frames. And yes, I'm currently mixing normal and txq-TX to prioritize
> ctl/mgmt frames over other less important traffic.

Management (and maybe control) frames can have different priorities as
well, this is only used for something with TDLS now I think though.

> > You might consider doing locking differently here - I think you probably
> > don't need the txq->queue spinlock at all since you're in per-AC and
> > mappings are static. Not sure how that interacts with other parts of the
> > code though.
> I wanted to use the lock to give the driver the freedom to call
> ieee80211_tx_dequeue from outside of normal per-AC tx context.

Ok.

johannes

