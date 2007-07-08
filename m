Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:59541 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756279AbXGHURG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 16:17:06 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id CAC248CAD8
	for <linux-wireless@vger.kernel.org>; Sun,  8 Jul 2007 22:16:56 +0200 (CEST)
Message-Id: <20070708201701.126477512@warmcat.com>
References: <20070708201636.804206271@warmcat.com>
Date: Sun, 08 Jul 2007 21:16:37 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Cc: Andy Green <andy@warmcat.com>
Subject: [PATCH 1/1] iwl3945: provide frequency to radiotap monitor not channel index
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl3945 and presumably 4965 wrongly provide the channel index to the radiotap
header on Monitor mode.  This results in tcpdump showing "6MHz" for example.

This patch arranges to send the frequency in MHz instead eg, 2437MHz

Signed-off-by: Andy Green <andy@warmcat.com>
---
 drivers/net/wireless/mac80211/iwlwifi/base.c    |    5 ++---
 drivers/net/wireless/mac80211/iwlwifi/iwlwifi.h |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

Index: wireless-dev/drivers/net/wireless/mac80211/iwlwifi/base.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/iwlwifi/base.c
+++ wireless-dev/drivers/net/wireless/mac80211/iwlwifi/base.c
@@ -2986,7 +2986,6 @@ void iwl_handle_data_packet_monitor(stru
 	 * the information provided in the skb from the hardware */
 	s8 signal = stats->ssi;
 	s8 noise = 0;
-	u16 channel = stats->channel;
 	int rate = stats->rate;
 	u64 tsf = stats->mactime;
 
@@ -3028,8 +3027,8 @@ void iwl_handle_data_packet_monitor(stru
 	iwl_rt->rt_dbmsignal = signal;
 	iwl_rt->rt_dbmnoise = noise;
 
-	/* Convert the channel data and set the flags */
-	iwl_rt->rt_channel = cpu_to_le16(channel);
+	/* Convert the channel frequency and set the flags */
+	iwl_rt->rt_channelMHz = cpu_to_le16(stats->freq);
 	if (!(phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK)) {
 		iwl_rt->rt_chbitmask =
 		    cpu_to_le16((IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ));
Index: wireless-dev/drivers/net/wireless/mac80211/iwlwifi/iwlwifi.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/iwlwifi/iwlwifi.h
+++ wireless-dev/drivers/net/wireless/mac80211/iwlwifi/iwlwifi.h
@@ -103,7 +103,7 @@ struct iwl_rt_rx_hdr {
 	__le64 rt_tsf;		/* TSF */
 	u8 rt_flags;		/* radiotap packet flags */
 	u8 rt_rate;		/* rate in 500kb/s */
-	__le16 rt_channel;	/* channel in mHz */
+	__le16 rt_channelMHz;	/* channel in MHz */
 	__le16 rt_chbitmask;	/* channel bitfield */
 	s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
 	s8 rt_dbmnoise;

-- 
