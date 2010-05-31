Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:16520 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab0EaHDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 May 2010 03:03:01 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o4V72m0q006436
	for <linux-wireless@vger.kernel.org>; Mon, 31 May 2010 10:02:58 +0300
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o4V72dcY011221
	for <linux-wireless@vger.kernel.org>; Mon, 31 May 2010 10:02:41 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv2 0/1] mac80211: Shared BT/WLAN antenna co-existence management
Date: Mon, 31 May 2010 10:05:46 +0300
Message-Id: <1275289547-7104-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v2 of these RFC patches only add more elaboration to the description of the
patch itself.

The following patch proposes an implementation to handle WLAN-Bluetooth
coexistence in the case of a shared WLAN/BT antenna.

The patch adds to mac80211 an interface for the driver to be able to
temporarily disable dynamic power save. When power save is enabled, a call to
the function will cause mac80211 to immediately enter full PSM until the driver
indicates that dynamic PSM can be resumed. If power save is enabled the 
function does nothing.

The driver uses this function to disable dynamic PSM whenever there are bursts
Bluetooth traffic. Full PSM allows the WLAN hardware to relinquish the antenna
for use by BT during the inactive WLAN periods.

The driver gets information on Bluetooth traffic from the WLAN chipset. The
chipset has hardware lines to coordinate the co-existence, and the chipset will
indicate to the driver whenever there is Bluetooth traffic.

Comments are welcomed!

Juuso Oikarinen (1):
  mac80211: Add interface for driver to temporarily disable dynamic ps

 include/net/mac80211.h     |   15 +++++++++++++++
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/iface.c       |    1 +
 net/mac80211/mlme.c        |   20 +++++++++++++++++++-
 net/mac80211/rx.c          |    3 ++-
 net/mac80211/tx.c          |    4 ++++
 6 files changed, 44 insertions(+), 2 deletions(-)

