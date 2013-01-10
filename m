Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:64714 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3AJInI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 03:43:08 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: Q: offchannel operations
Date: Thu, 10 Jan 2013 10:43:04 +0200
Message-ID: <1690590.qQcKllxmg2@lx-vladimir> (sfid-20130110_094313_310385_C41C27AB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

There are 2 similar operations in the struct cfg80211_ops:
remain_on_channel() and mgmt_tx(). Actually, mgmt_tx() when called for
off-channel operation, is the same as remain_on_channel() except it
transmits frame at the beginning.

What I am interesting about, is notifications to cfg80211. For
remain_on_channel(), there are 2: cfg80211_ready_on_channel() when
channel tuned, and cfg80211_remain_on_channel_expired() when tuned off
requested channel. In contrast, if mgmt_tx() called for off-channel
with duration, 2 above notifications are not used. Instead, only
cfg80211_mgmt_tx_status() called after tx.

My question is why don't mgmt_tx() call cfg80211_ready_on_channel() and
cfg80211_remain_on_channel_expired() ? It seems logical to notify about
off-channel status. Otherwise, how can upper layers know when off-channel
started/finished in context of mgmt_tx()?

Comments?

Thanks, Vladimir
