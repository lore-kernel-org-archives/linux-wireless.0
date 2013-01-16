Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab3APN6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 08:58:41 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] iwlwifi: audit single frames from AGG queue in RS
Date: Wed, 16 Jan 2013 14:59:06 +0100
Message-Id: <1358344746-26531-1-git-send-email-johannes@sipsolutions.net> (sfid-20130116_145846_363621_9F8A7655)
In-Reply-To: <1358344048.22862.0.camel@jlt4.sipsolutions.net>
References: <1358344048.22862.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The rate scaling won't treat the information in a frame
with IEEE80211_TX_CTL_AMPDU set if IEEE80211_TX_STAT_AMPDU
is cleared. But all the frames coming from an AGG tx queue
have IEEE80211_TX_CTL_AMPDU set, and IEEE80211_TX_STAT_AMPDU
is set only if the frame was sent in an AMPDU.
This means that all the data in frames in AGG tx queues that
aren't sent as an AMPDU is thrown away.
This is even more harmful when in bad link conditions, the
frames are sent in an AMPDU and then finally sent as single
frame. So a lot of failures weren't reported and the rate
scaling got stuck in high rates leading to very poor
connectivity.

Fix that by clearing IEEE80211_TX_CTL_AMPDU when the frame
isn't part of an AMPDU.

This bug was introduced by

2eb81a40aa521035ff9c8c8309e482dff523f8c9
iwlwifi: don't clear CTL_AMPDU on frame status

This fix basically reverts the aforementioned commit.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index a790599..31534f7 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -1079,6 +1079,8 @@ static void iwlagn_set_tx_status(struct iwl_priv *priv,
 {
 	u16 status = le16_to_cpu(tx_resp->status.status);
 
+	info->flags &= ~IEEE80211_TX_CTL_AMPDU;
+
 	info->status.rates[0].count = tx_resp->failure_frame + 1;
 	info->flags |= iwl_tx_status_to_mac80211(status);
 	iwlagn_hwrate_to_tx_control(priv, le32_to_cpu(tx_resp->rate_n_flags),
-- 
1.8.0

