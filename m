Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49839 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab2DWQfo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 12:35:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH v2 1/1] mac80211: check for non-managed interface
Date: Mon, 23 Apr 2012 09:30:32 -0700
Message-Id: <1335198632-27102-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_183547_725531_461E5FAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Average beacon signal only keep tracked by managed interface,
give warning and return 0 for the others.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 net/mac80211/util.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 89c1e5b..d0c979e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1799,5 +1799,9 @@ int ieee80211_ave_rssi(struct ieee80211_vif *vif)
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	if (WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_STATION)) {
+		/* non-managed type inferfaces */
+		return 0;
+	}
 	return ifmgd->ave_beacon_signal;
 }
-- 
1.7.0.4

