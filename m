Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23006 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964890AbbLHOGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:06:35 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/9] mac80211: document status.freq restrictions
Date: Tue,  8 Dec 2015 16:04:35 +0200
Message-Id: <1449583479-26658-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151208_150641_081143_BDB80EB2)
In-Reply-To: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's not always necessary to set the status.freq field, for example
when this would be an expensive calculation. It must be set for all
management frames (as they might be reported to userspace), but for
data frames it's not really required. Document this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dca010a..54af948 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1108,6 +1108,8 @@ enum mac80211_rx_vht_flags {
  *	it but can store it and pass it back to the driver for synchronisation
  * @band: the active band when this frame was received
  * @freq: frequency the radio was tuned to when receiving this frame, in MHz
+ *	This field must be set for management frames, but isn't strictly needed
+ *	for data (other) frames - for those it only affects radiotap reporting.
  * @signal: signal strength when receiving this frame, either in dBm, in dB or
  *	unspecified depending on the hardware capabilities flags
  *	@IEEE80211_HW_SIGNAL_*
-- 
2.5.0

