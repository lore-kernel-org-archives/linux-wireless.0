Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31951 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932659AbXLQQNc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 11:13:32 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
Subject: [PATCH 0/8] mac80211/iwlwifi: integrate IEEE802.11n A-MPDU Rx MLME
Date: Mon, 17 Dec 2007 17:57:41 +0200
Message-Id: <11979070692599-git-send-email-ron.rindjunsky@intel.com> (sfid-20071217_161337_697425_F35D56D5)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches contains implementation for the IEEE802.11n 
aggregated MPDUs (A-MPDU) MLME. The series handles Rx A-MPDU (recipient party).

Please notice:
===============
Patch "mac80211: A-MPDU Rx adding BAR handling capability" depends on patch 
"mac80211: pass in PS_POLL frames" that was already sent as a stand alone patch.
Further more, the latter patch is needed for this series to function well.

Notes to this series:
======================
This series of patches splits into:
 - patches 1-7 add 802.11n Rx A-MPDU MLME support to mac80211.
 - patch 8 demonstrates the use of the above mac80211's MLME through iwl4965 low level driver

The patches in the series should not be treated as stand alone patches,
but as a complete MLME according to IEEE802.11n spec, although separation
to patches by subjects was made for ease of handling.

The patches do _not_ break any existing driver.
Patches were made (and tested to work) with wireless branch 2.6.24-rc3 (#everything)

The MLME framework includes the following:
- A-MPDU MLME (for aggregated Rx per STA/TID)
- addBA request support.
- delBA request support (recipient party).
- Block Ack Request (BAR) support.
- A-MPDU reordering.


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

