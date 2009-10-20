Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:47544 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbZJTMNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 08:13:51 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: allow driver to signal noise level
Date: Tue, 20 Oct 2009 14:13:29 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910201413.29734.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allows a WLAN driver to signal current noise level:

# iw eth1 link
Connected to 00:13:19:80:da:30 (on eth1)
        SSID: SSID
        freq: 2437
        RX: 424 bytes (5 packets)
        TX: 0 bytes (0 packets)
        signal: -49 dBm
        noise: -93 dBm
        tx bitrate: 11.0 MBit/s

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

NOTE: I didn't find out how to modify wext-compat.c so
that "iwconfig" would also display the noise.

--- linux-wl.orig/include/linux/nl80211.h
+++ linux-wl/include/linux/nl80211.h
@@ -871,6 +871,8 @@
  * @NL80211_STA_INFO_RX_PACKETS: total received packet (u32, from this station)
  * @NL80211_STA_INFO_TX_PACKETS: total transmitted packets (u32, to this
  *	station)
+ * @NL80211_STA_INFO_NOISE: noise level (u8, dBm) (used in station mode for
+ *	"iw link")
  */
 enum nl80211_sta_info {
 	__NL80211_STA_INFO_INVALID,
@@ -884,6 +886,7 @@
 	NL80211_STA_INFO_TX_BITRATE,
 	NL80211_STA_INFO_RX_PACKETS,
 	NL80211_STA_INFO_TX_PACKETS,
+	NL80211_STA_INFO_NOISE,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
--- linux-wl.orig/include/net/cfg80211.h
+++ linux-wl/include/net/cfg80211.h
@@ -309,6 +309,7 @@
  *  (tx_bitrate, tx_bitrate_flags and tx_bitrate_mcs)
  * @STATION_INFO_RX_PACKETS: @rx_packets filled
  * @STATION_INFO_TX_PACKETS: @tx_packets filled
+ * @STATION_INFO_NOISE: @noise filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -321,6 +322,7 @@
 	STATION_INFO_TX_BITRATE		= 1<<7,
 	STATION_INFO_RX_PACKETS		= 1<<8,
 	STATION_INFO_TX_PACKETS		= 1<<9,
+	STATION_INFO_NOISE		= 1<<10,
 };
 
 /**
@@ -367,6 +369,7 @@
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
  * @signal: signal strength of last received packet in dBm
+ * @noise: noise level in dBm
  * @txrate: current unicast bitrate to this station
  * @rx_packets: packets received from this station
  * @tx_packets: packets transmitted to this station
@@ -384,6 +387,7 @@
 	u16 plid;
 	u8 plink_state;
 	s8 signal;
+	s8 noise;
 	struct rate_info txrate;
 	u32 rx_packets;
 	u32 tx_packets;
--- linux-wl.orig/net/wireless/nl80211.c
+++ linux-wl/net/wireless/nl80211.c
@@ -1636,6 +1636,9 @@
 	if (sinfo->filled & STATION_INFO_SIGNAL)
 		NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL,
 			   sinfo->signal);
+	if (sinfo->filled & STATION_INFO_NOISE)
+		NLA_PUT_U8(msg, NL80211_STA_INFO_NOISE,
+			   sinfo->noise);
 	if (sinfo->filled & STATION_INFO_TX_BITRATE) {
 		txrate = nla_nest_start(msg, NL80211_STA_INFO_TX_BITRATE);
 		if (!txrate)

-- 
http://www.holgerschurig.de
