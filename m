Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54200 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab2KWWqD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 17:46:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] iwlwifi: initialize rx_status
Date: Fri, 23 Nov 2012 23:46:19 +0100
Message-Id: <1353710779-7142-1-git-send-email-johannes@sipsolutions.net> (sfid-20121123_234642_526071_AA7F642B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The vendor radiotap patch added a few fields to
struct ieee80211_rx_status that need to be zero,
initialize the struct instead of using whatever
was left on the stack.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index 9a8d502..85b4763 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -899,7 +899,7 @@ static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
 			    struct iwl_device_cmd *cmd)
 {
 	struct ieee80211_hdr *header;
-	struct ieee80211_rx_status rx_status;
+	struct ieee80211_rx_status rx_status = {};
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_rx_phy_res *phy_res;
 	__le32 rx_pkt_status;
-- 
1.8.0

