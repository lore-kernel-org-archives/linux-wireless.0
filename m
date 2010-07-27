Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34474 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab0G0TEh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 15:04:37 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] Revert "mac80211: fix sw scan bracketing"
Date: Tue, 27 Jul 2010 15:04:31 -0400
Message-Id: <1280257471-9126-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts this commit. While in theory the change is
correct the patch does not address current assumptions made
by some drivers, one which is definitley affected is ath9k.

Prior to this change the scan complete callback would be
called after we returned to the home channel and configured
the hardware filters. After this change we call the scan
complete callback prior to both the hw config and the config
filter.

At least for ath9k this breaks quite a few assumptions on the
callback, leading to disconnects to the AP after every scan
making the driver pretty useless on STA mode. The goal behind
this commit was to address the now understood spurious warnings
from ath9k and mac80211_hwsim on scanning on two wiphys at the
same time. The issue was that the scan complete callback was
called after the lock was released. The spurious warnings
will come up still but since they are wrapped under KERN_DEBUG
and this will be addressed in the next kernel release we leave
then in place.

When fixing this for good next we must first review the other
driver's dependence on this logic and perhaps consider removal
of the scan complete callback all together.

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

John, without this ath9k is useless in STA mode, please consider
as a regresion fix for for 2.6.36.

 net/mac80211/scan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 4dcbf8b..9aa19ec 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -287,8 +287,6 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	local->scanning = 0;
 	local->scan_channel = NULL;
 
-	drv_sw_scan_complete(local);
-
 	/* we only have to protect scan_req and hw/sw scan */
 	mutex_unlock(&local->scan_mtx);
 
@@ -298,6 +296,8 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 
 	ieee80211_configure_filter(local);
 
+	drv_sw_scan_complete(local);
+
 	ieee80211_offchannel_return(local, true);
 
  done:
-- 
1.7.0.4

