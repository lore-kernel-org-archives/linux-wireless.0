Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64421 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3AaJq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 04:46:58 -0500
To: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC] Expand byte counters in struct station_info
Date: Thu, 31 Jan 2013 11:46:44 +0200
Message-ID: <6017229.5ECEUbBVAL@lx-vladimir> (sfid-20130131_104704_474089_A6567C5E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Now wifi drivers reports per-station info using struct station_info;
and currently for the data counters it has:
	u32 rx_bytes;
	u32 tx_bytes;

while for device-wide statistics one can use ndo_get_stats64() to fill
64-bit counters in the struct rtnl_link_stats64, per-station statistics
are 32-bit.

This becomes problematic with gigabit speeds now observed for .11ac and .11ad -
counters overflown every few seconds.

I'd like to extend rx and tx byte counters to 64-bit.

What is better - expand existing fields in struct station_info as:
	u64 rx_bytes;
	u64 tx_bytes;
or add ne ones like:
	u64 rx_bytes64;
	u64 tx_bytes64;


Then, I'll add
	NL80211_STA_INFO_RX_BYTES64,
	NL80211_STA_INFO_TX_BYTES64,
to the enum nl80211_sta_info

Before doing patch, I'd like to hear comments.
Any consideration why is this not to be done or done differently?

Thanks, Vladimir
