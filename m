Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:48063 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab3A1ICV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 03:02:21 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Q: offchannel operations
Date: Mon, 28 Jan 2013 10:02:17 +0200
Message-ID: <1782786.GNue92Gz0e@lx-vladimir> (sfid-20130128_090224_842098_6B8786B1)
In-Reply-To: <1359155773.4655.54.camel@jlt4.sipsolutions.net>
References: <1690590.qQcKllxmg2@lx-vladimir> <1359155773.4655.54.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, January 26, 2013 12:16:13 AM Johannes Berg wrote:
> On Thu, 2013-01-10 at 10:43 +0200, Vladimir Kondratiev wrote:
> > Hi,
> > 
> > There are 2 similar operations in the struct cfg80211_ops:
> > remain_on_channel() and mgmt_tx(). Actually, mgmt_tx() when called for
> > off-channel operation, is the same as remain_on_channel() except it
> > transmits frame at the beginning.
> > 
> > What I am interesting about, is notifications to cfg80211. For
> > remain_on_channel(), there are 2: cfg80211_ready_on_channel() when
> > channel tuned, and cfg80211_remain_on_channel_expired() when tuned off
> > requested channel. In contrast, if mgmt_tx() called for off-channel
> > with duration, 2 above notifications are not used. Instead, only
> > cfg80211_mgmt_tx_status() called after tx.
> > 
> > My question is why don't mgmt_tx() call cfg80211_ready_on_channel() and
> > cfg80211_remain_on_channel_expired() ? It seems logical to notify about
> > off-channel status. Otherwise, how can upper layers know when off-channel
> > started/finished in context of mgmt_tx()?
> 
> If all they care about is transmitting a frame, why would they want to
> know?
> 
> johannes
> 

My understanding is that mgmt_tx() with delay intended for the flows
when one expect to rx some frame(s) solicited by original tx.
Ex: active scan - one tx probe and waits for probe resp on the same channel;
other example may be GO negotiation.
So, actually tx_mgmt() is like remain_on_channel() but with initial tx. That's
why it is strange to see different notification policy.

For practical example, let's see fragmented scan while connected -
upper layers issue mgmt_tx() for probe with delay about 10 ms; and use
start/end offchannel notification to pause/resume tx. Currently, one can't
do this; and need to call remain_on_channel() following mgmt_tx() upon
receiving cfg80211_ready_on_channel notification.

