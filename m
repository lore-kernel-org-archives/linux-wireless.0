Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24312 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbYBCUQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 15:16:48 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [RFC] mac80211: add rate to ieee80211_tx_status
Date: Sun,  3 Feb 2008 22:15:05 +0200
Message-Id: <12020697053277-git-send-email-tomas.winkler@intel.com> (sfid-20080203_201652_621426_CC400D51)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds rate to ieee80211_tx_status.
Downscaling in iwl4965 is done in FW. Rate scaling algorithm
needs to know at which rate the packet was actually transmitted
Patch 'cfg80211 API for channels/bitrates' removed the placeholder
for this information that was present in ieee80211_tx_control.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---

This fix or something similar is required for bringing iwlwifi back to life.
Please comments, suggestions 
Thanks

 include/net/mac80211.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 460da54..a700ea6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -342,6 +342,7 @@ enum ieee80211_tx_status_flags {
  *
  * @control: a copy of the &struct ieee80211_tx_control passed to the driver
  *	in the tx() callback.
+ * @rate: rate at which the packet was actually transmitted
  * @flags: transmit status flags, defined above
  * @retry_count: number of retries
  * @excessive_retries: set to 1 if the frame was retried many times
@@ -356,6 +357,7 @@ enum ieee80211_tx_status_flags {
  */
 struct ieee80211_tx_status {
 	struct ieee80211_tx_control control;
+	struct ieee80211_rate rate;
 	u8 flags;
 	u8 retry_count;
 	bool excessive_retries;
-- 
1.5.2.2

