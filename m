Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36494 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab2E2XXt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 19:23:49 -0400
Message-ID: <4FC55A83.6030602@openwrt.org> (sfid-20120530_012353_545702_9D29D737)
Date: Wed, 30 May 2012 01:23:47 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Limit number of pending skbs.
References: <1338332576-26427-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1338332576-26427-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-05-30 1:02 AM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Current code will allow any number of pending skbs, and
> this can OOM the system when used with something like
> the pktgen tool (which may not back off properly if
> queue is stopped).
> 
> Possibly this is just a bug in our version of pktgen,
> but either way, it seems reasonable to add a limit
> so that it is not possible to go OOM in this manner.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
Adding a module parameter in a workaround for a possibly broken module
seems a bit excessive to me.

Also, I'm not sure adding such a silent packet drop is a good idea. At
the very least, it should complain loudly to encourage people to fix the
actual bug instead of just papering over it.

When the driver cannot accept more packets, the queue stop should
prevent the network stack from spamming mac80211 with more packets. Your
pktgen seems to be ignoring this, so please fix it instead of adding
workarounds to mac80211.

- Felix
