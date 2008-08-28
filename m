Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:34136 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbYH1O4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 10:56:43 -0400
Date: Thu, 28 Aug 2008 17:55:49 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Reorder debugfs calls during netdev deinit
Message-ID: <20080828145549.GF4863@jm.kir.nu> (sfid-20080828_165650_474082_44CE6FEB)
References: <20080828135651.GE4863@jm.kir.nu> <1219933734.25321.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1219933734.25321.16.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 04:28:54PM +0200, Johannes Berg wrote:

> > It looks like someone has cleaned up the netdev uninit sequence (which
> > was quite a mess at the time I looked at it last and ended up just
> > delaying the fix till now..) and that seems to make it trivial to fix
> > the deinit order issue.
> 
> Yeah, that was me, I mostly rewrote the junk in iface.c.

Thanks! That saved lots of work.

> Seems sane to me.
> 
> Not that I like the workaround of setting keys on the monitor, in fact,
> I think it shouldn't be allowed ;)

Well, I don't like it either and it is next on my list for 802.11w
work.. I just needed to get mac80211 into a state where 802.11w works
and I do not need to reboot every time when I re-load mac80211 ;-).
Anyway, this reordering of the calls is correct even if the key was not
set for the monitor netdev; I just don't know whether there is any other
way to trigger this particular issue.

-- 
Jouni Malinen                                            PGP id EFC895FA
