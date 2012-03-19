Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43429 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab2CSNt4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 09:49:56 -0400
Subject: Re: [RFC] mac80211: fix possible tid_rx->reorder_timer use after
 free
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20120319134259.GD6169@redhat.com>
References: <1332161442-7315-1-git-send-email-sgruszka@redhat.com>
	 <1332162188.3359.33.camel@jlt3.sipsolutions.net>
	 <1332162477.3359.34.camel@jlt3.sipsolutions.net>
	 <20120319134259.GD6169@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 14:49:54 +0100
Message-ID: <1332164994.3359.36.camel@jlt3.sipsolutions.net> (sfid-20120319_145002_162698_72B4F3B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 14:43 +0100, Stanislaw Gruszka wrote:
> On Mon, Mar 19, 2012 at 02:07:57PM +0100, Johannes Berg wrote:
> > I was actually thinking of using just del_timer(), but now that I think
> > about it, should anything prevent us from using del_timer_sync() inside
> > ieee80211_free_tid_rx?
> 
> Yes, call_rcu() callback can not sleep. Depending of RCU implementation
> callback can run with bottom half disabled.

del_timer_sync() doesn't really *sleep* though, even if it waits, so it
should be fine?

johannes

