Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3DVNlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 09:41:08 -0400
Message-ID: <1366638061.8637.12.camel@jlt4.sipsolutions.net> (sfid-20130422_154113_132002_67C7D37E)
Subject: Re: [PATCH v2] mac80211: use synchronize_rcu() with rcu_barrier()
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, paulmck@linux.vnet.ibm.com
Date: Mon, 22 Apr 2013 15:41:01 +0200
In-Reply-To: <20130418222649.GC3759@localhost> (sfid-20130419_002738_056827_6A84C745)
References: <20130418220443.GB3759@localhost>
	 <20130418222649.GC3759@localhost> (sfid-20130419_002738_056827_6A84C745)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-04-18 at 18:26 -0400, Bob Copeland wrote:
> The RCU docs used to state that rcu_barrier() included a wait
> for an RCU grace period; however the comments for rcu_barrier()
> as of commit f0a0e6f... "rcu: Clarify memory-ordering properties
> of grace-period primitives" contradict this.
> 
> So add back synchronize_{rcu,net}() to where they once were,
> but keep the rcu_barrier()s for the call_rcu() callbacks.

Applied, thanks for spotting this!

johannes

