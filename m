Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5577 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146Ab3LEN77 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 08:59:59 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v3 5/6] cfg80211: Enable GO operation on indoor channels
Date: Thu,  5 Dec 2013 16:00:56 +0200
Message-Id: <1386252056-17808-1-git-send-email-ilan.peer@intel.com> (sfid-20131205_150002_179892_4A045FC2)
In-Reply-To: <1386098166-24196-6-git-send-email-ilan.peer@intel.com>
References: <1386098166-24196-6-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow GO operation on a channel marked with IEEE80211_CHAN_INDOOR_ONLY
iff there is a user hint indicating that the platform is operating in
an indoor environment, i.e., the platform is a printer or media center
device.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/wireless/chan.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 2c1b319..49fef2a 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -610,6 +610,8 @@ EXPORT_SYMBOL(cfg80211_chandef_usable);
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

