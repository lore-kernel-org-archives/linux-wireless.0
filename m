Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63020 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbXG0J2q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:28:46 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Andy Green <andy@warmcat.com>
Subject: [PATCH 01/17] iwlwifi: provide frequency to radiotap monitor not channel index
Date: Fri, 27 Jul 2007 17:26:25 +0800
Message-Id: <11855284032407-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11855284012123-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
To: ipwpatch@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwlwifi wrongly provides the channel index to the radiotap header
on Monitor mode. This results in tcpdump showing "6MHz" for example.

This patch arranges to send the frequency in MHz instead eg, 2437MHz

Signed-off-by: Andy Green <andy@warmcat.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |    5 ++---
 drivers/net/wireless/iwlwifi.h  |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index a1ebc2a..8671891 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -3120,7 +3120,6 @@ void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
 	 * the information provided in the skb from the hardware */
 	s8 signal = stats->ssi;
 	s8 noise = 0;
-	u16 channel = stats->channel;
 	int rate = stats->rate;
 	u64 tsf = stats->mactime;
 
@@ -3162,8 +3161,8 @@ void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
 	iwl_rt->rt_dbmsignal = signal;
 	iwl_rt->rt_dbmnoise = noise;
 
-	/* Convert the channel data and set the flags */
-	iwl_rt->rt_channel = cpu_to_le16(channel);
+	/* Convert the channel frequency and set the flags */
+	iwl_rt->rt_channelMHz = cpu_to_le16(stats->freq);
 	if (!(phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK)) {
 		iwl_rt->rt_chbitmask =
 		    cpu_to_le16((IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ));
diff --git a/drivers/net/wireless/iwlwifi.h b/drivers/net/wireless/iwlwifi.h
index a86fc48..58e3ea6 100644
--- a/drivers/net/wireless/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi.h
@@ -104,7 +104,7 @@ struct iwl_rt_rx_hdr {
 	__le64 rt_tsf;		/* TSF */
 	u8 rt_flags;		/* radiotap packet flags */
 	u8 rt_rate;		/* rate in 500kb/s */
-	__le16 rt_channel;	/* channel in mHz */
+	__le16 rt_channelMHz;	/* channel in MHz */
 	__le16 rt_chbitmask;	/* channel bitfield */
 	s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
 	s8 rt_dbmnoise;
-- 
1.5.2
