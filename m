Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab2CSNnG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 09:43:06 -0400
Date: Mon, 19 Mar 2012 14:43:00 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: fix possible tid_rx->reorder_timer use after free
Message-ID: <20120319134259.GD6169@redhat.com> (sfid-20120319_144311_559899_A58B21E2)
References: <1332161442-7315-1-git-send-email-sgruszka@redhat.com>
 <1332162188.3359.33.camel@jlt3.sipsolutions.net>
 <1332162477.3359.34.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1332162477.3359.34.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 19, 2012 at 02:07:57PM +0100, Johannes Berg wrote:
> I was actually thinking of using just del_timer(), but now that I think
> about it, should anything prevent us from using del_timer_sync() inside
> ieee80211_free_tid_rx?

Yes, call_rcu() callback can not sleep. Depending of RCU implementation
callback can run with bottom half disabled.

Stanislaw
