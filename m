Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46860 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbbFQJAt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 05:00:49 -0400
Message-ID: <1434531646.1884.18.camel@sipsolutions.net> (sfid-20150617_110103_391057_9D3AF0F1)
Subject: Re: [PATCH] mac80211: Check SN for deactivated mpaths
From: Johannes Berg <johannes@sipsolutions.net>
To: agreen@cococorp.com
Cc: linux-wireless@vger.kernel.org, Jesse Jones <jjones@cococorp.com>
Date: Wed, 17 Jun 2015 11:00:46 +0200
In-Reply-To: <557B5F4F.1060703@cococorp.com> (sfid-20150613_003822_322805_8822167A)
References: <557B5F4F.1060703@cococorp.com>
	 (sfid-20150613_003822_322805_8822167A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-06-12 at 15:38 -0700, Alexis Green wrote:
> From: Jesse Jones <jjones@cococorp.com>
> 
> When processing a PREQ or PREP it's critical to use the incoming SN. If
> that is improperly done routing loops and other types of badness can
> happen. But the code was always processing path messages for deactivated
> paths. This path fixes that so that if we have a valid SN then we use it
> to verify that it is a message we can accept. For reference the relevant
> section of the standard is 13.10.8.4 which doesn't address the deactivated
> path case at all.
> 
> I also included a special case for when our peer reboots or restarts
> networking. This is an important case because without it there can be a
> very long delay before we accept path messages from that peer. It's also a
> simple case and intimately associated with processing messages for
> deactivated paths so I used one patch instead of two.

Applied.

johannes

