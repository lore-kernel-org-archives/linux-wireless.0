Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5806 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbaAOPvD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 10:51:03 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, wireless-regdb@lists.infradead.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v2 5/6] cfg80211: Enable GO operation on indoor channels
Date: Wed, 15 Jan 2014 17:52:41 +0200
Message-Id: <1389801162-14488-6-git-send-email-ilan.peer@intel.com> (sfid-20140115_165107_794540_E18C8882)
In-Reply-To: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
References: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/wireless/chan.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index d47856b..36f2f5f 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -611,6 +611,8 @@ EXPORT_SYMBOL(cfg80211_chandef_usable);
  * IEEE80211_CHAN_GO_CONCURRENT and there is an additional station interface
  * associated to an AP on the same channel or on the same UNII band
  * (assuming that the AP is an authorized master).
+ * In addition allow the GO to operate on a channel on which indoor operation is
+ * allowed, iff we are currently operating in an indoor environment.
  */
 static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
 					struct ieee80211_channel *chan)
@@ -619,6 +621,9 @@ static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
 
 	ASSERT_RTNL();
 
+	if (regulatory_ir_allowed(chan))
+		return true;
+
 	if (!(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
 		return false;
 
-- 
1.7.10.4

