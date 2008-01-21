Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7349 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361AbYAULwW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 06:52:22 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
Subject: [PATCH 0/12] mac80211/iwlwifi: A-MPDU Tx support
Date: Mon, 21 Jan 2008 13:52:00 +0200
Message-Id: <12009163321727-git-send-email-ron.rindjunsky@intel.com> (sfid-20080121_115237_865686_BFFB178E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches contains implementation for the IEEE802.11n 
aggregated MPDUs (A-MPDU) MLME. The series handles Tx A-MPDU (initiator party).

Please notice:
===============
Patch "mac80211: A-MPDU Tx adding basic functionality" depends on patch 
"mac80211: fix rx flow sparse errors" that was already sent as a stand alone patch.

Notes to this series:
======================
This series of patches splits into:
 - patches 1-8 add 802.11n Tx A-MPDU MLME support to mac80211.
 - patches 9-12 demonstrates the use of the above mac80211's MLME through iwl4965 low level driver

The patches in the series should not be treated as stand alone patches,
but as a complete MLME according to IEEE802.11n spec, although separation
to patches by subjects was made for ease of handling.

The patches do _not_ break any existing driver.
Patches were made (and tested to work) with wireless branch 2.6.24-rc8 (#everything)

The MLME framework includes the following:
- A-MPDU MLME (for aggregated Tx per STA/TID)
- addBA request support.
- delBA request support (initiator party).
- qdisc support by STA/TID.
- Tx rate scaling support (block Ack aware)


