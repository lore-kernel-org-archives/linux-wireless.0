Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58160 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751551AbdE3OMJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 May 2017 10:12:09 -0400
Message-ID: <1496153526.3327.12.camel@sipsolutions.net> (sfid-20170530_161212_064559_0B6DC357)
Subject: Re: [PATCH] mac80211: manage RX BA session offload without SKB queue
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>,
        ath10k@lists.infradead.org
Date: Tue, 30 May 2017 16:12:06 +0200
In-Reply-To: <20170530141059.28006-1-johannes@sipsolutions.net> (sfid-20170530_161107_071358_D610DE8E)
References: <20170530141059.28006-1-johannes@sipsolutions.net>
         (sfid-20170530_161107_071358_D610DE8E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-05-30 at 16:10 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Instead of using the SKB queue with the fake pkt_type for the
> offloaded RX BA session management, also handle this with the
> normal aggregation state machine worker. This also makes the
> use of this more reliable since it gets rid of the allocation
> of the fake skb.
> 
> Combined with the previous patch, this finally allows us to
> get rid of the pkt_type hack entirely, so do that as well.

Previous patch is this:

https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git/commit/?id=7a7c0a6438b8e7636d5a22e572892cc234f68297

I can't test this (don't have ath10k easily testable), so testing would
be appreciated.

johannes
