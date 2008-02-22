Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40591 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763966AbYBVOIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 09:08:55 -0500
Message-Id: <20080222111644.183587000@sipsolutions.net> (sfid-20080222_140858_866959_D0B6572D)
Date: Fri, 22 Feb 2008 12:16:44 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 0/8] mac80211 sta info and related changes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains a few loosely related changes in mac80211
I did over the past few days:

 * clarify use of TX status/RX callbacks
   as per my previous mail, the irqsafe/non-irq-safe stuff

 * safely free beacon in ieee80211_if_reinit
   This is necessary for reentrancy reasons with ieee80211_beacon_get()

 * split ieee80211_key_alloc
   Preparation for RCU-ifying STA info, split key allocation into
   allocation and insertion

 * RCU-ify STA info structure access
   Remove STA refcount and instead protect them by RCU

 * split ieee80211_txrx_data
   Mostly unrelated, split up txrx_data and flags into one struct for TX
   and one for RX

 * split sta_info_add
   Split sta_info_add into _alloc and _link to resolve a few races and
   allow GFP_KERNEL allocations in many cases (which was removed by the
   RCU-ification patch)

 * remove STA info's last_ack stuff
   Remove some unused stats members

 * clean up sta_info and document locking
   Document and clean up the definition of struct sta_info and document
   the locking (deficiencies)

I'd like to have somebody else look over these but I'm confident that the
changes do not, at least, introduce regressions.

johannes

