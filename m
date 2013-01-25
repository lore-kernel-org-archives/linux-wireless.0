Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60484 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3AYXPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 18:15:50 -0500
Message-ID: <1359155773.4655.54.camel@jlt4.sipsolutions.net> (sfid-20130126_001553_942817_44B8EF23)
Subject: Re: Q: offchannel operations
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 26 Jan 2013 00:16:13 +0100
In-Reply-To: <1690590.qQcKllxmg2@lx-vladimir> (sfid-20130110_094313_310385_C41C27AB)
References: <1690590.qQcKllxmg2@lx-vladimir>
	 (sfid-20130110_094313_310385_C41C27AB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-10 at 10:43 +0200, Vladimir Kondratiev wrote:
> Hi,
> 
> There are 2 similar operations in the struct cfg80211_ops:
> remain_on_channel() and mgmt_tx(). Actually, mgmt_tx() when called for
> off-channel operation, is the same as remain_on_channel() except it
> transmits frame at the beginning.
> 
> What I am interesting about, is notifications to cfg80211. For
> remain_on_channel(), there are 2: cfg80211_ready_on_channel() when
> channel tuned, and cfg80211_remain_on_channel_expired() when tuned off
> requested channel. In contrast, if mgmt_tx() called for off-channel
> with duration, 2 above notifications are not used. Instead, only
> cfg80211_mgmt_tx_status() called after tx.
> 
> My question is why don't mgmt_tx() call cfg80211_ready_on_channel() and
> cfg80211_remain_on_channel_expired() ? It seems logical to notify about
> off-channel status. Otherwise, how can upper layers know when off-channel
> started/finished in context of mgmt_tx()?

If all they care about is transmitting a frame, why would they want to
know?

johannes

