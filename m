Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9802 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3GBNbY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 09:31:24 -0400
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 0/3] Enable additional channels for GO
Date: Tue,  2 Jul 2013 15:28:12 +0300
Message-Id: <1372768095-26053-1-git-send-email-ilan.peer@intel.com> (sfid-20130702_153127_155782_6DDB843A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The FCC are clarifying some soft configuration requirements,
which among other includes the following:

1. Concurrent GO operation, where devices may support WFD in
   bands where an authorized master (for example with DFS and
   DFS and radar detection capability in the UNII band) is operating.
2. Indoor operation, where in bands requiring indoor operation, the
   device must be programmed to detect indoor operation, or
   - Device must be connected to AC Power
   - Device must be under the control of a local master that is acting
     as an AP and is connected to AC Power.

See https://apps.fcc.gov/eas/comments/GetPublishedDocument.html?id=327&tn=528122

David Spinadel (2):
  [RFC] cfg80211: Add indoor only and GO concurrent channel attributes
  [RFC] cfg80211: Enable GO operation on additional channels

Ilan Peer (1):
  [RFC] cfg80211: Add Kconfig option for cellular BS hints

 include/net/cfg80211.h       |   10 ++++-
 include/uapi/linux/nl80211.h |    7 +++
 net/mac80211/ibss.c          |    2 +-
 net/wireless/Kconfig         |   17 ++++++++
 net/wireless/chan.c          |   98 +++++++++++++++++++++++++++++++++++++++---
 net/wireless/mesh.c          |    2 +-
 net/wireless/nl80211.c       |   14 ++++--
 net/wireless/reg.c           |    2 +-
 net/wireless/trace.h         |   11 +++--
 9 files changed, 145 insertions(+), 18 deletions(-)

-- 
1.7.10.4

