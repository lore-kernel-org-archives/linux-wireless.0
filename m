Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3423 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbYGJL2s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 07:28:48 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwlwif: remove compilation warnings iwl_add_radiotap
Date: Thu, 10 Jul 2008 14:28:42 +0300
Message-Id: <1215689322-25017-1-git-send-email-tomas.winkler@intel.com> (sfid-20080710_132851_949265_F5B07E7F)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use directly put_unaligned_leX instead of put_unaligned(cpu_to_leX

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-rx.c |   37 +++++++++++++++-----------------
 1 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index d062d4d..6a465d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -29,6 +29,7 @@
 
 #include <linux/etherdevice.h>
 #include <net/mac80211.h>
+#include <asm/unaligned.h>
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
@@ -829,23 +830,22 @@ static void iwl_add_radiotap(struct iwl_priv *priv,
 	iwl4965_rt->rt_hdr.it_pad = 0;
 
 	/* total header + data */
-	put_unaligned(cpu_to_le16(sizeof(*iwl4965_rt)),
-		      &iwl4965_rt->rt_hdr.it_len);
+	put_unaligned_le16(sizeof(*iwl4965_rt), &iwl4965_rt->rt_hdr.it_len);
 
 	/* Indicate all the fields we add to the radiotap header */
-	put_unaligned(cpu_to_le32((1 << IEEE80211_RADIOTAP_TSFT) |
-				  (1 << IEEE80211_RADIOTAP_FLAGS) |
-				  (1 << IEEE80211_RADIOTAP_RATE) |
-				  (1 << IEEE80211_RADIOTAP_CHANNEL) |
-				  (1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
-				  (1 << IEEE80211_RADIOTAP_DBM_ANTNOISE) |
-				  (1 << IEEE80211_RADIOTAP_ANTENNA)),
-		      &iwl4965_rt->rt_hdr.it_present);
+	put_unaligned_le32((1 << IEEE80211_RADIOTAP_TSFT) |
+			   (1 << IEEE80211_RADIOTAP_FLAGS) |
+			   (1 << IEEE80211_RADIOTAP_RATE) |
+			   (1 << IEEE80211_RADIOTAP_CHANNEL) |
+			   (1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
+			   (1 << IEEE80211_RADIOTAP_DBM_ANTNOISE) |
+			   (1 << IEEE80211_RADIOTAP_ANTENNA),
+			   &(iwl4965_rt->rt_hdr.it_present));
 
 	/* Zero the flags, we'll add to them as we go */
 	iwl4965_rt->rt_flags = 0;
 
-	put_unaligned(cpu_to_le64(tsf), &iwl4965_rt->rt_tsf);
+	put_unaligned_le64(tsf, &iwl4965_rt->rt_tsf);
 
 	iwl4965_rt->rt_dbmsignal = signal;
 	iwl4965_rt->rt_dbmnoise = noise;
@@ -853,17 +853,14 @@ static void iwl_add_radiotap(struct iwl_priv *priv,
 	/* Convert the channel frequency and set the flags */
 	put_unaligned(cpu_to_le16(stats->freq), &iwl4965_rt->rt_channelMHz);
 	if (!(phy_flags_hw & RX_RES_PHY_FLAGS_BAND_24_MSK))
-		put_unaligned(cpu_to_le16(IEEE80211_CHAN_OFDM |
-					  IEEE80211_CHAN_5GHZ),
-			      &iwl4965_rt->rt_chbitmask);
+		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ,
+				   &iwl4965_rt->rt_chbitmask);
 	else if (phy_flags_hw & RX_RES_PHY_FLAGS_MOD_CCK_MSK)
-		put_unaligned(cpu_to_le16(IEEE80211_CHAN_CCK |
-					  IEEE80211_CHAN_2GHZ),
-			      &iwl4965_rt->rt_chbitmask);
+		put_unaligned_le16(IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ,
+				   &iwl4965_rt->rt_chbitmask);
 	else	/* 802.11g */
-		put_unaligned(cpu_to_le16(IEEE80211_CHAN_OFDM |
-					  IEEE80211_CHAN_2GHZ),
-			      &iwl4965_rt->rt_chbitmask);
+		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ,
+				   &iwl4965_rt->rt_chbitmask);
 
 	if (rate == -1)
 		iwl4965_rt->rt_rate = 0;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

