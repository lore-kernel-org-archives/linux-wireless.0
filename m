Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46198 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab1BOMNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 07:13:11 -0500
Subject: Re: [PATCH 4/5] iwlwifi: auto-tune tx queue size to minimize
 latency
From: Johannes Berg <johannes@sipsolutions.net>
To: Nathaniel Smith <njs@pobox.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
In-Reply-To: <AANLkTinuvxEuuz3-xWkhQ1fA8s7QumJHJQKpd1C48CV1@mail.gmail.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	 <1297619803-2832-5-git-send-email-njs@pobox.com>
	 <1297685871.3785.39.camel@jlt3.sipsolutions.net>
	 <AANLkTinuvxEuuz3-xWkhQ1fA8s7QumJHJQKpd1C48CV1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 13:13:06 +0100
Message-ID: <1297771986.3935.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-14 at 13:58 -0800, Nathaniel Smith wrote:

> > This sounds nice -- but couldn't it just as well be implemented in
> > mac80211, at least for most devices (that have accurate TX status
> > reporting)?
> 
> I don't know. I take it you're imagining a scheme where mac80211 keeps
> a hash table or similar of all packets that have been queued to the
> device, and does its own tx rate estimation and calls start/stop_queue
> as needed? If that works, then it would be lovely. (Heck, it should
> probably go in the generic net layer eventually; ethernet cards have
> the same problem.)

Well, no, why would it keep a hash table?? And no -- it can't be done in
the generic net layer.

mac80211 has the advantage that TX status is reported back, so it could
pretty accurately know how many frames are queued up -- more generically
this cannot be done.

But since it's not perfectly accurate right now, it may not be the best
idea to do this at this time.

johannes

