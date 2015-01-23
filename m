Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35514 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbbAWJ4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 04:56:44 -0500
Message-ID: <1422006994.2728.22.camel@sipsolutions.net> (sfid-20150123_105648_268778_2C24FEE0)
Subject: Re: [PATCH] mac80211: synchronize_net() before flushing the queues
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Jan 2015 10:56:34 +0100
In-Reply-To: <1421962219-6840-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1421962219-6840-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-01-22 at 23:30 +0200, Emmanuel Grumbach wrote:
> When mac80211 disconnects, it drops all the packets on the
> queues. This happens after the net stack has been notified
> that we have no link anymore (netif_carrier_off).
> netif_carrier_off ensures that no new packets are sent to
> xmit() callback, but we might have older packets in the
> middle of the Tx path. These packets will land in the
> driver's queues after the latter have been flushed.
> Synchronize_net() between netif_carrier_off and drv_flush()
> will fix this.
> 
> Note that we can't call synchronize_net inside
> ieee80211_flush_queues since there are flows that call
> ieee80211_flush_queues and don't need synchronize_net()
> which is an expensive operation.

I'm -- with a heavy heart -- applying this for now. TI/wizery spent a
lot of time optimising the time it takes to roam, and this single line
will introduce a potential for hundreds of ms of latency into the
roaming flow.

You (we) really need to think about how to avoid that.

johannes

