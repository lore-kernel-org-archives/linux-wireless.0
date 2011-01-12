Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab1ALMbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 07:31:12 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Pczr5-0001fF-TT
	for linux-wireless@vger.kernel.org; Wed, 12 Jan 2011 13:31:12 +0100
Message-Id: <20110112123132.232241948@sipsolutions.net>
Date: Wed, 12 Jan 2011 13:31:02 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 2/2] iwlwifi: advertise max aggregate size
References: <20110112123100.615900267@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Allow peers to size their reorder buffer more
accurately by advertising that we'll never send
aggregates longer than the default (31).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-01-12 13:28:18.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-01-12 13:28:41.000000000 +0100
@@ -3191,6 +3191,8 @@ static int iwl_mac_setup_register(struct
 		    IEEE80211_HW_SPECTRUM_MGMT |
 		    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
+	hw->max_tx_aggregation_subframes = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
+
 	if (!priv->cfg->base_params->broken_powersave)
 		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
 			     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;


