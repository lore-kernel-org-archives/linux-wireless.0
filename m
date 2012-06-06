Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33673 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab2FFNWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:22:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 08/29] iwlwifi: give HT format to mac80211/radiotap
Date: Wed,  6 Jun 2012 15:21:49 +0200
Message-Id: <1338988930-11561-8-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152240_308029_BFFCB9CB)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We know whether we received a frame in GF format
or not, add it to the radiotap information.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c   |    2 ++
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 403de96..5035d2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -1012,6 +1012,8 @@ static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
 		rx_status.flag |= RX_FLAG_40MHZ;
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
 		rx_status.flag |= RX_FLAG_SHORT_GI;
+	if (rate_n_flags & RATE_MCS_GF_MSK)
+		rx_status.flag |= RX_FLAG_HT_GF;
 
 	iwlagn_pass_packet_to_mac80211(priv, header, len, ampdu_status,
 				    rxb, &rx_status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 19e5235..26a87c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -38,6 +38,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 
+#include <net/ieee80211_radiotap.h>
 #include <net/mac80211.h>
 
 #include <asm/div64.h>
@@ -154,6 +155,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 		    IEEE80211_HW_SCAN_WHILE_IDLE;
 
 	hw->offchannel_tx_hw_queue = IWL_AUX_QUEUE;
+	hw->radiotap_mcs_details |= IEEE80211_RADIOTAP_MCS_HAVE_FMT;
 
 	/*
 	 * Including the following line will crash some AP's.  This
-- 
1.7.10

