Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:37050 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585AbZBQLZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 06:25:17 -0500
Date: Tue, 17 Feb 2009 13:24:57 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Provide access to STA TX/RX packet counters
Message-ID: <20090217112457.GA22926@jm.kir.nu> (sfid-20090217_122535_761731_C0816CB0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX/RX packet counters are needed to fill in RADIUS Accounting
attributes Acct-Output-Packets and Acct-Input-Packets. We already
collect the needed information, but only the TX/RX bytes were
previously exposed through nl80211. Allow applications to fetch the
packet counters, too, to provide more complete support for accounting.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/linux/nl80211.h |    5 +++++
 include/net/cfg80211.h  |    8 ++++++++
 net/mac80211/cfg.c      |    4 ++++
 net/wireless/nl80211.c  |    6 ++++++
 4 files changed, 23 insertions(+)

--- uml.orig/include/linux/nl80211.h	2009-02-17 13:09:52.000000000 +0200
+++ uml/include/linux/nl80211.h	2009-02-17 13:11:11.000000000 +0200
@@ -526,6 +526,9 @@ enum nl80211_rate_info {
  * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, dBm)
  * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
  * 	containing info as possible, see &enum nl80211_sta_info_txrate.
+ * @NL80211_STA_INFO_RX_PACKETS: total received packet (u32, from this station)
+ * @NL80211_STA_INFO_TX_PACKETS: total transmitted packets (u32, to this
+ *	station)
  */
 enum nl80211_sta_info {
 	__NL80211_STA_INFO_INVALID,
@@ -537,6 +540,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_PLINK_STATE,
 	NL80211_STA_INFO_SIGNAL,
 	NL80211_STA_INFO_TX_BITRATE,
+	NL80211_STA_INFO_RX_PACKETS,
+	NL80211_STA_INFO_TX_PACKETS,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
--- uml.orig/include/net/cfg80211.h	2009-02-17 13:11:25.000000000 +0200
+++ uml/include/net/cfg80211.h	2009-02-17 13:12:37.000000000 +0200
@@ -178,6 +178,8 @@ struct station_parameters {
  * @STATION_INFO_SIGNAL: @signal filled
  * @STATION_INFO_TX_BITRATE: @tx_bitrate fields are filled
  *  (tx_bitrate, tx_bitrate_flags and tx_bitrate_mcs)
+ * @STATION_INFO_RX_PACKETS: @rx_packets filled
+ * @STATION_INFO_TX_PACKETS: @tx_packets filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -188,6 +190,8 @@ enum station_info_flags {
 	STATION_INFO_PLINK_STATE	= 1<<5,
 	STATION_INFO_SIGNAL		= 1<<6,
 	STATION_INFO_TX_BITRATE		= 1<<7,
+	STATION_INFO_RX_PACKETS		= 1<<8,
+	STATION_INFO_TX_PACKETS		= 1<<9,
 };
 
 /**
@@ -235,6 +239,8 @@ struct rate_info {
  * @plink_state: mesh peer link state
  * @signal: signal strength of last received packet in dBm
  * @txrate: current unicast bitrate to this station
+ * @rx_packets: packets received from this station
+ * @tx_packets: packets transmitted to this station
  */
 struct station_info {
 	u32 filled;
@@ -246,6 +252,8 @@ struct station_info {
 	u8 plink_state;
 	s8 signal;
 	struct rate_info txrate;
+	u32 rx_packets;
+	u32 tx_packets;
 };
 
 /**
--- uml.orig/net/mac80211/cfg.c	2009-02-17 13:13:59.000000000 +0200
+++ uml/net/mac80211/cfg.c	2009-02-17 13:14:40.000000000 +0200
@@ -341,11 +341,15 @@ static void sta_set_sinfo(struct sta_inf
 	sinfo->filled = STATION_INFO_INACTIVE_TIME |
 			STATION_INFO_RX_BYTES |
 			STATION_INFO_TX_BYTES |
+			STATION_INFO_RX_PACKETS |
+			STATION_INFO_TX_PACKETS |
 			STATION_INFO_TX_BITRATE;
 
 	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
 	sinfo->rx_bytes = sta->rx_bytes;
 	sinfo->tx_bytes = sta->tx_bytes;
+	sinfo->rx_packets = sta->rx_packets;
+	sinfo->tx_packets = sta->tx_packets;
 
 	if (sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
 		sinfo->filled |= STATION_INFO_SIGNAL;
--- uml.orig/net/wireless/nl80211.c	2009-02-17 13:12:55.000000000 +0200
+++ uml/net/wireless/nl80211.c	2009-02-17 13:13:54.000000000 +0200
@@ -1206,6 +1206,12 @@ static int nl80211_send_station(struct s
 
 		nla_nest_end(msg, txrate);
 	}
+	if (sinfo->filled & STATION_INFO_RX_PACKETS)
+		NLA_PUT_U32(msg, NL80211_STA_INFO_RX_PACKETS,
+			    sinfo->rx_packets);
+	if (sinfo->filled & STATION_INFO_TX_PACKETS)
+		NLA_PUT_U32(msg, NL80211_STA_INFO_TX_PACKETS,
+			    sinfo->tx_packets);
 	nla_nest_end(msg, sinfoattr);
 
 	return genlmsg_end(msg, hdr);

-- 
Jouni Malinen                                            PGP id EFC895FA
