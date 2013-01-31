Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54401 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab3AaKll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 05:41:41 -0500
Message-ID: <1359628924.8415.5.camel@jlt4.sipsolutions.net> (sfid-20130131_114145_323910_47F0D30E)
Subject: Re: [RFC] Expand byte counters in struct station_info
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 31 Jan 2013 11:42:04 +0100
In-Reply-To: <6017229.5ECEUbBVAL@lx-vladimir>
References: <6017229.5ECEUbBVAL@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-31 at 11:46 +0200, Vladimir Kondratiev wrote:
> Hi,
> 
> Now wifi drivers reports per-station info using struct station_info;
> and currently for the data counters it has:
> 	u32 rx_bytes;
> 	u32 tx_bytes;
> 
> while for device-wide statistics one can use ndo_get_stats64() to fill
> 64-bit counters in the struct rtnl_link_stats64, per-station statistics
> are 32-bit.
> 
> This becomes problematic with gigabit speeds now observed for .11ac and .11ad -
> counters overflown every few seconds.
> 
> I'd like to extend rx and tx byte counters to 64-bit.
> 
> What is better - expand existing fields in struct station_info as:
> 	u64 rx_bytes;
> 	u64 tx_bytes;

This.

> or add ne ones like:
> 	u64 rx_bytes64;
> 	u64 tx_bytes64;

I don't see a reason to do this.

> 
> Then, I'll add
> 	NL80211_STA_INFO_RX_BYTES64,
> 	NL80211_STA_INFO_TX_BYTES64,
> to the enum nl80211_sta_info
> 
> Before doing patch, I'd like to hear comments.
> Any consideration why is this not to be done or done differently?

Sounds good to me.

Two points:

1) You should provide the RX_TX_BYTES attributes, but I think only if
the value fits into 32 bits. That way, we don't report invalid
information.

2a) Need to be careful in downstream drivers/mac80211, they should also
be converted to use 64-bit counters when gathering the data. Otherwise,
userspace might assume the value is actually 64-bit, when it rolled over
in mac80211.

2b) An alternative to converting all the non-mac80211 drivers and
mac80211 would be to add new station info flags: STATION_INFO_TX_BYTES64
and STATION_INFO_RX_BYTES64. You'd still fill the rx_bytes/tx_bytes
values, but if the driver sets STATION_INFO_TX_BYTES you'd never use a
64-bit attribute in nl80211.

I think 2a is preferable, but it'd be a bunch of work to make sure to
catch all drivers, and some devices might not actually have 64-bit
counters (if the data comes from firmware)? So 2b might be a better
choice.

johannes

