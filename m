Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab2EJHKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 03:10:18 -0400
Message-Id: <20120510070930.930461401@sipsolutions.net> (sfid-20120510_091026_566500_5319066D)
Date: Thu, 10 May 2012 09:09:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 2/2] iwlwifi: give HT format to mac80211/radiotap
References: <20120510070909.253886400@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We know whether we received a frame in GF format
or not, add it to the radiotap information.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c   |    2 ++
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c	2012-05-10 08:54:26.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c	2012-05-10 09:04:42.000000000 +0200
@@ -1007,6 +1007,8 @@ static int iwlagn_rx_reply_rx(struct iwl
 		rx_status.flag |= RX_FLAG_40MHZ;
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
 		rx_status.flag |= RX_FLAG_SHORT_GI;
+	if (rate_n_flags & RATE_MCS_GF_MSK)
+		rx_status.flag |= RX_FLAG_HT_GF;
 
 	iwlagn_pass_packet_to_mac80211(priv, header, len, ampdu_status,
 				    rxb, &rx_status);
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c	2012-05-10 08:53:23.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c	2012-05-10 09:06:16.000000000 +0200
@@ -38,6 +38,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 
+#include <net/ieee80211_radiotap.h>
 #include <net/mac80211.h>
 
 #include <asm/div64.h>
@@ -154,6 +155,7 @@ int iwlagn_mac_setup_register(struct iwl
 		    IEEE80211_HW_SCAN_WHILE_IDLE;
 
 	hw->offchannel_tx_hw_queue = IWL_AUX_QUEUE;
+	hw->radiotap_mcs_details |= IEEE80211_RADIOTAP_MCS_HAVE_FMT;
 
 	/*
 	 * Including the following line will crash some AP's.  This


