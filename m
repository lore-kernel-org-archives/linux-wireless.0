Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:43882 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaBWT5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:18 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so4110237wes.30
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:17 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/17] iwlwifi: mvm: propagate LDPC / STBC status to radiotap
Date: Sun, 23 Feb 2014 21:56:54 +0200
Message-Id: <1393185428-8524-3-git-send-email-egrumbach@gmail.com> (sfid-20140223_205731_323007_41C8F5DB)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This will allow to get sniffer captures with correct
settings for these HT / VHT capabilities.
Also set the corresponding HAVE_MCS / VHT_KNOWN bits in
the registration to mac80211.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h |    3 ++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  |    4 ++++
 drivers/net/wireless/iwlwifi/mvm/rs.c        |    2 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c        |    8 ++++++++
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
index 8505721..39148b5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
@@ -257,7 +257,8 @@ enum {
 
 /* Bit 17-18: (0) SS, (1) SS*2 */
 #define RATE_MCS_STBC_POS		17
-#define RATE_MCS_STBC_MSK		(1 << RATE_MCS_STBC_POS)
+#define RATE_MCS_HT_STBC_MSK		(3 << RATE_MCS_STBC_POS)
+#define RATE_MCS_VHT_STBC_MSK		(1 << RATE_MCS_STBC_POS)
 
 /* Bit 19: (0) Beamforming is off, (1) Beamforming is on */
 #define RATE_MCS_BF_POS			19
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 42f7046..2a1b4b6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -68,6 +68,7 @@
 #include <linux/ip.h>
 #include <linux/if_arp.h>
 #include <net/mac80211.h>
+#include <net/ieee80211_radiotap.h>
 #include <net/tcp.h>
 
 #include "iwl-op-mode.h"
@@ -280,6 +281,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	hw->queues = mvm->first_agg_queue;
 	hw->offchannel_tx_hw_queue = IWL_MVM_OFFCHANNEL_QUEUE;
+	hw->radiotap_mcs_details |= IEEE80211_RADIOTAP_MCS_HAVE_FEC |
+				    IEEE80211_RADIOTAP_MCS_HAVE_STBC;
+	hw->radiotap_vht_details |= IEEE80211_RADIOTAP_VHT_KNOWN_STBC;
 	hw->rate_control_algorithm = "iwl-mvm-rs";
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 32bb807..a6d0ab1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2595,7 +2595,7 @@ static int rs_pretty_print_rate(char *buf, const u32 rate)
 	return sprintf(buf, "%s | ANT: %s BW: %s MCS: %d NSS: %d %s%s%s%s%s\n",
 		       type, rs_pretty_ant(ant), bw, mcs, nss,
 		       (rate & RATE_MCS_SGI_MSK) ? "SGI " : "NGI ",
-		       (rate & RATE_MCS_STBC_MSK) ? "STBC " : "",
+		       (rate & RATE_MCS_HT_STBC_MSK) ? "STBC " : "",
 		       (rate & RATE_MCS_LDPC_MSK) ? "LDPC " : "",
 		       (rate & RATE_MCS_BF_MSK) ? "BF " : "",
 		       (rate & RATE_MCS_ZLF_MSK) ? "ZLF " : "");
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index fa3c139..817d3e0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -368,15 +368,23 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		rx_status.flag |= RX_FLAG_SHORT_GI;
 	if (rate_n_flags & RATE_HT_MCS_GF_MSK)
 		rx_status.flag |= RX_FLAG_HT_GF;
+	if (rate_n_flags & RATE_MCS_LDPC_MSK)
+		rx_status.flag |= RX_FLAG_LDPC;
 	if (rate_n_flags & RATE_MCS_HT_MSK) {
+		u8 stbc = (rate_n_flags & RATE_MCS_HT_STBC_MSK) >>
+				RATE_MCS_STBC_POS;
 		rx_status.flag |= RX_FLAG_HT;
 		rx_status.rate_idx = rate_n_flags & RATE_HT_MCS_INDEX_MSK;
+		rx_status.flag |= stbc << RX_FLAG_STBC_SHIFT;
 	} else if (rate_n_flags & RATE_MCS_VHT_MSK) {
+		u8 stbc = (rate_n_flags & RATE_MCS_VHT_STBC_MSK) >>
+				RATE_MCS_STBC_POS;
 		rx_status.vht_nss =
 			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
 						RATE_VHT_MCS_NSS_POS) + 1;
 		rx_status.rate_idx = rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK;
 		rx_status.flag |= RX_FLAG_VHT;
+		rx_status.flag |= stbc << RX_FLAG_STBC_SHIFT;
 	} else {
 		rx_status.rate_idx =
 			iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
-- 
1.7.9.5

