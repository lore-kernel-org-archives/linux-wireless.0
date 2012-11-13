Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44430 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab2KMSqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 13:46:46 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so5216526pad.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 10:46:46 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2] mac80211: support RX_FLAG_MACTIME_END
Date: Tue, 13 Nov 2012 10:46:27 -0800
Message-Id: <1352832387-21162-1-git-send-email-thomas@cozybit.com> (sfid-20121113_194651_355630_D5884664)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow drivers to indicate their mactime is at RX completion and adjust
for this in mac80211. Also rename the existing RX_FLAG_MACTIME_MPDU to
RX_FLAG_MACTIME_START to clarify its intent. Based on similar code by
Johannes Berg.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
v2:
	Rename MACTIME_MPDU to MACTIME_START (Javier)
	Throw a warning if invalid combination is set (Javier)
	Use FCS_LEN and improve documentation (Johannes)

 drivers/net/wireless/b43/xmit.c                |    2 +-
 drivers/net/wireless/b43legacy/xmit.c          |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c       |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c          |    2 +-
 drivers/net/wireless/mac80211_hwsim.c          |    2 +-
 drivers/net/wireless/p54/txrx.c                |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c   |    2 +-
 drivers/net/wireless/ti/wl1251/rx.c            |    2 +-
 include/net/mac80211.h                         |    8 +++-
 net/mac80211/ibss.c                            |   29 +++-----------
 net/mac80211/ieee80211_i.h                     |   11 ++++++
 net/mac80211/mesh_sync.c                       |   44 ++++-----------------
 net/mac80211/rx.c                              |   14 +++++--
 net/mac80211/util.c                            |   50 ++++++++++++++++++++++++
 20 files changed, 104 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 136510e..8cb206a 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -796,7 +796,7 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 		status.mactime += mactime;
 		if (low_mactime_now <= mactime)
 			status.mactime -= 0x10000;
-		status.flag |= RX_FLAG_MACTIME_MPDU;
+		status.flag |= RX_FLAG_MACTIME_START;
 	}
 
 	chanid = (chanstat & B43_RX_CHAN_ID) >> B43_RX_CHAN_ID_SHIFT;
diff --git a/drivers/net/wireless/b43legacy/xmit.c b/drivers/net/wireless/b43legacy/xmit.c
index b8ffea6..849a28c 100644
--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -557,7 +557,7 @@ void b43legacy_rx(struct b43legacy_wldev *dev,
 		status.mactime += mactime;
 		if (low_mactime_now <= mactime)
 			status.mactime -= 0x10000;
-		status.flag |= RX_FLAG_MACTIME_MPDU;
+		status.flag |= RX_FLAG_MACTIME_START;
 	}
 
 	chanid = (chanstat & B43legacy_RX_CHAN_ID) >>
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 565c15a..02363f8 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7508,7 +7508,7 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 
 	/* fill in TSF and flag its presence */
 	rx_status->mactime = brcms_c_recover_tsf64(wlc, rxh);
-	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
+	rx_status->flag |= RX_FLAG_MACTIME_START;
 
 	channel = BRCMS_CHAN_CHANNEL(rxh->RxChan);
 
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index eac4dc8..ef68b72 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -686,7 +686,7 @@ il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 
 	/* TSF isn't reliable. In order to allow smooth user experience,
 	 * this W/A doesn't propagate it to the mac80211 */
-	/*rx_status.flag |= RX_FLAG_MACTIME_MPDU; */
+	/*rx_status.flag |= RX_FLAG_MACTIME_START; */
 
 	il->ucode_beacon_time = le32_to_cpu(phy_res->beacon_time_stamp);
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index 5a9c325..ad50fb9 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -951,7 +951,7 @@ static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
 
 	/* TSF isn't reliable. In order to allow smooth user experience,
 	 * this W/A doesn't propagate it to the mac80211 */
-	/*rx_status.flag |= RX_FLAG_MACTIME_MPDU;*/
+	/*rx_status.flag |= RX_FLAG_MACTIME_START;*/
 
 	priv->ucode_beacon_time = le32_to_cpu(phy_res->beacon_time_stamp);
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 429ca32..26d2b38 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -645,7 +645,7 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	}
 
 	memset(&rx_status, 0, sizeof(rx_status));
-	rx_status.flag |= RX_FLAG_MACTIME_MPDU;
+	rx_status.flag |= RX_FLAG_MACTIME_START;
 	rx_status.freq = data->channel->center_freq;
 	rx_status.band = data->channel->band;
 	rx_status.rate_idx = info->control.rates[0].idx;
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 5861e13..8ae982b 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -369,7 +369,7 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
 	rx_status->mactime = ((u64)priv->tsf_high32) << 32 | tsf32;
 	priv->tsf_low32 = tsf32;
 
-	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
+	rx_status->flag |= RX_FLAG_MACTIME_START;
 
 	if (hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN))
 		header_len += hdr->align[0];
diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 021d83e..b4218a5 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -150,7 +150,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			rx_status.freq = dev->conf.channel->center_freq;
 			rx_status.band = dev->conf.channel->band;
 			rx_status.mactime = le64_to_cpu(entry->tsft);
-			rx_status.flag |= RX_FLAG_MACTIME_MPDU;
+			rx_status.flag |= RX_FLAG_MACTIME_START;
 			if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
 				rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index 7811b63..52e6beb 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -381,7 +381,7 @@ static void rtl8187_rx_cb(struct urb *urb)
 	rx_status.rate_idx = rate;
 	rx_status.freq = dev->conf.channel->center_freq;
 	rx_status.band = dev->conf.channel->band;
-	rx_status.flag |= RX_FLAG_MACTIME_MPDU;
+	rx_status.flag |= RX_FLAG_MACTIME_START;
 	if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
 		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index d7e1f0a..1734247 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -559,7 +559,7 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 	if (GET_RX_DESC_RXHT(pdesc))
 		rx_status->flag |= RX_FLAG_HT;
 
-	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
+	rx_status->flag |= RX_FLAG_MACTIME_START;
 
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 6e66f04..b6222ee 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -334,7 +334,7 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 		rx_status->flag |= RX_FLAG_40MHZ;
 	if (GET_RX_DESC_RX_HT(pdesc))
 		rx_status->flag |= RX_FLAG_HT;
-	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
+	rx_status->flag |= RX_FLAG_MACTIME_START;
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
index 35bb9da..f9f3861 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -509,7 +509,7 @@ bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,	struct rtl_stats *stats,
 		rx_status->flag |= RX_FLAG_40MHZ;
 	if (GET_RX_DESC_RXHT(pdesc))
 		rx_status->flag |= RX_FLAG_HT;
-	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
+	rx_status->flag |= RX_FLAG_MACTIME_START;
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 1ad51e7..0e9f6eb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -553,7 +553,7 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 	if (stats->is_ht)
 		rx_status->flag |= RX_FLAG_HT;
 
-	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
+	rx_status->flag |= RX_FLAG_MACTIME_START;
 
 	/* hw will set stats->decrypted true, if it finds the
 	 * frame is open data frame or mgmt frame,
diff --git a/drivers/net/wireless/ti/wl1251/rx.c b/drivers/net/wireless/ti/wl1251/rx.c
index 6af3526..23289d4 100644
--- a/drivers/net/wireless/ti/wl1251/rx.c
+++ b/drivers/net/wireless/ti/wl1251/rx.c
@@ -81,7 +81,7 @@ static void wl1251_rx_status(struct wl1251 *wl,
 	status->freq = ieee80211_channel_to_frequency(desc->channel,
 						      status->band);
 
-	status->flag |= RX_FLAG_MACTIME_MPDU;
+	status->flag |= RX_FLAG_MACTIME_START;
 
 	if (desc->flags & RX_DESC_ENCRYPTION_MASK) {
 		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 00b7204..4c2be57 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -700,10 +700,13 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  *	the frame.
  * @RX_FLAG_FAILED_PLCP_CRC: Set this flag if the PCLP check failed on
  *	the frame.
- * @RX_FLAG_MACTIME_MPDU: The timestamp passed in the RX status (@mactime
+ * @RX_FLAG_MACTIME_START: The timestamp passed in the RX status (@mactime
  *	field) is valid and contains the time the first symbol of the MPDU
  *	was received. This is useful in monitor mode and for proper IBSS
  *	merging.
+ * @RX_FLAG_MACTIME_END: The timestamp passed in the RX status (@mactime
+ *	field) is valid and contains the time the last symbol of the MPDU
+ *	(including FCS) was received.
  * @RX_FLAG_SHORTPRE: Short preamble was used for this frame
  * @RX_FLAG_HT: HT MCS was used and rate_idx is MCS index
  * @RX_FLAG_40MHZ: HT40 (40 MHz) was used
@@ -734,7 +737,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_IV_STRIPPED		= BIT(4),
 	RX_FLAG_FAILED_FCS_CRC		= BIT(5),
 	RX_FLAG_FAILED_PLCP_CRC 	= BIT(6),
-	RX_FLAG_MACTIME_MPDU		= BIT(7),
+	RX_FLAG_MACTIME_START		= BIT(7),
 	RX_FLAG_SHORTPRE		= BIT(8),
 	RX_FLAG_HT			= BIT(9),
 	RX_FLAG_40MHZ			= BIT(10),
@@ -748,6 +751,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_AMPDU_IS_LAST		= BIT(18),
 	RX_FLAG_AMPDU_DELIM_CRC_ERROR	= BIT(19),
 	RX_FLAG_AMPDU_DELIM_CRC_KNOWN	= BIT(20),
+	RX_FLAG_MACTIME_END		= BIT(21),
 };
 
 /**
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index c7386b2..cc11558 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -543,30 +543,11 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	if (ether_addr_equal(cbss->bssid, sdata->u.ibss.bssid))
 		goto put_bss;
 
-	if (rx_status->flag & RX_FLAG_MACTIME_MPDU) {
-		/*
-		 * For correct IBSS merging we need mactime; since mactime is
-		 * defined as the time the first data symbol of the frame hits
-		 * the PHY, and the timestamp of the beacon is defined as "the
-		 * time that the data symbol containing the first bit of the
-		 * timestamp is transmitted to the PHY plus the transmitting
-		 * STA's delays through its local PHY from the MAC-PHY
-		 * interface to its interface with the WM" (802.11 11.1.2)
-		 * - equals the time this bit arrives at the receiver - we have
-		 * to take into account the offset between the two.
-		 *
-		 * E.g. at 1 MBit that means mactime is 192 usec earlier
-		 * (=24 bytes * 8 usecs/byte) than the beacon timestamp.
-		 */
-		int rate;
-
-		if (rx_status->flag & RX_FLAG_HT)
-			rate = 65; /* TODO: HT rates */
-		else
-			rate = local->hw.wiphy->bands[band]->
-				bitrates[rx_status->rate_idx].bitrate;
-
-		rx_timestamp = rx_status->mactime + (24 * 8 * 10 / rate);
+	if (ieee80211_have_rx_timestamp(rx_status)) {
+		/* time when timestamp field was received */
+		rx_timestamp =
+			ieee80211_calculate_rx_timestamp(local, rx_status,
+							 len + FCS_LEN, 24);
 	} else {
 		/*
 		 * second best option: get current TSF
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3026519..236ee90 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1251,7 +1251,18 @@ static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
 	       is_broadcast_ether_addr(raddr);
 }
 
+static inline bool
+ieee80211_have_rx_timestamp(struct ieee80211_rx_status *status)
+{
+	WARN_ON_ONCE(status->flag & RX_FLAG_MACTIME_START &&
+		     status->flag & RX_FLAG_MACTIME_END);
+	return status->flag & (RX_FLAG_MACTIME_START | RX_FLAG_MACTIME_END);
+}
 
+u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
+				     struct ieee80211_rx_status *status,
+				     unsigned int mpdu_len,
+				     unsigned int mpdu_offset);
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed);
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index 407c870..9c6ea9c 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -116,43 +116,13 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		goto no_sync;
 	}
 
-	if (rx_status->flag & RX_FLAG_MACTIME_MPDU && rx_status->mactime) {
-		/*
-		 * The mactime is defined as the time the first data symbol
-		 * of the frame hits the PHY, and the timestamp of the beacon
-		 * is defined as "the time that the data symbol containing the
-		 * first bit of the timestamp is transmitted to the PHY plus
-		 * the transmitting STA's delays through its local PHY from the
-		 * MAC-PHY interface to its interface with the WM" (802.11
-		 * 11.1.2)
-		 *
-		 * T_r, in 13.13.2.2.2, is just defined as "the frame reception
-		 * time" but we unless we interpret that time to be the same
-		 * time of the beacon timestamp, the offset calculation will be
-		 * off.  Below we adjust t_r to be "the time at which the first
-		 * symbol of the timestamp element in the beacon is received".
-		 * This correction depends on the rate.
-		 *
-		 * Based on similar code in ibss.c
-		 */
-		int rate;
-
-		if (rx_status->flag & RX_FLAG_HT) {
-			/* TODO:
-			 * In principle there could be HT-beacons (Dual Beacon
-			 * HT Operation options), but for now ignore them and
-			 * just use the primary (i.e. non-HT) beacons for
-			 * synchronization.
-			 * */
-			goto no_sync;
-		} else
-			rate = local->hw.wiphy->bands[rx_status->band]->
-				bitrates[rx_status->rate_idx].bitrate;
-
-		/* 24 bytes of header * 8 bits/byte *
-		 * 10*(100 Kbps)/Mbps / rate (100 Kbps)*/
-		t_r = rx_status->mactime + (24 * 8 * 10 / rate);
-	}
+	if (ieee80211_have_rx_timestamp(rx_status))
+		/* time when timestamp field was received */
+		t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
+						       24 + 12 +
+						       elems->total_len +
+						       FCS_LEN,
+						       24);
 
 	/* Timing offset calculation (see 13.13.2.2.2) */
 	t_t = le64_to_cpu(mgmt->u.beacon.timestamp);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8c1f152..b75495e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -82,7 +82,7 @@ ieee80211_rx_radiotap_len(struct ieee80211_local *local,
 	/* always present fields */
 	len = sizeof(struct ieee80211_radiotap_header) + 9;
 
-	if (status->flag & RX_FLAG_MACTIME_MPDU)
+	if (ieee80211_have_rx_timestamp(status))
 		len += 8;
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		len += 1;
@@ -118,6 +118,11 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	struct ieee80211_radiotap_header *rthdr;
 	unsigned char *pos;
 	u16 rx_flags = 0;
+	int mpdulen;
+
+	mpdulen = skb->len;
+	if (!(has_fcs && (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)))
+		mpdulen += FCS_LEN;
 
 	rthdr = (struct ieee80211_radiotap_header *)skb_push(skb, rtap_len);
 	memset(rthdr, 0, rtap_len);
@@ -135,8 +140,11 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	/* the order of the following fields is important */
 
 	/* IEEE80211_RADIOTAP_TSFT */
-	if (status->flag & RX_FLAG_MACTIME_MPDU) {
-		put_unaligned_le64(status->mactime, pos);
+	if (ieee80211_have_rx_timestamp(status)) {
+		put_unaligned_le64(
+			ieee80211_calculate_rx_timestamp(local, status,
+							 mpdulen, 0),
+			pos);
 		rthdr->it_present |=
 			cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
 		pos += 8;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9556391..9d7271e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1990,3 +1990,53 @@ u8 ieee80211_mcs_to_chains(const struct ieee80211_mcs_info *mcs)
 		return 2;
 	return 1;
 }
+
+/**
+ * ieee80211_calculate_rx_timestamp - calculate timestamp in frame
+ * @status: RX status
+ * @mpdu_len: total MPDU length (including FCS)
+ * @mpdu_offset: offset into MPDU to calculate timestamp at
+ *
+ * This function calculates the RX timestamp at the given MPDU offset, taking
+ * into account what the RX timestamp was. An offset of 0 will just normalize
+ * the timestamp to TSF at beginning of MPDU reception.
+ */
+u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
+				     struct ieee80211_rx_status *status,
+				     unsigned int mpdu_len,
+				     unsigned int mpdu_offset)
+{
+	u64 ts = status->mactime;
+	struct rate_info ri;
+	u16 rate;
+
+	if (WARN_ON(!ieee80211_have_rx_timestamp(status)))
+		return 0;
+
+	memset(&ri, 0, sizeof(ri));
+
+	/* Fill cfg80211 rate info */
+	if (status->flag & RX_FLAG_HT) {
+		ri.mcs = status->rate_idx;
+		ri.flags |= RATE_INFO_FLAGS_MCS;
+		if (status->flag & RX_FLAG_40MHZ)
+			ri.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+		if (status->flag & RX_FLAG_SHORT_GI)
+			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
+	} else {
+		struct ieee80211_supported_band *sband;
+
+		sband = local->hw.wiphy->bands[status->band];
+		ri.legacy = sband->bitrates[status->rate_idx].bitrate;
+	}
+
+	rate = cfg80211_calculate_bitrate(&ri);
+
+	/* rewind from end of MPDU */
+	if (status->flag & RX_FLAG_MACTIME_END)
+		ts -= mpdu_len * 8 * 10 / rate;
+
+	ts += mpdu_offset * 8 * 10 / rate;
+
+	return ts;
+}
-- 
1.7.10.4

