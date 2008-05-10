Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbYEJWWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 18:22:13 -0400
Message-Id: <20080510221908.875473000@sipsolutions.net> (sfid-20080511_002320_626219_D50468B0)
References: <20080510221845.340428000@sipsolutions.net>
Date: Sun, 11 May 2008 00:18:52 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Subject: [RFT/C 7/7] mac80211: move TX info into skb->cb
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch converts mac80211 and all drivers to have transmit
information and status in skb->cb rather than allocating extra
memory for it and copying all the data around. To make it fit,
a union is used where only data that is necessary for all steps
is kept outside of the union.

A number of fixes were done by Ivo, as well as the rt2x00 part
of this patch.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/adm8211.c              |   31 +-
 drivers/net/wireless/adm8211.h              |    1 
 drivers/net/wireless/at76_usb.c             |   17 -
 drivers/net/wireless/at76_usb.h             |    1 
 drivers/net/wireless/ath5k/base.c           |   70 ++----
 drivers/net/wireless/ath5k/base.h           |    1 
 drivers/net/wireless/b43/b43.h              |    1 
 drivers/net/wireless/b43/dma.c              |   45 ++--
 drivers/net/wireless/b43/dma.h              |    3 
 drivers/net/wireless/b43/main.c             |   33 +-
 drivers/net/wireless/b43/pio.c              |   36 +--
 drivers/net/wireless/b43/pio.h              |    8 
 drivers/net/wireless/b43/xmit.c             |   58 ++---
 drivers/net/wireless/b43/xmit.h             |    4 
 drivers/net/wireless/b43legacy/dma.c        |   36 +--
 drivers/net/wireless/b43legacy/dma.h        |    4 
 drivers/net/wireless/b43legacy/main.c       |   12 -
 drivers/net/wireless/b43legacy/pio.c        |   19 -
 drivers/net/wireless/b43legacy/pio.h        |    4 
 drivers/net/wireless/b43legacy/xmit.c       |   44 +--
 drivers/net/wireless/b43legacy/xmit.h       |    2 
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |   12 -
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   24 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    3 
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |   49 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   32 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    5 
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   48 +---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   92 +++-----
 drivers/net/wireless/p54/p54common.c        |   90 +++-----
 drivers/net/wireless/p54/p54common.h        |    1 
 drivers/net/wireless/rt2x00/rt2400pci.c     |   14 -
 drivers/net/wireless/rt2x00/rt2500pci.c     |   14 -
 drivers/net/wireless/rt2x00/rt2500usb.c     |   15 -
 drivers/net/wireless/rt2x00/rt2x00.h        |   10 
 drivers/net/wireless/rt2x00/rt2x00dev.c     |   49 ++--
 drivers/net/wireless/rt2x00/rt2x00mac.c     |   82 +++----
 drivers/net/wireless/rt2x00/rt2x00pci.c     |   11 
 drivers/net/wireless/rt2x00/rt2x00pci.h     |    6 
 drivers/net/wireless/rt2x00/rt2x00queue.c   |   35 +--
 drivers/net/wireless/rt2x00/rt2x00queue.h   |   31 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c     |   12 -
 drivers/net/wireless/rt2x00/rt2x00usb.h     |    9 
 drivers/net/wireless/rt2x00/rt61pci.c       |   14 -
 drivers/net/wireless/rt2x00/rt73usb.c       |   14 -
 drivers/net/wireless/rtl8180_dev.c          |   57 ++---
 drivers/net/wireless/rtl8187.h              |    6 
 drivers/net/wireless/rtl8187_dev.c          |   41 +--
 drivers/net/wireless/zd1211rw/zd_mac.c      |  153 +++----------
 drivers/net/wireless/zd1211rw/zd_mac.h      |   16 -
 drivers/net/wireless/zd1211rw/zd_usb.c      |    6 
 include/net/mac80211.h                      |  297 +++++++++++---------------
 net/mac80211/ieee80211_i.h                  |   18 -
 net/mac80211/main.c                         |  126 +++--------
 net/mac80211/mlme.c                         |   30 +-
 net/mac80211/rate.h                         |    8 
 net/mac80211/rc80211_pid.h                  |    4 
 net/mac80211/rc80211_pid_algo.c             |   18 -
 net/mac80211/rc80211_pid_debugfs.c          |    8 
 net/mac80211/rx.c                           |   10 
 net/mac80211/sta_info.c                     |    6 
 net/mac80211/sta_info.h                     |    2 
 net/mac80211/tx.c                           |  313 +++++++++++++---------------
 net/mac80211/util.c                         |   10 
 net/mac80211/wep.c                          |    9 
 net/mac80211/wme.c                          |   22 -
 net/mac80211/wpa.c                          |   65 ++---
 67 files changed, 1028 insertions(+), 1299 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-05-11 00:05:13.000000000 +0200
+++ everything/include/net/mac80211.h	2008-05-11 00:05:16.000000000 +0200
@@ -201,103 +201,128 @@ struct ieee80211_bss_conf {
 };
 
 /**
- * enum mac80211_tx_control_flags - flags to describe Tx configuration for
- * 				    the Tx frame
+ * enum mac80211_tx_flags - flags to transmission information/status
  *
- * These flags are used with the @flags member of &ieee80211_tx_control
+ * These flags are used with the @flags member of &ieee80211_tx_info
  *
- * @IEEE80211_TXCTL_REQ_TX_STATUS: request TX status callback for this frame.
- * @IEEE80211_TXCTL_DO_NOT_ENCRYPT: send this frame without encryption;
- * 				    e.g., for EAPOL frame
- * @IEEE80211_TXCTL_USE_RTS_CTS: use RTS-CTS before sending frame
- * @IEEE80211_TXCTL_USE_CTS_PROTECT: use CTS protection for the frame (e.g.,
- * 				     for combined 802.11g / 802.11b networks)
- * @IEEE80211_TXCTL_NO_ACK: tell the low level not to wait for an ack
- * @IEEE80211_TXCTL_RATE_CTRL_PROBE
- * @EEE80211_TXCTL_CLEAR_PS_FILT: clear powersave filter
- *                                 for destination station
- * @IEEE80211_TXCTL_REQUEUE:
- * @IEEE80211_TXCTL_FIRST_FRAGMENT: this is a first fragment of the frame
- * @IEEE80211_TXCTL_LONG_RETRY_LIMIT: this frame should be send using the
- * 				      through set_retry_limit configured long
- * 				      retry value
- * @IEEE80211_TXCTL_EAPOL_FRAME: internal to mac80211
- * @IEEE80211_TXCTL_SEND_AFTER_DTIM: send this frame after DTIM beacon
- * @IEEE80211_TXCTL_AMPDU: this frame should be sent as part of an A-MPDU
- * @IEEE80211_TXCTL_OFDM_HT: this frame can be sent in HT OFDM rates. number
- * 			     of streams when this flag is on can be extracted
- *			     from antenna_sel_tx, so if 1 antenna is marked
- *			     use SISO, 2 antennas marked use MIMO, n antennas
- *			     marked use MIMO_n.
- * @IEEE80211_TXCTL_GREEN_FIELD: use green field protection for this frame
- * @IEEE80211_TXCTL_40_MHZ_WIDTH: send this frame using 40 Mhz channel width
- * @IEEE80211_TXCTL_DUP_DATA: duplicate data frame on both 20 Mhz channels
- * @IEEE80211_TXCTL_SHORT_GI: send this frame using short guard interval
+ * @IEEE80211_TX_CTL_REQ_TX_STATUS: request TX status callback for this frame.
+ * @IEEE80211_TX_CTL_DO_NOT_ENCRYPT: send this frame without encryption;
+ *	e.g., for EAPOL frame
+ * @IEEE80211_TX_CTL_USE_RTS_CTS: use RTS-CTS before sending frame
+ * @IEEE80211_TX_CTL_USE_CTS_PROTECT: use CTS protection for the frame (e.g.,
+ *	for combined 802.11g / 802.11b networks)
+ * @IEEE80211_TX_CTL_NO_ACK: tell the low level not to wait for an ack
+ * @IEEE80211_TX_CTL_RATE_CTRL_PROBE
+ * @IEEE80211_TX_CTL_CLEAR_PS_FILT: clear powersave filter for destination
+ *	station
+ * @IEEE80211_TX_CTL_REQUEUE:
+ * @IEEE80211_TX_CTL_FIRST_FRAGMENT: this is a first fragment of the frame
+ * @IEEE80211_TX_CTL_LONG_RETRY_LIMIT: this frame should be send using the
+ *	through set_retry_limit configured long retry value
+ * @IEEE80211_TX_CTL_EAPOL_FRAME: internal to mac80211
+ * @IEEE80211_TX_CTL_SEND_AFTER_DTIM: send this frame after DTIM beacon
+ * @IEEE80211_TX_CTL_AMPDU: this frame should be sent as part of an A-MPDU
+ * @IEEE80211_TX_CTL_OFDM_HT: this frame can be sent in HT OFDM rates. number
+ *	of streams when this flag is on can be extracted from antenna_sel_tx,
+ *	so if 1 antenna is marked use SISO, 2 antennas marked use MIMO, n
+ *	antennas marked use MIMO_n.
+ * @IEEE80211_TX_CTL_GREEN_FIELD: use green field protection for this frame
+ * @IEEE80211_TX_CTL_40_MHZ_WIDTH: send this frame using 40 Mhz channel width
+ * @IEEE80211_TX_CTL_DUP_DATA: duplicate data frame on both 20 Mhz channels
+ * @IEEE80211_TX_CTL_SHORT_GI: send this frame using short guard interval
+ * @IEEE80211_TX_CTL_READY_FOR_TX: Set by mac80211 internally when the frame
+ *	has been prepared for transmission, will always be set when a frame
+ *	is handed to a driver.
+ * @IEEE80211_TX_STAT_TX_FILTERED: The frame was not transmitted
+ *	because the destination STA was in powersave mode.
+ * @IEEE80211_TX_STAT_ACK: Frame was acknowledged
+ * @IEEE80211_TX_STAT_AMPDU: The frame was aggregated, so status
+ * 	is for the whole aggregation.
  */
 enum mac80211_tx_control_flags {
-	IEEE80211_TXCTL_REQ_TX_STATUS		= (1<<0),
-	IEEE80211_TXCTL_DO_NOT_ENCRYPT		= (1<<1),
-	IEEE80211_TXCTL_USE_RTS_CTS		= (1<<2),
-	IEEE80211_TXCTL_USE_CTS_PROTECT		= (1<<3),
-	IEEE80211_TXCTL_NO_ACK			= (1<<4),
-	IEEE80211_TXCTL_RATE_CTRL_PROBE		= (1<<5),
-	IEEE80211_TXCTL_CLEAR_PS_FILT		= (1<<6),
-	IEEE80211_TXCTL_REQUEUE			= (1<<7),
-	IEEE80211_TXCTL_FIRST_FRAGMENT		= (1<<8),
-	IEEE80211_TXCTL_SHORT_PREAMBLE		= (1<<9),
-	IEEE80211_TXCTL_LONG_RETRY_LIMIT	= (1<<10),
-	IEEE80211_TXCTL_EAPOL_FRAME		= (1<<11),
-	IEEE80211_TXCTL_SEND_AFTER_DTIM		= (1<<12),
-	IEEE80211_TXCTL_AMPDU			= (1<<13),
-	IEEE80211_TXCTL_OFDM_HT			= (1<<14),
-	IEEE80211_TXCTL_GREEN_FIELD		= (1<<15),
-	IEEE80211_TXCTL_40_MHZ_WIDTH		= (1<<16),
-	IEEE80211_TXCTL_DUP_DATA		= (1<<17),
-	IEEE80211_TXCTL_SHORT_GI		= (1<<18),
-};
-
-/* Transmit control fields. This data structure is passed to low-level driver
- * with each TX frame. The low-level driver is responsible for configuring
- * the hardware to use given values (depending on what is supported).
- *
- * NOTE: Be careful with using the pointers outside of the ieee80211_ops->tx()
- * context (i.e. when defering the work to a workqueue).
- * The vif pointer is valid until the it has been removed with the
- * ieee80211_ops->remove_interface() callback funtion.
- * The hw_key pointer is valid until it has been removed with the
- * ieee80211_ops->set_key() callback function.
- */
-struct ieee80211_tx_control {
-	u32 flags;		/* tx control flags defined above */
-
-	s8 tx_rate_idx,		/* Transmit rate (indexes registered rates) */
-	   rts_cts_rate_idx,	/* Transmit rate for RTS/CTS frame */
-	   alt_retry_rate_idx;	/* retry rate for the last retries */
-
-	s8 retry_limit;		/* 1 = only first attempt, 2 = one retry, ..
-				 * This could be used when set_retry_limit
-				 * is not implemented by the driver */
+	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
+	IEEE80211_TX_CTL_DO_NOT_ENCRYPT		= BIT(1),
+	IEEE80211_TX_CTL_USE_RTS_CTS		= BIT(2),
+	IEEE80211_TX_CTL_USE_CTS_PROTECT	= BIT(3),
+	IEEE80211_TX_CTL_NO_ACK			= BIT(4),
+	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(5),
+	IEEE80211_TX_CTL_CLEAR_PS_FILT		= BIT(6),
+	IEEE80211_TX_CTL_REQUEUE		= BIT(7),
+	IEEE80211_TX_CTL_FIRST_FRAGMENT		= BIT(8),
+	IEEE80211_TX_CTL_SHORT_PREAMBLE		= BIT(9),
+	IEEE80211_TX_CTL_LONG_RETRY_LIMIT	= BIT(10),
+	IEEE80211_TX_CTL_EAPOL_FRAME		= BIT(11),
+	IEEE80211_TX_CTL_SEND_AFTER_DTIM	= BIT(12),
+	IEEE80211_TX_CTL_AMPDU			= BIT(13),
+	IEEE80211_TX_CTL_OFDM_HT		= BIT(14),
+	IEEE80211_TX_CTL_GREEN_FIELD		= BIT(15),
+	IEEE80211_TX_CTL_40_MHZ_WIDTH		= BIT(16),
+	IEEE80211_TX_CTL_DUP_DATA		= BIT(17),
+	IEEE80211_TX_CTL_SHORT_GI		= BIT(18),
+	IEEE80211_TX_CTL_READY_FOR_TX		= BIT(19),
+	IEEE80211_TX_CTL_INJECTED		= BIT(20),
+	IEEE80211_TX_STAT_TX_FILTERED		= BIT(21),
+	IEEE80211_TX_STAT_ACK			= BIT(22),
+	IEEE80211_TX_STAT_AMPDU			= BIT(23),
+};
 
-	struct ieee80211_vif *vif;
 
-	/* Key used for hardware encryption
-	 * NULL if IEEE80211_TXCTL_DO_NOT_ENCRYPT is set */
-	struct ieee80211_key_conf *hw_key;
+#define IEEE80211_TX_INFO_DRIVER_DATA_SIZE \
+	(sizeof(((struct sk_buff *)0)->cb) - 8)
+#define IEEE80211_TX_INFO_DRIVER_DATA_PTRS \
+	(IEEE80211_TX_INFO_DRIVER_DATA_SIZE / sizeof(void *))
+
+/**
+ * union ieee80211_tx_info - skb transmit information
+ *
+ * This structure is placed in skb->cb for three uses:
+ *  (1) mac80211 TX control - mac80211 tells the driver what to do
+ *  (2) driver internal use (if applicable)
+ *  (3) TX status information - driver tells mac80211 what happened
+ *
+ * @flags: transmit info flags, defined above
+ * @retry_count: number of retries
+ * @excessive_retries: set to 1 if the frame was retried many times
+ *	but not acknowledged
+ * @ampdu_ack_len: number of aggregated frames.
+ * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
+ * @ampdu_ack_map: block ack bit map for the aggregation.
+ * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
+ * @ack_signal: signal strength of the ACK frame
+ */
+struct ieee80211_tx_info {
+	/* common information */
+	u32 flags;
+	u8 band;
+	s8 tx_rate_idx;
+	u8 antenna_sel_tx;
 
-	enum ieee80211_band band;
+	u8 queue; /* use skb_queue_mapping soon */
 
-	u8 antenna_sel_tx; 	/* 0 = default/diversity, otherwise bit
-				 * position represents antenna number used */
-	u8 icv_len;		/* length of the ICV/MIC field in octets */
-	u8 iv_len;		/* length of the IV field in octets */
-	u16 queue;		/* hardware queue to use for this frame;
-				 * 0 = highest, hw->queues-1 = lowest */
-	u16 aid;		/* Station AID */
-	int type;	/* internal */
+	union {
+		struct {
+			struct ieee80211_vif *vif;
+			struct ieee80211_key_conf *hw_key;
+			unsigned long jiffies;
+			int ifindex;
+			u16 aid;
+			s8 rts_cts_rate_idx, alt_retry_rate_idx;
+			u8 retry_limit;
+			u8 icv_len;
+			u8 iv_len;
+		} control;
+		struct {
+			u64 ampdu_ack_map;
+			int ack_signal;
+			u8 retry_count;
+			bool excessive_retries;
+			u8 ampdu_ack_len;
+		} status;
+		void *driver_data[IEEE80211_TX_INFO_DRIVER_DATA_PTRS];
+	};
 };
 
 
-
 /**
  * enum mac80211_rx_flags - receive flags
  *
@@ -360,51 +385,6 @@ struct ieee80211_rx_status {
 };
 
 /**
- * enum ieee80211_tx_status_flags - transmit status flags
- *
- * Status flags to indicate various transmit conditions.
- *
- * @IEEE80211_TX_STATUS_TX_FILTERED: The frame was not transmitted
- *	because the destination STA was in powersave mode.
- * @IEEE80211_TX_STATUS_ACK: Frame was acknowledged
- * @IEEE80211_TX_STATUS_AMPDU: The frame was aggregated, so status
- * 	is for the whole aggregation.
- */
-enum ieee80211_tx_status_flags {
-	IEEE80211_TX_STATUS_TX_FILTERED	= 1<<0,
-	IEEE80211_TX_STATUS_ACK		= 1<<1,
-	IEEE80211_TX_STATUS_AMPDU	= 1<<2,
-};
-
-/**
- * struct ieee80211_tx_status - transmit status
- *
- * As much information as possible should be provided for each transmitted
- * frame with ieee80211_tx_status().
- *
- * @control: a copy of the &struct ieee80211_tx_control passed to the driver
- *	in the tx() callback.
- * @flags: transmit status flags, defined above
- * @retry_count: number of retries
- * @excessive_retries: set to 1 if the frame was retried many times
- *	but not acknowledged
- * @ampdu_ack_len: number of aggregated frames.
- * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
- * @ampdu_ack_map: block ack bit map for the aggregation.
- * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
- * @ack_signal: signal strength of the ACK frame
- */
-struct ieee80211_tx_status {
-	struct ieee80211_tx_control control;
-	u8 flags;
-	u8 retry_count;
-	bool excessive_retries;
-	u8 ampdu_ack_len;
-	u64 ampdu_ack_map;
-	int ack_signal;
-};
-
-/**
  * enum ieee80211_conf_flags - configuration flags
  *
  * Flags to define PHY configuration options
@@ -559,7 +539,6 @@ struct ieee80211_if_conf {
 	u8 *ssid;
 	size_t ssid_len;
 	struct sk_buff *beacon;
-	struct ieee80211_tx_control *beacon_control;
 };
 
 /**
@@ -804,7 +783,7 @@ static inline void SET_IEEE80211_PERM_AD
 
 static inline struct ieee80211_rate *
 ieee80211_get_tx_rate(const struct ieee80211_hw *hw,
-		      const struct ieee80211_tx_control *c)
+		      const struct ieee80211_tx_info *c)
 {
 	if (WARN_ON(c->tx_rate_idx < 0))
 		return NULL;
@@ -813,20 +792,20 @@ ieee80211_get_tx_rate(const struct ieee8
 
 static inline struct ieee80211_rate *
 ieee80211_get_rts_cts_rate(const struct ieee80211_hw *hw,
-			   const struct ieee80211_tx_control *c)
+			   const struct ieee80211_tx_info *c)
 {
-	if (c->rts_cts_rate_idx < 0)
+	if (c->control.rts_cts_rate_idx < 0)
 		return NULL;
-	return &hw->wiphy->bands[c->band]->bitrates[c->rts_cts_rate_idx];
+	return &hw->wiphy->bands[c->band]->bitrates[c->control.rts_cts_rate_idx];
 }
 
 static inline struct ieee80211_rate *
 ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
-			     const struct ieee80211_tx_control *c)
+			     const struct ieee80211_tx_info *c)
 {
-	if (c->alt_retry_rate_idx < 0)
+	if (c->control.alt_retry_rate_idx < 0)
 		return NULL;
-	return &hw->wiphy->bands[c->band]->bitrates[c->alt_retry_rate_idx];
+	return &hw->wiphy->bands[c->band]->bitrates[c->control.alt_retry_rate_idx];
 }
 
 /**
@@ -1121,8 +1100,7 @@ enum ieee80211_ampdu_mlme_action {
  * 	that TX/RX_STOP can pass NULL for this parameter.
  */
 struct ieee80211_ops {
-	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb,
-		  struct ieee80211_tx_control *control);
+	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
 	int (*start)(struct ieee80211_hw *hw);
 	void (*stop)(struct ieee80211_hw *hw);
 	int (*add_interface)(struct ieee80211_hw *hw,
@@ -1166,8 +1144,7 @@ struct ieee80211_ops {
 	u64 (*get_tsf)(struct ieee80211_hw *hw);
 	void (*reset_tsf)(struct ieee80211_hw *hw);
 	int (*beacon_update)(struct ieee80211_hw *hw,
-			     struct sk_buff *skb,
-			     struct ieee80211_tx_control *control);
+			     struct sk_buff *skb);
 	int (*tx_last_beacon)(struct ieee80211_hw *hw);
 	int (*ampdu_action)(struct ieee80211_hw *hw,
 			    enum ieee80211_ampdu_mlme_action action,
@@ -1363,13 +1340,9 @@ void ieee80211_rx_irqsafe(struct ieee802
  *
  * @hw: the hardware the frame was transmitted by
  * @skb: the frame that was transmitted, owned by mac80211 after this call
- * @status: status information for this frame; the status pointer need not
- *	be valid after this function returns and is not freed by mac80211,
- *	it is recommended that it points to a stack area
  */
 void ieee80211_tx_status(struct ieee80211_hw *hw,
-			 struct sk_buff *skb,
-			 struct ieee80211_tx_status *status);
+			 struct sk_buff *skb);
 
 /**
  * ieee80211_tx_status_irqsafe - irq-safe transmit status callback
@@ -1382,13 +1355,9 @@ void ieee80211_tx_status(struct ieee8021
  *
  * @hw: the hardware the frame was transmitted by
  * @skb: the frame that was transmitted, owned by mac80211 after this call
- * @status: status information for this frame; the status pointer need not
- *	be valid after this function returns and is not freed by mac80211,
- *	it is recommended that it points to a stack area
  */
 void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
-				 struct sk_buff *skb,
-				 struct ieee80211_tx_status *status);
+				 struct sk_buff *skb);
 
 /**
  * ieee80211_beacon_get - beacon generation function
@@ -1404,8 +1373,7 @@ void ieee80211_tx_status_irqsafe(struct 
  * is responsible of freeing it.
  */
 struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
-				     struct ieee80211_vif *vif,
-				     struct ieee80211_tx_control *control);
+				     struct ieee80211_vif *vif);
 
 /**
  * ieee80211_rts_get - RTS frame generation function
@@ -1413,7 +1381,7 @@ struct sk_buff *ieee80211_beacon_get(str
  * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
  * @frame: pointer to the frame that is going to be protected by the RTS.
  * @frame_len: the frame length (in octets).
- * @frame_txctl: &struct ieee80211_tx_control of the frame.
+ * @frame_txctl: &struct ieee80211_tx_info of the frame.
  * @rts: The buffer where to store the RTS frame.
  *
  * If the RTS frames are generated by the host system (i.e., not in
@@ -1423,7 +1391,7 @@ struct sk_buff *ieee80211_beacon_get(str
  */
 void ieee80211_rts_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       const void *frame, size_t frame_len,
-		       const struct ieee80211_tx_control *frame_txctl,
+		       const struct ieee80211_tx_info *frame_txctl,
 		       struct ieee80211_rts *rts);
 
 /**
@@ -1431,7 +1399,7 @@ void ieee80211_rts_get(struct ieee80211_
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
  * @frame_len: the length of the frame that is going to be protected by the RTS.
- * @frame_txctl: &struct ieee80211_tx_control of the frame.
+ * @frame_txctl: &struct ieee80211_tx_info of the frame.
  *
  * If the RTS is generated in firmware, but the host system must provide
  * the duration field, the low-level driver uses this function to receive
@@ -1439,7 +1407,7 @@ void ieee80211_rts_get(struct ieee80211_
  */
 __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif, size_t frame_len,
-			      const struct ieee80211_tx_control *frame_txctl);
+			      const struct ieee80211_tx_info *frame_txctl);
 
 /**
  * ieee80211_ctstoself_get - CTS-to-self frame generation function
@@ -1447,7 +1415,7 @@ __le16 ieee80211_rts_duration(struct iee
  * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
  * @frame: pointer to the frame that is going to be protected by the CTS-to-self.
  * @frame_len: the frame length (in octets).
- * @frame_txctl: &struct ieee80211_tx_control of the frame.
+ * @frame_txctl: &struct ieee80211_tx_info of the frame.
  * @cts: The buffer where to store the CTS-to-self frame.
  *
  * If the CTS-to-self frames are generated by the host system (i.e., not in
@@ -1458,7 +1426,7 @@ __le16 ieee80211_rts_duration(struct iee
 void ieee80211_ctstoself_get(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     const void *frame, size_t frame_len,
-			     const struct ieee80211_tx_control *frame_txctl,
+			     const struct ieee80211_tx_info *frame_txctl,
 			     struct ieee80211_cts *cts);
 
 /**
@@ -1466,7 +1434,7 @@ void ieee80211_ctstoself_get(struct ieee
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
  * @frame_len: the length of the frame that is going to be protected by the CTS-to-self.
- * @frame_txctl: &struct ieee80211_tx_control of the frame.
+ * @frame_txctl: &struct ieee80211_tx_info of the frame.
  *
  * If the CTS-to-self is generated in firmware, but the host system must provide
  * the duration field, the low-level driver uses this function to receive
@@ -1475,7 +1443,7 @@ void ieee80211_ctstoself_get(struct ieee
 __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    size_t frame_len,
-				    const struct ieee80211_tx_control *frame_txctl);
+				    const struct ieee80211_tx_info *frame_txctl);
 
 /**
  * ieee80211_generic_frame_duration - Calculate the duration field for a frame
@@ -1514,8 +1482,7 @@ __le16 ieee80211_generic_frame_duration(
  * use common code for all beacons.
  */
 struct sk_buff *
-ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			  struct ieee80211_tx_control *control);
+ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 
 /**
  * ieee80211_get_hdrlen_from_skb - get header length from data
--- everything.orig/net/mac80211/main.c	2008-05-11 00:04:49.000000000 +0200
+++ everything/net/mac80211/main.c	2008-05-11 00:05:16.000000000 +0200
@@ -1022,8 +1022,7 @@ void ieee80211_if_setup(struct net_devic
 /* everything else */
 
 static int __ieee80211_if_config(struct net_device *dev,
-				 struct sk_buff *beacon,
-				 struct ieee80211_tx_control *control)
+				 struct sk_buff *beacon)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -1041,13 +1040,11 @@ static int __ieee80211_if_config(struct 
 		conf.ssid_len = sdata->u.sta.ssid_len;
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		conf.beacon = beacon;
-		conf.beacon_control = control;
 		ieee80211_start_mesh(dev);
 	} else if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
 		conf.ssid = sdata->u.ap.ssid;
 		conf.ssid_len = sdata->u.ap.ssid_len;
 		conf.beacon = beacon;
-		conf.beacon_control = control;
 	}
 	return local->ops->config_interface(local_to_hw(local),
 					    &sdata->vif, &conf);
@@ -1060,23 +1057,21 @@ int ieee80211_if_config(struct net_devic
 	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT &&
 	    (local->hw.flags & IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE))
 		return ieee80211_if_config_beacon(dev);
-	return __ieee80211_if_config(dev, NULL, NULL);
+	return __ieee80211_if_config(dev, NULL);
 }
 
 int ieee80211_if_config_beacon(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_tx_control control;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sk_buff *skb;
 
 	if (!(local->hw.flags & IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE))
 		return 0;
-	skb = ieee80211_beacon_get(local_to_hw(local), &sdata->vif,
-				   &control);
+	skb = ieee80211_beacon_get(local_to_hw(local), &sdata->vif);
 	if (!skb)
 		return -ENOMEM;
-	return __ieee80211_if_config(dev, skb, &control);
+	return __ieee80211_if_config(dev, skb);
 }
 
 int ieee80211_hw_config(struct ieee80211_local *local)
@@ -1203,38 +1198,20 @@ void ieee80211_reset_erp_info(struct net
 }
 
 void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
-				 struct sk_buff *skb,
-				 struct ieee80211_tx_status *status)
+				 struct sk_buff *skb)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_tx_status *saved;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	int tmp;
 
 	skb->dev = local->mdev;
-	saved = kmalloc(sizeof(struct ieee80211_tx_status), GFP_ATOMIC);
-	if (unlikely(!saved)) {
-		if (net_ratelimit())
-			printk(KERN_WARNING "%s: Not enough memory, "
-			       "dropping tx status", skb->dev->name);
-		/* should be dev_kfree_skb_irq, but due to this function being
-		 * named _irqsafe instead of just _irq we can't be sure that
-		 * people won't call it from non-irq contexts */
-		dev_kfree_skb_any(skb);
-		return;
-	}
-	memcpy(saved, status, sizeof(struct ieee80211_tx_status));
-	/* copy pointer to saved status into skb->cb for use by tasklet */
-	memcpy(skb->cb, &saved, sizeof(saved));
-
 	skb->pkt_type = IEEE80211_TX_STATUS_MSG;
-	skb_queue_tail(status->control.flags & IEEE80211_TXCTL_REQ_TX_STATUS ?
+	skb_queue_tail(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS ?
 		       &local->skb_queue : &local->skb_queue_unreliable, skb);
 	tmp = skb_queue_len(&local->skb_queue) +
 		skb_queue_len(&local->skb_queue_unreliable);
 	while (tmp > IEEE80211_IRQSAFE_QUEUE_LIMIT &&
 	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
-		memcpy(&saved, skb->cb, sizeof(saved));
-		kfree(saved);
 		dev_kfree_skb_irq(skb);
 		tmp--;
 		I802_DEBUG_INC(local->tx_status_drop);
@@ -1248,7 +1225,6 @@ static void ieee80211_tasklet_handler(un
 	struct ieee80211_local *local = (struct ieee80211_local *) data;
 	struct sk_buff *skb;
 	struct ieee80211_rx_status rx_status;
-	struct ieee80211_tx_status *tx_status;
 	struct ieee80211_ra_tid *ra_tid;
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
@@ -1263,12 +1239,8 @@ static void ieee80211_tasklet_handler(un
 			__ieee80211_rx(local_to_hw(local), skb, &rx_status);
 			break;
 		case IEEE80211_TX_STATUS_MSG:
-			/* get pointer to saved status out of skb->cb */
-			memcpy(&tx_status, skb->cb, sizeof(tx_status));
 			skb->pkt_type = 0;
-			ieee80211_tx_status(local_to_hw(local),
-					    skb, tx_status);
-			kfree(tx_status);
+			ieee80211_tx_status(local_to_hw(local), skb);
 			break;
 		case IEEE80211_DELBA_MSG:
 			ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
@@ -1297,24 +1269,15 @@ static void ieee80211_tasklet_handler(un
  * Also, tx_packet_data in cb is restored from tx_control. */
 static void ieee80211_remove_tx_extra(struct ieee80211_local *local,
 				      struct ieee80211_key *key,
-				      struct sk_buff *skb,
-				      struct ieee80211_tx_control *control)
+				      struct sk_buff *skb)
 {
 	int hdrlen, iv_len, mic_len;
-	struct ieee80211_tx_packet_data *pkt_data;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 
-	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
-	pkt_data->ifindex = vif_to_sdata(control->vif)->dev->ifindex;
-	pkt_data->flags = 0;
-	if (control->flags & IEEE80211_TXCTL_REQ_TX_STATUS)
-		pkt_data->flags |= IEEE80211_TXPD_REQ_TX_STATUS;
-	if (control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT)
-		pkt_data->flags |= IEEE80211_TXPD_DO_NOT_ENCRYPT;
-	if (control->flags & IEEE80211_TXCTL_REQUEUE)
-		pkt_data->flags |= IEEE80211_TXPD_REQUEUE;
-	if (control->flags & IEEE80211_TXCTL_EAPOL_FRAME)
-		pkt_data->flags |= IEEE80211_TXPD_EAPOL_FRAME;
-	pkt_data->queue = control->queue;
+	info->flags &=	IEEE80211_TX_CTL_REQ_TX_STATUS |
+			IEEE80211_TX_CTL_DO_NOT_ENCRYPT |
+			IEEE80211_TX_CTL_REQUEUE |
+			IEEE80211_TX_CTL_EAPOL_FRAME;
 
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 
@@ -1361,9 +1324,10 @@ no_key:
 
 static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 					    struct sta_info *sta,
-					    struct sk_buff *skb,
-					    struct ieee80211_tx_status *status)
+					    struct sk_buff *skb)
 {
+	struct ieee80211_tx_info *info = (void *)skb->cb;
+
 	sta->tx_filtered_count++;
 
 	/*
@@ -1405,18 +1369,16 @@ static void ieee80211_handle_filtered_fr
 	 */
 	if (test_sta_flags(sta, WLAN_STA_PS) &&
 	    skb_queue_len(&sta->tx_filtered) < STA_MAX_TX_BUFFER) {
-		ieee80211_remove_tx_extra(local, sta->key, skb,
-					  &status->control);
+		ieee80211_remove_tx_extra(local, sta->key, skb);
 		skb_queue_tail(&sta->tx_filtered, skb);
 		return;
 	}
 
 	if (!test_sta_flags(sta, WLAN_STA_PS) &&
-	    !(status->control.flags & IEEE80211_TXCTL_REQUEUE)) {
+	    !(info->flags & IEEE80211_TX_CTL_REQUEUE)) {
 		/* Software retry the packet once */
-		status->control.flags |= IEEE80211_TXCTL_REQUEUE;
-		ieee80211_remove_tx_extra(local, sta->key, skb,
-					  &status->control);
+		info->flags |= IEEE80211_TX_CTL_REQUEUE;
+		ieee80211_remove_tx_extra(local, sta->key, skb);
 		dev_queue_xmit(skb);
 		return;
 	}
@@ -1430,28 +1392,20 @@ static void ieee80211_handle_filtered_fr
 	dev_kfree_skb(skb);
 }
 
-void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
-			 struct ieee80211_tx_status *status)
+void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct sk_buff *skb2;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	u16 frag, type;
 	struct ieee80211_tx_status_rtap_hdr *rthdr;
 	struct ieee80211_sub_if_data *sdata;
 	struct net_device *prev_dev = NULL;
 
-	if (!status) {
-		printk(KERN_ERR
-		       "%s: ieee80211_tx_status called with NULL status\n",
-		       wiphy_name(local->hw.wiphy));
-		dev_kfree_skb(skb);
-		return;
-	}
-
 	rcu_read_lock();
 
-	if (status->excessive_retries) {
+	if (info->status.excessive_retries) {
 		struct sta_info *sta;
 		sta = sta_info_get(local, hdr->addr1);
 		if (sta) {
@@ -1460,27 +1414,23 @@ void ieee80211_tx_status(struct ieee8021
 				 * The STA is in power save mode, so assume
 				 * that this TX packet failed because of that.
 				 */
-				status->excessive_retries = 0;
-				status->flags |= IEEE80211_TX_STATUS_TX_FILTERED;
-				ieee80211_handle_filtered_frame(local, sta,
-								skb, status);
+				ieee80211_handle_filtered_frame(local, sta, skb);
 				rcu_read_unlock();
 				return;
 			}
 		}
 	}
 
-	if (status->flags & IEEE80211_TX_STATUS_TX_FILTERED) {
+	if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
 		struct sta_info *sta;
 		sta = sta_info_get(local, hdr->addr1);
 		if (sta) {
-			ieee80211_handle_filtered_frame(local, sta, skb,
-							status);
+			ieee80211_handle_filtered_frame(local, sta, skb);
 			rcu_read_unlock();
 			return;
 		}
 	} else
-		rate_control_tx_status(local->mdev, skb, status);
+		rate_control_tx_status(local->mdev, skb);
 
 	rcu_read_unlock();
 
@@ -1494,14 +1444,14 @@ void ieee80211_tx_status(struct ieee8021
 	frag = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG;
 	type = le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_FTYPE;
 
-	if (status->flags & IEEE80211_TX_STATUS_ACK) {
+	if (info->flags & IEEE80211_TX_STAT_ACK) {
 		if (frag == 0) {
 			local->dot11TransmittedFrameCount++;
 			if (is_multicast_ether_addr(hdr->addr1))
 				local->dot11MulticastTransmittedFrameCount++;
-			if (status->retry_count > 0)
+			if (info->status.retry_count > 0)
 				local->dot11RetryCount++;
-			if (status->retry_count > 1)
+			if (info->status.retry_count > 1)
 				local->dot11MultipleRetryCount++;
 		}
 
@@ -1547,17 +1497,17 @@ void ieee80211_tx_status(struct ieee8021
 		cpu_to_le32((1 << IEEE80211_RADIOTAP_TX_FLAGS) |
 			    (1 << IEEE80211_RADIOTAP_DATA_RETRIES));
 
-	if (!(status->flags & IEEE80211_TX_STATUS_ACK) &&
+	if (!(info->flags & IEEE80211_TX_STAT_ACK) &&
 	    !is_multicast_ether_addr(hdr->addr1))
 		rthdr->tx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_FAIL);
 
-	if ((status->control.flags & IEEE80211_TXCTL_USE_RTS_CTS) &&
-	    (status->control.flags & IEEE80211_TXCTL_USE_CTS_PROTECT))
+	if ((info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) &&
+	    (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT))
 		rthdr->tx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_CTS);
-	else if (status->control.flags & IEEE80211_TXCTL_USE_RTS_CTS)
+	else if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS)
 		rthdr->tx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_RTS);
 
-	rthdr->data_retries = status->retry_count;
+	rthdr->data_retries = info->status.retry_count;
 
 	/* XXX: is this sufficient for BPF? */
 	skb_set_mac_header(skb, 0);
@@ -1926,7 +1876,9 @@ static int __init ieee80211_init(void)
 	struct sk_buff *skb;
 	int ret;
 
-	BUILD_BUG_ON(sizeof(struct ieee80211_tx_packet_data) > sizeof(skb->cb));
+	BUILD_BUG_ON(sizeof(struct ieee80211_tx_info) > sizeof(skb->cb));
+	BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, driver_data) +
+	             IEEE80211_TX_INFO_DRIVER_DATA_SIZE > sizeof(skb->cb));
 
 	ret = rc80211_pid_init();
 	if (ret)
--- everything.orig/net/mac80211/mlme.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-05-11 00:05:16.000000000 +0200
@@ -578,7 +578,7 @@ void ieee80211_sta_tx(struct net_device 
 		      int encrypt)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_tx_packet_data *pkt_data;
+	struct ieee80211_tx_info *info;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	skb->dev = sdata->local->mdev;
@@ -586,11 +586,11 @@ void ieee80211_sta_tx(struct net_device 
 	skb_set_network_header(skb, 0);
 	skb_set_transport_header(skb, 0);
 
-	pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
-	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
-	pkt_data->ifindex = sdata->dev->ifindex;
+	info = (void *) skb->cb;
+	memset(info, 0, sizeof(struct ieee80211_tx_info));
+	info->control.ifindex = sdata->dev->ifindex;
 	if (!encrypt)
-		pkt_data->flags |= IEEE80211_TXPD_DO_NOT_ENCRYPT;
+		info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
 
 	dev_queue_xmit(skb);
 }
@@ -2278,7 +2278,7 @@ static int ieee80211_sta_join_ibss(struc
 	int res, rates, i, j;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_tx_control control;
+	struct ieee80211_tx_info *control;
 	struct rate_selection ratesel;
 	u8 *pos;
 	struct ieee80211_sub_if_data *sdata;
@@ -2368,21 +2368,22 @@ static int ieee80211_sta_join_ibss(struc
 			memcpy(pos, &bss->supp_rates[8], rates);
 		}
 
-		memset(&control, 0, sizeof(control));
+		control = (void *)skb->cb;
+
 		rate_control_get_rate(dev, sband, skb, &ratesel);
 		if (ratesel.rate_idx < 0) {
 			printk(KERN_DEBUG "%s: Failed to determine TX rate "
 			       "for IBSS beacon\n", dev->name);
 			break;
 		}
-		control.vif = &sdata->vif;
-		control.tx_rate_idx = ratesel.rate_idx;
+		control->control.vif = &sdata->vif;
+		control->tx_rate_idx = ratesel.rate_idx;
 		if (sdata->bss_conf.use_short_preamble &&
 		    sband->bitrates[ratesel.rate_idx].flags & IEEE80211_RATE_SHORT_PREAMBLE)
-			control.flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
-		control.antenna_sel_tx = local->hw.conf.antenna_sel_tx;
-		control.flags |= IEEE80211_TXCTL_NO_ACK;
-		control.retry_limit = 1;
+			control->flags |= IEEE80211_TX_CTL_SHORT_PREAMBLE;
+		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
+		control->flags |= IEEE80211_TX_CTL_NO_ACK;
+		control->control.retry_limit = 1;
 
 		ifsta->probe_resp = skb_copy(skb, GFP_ATOMIC);
 		if (ifsta->probe_resp) {
@@ -2397,8 +2398,7 @@ static int ieee80211_sta_join_ibss(struc
 		}
 
 		if (local->ops->beacon_update &&
-		    local->ops->beacon_update(local_to_hw(local),
-					     skb, &control) == 0) {
+		    local->ops->beacon_update(local_to_hw(local), skb) == 0) {
 			printk(KERN_DEBUG "%s: Configured IBSS beacon "
 			       "template\n", dev->name);
 			skb = NULL;
--- everything.orig/net/mac80211/sta_info.h	2008-05-11 00:02:03.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-05-11 00:05:16.000000000 +0200
@@ -32,7 +32,7 @@
  * @WLAN_STA_WDS: Station is one of our WDS peers.
  * @WLAN_STA_PSPOLL: Station has just PS-polled us.
  * @WLAN_STA_CLEAR_PS_FILT: Clear PS filter in hardware (using the
- *	IEEE80211_TXCTL_CLEAR_PS_FILT control flag) when the next
+ *	IEEE80211_TX_CTL_CLEAR_PS_FILT control flag) when the next
  *	frame to this station is transmitted.
  */
 enum ieee80211_sta_info_flags {
--- everything.orig/net/mac80211/tx.c	2008-05-11 00:05:15.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-05-11 00:05:16.000000000 +0200
@@ -238,12 +238,12 @@ static ieee80211_tx_result
 ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	struct sk_buff *skb = tx->skb;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+	struct ieee80211_tx_info *info = (void *)tx->skb->cb;
 	u32 sta_flags;
 
-	if (unlikely(tx->flags & IEEE80211_TX_INJECTED))
+	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
 		return TX_CONTINUE;
 
 	if (unlikely(tx->local->sta_sw_scanning) &&
@@ -348,6 +348,8 @@ static void purge_old_ps_buffers(struct 
 static ieee80211_tx_result
 ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 {
+	struct ieee80211_tx_info *info = (void *)tx->skb->cb;
+
 	/*
 	 * broadcast/multicast frame
 	 *
@@ -383,7 +385,7 @@ ieee80211_tx_h_multicast_ps_buf(struct i
 	}
 
 	/* buffered in hardware */
-	tx->control->flags |= IEEE80211_TXCTL_SEND_AFTER_DTIM;
+	info->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
 
 	return TX_CONTINUE;
 }
@@ -392,6 +394,7 @@ static ieee80211_tx_result
 ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	struct sta_info *sta = tx->sta;
+	struct ieee80211_tx_info *info = (void *)tx->skb->cb;
 	u32 staflags;
 	DECLARE_MAC_BUF(mac);
 
@@ -404,7 +407,6 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 
 	if (unlikely((staflags & WLAN_STA_PS) &&
 		     !(staflags & WLAN_STA_PSPOLL))) {
-		struct ieee80211_tx_packet_data *pkt_data;
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "STA %s aid %d: PS buffer (entries "
 		       "before %d)\n",
@@ -428,8 +430,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		if (skb_queue_empty(&sta->ps_tx_buf))
 			sta_info_set_tim_bit(sta);
 
-		pkt_data = (struct ieee80211_tx_packet_data *)tx->skb->cb;
-		pkt_data->jiffies = jiffies;
+		info->control.jiffies = jiffies;
 		skb_queue_tail(&sta->ps_tx_buf, tx->skb);
 		return TX_QUEUED;
 	}
@@ -461,17 +462,18 @@ static ieee80211_tx_result
 ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_key *key;
+	struct ieee80211_tx_info *info = (void *)tx->skb->cb;
 	u16 fc = tx->fc;
 
-	if (unlikely(tx->control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
+	if (unlikely(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT))
 		tx->key = NULL;
 	else if (tx->sta && (key = rcu_dereference(tx->sta->key)))
 		tx->key = key;
 	else if ((key = rcu_dereference(tx->sdata->default_key)))
 		tx->key = key;
 	else if (tx->sdata->drop_unencrypted &&
-		 !(tx->control->flags & IEEE80211_TXCTL_EAPOL_FRAME) &&
-		 !(tx->flags & IEEE80211_TX_INJECTED)) {
+		 !(info->flags & IEEE80211_TX_CTL_EAPOL_FRAME) &&
+		 !(info->flags & IEEE80211_TX_CTL_INJECTED)) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TX_DROP;
 	} else
@@ -500,7 +502,7 @@ ieee80211_tx_h_select_key(struct ieee802
 	}
 
 	if (!tx->key || !(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
-		tx->control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
+		info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
 
 	return TX_CONTINUE;
 }
@@ -510,6 +512,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 {
 	struct rate_selection rsel;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_tx_info *info = (void *)tx->skb->cb;
 
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
@@ -517,18 +520,17 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 		rate_control_get_rate(tx->dev, sband, tx->skb, &rsel);
 		tx->rate_idx = rsel.rate_idx;
 		if (unlikely(rsel.probe_idx >= 0)) {
-			tx->control->flags |=
-				IEEE80211_TXCTL_RATE_CTRL_PROBE;
+			info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 			tx->flags |= IEEE80211_TX_PROBE_LAST_FRAG;
-			tx->control->alt_retry_rate_idx = tx->rate_idx;
+			info->control.alt_retry_rate_idx = tx->rate_idx;
 			tx->rate_idx = rsel.probe_idx;
 		} else
-			tx->control->alt_retry_rate_idx = -1;
+			info->control.alt_retry_rate_idx = -1;
 
 		if (unlikely(tx->rate_idx < 0))
 			return TX_DROP;
 	} else
-		tx->control->alt_retry_rate_idx = -1;
+		info->control.alt_retry_rate_idx = -1;
 
 	if (tx->sdata->bss_conf.use_cts_prot &&
 	    (tx->flags & IEEE80211_TX_FRAGMENTED) && (rsel.nonerp_idx >= 0)) {
@@ -538,13 +540,13 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 		else
 			tx->flags |= IEEE80211_TX_PROBE_LAST_FRAG;
 		tx->rate_idx = rsel.nonerp_idx;
-		tx->control->tx_rate_idx = rsel.nonerp_idx;
-		tx->control->flags &= ~IEEE80211_TXCTL_RATE_CTRL_PROBE;
+		info->tx_rate_idx = rsel.nonerp_idx;
+		info->flags &= ~IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 	} else {
 		tx->last_frag_rate_idx = tx->rate_idx;
-		tx->control->tx_rate_idx = tx->rate_idx;
+		info->tx_rate_idx = tx->rate_idx;
 	}
-	tx->control->tx_rate_idx = tx->rate_idx;
+	info->tx_rate_idx = tx->rate_idx;
 
 	return TX_CONTINUE;
 }
@@ -555,28 +557,32 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
 	u16 fc = le16_to_cpu(hdr->frame_control);
 	u16 dur;
-	struct ieee80211_tx_control *control = tx->control;
+	struct ieee80211_tx_info *info = (void *)tx->skb->cb;
 	struct ieee80211_supported_band *sband;
 
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
-	if (!control->retry_limit) {
+	if (tx->sta)
+		info->control.aid = tx->sta->aid;
+
+	if (!info->control.retry_limit) {
 		if (!is_multicast_ether_addr(hdr->addr1)) {
-			if (tx->skb->len + FCS_LEN > tx->local->rts_threshold
+			int len = min_t(int, tx->skb->len + FCS_LEN,
+					tx->local->fragmentation_threshold);
+			if (len > tx->local->rts_threshold
 			    && tx->local->rts_threshold <
-					IEEE80211_MAX_RTS_THRESHOLD) {
-				control->flags |=
-					IEEE80211_TXCTL_USE_RTS_CTS;
-				control->flags |=
-					IEEE80211_TXCTL_LONG_RETRY_LIMIT;
-				control->retry_limit =
+						IEEE80211_MAX_RTS_THRESHOLD) {
+				info->flags |= IEEE80211_TX_CTL_USE_RTS_CTS;
+				info->flags |=
+					IEEE80211_TX_CTL_LONG_RETRY_LIMIT;
+				info->control.retry_limit =
 					tx->local->long_retry_limit;
 			} else {
-				control->retry_limit =
+				info->control.retry_limit =
 					tx->local->short_retry_limit;
 			}
 		} else {
-			control->retry_limit = 1;
+			info->control.retry_limit = 1;
 		}
 	}
 
@@ -585,7 +591,7 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 		 * frames.
 		 * TODO: The last fragment could still use multiple retry
 		 * rates. */
-		control->alt_retry_rate_idx = -1;
+		info->control.alt_retry_rate_idx = -1;
 	}
 
 	/* Use CTS protection for unicast frames sent using extended rates if
@@ -595,8 +601,8 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 	    (sband->bitrates[tx->rate_idx].flags & IEEE80211_RATE_ERP_G) &&
 	    (tx->flags & IEEE80211_TX_UNICAST) &&
 	    tx->sdata->bss_conf.use_cts_prot &&
-	    !(control->flags & IEEE80211_TXCTL_USE_RTS_CTS))
-		control->flags |= IEEE80211_TXCTL_USE_CTS_PROTECT;
+	    !(info->flags & IEEE80211_TX_CTL_USE_RTS_CTS))
+		info->flags |= IEEE80211_TX_CTL_USE_CTS_PROTECT;
 
 	/* Transmit data frames using short preambles if the driver supports
 	 * short preambles at the selected rate and short preambles are
@@ -605,7 +611,7 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 	    (sband->bitrates[tx->rate_idx].flags & IEEE80211_RATE_SHORT_PREAMBLE) &&
 	    tx->sdata->bss_conf.use_short_preamble &&
 	    (!tx->sta || test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE))) {
-		tx->control->flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
+		info->flags |= IEEE80211_TX_CTL_SHORT_PREAMBLE;
 	}
 
 	/* Setup duration field for the first fragment of the frame. Duration
@@ -616,8 +622,8 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 				 tx->extra_frag[0]->len : 0);
 	hdr->duration_id = cpu_to_le16(dur);
 
-	if ((control->flags & IEEE80211_TXCTL_USE_RTS_CTS) ||
-	    (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)) {
+	if ((info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) ||
+	    (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)) {
 		struct ieee80211_supported_band *sband;
 		struct ieee80211_rate *rate;
 		s8 baserate = -1;
@@ -626,7 +632,7 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 		sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
 		/* Do not use multiple retry rates when using RTS/CTS */
-		control->alt_retry_rate_idx = -1;
+		info->control.alt_retry_rate_idx = -1;
 
 		/* Use min(data rate, max base rate) as CTS/RTS rate */
 		rate = &sband->bitrates[tx->rate_idx];
@@ -642,13 +648,13 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 		}
 
 		if (baserate >= 0)
-			control->rts_cts_rate_idx = baserate;
+			info->control.rts_cts_rate_idx = baserate;
 		else
-			control->rts_cts_rate_idx = 0;
+			info->control.rts_cts_rate_idx = 0;
 	}
 
 	if (tx->sta)
-		control->aid = tx->sta->aid;
+		info->control.aid = tx->sta->aid;
 
 	return TX_CONTINUE;
 }
@@ -762,6 +768,7 @@ ieee80211_tx_h_stats(struct ieee80211_tx
 	u32 load = 0, hdrtime;
 	struct ieee80211_rate *rate;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 	rate = &sband->bitrates[tx->rate_idx];
@@ -786,9 +793,9 @@ ieee80211_tx_h_stats(struct ieee80211_tx
 	if (!is_multicast_ether_addr(hdr->addr1))
 		load += hdrtime;
 
-	if (tx->control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
+	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS)
 		load += 2 * hdrtime;
-	else if (tx->control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
+	else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
 		load += hdrtime;
 
 	/* TODO: optimise again */
@@ -839,6 +846,7 @@ static ieee80211_tx_handler ieee80211_tx
 	ieee80211_tx_h_rate_ctrl,
 	ieee80211_tx_h_misc,
 	ieee80211_tx_h_fragment,
+	/* handlers after fragment must be aware of tx info fragmentation! */
 	ieee80211_tx_h_encrypt,
 	ieee80211_tx_h_stats,
 	NULL
@@ -867,12 +875,12 @@ __ieee80211_parse_tx_radiotap(struct iee
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_supported_band *sband;
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len);
-	struct ieee80211_tx_control *control = tx->control;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
-	control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
-	tx->flags |= IEEE80211_TX_INJECTED;
+	info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
+	info->flags |= IEEE80211_TX_CTL_INJECTED;
 	tx->flags &= ~IEEE80211_TX_FRAGMENTED;
 
 	/*
@@ -920,7 +928,7 @@ __ieee80211_parse_tx_radiotap(struct iee
 			 * radiotap uses 0 for 1st ant, mac80211 is 1 for
 			 * 1st ant
 			 */
-			control->antenna_sel_tx = (*iterator.this_arg) + 1;
+			info->antenna_sel_tx = (*iterator.this_arg) + 1;
 			break;
 
 #if 0
@@ -944,8 +952,8 @@ __ieee80211_parse_tx_radiotap(struct iee
 				skb_trim(skb, skb->len - FCS_LEN);
 			}
 			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_WEP)
-				control->flags &=
-					~IEEE80211_TXCTL_DO_NOT_ENCRYPT;
+				info->flags &=
+					~IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
 			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_FRAG)
 				tx->flags |= IEEE80211_TX_FRAGMENTED;
 			break;
@@ -980,12 +988,12 @@ __ieee80211_parse_tx_radiotap(struct iee
 static ieee80211_tx_result
 __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 		       struct sk_buff *skb,
-		       struct net_device *dev,
-		       struct ieee80211_tx_control *control)
+		       struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 
 	int hdrlen;
 
@@ -994,7 +1002,7 @@ __ieee80211_tx_prepare(struct ieee80211_
 	tx->dev = dev; /* use original interface */
 	tx->local = local;
 	tx->sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	tx->control = control;
+	tx->channel = local->hw.conf.channel;
 	/*
 	 * Set this flag (used below to indicate "automatic fragmentation"),
 	 * it will be cleared/left by radiotap as desired.
@@ -1021,10 +1029,10 @@ __ieee80211_tx_prepare(struct ieee80211_
 
 	if (is_multicast_ether_addr(hdr->addr1)) {
 		tx->flags &= ~IEEE80211_TX_UNICAST;
-		control->flags |= IEEE80211_TXCTL_NO_ACK;
+		info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	} else {
 		tx->flags |= IEEE80211_TX_UNICAST;
-		control->flags &= ~IEEE80211_TXCTL_NO_ACK;
+		info->flags &= ~IEEE80211_TX_CTL_NO_ACK;
 	}
 
 	if (tx->flags & IEEE80211_TX_FRAGMENTED) {
@@ -1037,16 +1045,16 @@ __ieee80211_tx_prepare(struct ieee80211_
 	}
 
 	if (!tx->sta)
-		control->flags |= IEEE80211_TXCTL_CLEAR_PS_FILT;
+		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 	else if (test_and_clear_sta_flags(tx->sta, WLAN_STA_CLEAR_PS_FILT))
-		control->flags |= IEEE80211_TXCTL_CLEAR_PS_FILT;
+		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 
 	hdrlen = ieee80211_get_hdrlen(tx->fc);
 	if (skb->len > hdrlen + sizeof(rfc1042_header) + 2) {
 		u8 *pos = &skb->data[hdrlen + sizeof(rfc1042_header)];
 		tx->ethertype = (pos[0] << 8) | pos[1];
 	}
-	control->flags |= IEEE80211_TXCTL_FIRST_FRAGMENT;
+	info->flags |= IEEE80211_TX_CTL_FIRST_FRAGMENT;
 
 	return TX_CONTINUE;
 }
@@ -1056,14 +1064,12 @@ __ieee80211_tx_prepare(struct ieee80211_
  */
 static int ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 				struct sk_buff *skb,
-				struct net_device *mdev,
-				struct ieee80211_tx_control *control)
+				struct net_device *mdev)
 {
-	struct ieee80211_tx_packet_data *pkt_data;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	struct net_device *dev;
 
-	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
-	dev = dev_get_by_index(&init_net, pkt_data->ifindex);
+	dev = dev_get_by_index(&init_net, info->control.ifindex);
 	if (unlikely(dev && !is_ieee80211_device(dev, mdev))) {
 		dev_put(dev);
 		dev = NULL;
@@ -1071,7 +1077,7 @@ static int ieee80211_tx_prepare(struct i
 	if (unlikely(!dev))
 		return -ENODEV;
 	/* initialises tx with control */
-	__ieee80211_tx_prepare(tx, skb, dev, control);
+	__ieee80211_tx_prepare(tx, skb, dev);
 	dev_put(dev);
 	return 0;
 }
@@ -1079,7 +1085,7 @@ static int ieee80211_tx_prepare(struct i
 static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 			  struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_tx_control *control = tx->control;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	int ret, i;
 
 	if (!ieee80211_qdisc_installed(local->mdev) &&
@@ -1090,39 +1096,39 @@ static int __ieee80211_tx(struct ieee802
 	if (skb) {
 		ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
 				     "TX to low-level driver", skb);
-		ret = local->ops->tx(local_to_hw(local), skb, control);
+		ret = local->ops->tx(local_to_hw(local), skb);
 		if (ret)
 			return IEEE80211_TX_AGAIN;
 		local->mdev->trans_start = jiffies;
 		ieee80211_led_tx(local, 1);
 	}
 	if (tx->extra_frag) {
-		control->flags &= ~(IEEE80211_TXCTL_USE_RTS_CTS |
-				    IEEE80211_TXCTL_USE_CTS_PROTECT |
-				    IEEE80211_TXCTL_CLEAR_PS_FILT |
-				    IEEE80211_TXCTL_FIRST_FRAGMENT);
 		for (i = 0; i < tx->num_extra_frag; i++) {
 			if (!tx->extra_frag[i])
 				continue;
-			if (__ieee80211_queue_stopped(local, control->queue))
+			info = (void *)tx->extra_frag[i]->cb;
+			info->flags &= ~(IEEE80211_TX_CTL_USE_RTS_CTS |
+					 IEEE80211_TX_CTL_USE_CTS_PROTECT |
+					 IEEE80211_TX_CTL_CLEAR_PS_FILT |
+					 IEEE80211_TX_CTL_FIRST_FRAGMENT);
+			if (__ieee80211_queue_stopped(local, info->queue))
 				return IEEE80211_TX_FRAG_AGAIN;
 			if (i == tx->num_extra_frag) {
-				control->tx_rate_idx = tx->last_frag_rate_idx;
+				info->tx_rate_idx = tx->last_frag_rate_idx;
 
 				if (tx->flags & IEEE80211_TX_PROBE_LAST_FRAG)
-					control->flags |=
-						IEEE80211_TXCTL_RATE_CTRL_PROBE;
+					info->flags |=
+						IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 				else
-					control->flags &=
-						~IEEE80211_TXCTL_RATE_CTRL_PROBE;
+					info->flags &=
+						~IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 			}
 
 			ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
 					     "TX to low-level driver",
 					     tx->extra_frag[i]);
 			ret = local->ops->tx(local_to_hw(local),
-					    tx->extra_frag[i],
-					    control);
+					    tx->extra_frag[i]);
 			if (ret)
 				return IEEE80211_TX_FRAG_AGAIN;
 			local->mdev->trans_start = jiffies;
@@ -1135,17 +1141,18 @@ static int __ieee80211_tx(struct ieee802
 	return IEEE80211_TX_OK;
 }
 
-static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb,
-			struct ieee80211_tx_control *control)
+static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
 	ieee80211_tx_handler *handler;
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res = TX_DROP, res_prepare;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	int ret, i;
+	int queue = info->queue;
 
-	WARN_ON(__ieee80211_queue_pending(local, control->queue));
+	WARN_ON(__ieee80211_queue_pending(local, queue));
 
 	if (unlikely(skb->len < 10)) {
 		dev_kfree_skb(skb);
@@ -1155,7 +1162,7 @@ static int ieee80211_tx(struct net_devic
 	rcu_read_lock();
 
 	/* initialises tx */
-	res_prepare = __ieee80211_tx_prepare(&tx, skb, dev, control);
+	res_prepare = __ieee80211_tx_prepare(&tx, skb, dev);
 
 	if (res_prepare == TX_DROP) {
 		dev_kfree_skb(skb);
@@ -1165,7 +1172,8 @@ static int ieee80211_tx(struct net_devic
 
 	sta = tx.sta;
 	tx.channel = local->hw.conf.channel;
-	control->band = tx.channel->band;
+	info->band = tx.channel->band;
+	info->flags |= IEEE80211_TX_CTL_READY_FOR_TX;
 
 	for (handler = ieee80211_tx_handlers; *handler != NULL;
 	     handler++) {
@@ -1174,7 +1182,8 @@ static int ieee80211_tx(struct net_devic
 			break;
 	}
 
-	skb = tx.skb; /* handlers are allowed to change skb */
+	if (WARN_ON(tx.skb != skb))
+		goto drop;
 
 	if (unlikely(res == TX_DROP)) {
 		I802_DEBUG_INC(local->tx_handlers_drop);
@@ -1209,12 +1218,12 @@ retry:
 	ret = __ieee80211_tx(local, skb, &tx);
 	if (ret) {
 		struct ieee80211_tx_stored_packet *store =
-			&local->pending_packet[control->queue];
+			&local->pending_packet[info->queue];
 
 		if (ret == IEEE80211_TX_FRAG_AGAIN)
 			skb = NULL;
 		set_bit(IEEE80211_LINK_STATE_PENDING,
-			&local->state[control->queue]);
+			&local->state[queue]);
 		smp_mb();
 		/* When the driver gets out of buffers during sending of
 		 * fragments and calls ieee80211_stop_queue, there is
@@ -1225,13 +1234,11 @@ retry:
 		 * called with IEEE80211_LINK_STATE_PENDING. Prevent this by
 		 * continuing transmitting here when that situation is
 		 * possible to have happened. */
-		if (!__ieee80211_queue_stopped(local, control->queue)) {
+		if (!__ieee80211_queue_stopped(local, queue)) {
 			clear_bit(IEEE80211_LINK_STATE_PENDING,
-				  &local->state[control->queue]);
+				  &local->state[queue]);
 			goto retry;
 		}
-		memcpy(&store->control, control,
-		       sizeof(struct ieee80211_tx_control));
 		store->skb = skb;
 		store->extra_frag = tx.extra_frag;
 		store->num_extra_frag = tx.num_extra_frag;
@@ -1297,22 +1304,15 @@ static int ieee80211_skb_resize(struct i
 int ieee80211_master_start_xmit(struct sk_buff *skb,
 				struct net_device *dev)
 {
-	struct ieee80211_tx_control control;
-	struct ieee80211_tx_packet_data *pkt_data;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	struct net_device *odev = NULL;
 	struct ieee80211_sub_if_data *osdata;
 	int headroom;
 	bool encrypt;
 	int ret;
 
-	/*
-	 * copy control out of the skb so other people can use skb->cb
-	 */
-	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
-	memset(&control, 0, sizeof(struct ieee80211_tx_control));
-
-	if (pkt_data->ifindex)
-		odev = dev_get_by_index(&init_net, pkt_data->ifindex);
+	if (info->control.ifindex)
+		odev = dev_get_by_index(&init_net, info->control.ifindex);
 	if (unlikely(odev && !is_ieee80211_device(odev, dev))) {
 		dev_put(odev);
 		odev = NULL;
@@ -1325,9 +1325,10 @@ int ieee80211_master_start_xmit(struct s
 		dev_kfree_skb(skb);
 		return 0;
 	}
+
 	osdata = IEEE80211_DEV_TO_SUB_IF(odev);
 
-	encrypt = !(pkt_data->flags & IEEE80211_TXPD_DO_NOT_ENCRYPT);
+	encrypt = !(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT);
 
 	headroom = osdata->local->tx_headroom;
 	if (encrypt)
@@ -1341,21 +1342,8 @@ int ieee80211_master_start_xmit(struct s
 		return 0;
 	}
 
-	control.vif = &osdata->vif;
-	control.type = osdata->vif.type;
-	if (pkt_data->flags & IEEE80211_TXPD_REQ_TX_STATUS)
-		control.flags |= IEEE80211_TXCTL_REQ_TX_STATUS;
-	if (pkt_data->flags & IEEE80211_TXPD_DO_NOT_ENCRYPT)
-		control.flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
-	if (pkt_data->flags & IEEE80211_TXPD_REQUEUE)
-		control.flags |= IEEE80211_TXCTL_REQUEUE;
-	if (pkt_data->flags & IEEE80211_TXPD_EAPOL_FRAME)
-		control.flags |= IEEE80211_TXCTL_EAPOL_FRAME;
-	if (pkt_data->flags & IEEE80211_TXPD_AMPDU)
-		control.flags |= IEEE80211_TXCTL_AMPDU;
-	control.queue = pkt_data->queue;
-
-	ret = ieee80211_tx(odev, skb, &control);
+	info->control.vif = &osdata->vif;
+	ret = ieee80211_tx(odev, skb);
 	dev_put(odev);
 
 	return ret;
@@ -1365,7 +1353,7 @@ int ieee80211_monitor_start_xmit(struct 
 				 struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_tx_packet_data *pkt_data;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	struct ieee80211_radiotap_header *prthdr =
 		(struct ieee80211_radiotap_header *)skb->data;
 	u16 len_rthdr;
@@ -1387,12 +1375,11 @@ int ieee80211_monitor_start_xmit(struct 
 
 	skb->dev = local->mdev;
 
-	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
-	memset(pkt_data, 0, sizeof(*pkt_data));
-	/* needed because we set skb device to master */
-	pkt_data->ifindex = dev->ifindex;
+	memset(info, 0, sizeof(*info));
 
-	pkt_data->flags |= IEEE80211_TXPD_DO_NOT_ENCRYPT;
+	/* needed because we set skb device to master */
+	info->control.ifindex = dev->ifindex;
+	info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
 
 	/*
 	 * fix up the pointers accounting for the radiotap
@@ -1436,7 +1423,7 @@ int ieee80211_subif_start_xmit(struct sk
 			       struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_tx_packet_data *pkt_data;
+	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata;
 	int ret = 1, head_need;
 	u16 ethertype, hdrlen,  meshhdrlen = 0, fc;
@@ -1662,11 +1649,11 @@ int ieee80211_subif_start_xmit(struct sk
 	nh_pos += hdrlen;
 	h_pos += hdrlen;
 
-	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
-	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
-	pkt_data->ifindex = dev->ifindex;
+	info = (void *)skb->cb;
+	memset(info, 0, sizeof(*info));
+	info->control.ifindex = dev->ifindex;
 	if (ethertype == ETH_P_PAE)
-		pkt_data->flags |= IEEE80211_TXPD_EAPOL_FRAME;
+		info->flags |= IEEE80211_TX_CTL_EAPOL_FRAME;
 
 	skb->dev = local->mdev;
 	dev->stats.tx_packets++;
@@ -1727,7 +1714,6 @@ void ieee80211_tx_pending(unsigned long 
 			continue;
 		}
 		store = &local->pending_packet[i];
-		tx.control = &store->control;
 		tx.extra_frag = store->extra_frag;
 		tx.num_extra_frag = store->num_extra_frag;
 		tx.last_frag_rate_idx = store->last_frag_rate_idx;
@@ -1820,11 +1806,11 @@ static void ieee80211_beacon_add_tim(str
 }
 
 struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
-				     struct ieee80211_vif *vif,
-				     struct ieee80211_tx_control *control)
+				     struct ieee80211_vif *vif)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
 	struct net_device *bdev;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct ieee80211_if_ap *ap = NULL;
@@ -1930,31 +1916,32 @@ struct sk_buff *ieee80211_beacon_get(str
 		goto out;
 	}
 
-	if (control) {
-		control->band = band;
-		rate_control_get_rate(local->mdev, sband, skb, &rsel);
-		if (unlikely(rsel.rate_idx < 0)) {
-			if (net_ratelimit()) {
-				printk(KERN_DEBUG "%s: ieee80211_beacon_get: "
-				       "no rate found\n",
-				       wiphy_name(local->hw.wiphy));
-			}
-			dev_kfree_skb(skb);
-			skb = NULL;
-			goto out;
-		}
+	info = (void *)skb->cb;
 
-		control->vif = vif;
-		control->tx_rate_idx = rsel.rate_idx;
-		if (sdata->bss_conf.use_short_preamble &&
-		    sband->bitrates[rsel.rate_idx].flags & IEEE80211_RATE_SHORT_PREAMBLE)
-			control->flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
-		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
-		control->flags |= IEEE80211_TXCTL_NO_ACK;
-		control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
-		control->retry_limit = 1;
-		control->flags |= IEEE80211_TXCTL_CLEAR_PS_FILT;
+	info->band = band;
+	rate_control_get_rate(local->mdev, sband, skb, &rsel);
+
+	if (unlikely(rsel.rate_idx < 0)) {
+		if (net_ratelimit()) {
+			printk(KERN_DEBUG "%s: ieee80211_beacon_get: "
+			       "no rate found\n",
+			       wiphy_name(local->hw.wiphy));
+		}
+		dev_kfree_skb(skb);
+		skb = NULL;
+		goto out;
 	}
+
+	info->control.vif = vif;
+	info->tx_rate_idx = rsel.rate_idx;
+	if (sdata->bss_conf.use_short_preamble &&
+	    sband->bitrates[rsel.rate_idx].flags & IEEE80211_RATE_SHORT_PREAMBLE)
+		info->flags |= IEEE80211_TX_CTL_SHORT_PREAMBLE;
+	info->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
+	info->flags |= IEEE80211_TX_CTL_NO_ACK;
+	info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
+	info->control.retry_limit = 1;
+	info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 	(*num_beacons)++;
 out:
 	rcu_read_unlock();
@@ -1964,7 +1951,7 @@ EXPORT_SYMBOL(ieee80211_beacon_get);
 
 void ieee80211_rts_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       const void *frame, size_t frame_len,
-		       const struct ieee80211_tx_control *frame_txctl,
+		       const struct ieee80211_tx_info *frame_txctl,
 		       struct ieee80211_rts *rts)
 {
 	const struct ieee80211_hdr *hdr = frame;
@@ -1981,7 +1968,7 @@ EXPORT_SYMBOL(ieee80211_rts_get);
 
 void ieee80211_ctstoself_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			     const void *frame, size_t frame_len,
-			     const struct ieee80211_tx_control *frame_txctl,
+			     const struct ieee80211_tx_info *frame_txctl,
 			     struct ieee80211_cts *cts)
 {
 	const struct ieee80211_hdr *hdr = frame;
@@ -1997,8 +1984,7 @@ EXPORT_SYMBOL(ieee80211_ctstoself_get);
 
 struct sk_buff *
 ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
-			  struct ieee80211_vif *vif,
-			  struct ieee80211_tx_control *control)
+			  struct ieee80211_vif *vif)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct sk_buff *skb;
@@ -2010,6 +1996,7 @@ ieee80211_get_buffered_bc(struct ieee802
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_ap *bss = NULL;
 	struct beacon_data *beacon;
+	struct ieee80211_tx_info *info;
 
 	sdata = vif_to_sdata(vif);
 	bdev = sdata->dev;
@@ -2029,7 +2016,7 @@ ieee80211_get_buffered_bc(struct ieee802
 
 	if (bss->dtim_count != 0)
 		return NULL; /* send buffered bc/mc only after DTIM beacon */
-	memset(control, 0, sizeof(*control));
+
 	while (1) {
 		skb = skb_dequeue(&bss->ps_bc_buf);
 		if (!skb)
@@ -2046,21 +2033,27 @@ ieee80211_get_buffered_bc(struct ieee802
 				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 		}
 
-		if (!ieee80211_tx_prepare(&tx, skb, local->mdev, control))
+		if (!ieee80211_tx_prepare(&tx, skb, local->mdev))
 			break;
 		dev_kfree_skb_any(skb);
 	}
+
+	info = (void *)skb->cb;
+	info->flags |= IEEE80211_TX_CTL_READY_FOR_TX;
+
 	sta = tx.sta;
 	tx.flags |= IEEE80211_TX_PS_BUFFERED;
 	tx.channel = local->hw.conf.channel;
-	control->band = tx.channel->band;
+	info->band = tx.channel->band;
 
 	for (handler = ieee80211_tx_handlers; *handler != NULL; handler++) {
 		res = (*handler)(&tx);
 		if (res == TX_DROP || res == TX_QUEUED)
 			break;
 	}
-	skb = tx.skb; /* handlers are allowed to change skb */
+
+	if (WARN_ON(tx.skb != skb))
+		return NULL;
 
 	if (res == TX_DROP) {
 		I802_DEBUG_INC(local->tx_handlers_drop);
--- everything.orig/net/mac80211/util.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/net/mac80211/util.c	2008-05-11 00:05:16.000000000 +0200
@@ -258,7 +258,7 @@ EXPORT_SYMBOL(ieee80211_generic_frame_du
 
 __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif, size_t frame_len,
-			      const struct ieee80211_tx_control *frame_txctl)
+			      const struct ieee80211_tx_info *frame_txctl)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
@@ -272,7 +272,7 @@ __le16 ieee80211_rts_duration(struct iee
 
 	short_preamble = sdata->bss_conf.use_short_preamble;
 
-	rate = &sband->bitrates[frame_txctl->rts_cts_rate_idx];
+	rate = &sband->bitrates[frame_txctl->control.rts_cts_rate_idx];
 
 	erp = 0;
 	if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
@@ -295,7 +295,7 @@ EXPORT_SYMBOL(ieee80211_rts_duration);
 __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    size_t frame_len,
-				    const struct ieee80211_tx_control *frame_txctl)
+				    const struct ieee80211_tx_info *frame_txctl)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
@@ -309,7 +309,7 @@ __le16 ieee80211_ctstoself_duration(stru
 
 	short_preamble = sdata->bss_conf.use_short_preamble;
 
-	rate = &sband->bitrates[frame_txctl->rts_cts_rate_idx];
+	rate = &sband->bitrates[frame_txctl->control.rts_cts_rate_idx];
 	erp = 0;
 	if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
 		erp = rate->flags & IEEE80211_RATE_ERP_G;
@@ -317,7 +317,7 @@ __le16 ieee80211_ctstoself_duration(stru
 	/* Data frame duration */
 	dur = ieee80211_frame_duration(local, frame_len, rate->bitrate,
 				       erp, short_preamble);
-	if (!(frame_txctl->flags & IEEE80211_TXCTL_NO_ACK)) {
+	if (!(frame_txctl->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		/* ACK duration */
 		dur += ieee80211_frame_duration(local, 10, rate->bitrate,
 						erp, short_preamble);
--- everything.orig/drivers/net/wireless/at76_usb.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/at76_usb.c	2008-05-11 00:05:16.000000000 +0200
@@ -1692,13 +1692,14 @@ exit:
 static void at76_mac80211_tx_callback(struct urb *urb)
 {
 	struct at76_priv *priv = urb->context;
+	struct ieee80211_tx_info *info = (void *)priv->tx_skb->cb;
 
 	at76_dbg(DBG_MAC80211, "%s()", __func__);
 
 	switch (urb->status) {
 	case 0:
 		/* success */
-		priv->tx_status.flags |= IEEE80211_TX_STATUS_ACK;
+		info->flags |= IEEE80211_TX_STAT_ACK;
 		break;
 	case -ENOENT:
 	case -ECONNRESET:
@@ -1711,23 +1712,20 @@ static void at76_mac80211_tx_callback(st
 		break;
 	}
 
-	priv->tx_status.excessive_retries = 0;
-	priv->tx_status.retry_count = 0;
-	priv->tx_status.ack_signal = 0;
+	memset(&info->status, 0, sizeof(info->status));
 
-	ieee80211_tx_status_irqsafe(priv->hw, priv->tx_skb, &priv->tx_status);
+	ieee80211_tx_status_irqsafe(priv->hw, priv->tx_skb);
 
-	memset(&priv->tx_status, 0, sizeof(priv->tx_status));
 	priv->tx_skb = NULL;
 
 	ieee80211_wake_queues(priv->hw);
 }
 
-static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-			    struct ieee80211_tx_control *control)
+static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct at76_priv *priv = hw->priv;
 	struct at76_tx_buffer *tx_buffer = priv->bulk_out_buffer;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	int padding, submit_len, ret;
 
 	at76_dbg(DBG_MAC80211, "%s()", __func__);
@@ -1745,7 +1743,6 @@ static int at76_mac80211_tx(struct ieee8
 	WARN_ON(priv->tx_skb != NULL);
 
 	priv->tx_skb = skb;
-	memcpy(&priv->tx_status.control, control, sizeof(*control));
 	padding = at76_calc_padding(skb->len);
 	submit_len = AT76_TX_HDRLEN + skb->len + padding;
 
@@ -1753,7 +1750,7 @@ static int at76_mac80211_tx(struct ieee8
 	memset(tx_buffer, 0, sizeof(*tx_buffer));
 	tx_buffer->padding = padding;
 	tx_buffer->wlength = cpu_to_le16(skb->len);
-	tx_buffer->tx_rate = ieee80211_get_tx_rate(hw, control)->hw_value;
+	tx_buffer->tx_rate = ieee80211_get_tx_rate(hw, info)->hw_value;
 	memset(tx_buffer->reserved, 0, sizeof(tx_buffer->reserved));
 	memcpy(tx_buffer->packet, skb->data, skb->len);
 
--- everything.orig/drivers/net/wireless/rtl8180_dev.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/rtl8180_dev.c	2008-05-11 00:05:16.000000000 +0200
@@ -170,34 +170,29 @@ static void rtl8180_handle_tx(struct iee
 	while (skb_queue_len(&ring->queue)) {
 		struct rtl8180_tx_desc *entry = &ring->desc[ring->idx];
 		struct sk_buff *skb;
-		struct ieee80211_tx_status status;
-		struct ieee80211_tx_control *control;
+		struct ieee80211_tx_info *info;
 		u32 flags = le32_to_cpu(entry->flags);
 
 		if (flags & RTL8180_TX_DESC_FLAG_OWN)
 			return;
 
-		memset(&status, 0, sizeof(status));
-
 		ring->idx = (ring->idx + 1) % ring->entries;
 		skb = __skb_dequeue(&ring->queue);
 		pci_unmap_single(priv->pdev, le32_to_cpu(entry->tx_buf),
 				 skb->len, PCI_DMA_TODEVICE);
 
-		control = *((struct ieee80211_tx_control **)skb->cb);
-		if (control)
-			memcpy(&status.control, control, sizeof(*control));
-		kfree(control);
+		info = (void *)skb->cb;
+		memset(&info->status, 0, sizeof(info->status));
 
-		if (!(status.control.flags & IEEE80211_TXCTL_NO_ACK)) {
+		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 			if (flags & RTL8180_TX_DESC_FLAG_TX_OK)
-				status.flags = IEEE80211_TX_STATUS_ACK;
+				info->flags |= IEEE80211_TX_STAT_ACK;
 			else
-				status.excessive_retries = 1;
+				info->status.excessive_retries = 1;
 		}
-		status.retry_count = flags & 0xFF;
+		info->status.retry_count = flags & 0xFF;
 
-		ieee80211_tx_status_irqsafe(dev, skb, &status);
+		ieee80211_tx_status_irqsafe(dev, skb);
 		if (ring->entries - skb_queue_len(&ring->queue) == 2)
 			ieee80211_wake_queue(dev, prio);
 	}
@@ -238,9 +233,9 @@ static irqreturn_t rtl8180_interrupt(int
 	return IRQ_HANDLED;
 }
 
-static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
-		      struct ieee80211_tx_control *control)
+static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	struct rtl8180_priv *priv = dev->priv;
 	struct rtl8180_tx_ring *ring;
 	struct rtl8180_tx_desc *entry;
@@ -251,7 +246,7 @@ static int rtl8180_tx(struct ieee80211_h
 	u16 plcp_len = 0;
 	__le16 rts_duration = 0;
 
-	prio = control->queue;
+	prio = info->queue;
 	ring = &priv->tx_ring[prio];
 
 	mapping = pci_map_single(priv->pdev, skb->data,
@@ -259,35 +254,32 @@ static int rtl8180_tx(struct ieee80211_h
 
 	tx_flags = RTL8180_TX_DESC_FLAG_OWN | RTL8180_TX_DESC_FLAG_FS |
 		   RTL8180_TX_DESC_FLAG_LS |
-		   (ieee80211_get_tx_rate(dev, control)->hw_value << 24) |
+		   (ieee80211_get_tx_rate(dev, info)->hw_value << 24) |
 		   skb->len;
 
 	if (priv->r8185)
 		tx_flags |= RTL8180_TX_DESC_FLAG_DMA |
 			    RTL8180_TX_DESC_FLAG_NO_ENC;
 
-	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
+	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {
 		tx_flags |= RTL8180_TX_DESC_FLAG_RTS;
-		tx_flags |= ieee80211_get_rts_cts_rate(dev, control)->hw_value << 19;
-	} else if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
+		tx_flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
+	} else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT) {
 		tx_flags |= RTL8180_TX_DESC_FLAG_CTS;
-		tx_flags |= ieee80211_get_rts_cts_rate(dev, control)->hw_value << 19;
+		tx_flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
 	}
 
-	*((struct ieee80211_tx_control **) skb->cb) =
-		kmemdup(control, sizeof(*control), GFP_ATOMIC);
-
-	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
+	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS)
 		rts_duration = ieee80211_rts_duration(dev, priv->vif, skb->len,
-						      control);
+						      info);
 
 	if (!priv->r8185) {
 		unsigned int remainder;
 
 		plcp_len = DIV_ROUND_UP(16 * (skb->len + 4),
-				(ieee80211_get_tx_rate(dev, control)->bitrate * 2) / 10);
+				(ieee80211_get_tx_rate(dev, info)->bitrate * 2) / 10);
 		remainder = (16 * (skb->len + 4)) %
-			    ((ieee80211_get_tx_rate(dev, control)->bitrate * 2) / 10);
+			    ((ieee80211_get_tx_rate(dev, info)->bitrate * 2) / 10);
 		if (remainder > 0 && remainder <= 6)
 			plcp_len |= 1 << 15;
 	}
@@ -300,13 +292,13 @@ static int rtl8180_tx(struct ieee80211_h
 	entry->plcp_len = cpu_to_le16(plcp_len);
 	entry->tx_buf = cpu_to_le32(mapping);
 	entry->frame_len = cpu_to_le32(skb->len);
-	entry->flags2 = control->alt_retry_rate_idx >= 0 ?
-		ieee80211_get_alt_retry_rate(dev, control)->bitrate << 4 : 0;
-	entry->retry_limit = control->retry_limit;
+	entry->flags2 = info->control.alt_retry_rate_idx >= 0 ?
+		ieee80211_get_alt_retry_rate(dev, info)->bitrate << 4 : 0;
+	entry->retry_limit = info->control.retry_limit;
 	entry->flags = cpu_to_le32(tx_flags);
 	__skb_queue_tail(&ring->queue, skb);
 	if (ring->entries - skb_queue_len(&ring->queue) < 2)
-		ieee80211_stop_queue(dev, control->queue);
+		ieee80211_stop_queue(dev, info->queue);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	rtl818x_iowrite8(priv, &priv->map->TX_DMA_POLLING, (1 << (prio + 4)));
@@ -522,7 +514,6 @@ static void rtl8180_free_tx_ring(struct 
 
 		pci_unmap_single(priv->pdev, le32_to_cpu(entry->tx_buf),
 				 skb->len, PCI_DMA_TODEVICE);
-		kfree(*((struct ieee80211_tx_control **) skb->cb));
 		kfree_skb(skb);
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
--- everything.orig/drivers/net/wireless/rtl8187_dev.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/rtl8187_dev.c	2008-05-11 00:05:16.000000000 +0200
@@ -145,27 +145,22 @@ void rtl8187_write_phy(struct ieee80211_
 
 static void rtl8187_tx_cb(struct urb *urb)
 {
-	struct ieee80211_tx_status status;
 	struct sk_buff *skb = (struct sk_buff *)urb->context;
-	struct rtl8187_tx_info *info = (struct rtl8187_tx_info *)skb->cb;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
+	struct ieee80211_hw *hw = info->driver_data[0];
 
-	memset(&status, 0, sizeof(status));
-
-	usb_free_urb(info->urb);
-	if (info->control)
-		memcpy(&status.control, info->control, sizeof(status.control));
-	kfree(info->control);
+	usb_free_urb(info->driver_data[1]);
 	skb_pull(skb, sizeof(struct rtl8187_tx_hdr));
-	status.flags |= IEEE80211_TX_STATUS_ACK;
-	ieee80211_tx_status_irqsafe(info->dev, skb, &status);
+	memset(&info->status, 0, sizeof(info->status));
+	info->flags |= IEEE80211_TX_STAT_ACK;
+	ieee80211_tx_status_irqsafe(hw, skb);
 }
 
-static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
-		      struct ieee80211_tx_control *control)
+static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct rtl8187_priv *priv = dev->priv;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	struct rtl8187_tx_hdr *hdr;
-	struct rtl8187_tx_info *info;
 	struct urb *urb;
 	__le16 rts_dur = 0;
 	u32 flags;
@@ -179,29 +174,27 @@ static int rtl8187_tx(struct ieee80211_h
 	flags = skb->len;
 	flags |= RTL8187_TX_FLAG_NO_ENCRYPT;
 
-	flags |= ieee80211_get_tx_rate(dev, control)->hw_value << 24;
+	flags |= ieee80211_get_tx_rate(dev, info)->hw_value << 24;
 	if (ieee80211_get_morefrag((struct ieee80211_hdr *)skb->data))
 		flags |= RTL8187_TX_FLAG_MORE_FRAG;
-	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
+	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {
 		flags |= RTL8187_TX_FLAG_RTS;
-		flags |= ieee80211_get_rts_cts_rate(dev, control)->hw_value << 19;
+		flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
 		rts_dur = ieee80211_rts_duration(dev, priv->vif,
-						 skb->len, control);
-	} else if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
+						 skb->len, info);
+	} else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT) {
 		flags |= RTL8187_TX_FLAG_CTS;
-		flags |= ieee80211_get_rts_cts_rate(dev, control)->hw_value << 19;
+		flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
 	}
 
 	hdr = (struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
 	hdr->flags = cpu_to_le32(flags);
 	hdr->len = 0;
 	hdr->rts_duration = rts_dur;
-	hdr->retry = cpu_to_le32(control->retry_limit << 8);
+	hdr->retry = cpu_to_le32(info->control.retry_limit << 8);
 
-	info = (struct rtl8187_tx_info *)skb->cb;
-	info->control = kmemdup(control, sizeof(*control), GFP_ATOMIC);
-	info->urb = urb;
-	info->dev = dev;
+	info->driver_data[0] = dev;
+	info->driver_data[1] = urb;
 	usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev, 2),
 			  hdr, skb->len, rtl8187_tx_cb, skb);
 	usb_submit_urb(urb, GFP_ATOMIC);
--- everything.orig/net/mac80211/ieee80211_i.h	2008-05-11 00:05:13.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-05-11 00:05:16.000000000 +0200
@@ -2,6 +2,7 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
+ * Copyright 2007-2008	Johannes Berg <johannes@sipsolutions.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -147,7 +148,6 @@ typedef unsigned __bitwise__ ieee80211_t
 #define IEEE80211_TX_UNICAST		BIT(1)
 #define IEEE80211_TX_PS_BUFFERED	BIT(2)
 #define IEEE80211_TX_PROBE_LAST_FRAG	BIT(3)
-#define IEEE80211_TX_INJECTED		BIT(4)
 
 struct ieee80211_tx_data {
 	struct sk_buff *skb;
@@ -157,7 +157,6 @@ struct ieee80211_tx_data {
 	struct sta_info *sta;
 	struct ieee80211_key *key;
 
-	struct ieee80211_tx_control *control;
 	struct ieee80211_channel *channel;
 	s8 rate_idx;
 	/* use this rate (if set) for last fragment; rate can
@@ -207,22 +206,7 @@ struct ieee80211_rx_data {
 	u16 tkip_iv16;
 };
 
-/* flags used in struct ieee80211_tx_packet_data.flags */
-#define IEEE80211_TXPD_REQ_TX_STATUS	BIT(0)
-#define IEEE80211_TXPD_DO_NOT_ENCRYPT	BIT(1)
-#define IEEE80211_TXPD_REQUEUE		BIT(2)
-#define IEEE80211_TXPD_EAPOL_FRAME	BIT(3)
-#define IEEE80211_TXPD_AMPDU		BIT(4)
-/* Stored in sk_buff->cb */
-struct ieee80211_tx_packet_data {
-	int ifindex;
-	unsigned long jiffies;
-	unsigned int flags;
-	u8 queue;
-};
-
 struct ieee80211_tx_stored_packet {
-	struct ieee80211_tx_control control;
 	struct sk_buff *skb;
 	struct sk_buff **extra_frag;
 	s8 last_frag_rate_idx;
--- everything.orig/net/mac80211/rate.h	2008-05-11 00:05:13.000000000 +0200
+++ everything/net/mac80211/rate.h	2008-05-11 00:05:16.000000000 +0200
@@ -34,8 +34,7 @@ struct rate_control_ops {
 	struct module *module;
 	const char *name;
 	void (*tx_status)(void *priv, struct net_device *dev,
-			  struct sk_buff *skb,
-			  struct ieee80211_tx_status *status);
+			  struct sk_buff *skb);
 	void (*get_rate)(void *priv, struct net_device *dev,
 			 struct ieee80211_supported_band *band,
 			 struct sk_buff *skb,
@@ -77,13 +76,12 @@ struct rate_control_ref *rate_control_ge
 void rate_control_put(struct rate_control_ref *ref);
 
 static inline void rate_control_tx_status(struct net_device *dev,
-					  struct sk_buff *skb,
-					  struct ieee80211_tx_status *status)
+					  struct sk_buff *skb)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct rate_control_ref *ref = local->rate_ctrl;
 
-	ref->ops->tx_status(ref->priv, dev, skb, status);
+	ref->ops->tx_status(ref->priv, dev, skb);
 }
 
 
--- everything.orig/net/mac80211/rx.c	2008-05-11 00:02:03.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-05-11 00:05:16.000000000 +0200
@@ -643,7 +643,7 @@ static int ap_sta_ps_end(struct net_devi
 	struct sk_buff *skb;
 	int sent = 0;
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_tx_packet_data *pkt_data;
+	struct ieee80211_tx_info *info;
 	DECLARE_MAC_BUF(mac);
 
 	sdata = sta->sdata;
@@ -663,13 +663,13 @@ static int ap_sta_ps_end(struct net_devi
 
 	/* Send all buffered frames to the station */
 	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
-		pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
+		info = (void *) skb->cb;
 		sent++;
-		pkt_data->flags |= IEEE80211_TXPD_REQUEUE;
+		info->flags |= IEEE80211_TX_CTL_REQUEUE;
 		dev_queue_xmit(skb);
 	}
 	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
-		pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
+		info = (void *) skb->cb;
 		local->total_ps_buffered--;
 		sent++;
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
@@ -677,7 +677,7 @@ static int ap_sta_ps_end(struct net_devi
 		       "since STA not sleeping anymore\n", dev->name,
 		       print_mac(mac, sta->addr), sta->aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-		pkt_data->flags |= IEEE80211_TXPD_REQUEUE;
+		info->flags |= IEEE80211_TX_CTL_REQUEUE;
 		dev_queue_xmit(skb);
 	}
 
--- everything.orig/net/mac80211/sta_info.c	2008-05-11 00:02:03.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-05-11 00:05:16.000000000 +0200
@@ -511,20 +511,20 @@ static inline int sta_info_buffer_expire
 					  struct sta_info *sta,
 					  struct sk_buff *skb)
 {
-	struct ieee80211_tx_packet_data *pkt_data;
+	struct ieee80211_tx_info *info;
 	int timeout;
 
 	if (!skb)
 		return 0;
 
-	pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
+	info = (void *)skb->cb;
 
 	/* Timeout: (2 * listen_interval * beacon_int * 1024 / 1000000) sec */
 	timeout = (sta->listen_interval * local->hw.conf.beacon_int * 32 /
 		   15625) * HZ;
 	if (timeout < STA_TX_BUFFER_EXPIRE)
 		timeout = STA_TX_BUFFER_EXPIRE;
-	return time_after(jiffies, pkt_data->jiffies + timeout);
+	return time_after(jiffies, info->control.jiffies + timeout);
 }
 
 
--- everything.orig/net/mac80211/wme.c	2008-05-11 00:02:03.000000000 +0200
+++ everything/net/mac80211/wme.c	2008-05-11 00:05:16.000000000 +0200
@@ -149,8 +149,7 @@ static int wme_qdiscop_enqueue(struct sk
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_sched_data *q = qdisc_priv(qd);
-	struct ieee80211_tx_packet_data *pkt_data =
-		(struct ieee80211_tx_packet_data *) skb->cb;
+	struct ieee80211_tx_info *info = (void *) skb->cb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	unsigned short fc = le16_to_cpu(hdr->frame_control);
 	struct Qdisc *qdisc;
@@ -158,8 +157,8 @@ static int wme_qdiscop_enqueue(struct sk
 	int err, queue;
 	u8 tid;
 
-	if (pkt_data->flags & IEEE80211_TXPD_REQUEUE) {
-		queue = pkt_data->queue;
+	if (info->flags & IEEE80211_TX_CTL_REQUEUE) {
+		queue = info->queue;
 		rcu_read_lock();
 		sta = sta_info_get(local, hdr->addr1);
 		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
@@ -168,9 +167,9 @@ static int wme_qdiscop_enqueue(struct sk
 			if ((ampdu_queue < QD_NUM(hw)) &&
 			    test_bit(ampdu_queue, q->qdisc_pool)) {
 				queue = ampdu_queue;
-				pkt_data->flags |= IEEE80211_TXPD_AMPDU;
+				info->flags |= IEEE80211_TX_CTL_AMPDU;
 			} else {
-				pkt_data->flags &= ~IEEE80211_TXPD_AMPDU;
+				info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 			}
 		}
 		rcu_read_unlock();
@@ -206,9 +205,9 @@ static int wme_qdiscop_enqueue(struct sk
 			if ((ampdu_queue < QD_NUM(hw)) &&
 			    test_bit(ampdu_queue, q->qdisc_pool)) {
 				queue = ampdu_queue;
-				pkt_data->flags |= IEEE80211_TXPD_AMPDU;
+				info->flags |= IEEE80211_TX_CTL_AMPDU;
 			} else {
-				pkt_data->flags &= ~IEEE80211_TXPD_AMPDU;
+				info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 			}
 		}
 
@@ -220,7 +219,7 @@ static int wme_qdiscop_enqueue(struct sk
 			err = NET_XMIT_DROP;
 	} else {
 		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
-		pkt_data->queue = (unsigned int) queue;
+		info->queue = (unsigned int) queue;
 		qdisc = q->queues[queue];
 		err = qdisc->enqueue(skb, qdisc);
 		if (err == NET_XMIT_SUCCESS) {
@@ -241,13 +240,12 @@ static int wme_qdiscop_enqueue(struct sk
 static int wme_qdiscop_requeue(struct sk_buff *skb, struct Qdisc* qd)
 {
 	struct ieee80211_sched_data *q = qdisc_priv(qd);
-	struct ieee80211_tx_packet_data *pkt_data =
-		(struct ieee80211_tx_packet_data *) skb->cb;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	struct Qdisc *qdisc;
 	int err;
 
 	/* we recorded which queue to use earlier! */
-	qdisc = q->queues[pkt_data->queue];
+	qdisc = q->queues[info->queue];
 
 	if ((err = qdisc->ops->requeue(skb, qdisc)) == 0) {
 		qd->q.qlen++;
--- everything.orig/net/mac80211/wpa.c	2008-05-11 00:02:04.000000000 +0200
+++ everything/net/mac80211/wpa.c	2008-05-11 00:05:16.000000000 +0200
@@ -181,15 +181,25 @@ ieee80211_rx_h_michael_mic_verify(struct
 }
 
 
-static int tkip_encrypt_skb(struct ieee80211_tx_data *tx,
-			    struct sk_buff *skb, int test)
+static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_key *key = tx->key;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	int hdrlen, len, tail;
 	u16 fc;
 	u8 *pos;
 
+	info->control.icv_len = TKIP_ICV_LEN;
+	info->control.iv_len = TKIP_IV_LEN;
+
+	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
+	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
+		/* hwaccel - with no need for preallocated room for IV/ICV */
+		info->control.hw_key = &tx->key->conf;
+		return TX_CONTINUE;
+	}
+
 	fc = le16_to_cpu(hdr->frame_control);
 	hdrlen = ieee80211_get_hdrlen(fc);
 	len = skb->len - hdrlen;
@@ -222,7 +232,7 @@ static int tkip_encrypt_skb(struct ieee8
 					    0x7f),
 				      (u8) key->u.tkip.iv16);
 
-		tx->control->hw_key = &tx->key->conf;
+		info->control.hw_key = &tx->key->conf;
 		return 0;
 	}
 
@@ -240,28 +250,16 @@ ieee80211_tx_result
 ieee80211_crypto_tkip_encrypt(struct ieee80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
-	int wpa_test = 0, test = 0;
 
-	tx->control->icv_len = TKIP_ICV_LEN;
-	tx->control->iv_len = TKIP_IV_LEN;
 	ieee80211_tx_set_protected(tx);
 
-	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
-	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
-	    !wpa_test) {
-		/* hwaccel - with no need for preallocated room for IV/ICV */
-		tx->control->hw_key = &tx->key->conf;
-		return TX_CONTINUE;
-	}
-
-	if (tkip_encrypt_skb(tx, skb, test) < 0)
+	if (tkip_encrypt_skb(tx, skb) < 0)
 		return TX_DROP;
 
 	if (tx->extra_frag) {
 		int i;
 		for (i = 0; i < tx->num_extra_frag; i++) {
-			if (tkip_encrypt_skb(tx, tx->extra_frag[i], test)
-			    < 0)
+			if (tkip_encrypt_skb(tx, tx->extra_frag[i]) < 0)
 				return TX_DROP;
 		}
 	}
@@ -423,16 +421,27 @@ static inline int ccmp_hdr2pn(u8 *pn, u8
 }
 
 
-static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx,
-			    struct sk_buff *skb, int test)
+static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_key *key = tx->key;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	int hdrlen, len, tail;
 	u16 fc;
 	u8 *pos, *pn, *b_0, *aad, *scratch;
 	int i;
 
+	info->control.icv_len = CCMP_MIC_LEN;
+	info->control.iv_len = CCMP_HDR_LEN;
+
+	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
+	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
+		/* hwaccel - with no need for preallocated room for CCMP "
+		 * header or MIC fields */
+		info->control.hw_key = &tx->key->conf;
+		return TX_CONTINUE;
+	}
+
 	scratch = key->u.ccmp.tx_crypto_buf;
 	b_0 = scratch + 3 * AES_BLOCK_LEN;
 	aad = scratch + 4 * AES_BLOCK_LEN;
@@ -468,7 +477,7 @@ static int ccmp_encrypt_skb(struct ieee8
 
 	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		/* hwaccel - with preallocated room for CCMP header */
-		tx->control->hw_key = &tx->key->conf;
+		info->control.hw_key = &tx->key->conf;
 		return 0;
 	}
 
@@ -485,28 +494,16 @@ ieee80211_tx_result
 ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
-	int test = 0;
 
-	tx->control->icv_len = CCMP_MIC_LEN;
-	tx->control->iv_len = CCMP_HDR_LEN;
 	ieee80211_tx_set_protected(tx);
 
-	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
-	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
-		/* hwaccel - with no need for preallocated room for CCMP "
-		 * header or MIC fields */
-		tx->control->hw_key = &tx->key->conf;
-		return TX_CONTINUE;
-	}
-
-	if (ccmp_encrypt_skb(tx, skb, test) < 0)
+	if (ccmp_encrypt_skb(tx, skb) < 0)
 		return TX_DROP;
 
 	if (tx->extra_frag) {
 		int i;
 		for (i = 0; i < tx->num_extra_frag; i++) {
-			if (ccmp_encrypt_skb(tx, tx->extra_frag[i], test)
-			    < 0)
+			if (ccmp_encrypt_skb(tx, tx->extra_frag[i]) < 0)
 				return TX_DROP;
 		}
 	}
--- everything.orig/net/mac80211/rc80211_pid.h	2008-05-11 00:02:03.000000000 +0200
+++ everything/net/mac80211/rc80211_pid.h	2008-05-11 00:05:16.000000000 +0200
@@ -61,7 +61,7 @@ enum rc_pid_event_type {
 union rc_pid_event_data {
 	/* RC_PID_EVENT_TX_STATUS */
 	struct {
-		struct ieee80211_tx_status tx_status;
+		struct ieee80211_tx_info tx_status;
 	};
 	/* RC_PID_EVENT_TYPE_RATE_CHANGE */
 	/* RC_PID_EVENT_TYPE_TX_RATE */
@@ -158,7 +158,7 @@ struct rc_pid_debugfs_entries {
 };
 
 void rate_control_pid_event_tx_status(struct rc_pid_event_buffer *buf,
-					     struct ieee80211_tx_status *stat);
+				      struct ieee80211_tx_info *stat);
 
 void rate_control_pid_event_rate_change(struct rc_pid_event_buffer *buf,
 					       int index, int rate);
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-05-11 00:05:16.000000000 +0200
@@ -237,8 +237,7 @@ static void rate_control_pid_sample(stru
 }
 
 static void rate_control_pid_tx_status(void *priv, struct net_device *dev,
-				       struct sk_buff *skb,
-				       struct ieee80211_tx_status *status)
+				       struct sk_buff *skb)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -248,6 +247,7 @@ static void rate_control_pid_tx_status(v
 	struct rc_pid_sta_info *spinfo;
 	unsigned long period;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 
 	rcu_read_lock();
 
@@ -266,28 +266,28 @@ static void rate_control_pid_tx_status(v
 
 	/* Ignore all frames that were sent with a different rate than the rate
 	 * we currently advise mac80211 to use. */
-	if (status->control.tx_rate_idx != sta->txrate_idx)
+	if (info->tx_rate_idx != sta->txrate_idx)
 		goto unlock;
 
 	spinfo = sta->rate_ctrl_priv;
 	spinfo->tx_num_xmit++;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-	rate_control_pid_event_tx_status(&spinfo->events, status);
+	rate_control_pid_event_tx_status(&spinfo->events, info);
 #endif
 
 	/* We count frames that totally failed to be transmitted as two bad
 	 * frames, those that made it out but had some retries as one good and
 	 * one bad frame. */
-	if (status->excessive_retries) {
+	if (info->status.excessive_retries) {
 		spinfo->tx_num_failed += 2;
 		spinfo->tx_num_xmit++;
-	} else if (status->retry_count) {
+	} else if (info->status.retry_count) {
 		spinfo->tx_num_failed++;
 		spinfo->tx_num_xmit++;
 	}
 
-	if (status->excessive_retries) {
+	if (info->status.excessive_retries) {
 		sta->tx_retry_failed++;
 		sta->tx_num_consecutive_failures++;
 		sta->tx_num_mpdu_fail++;
@@ -295,8 +295,8 @@ static void rate_control_pid_tx_status(v
 		sta->tx_num_consecutive_failures = 0;
 		sta->tx_num_mpdu_ok++;
 	}
-	sta->tx_retry_count += status->retry_count;
-	sta->tx_num_mpdu_fail += status->retry_count;
+	sta->tx_retry_count += info->status.retry_count;
+	sta->tx_num_mpdu_fail += info->status.retry_count;
 
 	/* Update PID controller state. */
 	period = (HZ * pinfo->sampling_period + 500) / 1000;
--- everything.orig/net/mac80211/rc80211_pid_debugfs.c	2008-05-11 00:02:03.000000000 +0200
+++ everything/net/mac80211/rc80211_pid_debugfs.c	2008-05-11 00:05:16.000000000 +0200
@@ -39,11 +39,11 @@ static void rate_control_pid_event(struc
 }
 
 void rate_control_pid_event_tx_status(struct rc_pid_event_buffer *buf,
-					     struct ieee80211_tx_status *stat)
+				      struct ieee80211_tx_info *stat)
 {
 	union rc_pid_event_data evd;
 
-	memcpy(&evd.tx_status, stat, sizeof(struct ieee80211_tx_status));
+	memcpy(&evd.tx_status, stat, sizeof(struct ieee80211_tx_info));
 	rate_control_pid_event(buf, RC_PID_EVENT_TYPE_TX_STATUS, &evd);
 }
 
@@ -167,8 +167,8 @@ static ssize_t rate_control_pid_events_r
 	switch (ev->type) {
 	case RC_PID_EVENT_TYPE_TX_STATUS:
 		p += snprintf(pb + p, length - p, "tx_status %u %u",
-			      ev->data.tx_status.excessive_retries,
-			      ev->data.tx_status.retry_count);
+			      ev->data.tx_status.status.excessive_retries,
+			      ev->data.tx_status.status.retry_count);
 		break;
 	case RC_PID_EVENT_TYPE_RATE_CHANGE:
 		p += snprintf(pb + p, length - p, "rate_change %d %d",
--- everything.orig/drivers/net/wireless/b43/b43.h	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/b43/b43.h	2008-05-11 00:05:16.000000000 +0200
@@ -733,7 +733,6 @@ struct b43_wl {
 	/* The beacon we are currently using (AP or IBSS mode).
 	 * This beacon stuff is protected by the irq_lock. */
 	struct sk_buff *current_beacon;
-	struct ieee80211_tx_control beacon_txctl;
 	bool beacon0_uploaded;
 	bool beacon1_uploaded;
 	struct work_struct beacon_update_trigger;
--- everything.orig/drivers/net/wireless/b43/dma.c	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/b43/dma.c	2008-05-11 00:05:16.000000000 +0200
@@ -1131,10 +1131,10 @@ struct b43_dmaring *parse_cookie(struct 
 }
 
 static int dma_tx_fragment(struct b43_dmaring *ring,
-			   struct sk_buff *skb,
-			   struct ieee80211_tx_control *ctl)
+			   struct sk_buff *skb)
 {
 	const struct b43_dma_ops *ops = ring->ops;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	u8 *header;
 	int slot, old_top_slot, old_used_slots;
 	int err;
@@ -1158,7 +1158,7 @@ static int dma_tx_fragment(struct b43_dm
 	header = &(ring->txhdr_cache[slot * hdrsize]);
 	cookie = generate_cookie(ring, slot);
 	err = b43_generate_txhdr(ring->dev, header,
-				 skb->data, skb->len, ctl, cookie);
+				 skb->data, skb->len, info, cookie);
 	if (unlikely(err)) {
 		ring->current_slot = old_top_slot;
 		ring->used_slots = old_used_slots;
@@ -1180,7 +1180,6 @@ static int dma_tx_fragment(struct b43_dm
 	desc = ops->idx2desc(ring, slot, &meta);
 	memset(meta, 0, sizeof(*meta));
 
-	memcpy(&meta->txstat.control, ctl, sizeof(*ctl));
 	meta->skb = skb;
 	meta->is_last_fragment = 1;
 
@@ -1210,7 +1209,7 @@ static int dma_tx_fragment(struct b43_dm
 
 	ops->fill_descriptor(ring, desc, meta->dmaaddr, skb->len, 0, 1, 1);
 
-	if (ctl->flags & IEEE80211_TXCTL_SEND_AFTER_DTIM) {
+	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
 		/* Tell the firmware about the cookie of the last
 		 * mcast frame, so it can clear the more-data bit in it. */
 		b43_shm_write16(ring->dev, B43_SHM_SHARED,
@@ -1281,16 +1280,16 @@ static struct b43_dmaring * select_ring_
 	return ring;
 }
 
-int b43_dma_tx(struct b43_wldev *dev,
-	       struct sk_buff *skb, struct ieee80211_tx_control *ctl)
+int b43_dma_tx(struct b43_wldev *dev, struct sk_buff *skb)
 {
 	struct b43_dmaring *ring;
 	struct ieee80211_hdr *hdr;
 	int err = 0;
 	unsigned long flags;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
-	if (ctl->flags & IEEE80211_TXCTL_SEND_AFTER_DTIM) {
+	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
 		/* The multicast ring will be sent after the DTIM */
 		ring = dev->dma.tx_ring_mcast;
 		/* Set the more-data bit. Ucode will clear it on
@@ -1298,7 +1297,7 @@ int b43_dma_tx(struct b43_wldev *dev,
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 	} else {
 		/* Decide by priority where to put this frame. */
-		ring = select_ring_by_priority(dev, ctl->queue);
+		ring = select_ring_by_priority(dev, info->queue);
 	}
 
 	spin_lock_irqsave(&ring->lock, flags);
@@ -1316,9 +1315,9 @@ int b43_dma_tx(struct b43_wldev *dev,
 	/* Assign the queue number to the ring (if not already done before)
 	 * so TX status handling can use it. The queue to ring mapping is
 	 * static, so we don't need to store it per frame. */
-	ring->queue_prio = ctl->queue;
+	ring->queue_prio = info->queue;
 
-	err = dma_tx_fragment(ring, skb, ctl);
+	err = dma_tx_fragment(ring, skb);
 	if (unlikely(err == -ENOKEY)) {
 		/* Drop this packet, as we don't have the encryption key
 		 * anymore and must not transmit it unencrypted. */
@@ -1334,7 +1333,7 @@ int b43_dma_tx(struct b43_wldev *dev,
 	if ((free_slots(ring) < SLOTS_PER_PACKET) ||
 	    should_inject_overflow(ring)) {
 		/* This TX ring is full. */
-		ieee80211_stop_queue(dev->wl->hw, ctl->queue);
+		ieee80211_stop_queue(dev->wl->hw, info->queue);
 		ring->stopped = 1;
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
 			b43dbg(dev->wl, "Stopped TX ring %d\n", ring->index);
@@ -1377,13 +1376,19 @@ void b43_dma_handle_txstatus(struct b43_
 					 b43_txhdr_size(dev), 1);
 
 		if (meta->is_last_fragment) {
-			B43_WARN_ON(!meta->skb);
-			/* Call back to inform the ieee80211 subsystem about the
-			 * status of the transmission.
-			 * Some fields of txstat are already filled in dma_tx().
+			struct ieee80211_tx_info *info;
+
+			BUG_ON(!meta->skb);
+
+			info = (void *)meta->skb->cb;
+
+			memset(&info->status, 0, sizeof(info->status));
+
+			/*
+			 * Call back to inform the ieee80211 subsystem about
+			 * the status of the transmission.
 			 */
-			frame_succeed = b43_fill_txstatus_report(
-						&(meta->txstat), status);
+			frame_succeed = b43_fill_txstatus_report(info, status);
 #ifdef CONFIG_B43_DEBUG
 			if (frame_succeed)
 				ring->nr_succeed_tx_packets++;
@@ -1391,8 +1396,8 @@ void b43_dma_handle_txstatus(struct b43_
 				ring->nr_failed_tx_packets++;
 			ring->nr_total_packet_tries += status->frame_count;
 #endif /* DEBUG */
-			ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb,
-						    &(meta->txstat));
+			ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb);
+
 			/* skb is freed by ieee80211_tx_status_irqsafe() */
 			meta->skb = NULL;
 		} else {
--- everything.orig/drivers/net/wireless/b43/dma.h	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/b43/dma.h	2008-05-11 00:05:16.000000000 +0200
@@ -181,7 +181,6 @@ struct b43_dmadesc_meta {
 	dma_addr_t dmaaddr;
 	/* ieee80211 TX status. Only used once per 802.11 frag. */
 	bool is_last_fragment;
-	struct ieee80211_tx_status txstat;
 };
 
 struct b43_dmaring;
@@ -285,7 +284,7 @@ void b43_dma_get_tx_stats(struct b43_wld
 			  struct ieee80211_tx_queue_stats *stats);
 
 int b43_dma_tx(struct b43_wldev *dev,
-	       struct sk_buff *skb, struct ieee80211_tx_control *ctl);
+	       struct sk_buff *skb);
 void b43_dma_handle_txstatus(struct b43_wldev *dev,
 			     const struct b43_txstatus *status);
 
--- everything.orig/drivers/net/wireless/b43/main.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/b43/main.c	2008-05-11 00:05:16.000000000 +0200
@@ -1368,18 +1368,18 @@ static void b43_write_beacon_template(st
 	unsigned int rate;
 	u16 ctl;
 	int antenna;
+	struct ieee80211_tx_info *info = (void *)dev->wl->current_beacon->cb;
 
 	bcn = (const struct ieee80211_mgmt *)(dev->wl->current_beacon->data);
 	len = min((size_t) dev->wl->current_beacon->len,
 		  0x200 - sizeof(struct b43_plcp_hdr6));
-	rate = ieee80211_get_tx_rate(dev->wl->hw, &dev->wl->beacon_txctl)->hw_value;
+	rate = ieee80211_get_tx_rate(dev->wl->hw, info)->hw_value;
 
 	b43_write_template_common(dev, (const u8 *)bcn,
 				  len, ram_offset, shm_size_offset, rate);
 
 	/* Write the PHY TX control parameters. */
-	antenna = b43_antenna_from_ieee80211(dev,
-			dev->wl->beacon_txctl.antenna_sel_tx);
+	antenna = b43_antenna_from_ieee80211(dev, info->antenna_sel_tx);
 	antenna = b43_antenna_to_phyctl(antenna);
 	ctl = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_BEACPHYCTL);
 	/* We can't send beacons with short preamble. Would get PHY errors. */
@@ -1613,8 +1613,7 @@ static void b43_beacon_update_trigger_wo
 
 /* Asynchronously update the packet templates in template RAM.
  * Locking: Requires wl->irq_lock to be locked. */
-static void b43_update_templates(struct b43_wl *wl, struct sk_buff *beacon,
-				 const struct ieee80211_tx_control *txctl)
+static void b43_update_templates(struct b43_wl *wl, struct sk_buff *beacon)
 {
 	/* This is the top half of the ansynchronous beacon update.
 	 * The bottom half is the beacon IRQ.
@@ -1625,7 +1624,6 @@ static void b43_update_templates(struct 
 	if (wl->current_beacon)
 		dev_kfree_skb_any(wl->current_beacon);
 	wl->current_beacon = beacon;
-	memcpy(&wl->beacon_txctl, txctl, sizeof(wl->beacon_txctl));
 	wl->beacon0_uploaded = 0;
 	wl->beacon1_uploaded = 0;
 	queue_work(wl->hw->workqueue, &wl->beacon_update_trigger);
@@ -2813,8 +2811,7 @@ static int b43_rng_init(struct b43_wl *w
 }
 
 static int b43_op_tx(struct ieee80211_hw *hw,
-		     struct sk_buff *skb,
-		     struct ieee80211_tx_control *ctl)
+		     struct sk_buff *skb)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
@@ -2836,9 +2833,9 @@ static int b43_op_tx(struct ieee80211_hw
 	err = -ENODEV;
 	if (likely(b43_status(dev) >= B43_STAT_STARTED)) {
 		if (b43_using_pio_transfers(dev))
-			err = b43_pio_tx(dev, skb, ctl);
+			err = b43_pio_tx(dev, skb);
 		else
-			err = b43_dma_tx(dev, skb, ctl);
+			err = b43_dma_tx(dev, skb);
 	}
 
 	read_unlock_irqrestore(&wl->tx_lock, flags);
@@ -3429,10 +3426,8 @@ static int b43_op_config_interface(struc
 		if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP)) {
 			B43_WARN_ON(conf->type != IEEE80211_IF_TYPE_AP);
 			b43_set_ssid(dev, conf->ssid, conf->ssid_len);
-			if (conf->beacon) {
-				b43_update_templates(wl, conf->beacon,
-						     conf->beacon_control);
-			}
+			if (conf->beacon)
+				b43_update_templates(wl, conf->beacon);
 		}
 		b43_write_mac_bssid_templates(dev);
 	}
@@ -4118,31 +4113,29 @@ static int b43_op_beacon_set_tim(struct 
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct sk_buff *beacon;
 	unsigned long flags;
-	struct ieee80211_tx_control txctl;
 
 	/* We could modify the existing beacon and set the aid bit in
 	 * the TIM field, but that would probably require resizing and
 	 * moving of data within the beacon template.
 	 * Simply request a new beacon and let mac80211 do the hard work. */
-	beacon = ieee80211_beacon_get(hw, wl->vif, &txctl);
+	beacon = ieee80211_beacon_get(hw, wl->vif);
 	if (unlikely(!beacon))
 		return -ENOMEM;
 	spin_lock_irqsave(&wl->irq_lock, flags);
-	b43_update_templates(wl, beacon, &txctl);
+	b43_update_templates(wl, beacon);
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	return 0;
 }
 
 static int b43_op_ibss_beacon_update(struct ieee80211_hw *hw,
-				     struct sk_buff *beacon,
-				     struct ieee80211_tx_control *ctl)
+				     struct sk_buff *beacon)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	unsigned long flags;
 
 	spin_lock_irqsave(&wl->irq_lock, flags);
-	b43_update_templates(wl, beacon, ctl);
+	b43_update_templates(wl, beacon);
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	return 0;
--- everything.orig/drivers/net/wireless/b43/pio.c	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/b43/pio.c	2008-05-11 00:05:16.000000000 +0200
@@ -446,29 +446,27 @@ static void pio_tx_frame_4byte_queue(str
 }
 
 static int pio_tx_frame(struct b43_pio_txqueue *q,
-			struct sk_buff *skb,
-			struct ieee80211_tx_control *ctl)
+			struct sk_buff *skb)
 {
 	struct b43_pio_txpacket *pack;
 	struct b43_txhdr txhdr;
 	u16 cookie;
 	int err;
 	unsigned int hdrlen;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 
 	B43_WARN_ON(list_empty(&q->packets_list));
 	pack = list_entry(q->packets_list.next,
 			  struct b43_pio_txpacket, list);
-	memset(&pack->txstat, 0, sizeof(pack->txstat));
-	memcpy(&pack->txstat.control, ctl, sizeof(*ctl));
 
 	cookie = generate_cookie(q, pack);
 	hdrlen = b43_txhdr_size(q->dev);
 	err = b43_generate_txhdr(q->dev, (u8 *)&txhdr, skb->data,
-				 skb->len, ctl, cookie);
+				 skb->len, info, cookie);
 	if (err)
 		return err;
 
-	if (ctl->flags & IEEE80211_TXCTL_SEND_AFTER_DTIM) {
+	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
 		/* Tell the firmware about the cookie of the last
 		 * mcast frame, so it can clear the more-data bit in it. */
 		b43_shm_write16(q->dev, B43_SHM_SHARED,
@@ -492,17 +490,18 @@ static int pio_tx_frame(struct b43_pio_t
 	return 0;
 }
 
-int b43_pio_tx(struct b43_wldev *dev,
-	       struct sk_buff *skb, struct ieee80211_tx_control *ctl)
+int b43_pio_tx(struct b43_wldev *dev, struct sk_buff *skb)
 {
 	struct b43_pio_txqueue *q;
 	struct ieee80211_hdr *hdr;
 	unsigned long flags;
 	unsigned int hdrlen, total_len;
 	int err = 0;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
-	if (ctl->flags & IEEE80211_TXCTL_SEND_AFTER_DTIM) {
+
+	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
 		/* The multicast queue will be sent after the DTIM. */
 		q = dev->pio.tx_queue_mcast;
 		/* Set the frame More-Data bit. Ucode will clear it
@@ -510,7 +509,7 @@ int b43_pio_tx(struct b43_wldev *dev,
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 	} else {
 		/* Decide by priority where to put this frame. */
-		q = select_queue_by_priority(dev, ctl->queue);
+		q = select_queue_by_priority(dev, info->queue);
 	}
 
 	spin_lock_irqsave(&q->lock, flags);
@@ -533,7 +532,7 @@ int b43_pio_tx(struct b43_wldev *dev,
 	if (total_len > (q->buffer_size - q->buffer_used)) {
 		/* Not enough memory on the queue. */
 		err = -EBUSY;
-		ieee80211_stop_queue(dev->wl->hw, ctl->queue);
+		ieee80211_stop_queue(dev->wl->hw, info->queue);
 		q->stopped = 1;
 		goto out_unlock;
 	}
@@ -541,9 +540,9 @@ int b43_pio_tx(struct b43_wldev *dev,
 	/* Assign the queue number to the ring (if not already done before)
 	 * so TX status handling can use it. The mac80211-queue to b43-queue
 	 * mapping is static, so we don't need to store it per frame. */
-	q->queue_prio = ctl->queue;
+	q->queue_prio = info->queue;
 
-	err = pio_tx_frame(q, skb, ctl);
+	err = pio_tx_frame(q, skb);
 	if (unlikely(err == -ENOKEY)) {
 		/* Drop this packet, as we don't have the encryption key
 		 * anymore and must not transmit it unencrypted. */
@@ -561,7 +560,7 @@ int b43_pio_tx(struct b43_wldev *dev,
 	if (((q->buffer_size - q->buffer_used) < roundup(2 + 2 + 6, 4)) ||
 	    (q->free_packet_slots == 0)) {
 		/* The queue is full. */
-		ieee80211_stop_queue(dev->wl->hw, ctl->queue);
+		ieee80211_stop_queue(dev->wl->hw, info->queue);
 		q->stopped = 1;
 	}
 
@@ -578,6 +577,7 @@ void b43_pio_handle_txstatus(struct b43_
 	struct b43_pio_txqueue *q;
 	struct b43_pio_txpacket *pack = NULL;
 	unsigned int total_len;
+	struct ieee80211_tx_info *info;
 
 	q = parse_cookie(dev, status->cookie, &pack);
 	if (unlikely(!q))
@@ -586,15 +586,17 @@ void b43_pio_handle_txstatus(struct b43_
 
 	spin_lock(&q->lock); /* IRQs are already disabled. */
 
-	b43_fill_txstatus_report(&(pack->txstat), status);
+	info = (void *)pack->skb;
+	memset(&info->status, 0, sizeof(info->status));
+
+	b43_fill_txstatus_report(info, status);
 
 	total_len = pack->skb->len + b43_txhdr_size(dev);
 	total_len = roundup(total_len, 4);
 	q->buffer_used -= total_len;
 	q->free_packet_slots += 1;
 
-	ieee80211_tx_status_irqsafe(dev->wl->hw, pack->skb,
-				    &(pack->txstat));
+	ieee80211_tx_status_irqsafe(dev->wl->hw, pack->skb);
 	pack->skb = NULL;
 	list_add(&pack->list, &q->packets_list);
 
--- everything.orig/drivers/net/wireless/b43/pio.h	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/b43/pio.h	2008-05-11 00:05:16.000000000 +0200
@@ -62,8 +62,6 @@ struct b43_pio_txpacket {
 	struct b43_pio_txqueue *queue;
 	/* The TX data packet. */
 	struct sk_buff *skb;
-	/* The status meta data. */
-	struct ieee80211_tx_status txstat;
 	/* Index in the (struct b43_pio_txqueue)->packets array. */
 	u8 index;
 
@@ -167,8 +165,7 @@ int b43_pio_init(struct b43_wldev *dev);
 void b43_pio_stop(struct b43_wldev *dev);
 void b43_pio_free(struct b43_wldev *dev);
 
-int b43_pio_tx(struct b43_wldev *dev,
-	       struct sk_buff *skb, struct ieee80211_tx_control *ctl);
+int b43_pio_tx(struct b43_wldev *dev, struct sk_buff *skb);
 void b43_pio_handle_txstatus(struct b43_wldev *dev,
 			     const struct b43_txstatus *status);
 void b43_pio_get_tx_stats(struct b43_wldev *dev,
@@ -193,8 +190,7 @@ static inline void b43_pio_stop(struct b
 {
 }
 static inline int b43_pio_tx(struct b43_wldev *dev,
-			     struct sk_buff *skb,
-			     struct ieee80211_tx_control *ctl)
+			     struct sk_buff *skb)
 {
 	return 0;
 }
--- everything.orig/drivers/net/wireless/b43/xmit.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/b43/xmit.c	2008-05-11 00:05:16.000000000 +0200
@@ -185,14 +185,14 @@ int b43_generate_txhdr(struct b43_wldev 
 		       u8 *_txhdr,
 		       const unsigned char *fragment_data,
 		       unsigned int fragment_len,
-		       const struct ieee80211_tx_control *txctl,
+		       const struct ieee80211_tx_info *info,
 		       u16 cookie)
 {
 	struct b43_txhdr *txhdr = (struct b43_txhdr *)_txhdr;
 	const struct b43_phy *phy = &dev->phy;
 	const struct ieee80211_hdr *wlhdr =
 	    (const struct ieee80211_hdr *)fragment_data;
-	int use_encryption = (!(txctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT));
+	int use_encryption = (!(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT));
 	u16 fctl = le16_to_cpu(wlhdr->frame_control);
 	struct ieee80211_rate *fbrate;
 	u8 rate, rate_fb;
@@ -205,10 +205,10 @@ int b43_generate_txhdr(struct b43_wldev 
 
 	memset(txhdr, 0, sizeof(*txhdr));
 
-	txrate = ieee80211_get_tx_rate(dev->wl->hw, txctl);
+	txrate = ieee80211_get_tx_rate(dev->wl->hw, info);
 	rate = txrate ? txrate->hw_value : B43_CCK_RATE_1MB;
 	rate_ofdm = b43_is_ofdm_rate(rate);
-	fbrate = ieee80211_get_alt_retry_rate(dev->wl->hw, txctl) ? : txrate;
+	fbrate = ieee80211_get_alt_retry_rate(dev->wl->hw, info) ? : txrate;
 	rate_fb = fbrate->hw_value;
 	rate_fb_ofdm = b43_is_ofdm_rate(rate_fb);
 
@@ -228,15 +228,13 @@ int b43_generate_txhdr(struct b43_wldev 
 		 * use the original dur_id field. */
 		txhdr->dur_fb = wlhdr->duration_id;
 	} else {
-		txhdr->dur_fb = ieee80211_generic_frame_duration(dev->wl->hw,
-								 txctl->vif,
-								 fragment_len,
-								 fbrate);
+		txhdr->dur_fb = ieee80211_generic_frame_duration(
+			dev->wl->hw, info->control.vif, fragment_len, fbrate);
 	}
 
 	plcp_fragment_len = fragment_len + FCS_LEN;
 	if (use_encryption) {
-		u8 key_idx = txctl->hw_key->hw_key_idx;
+		u8 key_idx = info->control.hw_key->hw_key_idx;
 		struct b43_key *key;
 		int wlhdr_len;
 		size_t iv_len;
@@ -254,7 +252,7 @@ int b43_generate_txhdr(struct b43_wldev 
 		}
 
 		/* Hardware appends ICV. */
-		plcp_fragment_len += txctl->icv_len;
+		plcp_fragment_len += info->control.icv_len;
 
 		key_idx = b43_kidx_to_fw(dev, key_idx);
 		mac_ctl |= (key_idx << B43_TXH_MAC_KEYIDX_SHIFT) &
@@ -262,7 +260,7 @@ int b43_generate_txhdr(struct b43_wldev 
 		mac_ctl |= (key->algorithm << B43_TXH_MAC_KEYALG_SHIFT) &
 			   B43_TXH_MAC_KEYALG;
 		wlhdr_len = ieee80211_get_hdrlen(fctl);
-		iv_len = min((size_t) txctl->iv_len,
+		iv_len = min((size_t) info->control.iv_len,
 			     ARRAY_SIZE(txhdr->iv));
 		memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
 	}
@@ -293,10 +291,10 @@ int b43_generate_txhdr(struct b43_wldev 
 		phy_ctl |= B43_TXH_PHY_ENC_OFDM;
 	else
 		phy_ctl |= B43_TXH_PHY_ENC_CCK;
-	if (txctl->flags & IEEE80211_TXCTL_SHORT_PREAMBLE)
+	if (info->flags & IEEE80211_TX_CTL_SHORT_PREAMBLE)
 		phy_ctl |= B43_TXH_PHY_SHORTPRMBL;
 
-	switch (b43_ieee80211_antenna_sanitize(dev, txctl->antenna_sel_tx)) {
+	switch (b43_ieee80211_antenna_sanitize(dev, info->antenna_sel_tx)) {
 	case 0: /* Default */
 		phy_ctl |= B43_TXH_PHY_ANT01AUTO;
 		break;
@@ -317,21 +315,21 @@ int b43_generate_txhdr(struct b43_wldev 
 	}
 
 	/* MAC control */
-	if (!(txctl->flags & IEEE80211_TXCTL_NO_ACK))
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		mac_ctl |= B43_TXH_MAC_ACK;
 	if (!(((fctl & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
 	      ((fctl & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)))
 		mac_ctl |= B43_TXH_MAC_HWSEQ;
-	if (txctl->flags & IEEE80211_TXCTL_FIRST_FRAGMENT)
+	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 		mac_ctl |= B43_TXH_MAC_STMSDU;
 	if (phy->type == B43_PHYTYPE_A)
 		mac_ctl |= B43_TXH_MAC_5GHZ;
-	if (txctl->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT)
+	if (info->flags & IEEE80211_TX_CTL_LONG_RETRY_LIMIT)
 		mac_ctl |= B43_TXH_MAC_LONGFRAME;
 
 	/* Generate the RTS or CTS-to-self frame */
-	if ((txctl->flags & IEEE80211_TXCTL_USE_RTS_CTS) ||
-	    (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)) {
+	if ((info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) ||
+	    (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)) {
 		unsigned int len;
 		struct ieee80211_hdr *hdr;
 		int rts_rate, rts_rate_fb;
@@ -339,14 +337,14 @@ int b43_generate_txhdr(struct b43_wldev 
 		struct b43_plcp_hdr6 *plcp;
 		struct ieee80211_rate *rts_cts_rate;
 
-		rts_cts_rate = ieee80211_get_rts_cts_rate(dev->wl->hw, txctl);
+		rts_cts_rate = ieee80211_get_rts_cts_rate(dev->wl->hw, info);
 
 		rts_rate = rts_cts_rate ? rts_cts_rate->hw_value : B43_CCK_RATE_1MB;
 		rts_rate_ofdm = b43_is_ofdm_rate(rts_rate);
 		rts_rate_fb = b43_calc_fallback_rate(rts_rate);
 		rts_rate_fb_ofdm = b43_is_ofdm_rate(rts_rate_fb);
 
-		if (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
+		if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT) {
 			struct ieee80211_cts *cts;
 
 			if (b43_is_old_txhdr_format(dev)) {
@@ -356,9 +354,9 @@ int b43_generate_txhdr(struct b43_wldev 
 				cts = (struct ieee80211_cts *)
 					(txhdr->new_format.rts_frame);
 			}
-			ieee80211_ctstoself_get(dev->wl->hw, txctl->vif,
+			ieee80211_ctstoself_get(dev->wl->hw, info->control.vif,
 						fragment_data, fragment_len,
-						txctl, cts);
+						info, cts);
 			mac_ctl |= B43_TXH_MAC_SENDCTS;
 			len = sizeof(struct ieee80211_cts);
 		} else {
@@ -371,9 +369,9 @@ int b43_generate_txhdr(struct b43_wldev 
 				rts = (struct ieee80211_rts *)
 					(txhdr->new_format.rts_frame);
 			}
-			ieee80211_rts_get(dev->wl->hw, txctl->vif,
+			ieee80211_rts_get(dev->wl->hw, info->control.vif,
 					  fragment_data, fragment_len,
-					  txctl, rts);
+					  info, rts);
 			mac_ctl |= B43_TXH_MAC_SENDRTS;
 			len = sizeof(struct ieee80211_rts);
 		}
@@ -688,27 +686,27 @@ void b43_handle_txstatus(struct b43_wlde
 /* Fill out the mac80211 TXstatus report based on the b43-specific
  * txstatus report data. This returns a boolean whether the frame was
  * successfully transmitted. */
-bool b43_fill_txstatus_report(struct ieee80211_tx_status *report,
+bool b43_fill_txstatus_report(struct ieee80211_tx_info *report,
 			      const struct b43_txstatus *status)
 {
 	bool frame_success = 1;
 
 	if (status->acked) {
 		/* The frame was ACKed. */
-		report->flags |= IEEE80211_TX_STATUS_ACK;
+		report->flags |= IEEE80211_TX_STAT_ACK;
 	} else {
 		/* The frame was not ACKed... */
-		if (!(report->control.flags & IEEE80211_TXCTL_NO_ACK)) {
+		if (!(report->flags & IEEE80211_TX_CTL_NO_ACK)) {
 			/* ...but we expected an ACK. */
 			frame_success = 0;
-			report->excessive_retries = 1;
+			report->status.excessive_retries = 1;
 		}
 	}
 	if (status->frame_count == 0) {
 		/* The frame was not transmitted at all. */
-		report->retry_count = 0;
+		report->status.retry_count = 0;
 	} else
-		report->retry_count = status->frame_count - 1;
+		report->status.retry_count = status->frame_count - 1;
 
 	return frame_success;
 }
--- everything.orig/drivers/net/wireless/b43/xmit.h	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/b43/xmit.h	2008-05-11 00:05:16.000000000 +0200
@@ -178,7 +178,7 @@ int b43_generate_txhdr(struct b43_wldev 
 		       u8 * txhdr,
 		       const unsigned char *fragment_data,
 		       unsigned int fragment_len,
-		       const struct ieee80211_tx_control *txctl, u16 cookie);
+		       const struct ieee80211_tx_info *txctl, u16 cookie);
 
 /* Transmit Status */
 struct b43_txstatus {
@@ -294,7 +294,7 @@ void b43_rx(struct b43_wldev *dev, struc
 
 void b43_handle_txstatus(struct b43_wldev *dev,
 			 const struct b43_txstatus *status);
-bool b43_fill_txstatus_report(struct ieee80211_tx_status *report,
+bool b43_fill_txstatus_report(struct ieee80211_tx_info *report,
 			      const struct b43_txstatus *status);
 
 void b43_tx_suspend(struct b43_wldev *dev);
--- everything.orig/drivers/net/wireless/adm8211.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/adm8211.c	2008-05-11 00:05:16.000000000 +0200
@@ -324,7 +324,7 @@ static void adm8211_interrupt_tci(struct
 	for (dirty_tx = priv->dirty_tx; priv->cur_tx - dirty_tx; dirty_tx++) {
 		unsigned int entry = dirty_tx % priv->tx_ring_size;
 		u32 status = le32_to_cpu(priv->tx_ring[entry].status);
-		struct ieee80211_tx_status tx_status;
+		struct ieee80211_tx_info *txi;
 		struct adm8211_tx_ring_info *info;
 		struct sk_buff *skb;
 
@@ -334,24 +334,23 @@ static void adm8211_interrupt_tci(struct
 
 		info = &priv->tx_buffers[entry];
 		skb = info->skb;
+		txi = (void *)skb->cb;
 
 		/* TODO: check TDES0_STATUS_TUF and TDES0_STATUS_TRO */
 
 		pci_unmap_single(priv->pdev, info->mapping,
 				 info->skb->len, PCI_DMA_TODEVICE);
 
-		memset(&tx_status, 0, sizeof(tx_status));
+		memset(&txi->status, 0, sizeof(txi->status));
 		skb_pull(skb, sizeof(struct adm8211_tx_hdr));
 		memcpy(skb_push(skb, info->hdrlen), skb->cb, info->hdrlen);
-		memcpy(&tx_status.control, &info->tx_control,
-		       sizeof(tx_status.control));
-		if (!(tx_status.control.flags & IEEE80211_TXCTL_NO_ACK)) {
+		if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK)) {
 			if (status & TDES0_STATUS_ES)
-				tx_status.excessive_retries = 1;
+				txi->status.excessive_retries = 1;
 			else
-				tx_status.flags |= IEEE80211_TX_STATUS_ACK;
+				txi->flags |= IEEE80211_TX_STAT_ACK;
 		}
-		ieee80211_tx_status_irqsafe(dev, skb, &tx_status);
+		ieee80211_tx_status_irqsafe(dev, skb);
 
 		info->skb = NULL;
 	}
@@ -1638,7 +1637,6 @@ static void adm8211_calc_durations(int *
 /* Transmit skb w/adm8211_tx_hdr (802.11 header created by hardware) */
 static void adm8211_tx_raw(struct ieee80211_hw *dev, struct sk_buff *skb,
 			   u16 plcp_signal,
-			   struct ieee80211_tx_control *control,
 			   size_t hdrlen)
 {
 	struct adm8211_priv *priv = dev->priv;
@@ -1664,7 +1662,6 @@ static void adm8211_tx_raw(struct ieee80
 
 	priv->tx_buffers[entry].skb = skb;
 	priv->tx_buffers[entry].mapping = mapping;
-	memcpy(&priv->tx_buffers[entry].tx_control, control, sizeof(*control));
 	priv->tx_buffers[entry].hdrlen = hdrlen;
 	priv->tx_ring[entry].buffer1 = cpu_to_le32(mapping);
 
@@ -1685,17 +1682,17 @@ static void adm8211_tx_raw(struct ieee80
 }
 
 /* Put adm8211_tx_hdr on skb and transmit */
-static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
-		      struct ieee80211_tx_control *control)
+static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct adm8211_tx_hdr *txhdr;
 	u16 fc;
 	size_t payload_len, hdrlen;
 	int plcp, dur, len, plcp_signal, short_preamble;
 	struct ieee80211_hdr *hdr;
-	struct ieee80211_rate *txrate = ieee80211_get_tx_rate(dev, control);
+	struct ieee80211_tx_info *info = (void *)skb->cb;
+	struct ieee80211_rate *txrate = ieee80211_get_tx_rate(dev, info);
 
-	short_preamble = !!(txrate->flags & IEEE80211_TXCTL_SHORT_PREAMBLE);
+	short_preamble = !!(txrate->flags & IEEE80211_TX_CTL_SHORT_PREAMBLE);
 	plcp_signal = txrate->bitrate;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -1730,15 +1727,15 @@ static int adm8211_tx(struct ieee80211_h
 	if (short_preamble)
 		txhdr->header_control |= cpu_to_le16(ADM8211_TXHDRCTL_SHORT_PREAMBLE);
 
-	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
+	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS)
 		txhdr->header_control |= cpu_to_le16(ADM8211_TXHDRCTL_ENABLE_RTS);
 
 	if (fc & IEEE80211_FCTL_PROTECTED)
 		txhdr->header_control |= cpu_to_le16(ADM8211_TXHDRCTL_ENABLE_WEP_ENGINE);
 
-	txhdr->retry_limit = control->retry_limit;
+	txhdr->retry_limit = info->control.retry_limit;
 
-	adm8211_tx_raw(dev, skb, plcp_signal, control, hdrlen);
+	adm8211_tx_raw(dev, skb, plcp_signal, hdrlen);
 
 	return NETDEV_TX_OK;
 }
--- everything.orig/drivers/net/wireless/adm8211.h	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/adm8211.h	2008-05-11 00:05:16.000000000 +0200
@@ -443,7 +443,6 @@ struct adm8211_rx_ring_info {
 struct adm8211_tx_ring_info {
 	struct sk_buff *skb;
 	dma_addr_t mapping;
-	struct ieee80211_tx_control tx_control;
 	size_t hdrlen;
 };
 
--- everything.orig/drivers/net/wireless/at76_usb.h	2008-05-11 00:02:06.000000000 +0200
+++ everything/drivers/net/wireless/at76_usb.h	2008-05-11 00:05:16.000000000 +0200
@@ -441,7 +441,6 @@ struct at76_priv {
 	int beacon_period;	/* period of mgmt beacons, Kus */
 
 	struct ieee80211_hw *hw;
-	struct ieee80211_tx_status tx_status;
 	int mac80211_registered;
 };
 
--- everything.orig/drivers/net/wireless/b43legacy/dma.c	2008-05-11 00:02:06.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/dma.c	2008-05-11 00:05:16.000000000 +0200
@@ -1205,10 +1205,10 @@ struct b43legacy_dmaring *parse_cookie(s
 }
 
 static int dma_tx_fragment(struct b43legacy_dmaring *ring,
-			    struct sk_buff *skb,
-			    struct ieee80211_tx_control *ctl)
+			    struct sk_buff *skb)
 {
 	const struct b43legacy_dma_ops *ops = ring->ops;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	u8 *header;
 	int slot, old_top_slot, old_used_slots;
 	int err;
@@ -1231,7 +1231,7 @@ static int dma_tx_fragment(struct b43leg
 	header = &(ring->txhdr_cache[slot * sizeof(
 			       struct b43legacy_txhdr_fw3)]);
 	err = b43legacy_generate_txhdr(ring->dev, header,
-				 skb->data, skb->len, ctl,
+				 skb->data, skb->len, info,
 				 generate_cookie(ring, slot));
 	if (unlikely(err)) {
 		ring->current_slot = old_top_slot;
@@ -1255,7 +1255,6 @@ static int dma_tx_fragment(struct b43leg
 	desc = ops->idx2desc(ring, slot, &meta);
 	memset(meta, 0, sizeof(*meta));
 
-	memcpy(&meta->txstat.control, ctl, sizeof(*ctl));
 	meta->skb = skb;
 	meta->is_last_fragment = 1;
 
@@ -1323,14 +1322,14 @@ int should_inject_overflow(struct b43leg
 }
 
 int b43legacy_dma_tx(struct b43legacy_wldev *dev,
-		     struct sk_buff *skb,
-		     struct ieee80211_tx_control *ctl)
+		     struct sk_buff *skb)
 {
 	struct b43legacy_dmaring *ring;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	int err = 0;
 	unsigned long flags;
 
-	ring = priority_to_txring(dev, ctl->queue);
+	ring = priority_to_txring(dev, info->queue);
 	spin_lock_irqsave(&ring->lock, flags);
 	B43legacy_WARN_ON(!ring->tx);
 	if (unlikely(free_slots(ring) < SLOTS_PER_PACKET)) {
@@ -1343,7 +1342,7 @@ int b43legacy_dma_tx(struct b43legacy_wl
 	 * That would be a mac80211 bug. */
 	B43legacy_BUG_ON(ring->stopped);
 
-	err = dma_tx_fragment(ring, skb, ctl);
+	err = dma_tx_fragment(ring, skb);
 	if (unlikely(err == -ENOKEY)) {
 		/* Drop this packet, as we don't have the encryption key
 		 * anymore and must not transmit it unencrypted. */
@@ -1401,26 +1400,29 @@ void b43legacy_dma_handle_txstatus(struc
 					 1);
 
 		if (meta->is_last_fragment) {
-			B43legacy_WARN_ON(!meta->skb);
+			struct ieee80211_tx_info *info;
+			BUG_ON(!meta->skb);
+			info = (void *)meta->skb->cb;
 			/* Call back to inform the ieee80211 subsystem about the
 			 * status of the transmission.
 			 * Some fields of txstat are already filled in dma_tx().
 			 */
+
+			memset(&info->status, 0, sizeof(info->status));
+
 			if (status->acked) {
-				meta->txstat.flags |= IEEE80211_TX_STATUS_ACK;
+				info->flags |= IEEE80211_TX_STAT_ACK;
 			} else {
-				if (!(meta->txstat.control.flags
-				      & IEEE80211_TXCTL_NO_ACK))
-					 meta->txstat.excessive_retries = 1;
+				if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
+					 info->status.excessive_retries = 1;
 			}
 			if (status->frame_count == 0) {
 				/* The frame was not transmitted at all. */
-				meta->txstat.retry_count = 0;
+				info->status.retry_count = 0;
 			} else
-				meta->txstat.retry_count = status->frame_count
+				info->status.retry_count = status->frame_count
 							   - 1;
-			ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb,
-						    &(meta->txstat));
+			ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb);
 			/* skb is freed by ieee80211_tx_status_irqsafe() */
 			meta->skb = NULL;
 		} else {
--- everything.orig/drivers/net/wireless/b43legacy/dma.h	2008-05-11 00:02:06.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/dma.h	2008-05-11 00:05:16.000000000 +0200
@@ -195,7 +195,6 @@ struct b43legacy_dmadesc_meta {
 	dma_addr_t dmaaddr;
 	/* ieee80211 TX status. Only used once per 802.11 frag. */
 	bool is_last_fragment;
-	struct ieee80211_tx_status txstat;
 };
 
 struct b43legacy_dmaring;
@@ -297,8 +296,7 @@ void b43legacy_dma_get_tx_stats(struct b
 				struct ieee80211_tx_queue_stats *stats);
 
 int b43legacy_dma_tx(struct b43legacy_wldev *dev,
-		     struct sk_buff *skb,
-		     struct ieee80211_tx_control *ctl);
+		     struct sk_buff *skb);
 void b43legacy_dma_handle_txstatus(struct b43legacy_wldev *dev,
 				   const struct b43legacy_txstatus *status);
 
--- everything.orig/drivers/net/wireless/b43legacy/main.c	2008-05-11 00:02:06.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/main.c	2008-05-11 00:05:16.000000000 +0200
@@ -2358,8 +2358,7 @@ static int b43legacy_rng_init(struct b43
 }
 
 static int b43legacy_op_tx(struct ieee80211_hw *hw,
-			   struct sk_buff *skb,
-			   struct ieee80211_tx_control *ctl)
+			   struct sk_buff *skb)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
@@ -2373,10 +2372,10 @@ static int b43legacy_op_tx(struct ieee80
 	/* DMA-TX is done without a global lock. */
 	if (b43legacy_using_pio(dev)) {
 		spin_lock_irqsave(&wl->irq_lock, flags);
-		err = b43legacy_pio_tx(dev, skb, ctl);
+		err = b43legacy_pio_tx(dev, skb);
 		spin_unlock_irqrestore(&wl->irq_lock, flags);
 	} else
-		err = b43legacy_dma_tx(dev, skb, ctl);
+		err = b43legacy_dma_tx(dev, skb);
 out:
 	if (unlikely(err))
 		return NETDEV_TX_BUSY;
@@ -3409,7 +3408,7 @@ static int b43legacy_op_beacon_set_tim(s
 	 * field, but that would probably require resizing and moving of data
 	 * within the beacon template. Simply request a new beacon and let
 	 * mac80211 do the hard work. */
-	beacon = ieee80211_beacon_get(hw, wl->vif, NULL);
+	beacon = ieee80211_beacon_get(hw, wl->vif);
 	if (unlikely(!beacon))
 		return -ENOMEM;
 	spin_lock_irqsave(&wl->irq_lock, flags);
@@ -3420,8 +3419,7 @@ static int b43legacy_op_beacon_set_tim(s
 }
 
 static int b43legacy_op_ibss_beacon_update(struct ieee80211_hw *hw,
-					   struct sk_buff *beacon,
-					   struct ieee80211_tx_control *ctl)
+					   struct sk_buff *beacon)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	unsigned long flags;
--- everything.orig/drivers/net/wireless/b43legacy/pio.c	2008-05-11 00:02:06.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/pio.c	2008-05-11 00:05:16.000000000 +0200
@@ -196,7 +196,7 @@ static int pio_tx_write_fragment(struct 
 	B43legacy_WARN_ON(skb_shinfo(skb)->nr_frags != 0);
 	err = b43legacy_generate_txhdr(queue->dev,
 				 txhdr, skb->data, skb->len,
-				 &packet->txstat.control,
+				 (void *)skb->cb,
 				 generate_cookie(queue, packet));
 	if (err)
 		return err;
@@ -463,8 +463,7 @@ err_destroy0:
 }
 
 int b43legacy_pio_tx(struct b43legacy_wldev *dev,
-		     struct sk_buff *skb,
-		     struct ieee80211_tx_control *ctl)
+		     struct sk_buff *skb)
 {
 	struct b43legacy_pioqueue *queue = dev->pio.queue1;
 	struct b43legacy_pio_txpacket *packet;
@@ -476,9 +475,6 @@ int b43legacy_pio_tx(struct b43legacy_wl
 			    list);
 	packet->skb = skb;
 
-	memset(&packet->txstat, 0, sizeof(packet->txstat));
-	memcpy(&packet->txstat.control, ctl, sizeof(*ctl));
-
 	list_move_tail(&packet->list, &queue->txqueue);
 	queue->nr_txfree--;
 	queue->nr_tx_packets++;
@@ -494,6 +490,7 @@ void b43legacy_pio_handle_txstatus(struc
 {
 	struct b43legacy_pioqueue *queue;
 	struct b43legacy_pio_txpacket *packet;
+	struct ieee80211_tx_info *info;
 
 	queue = parse_cookie(dev, status->cookie, &packet);
 	B43legacy_WARN_ON(!queue);
@@ -505,11 +502,13 @@ void b43legacy_pio_handle_txstatus(struc
 	queue->tx_devq_used -= (packet->skb->len +
 				sizeof(struct b43legacy_txhdr_fw3));
 
+	info = (void *)packet->skb->cb;
+	memset(&info->status, 0, sizeof(info->status));
+
 	if (status->acked)
-		packet->txstat.flags |= IEEE80211_TX_STATUS_ACK;
-	packet->txstat.retry_count = status->frame_count - 1;
-	ieee80211_tx_status_irqsafe(dev->wl->hw, packet->skb,
-				    &(packet->txstat));
+		info->flags |= IEEE80211_TX_STAT_ACK;
+	info->status.retry_count = status->frame_count - 1;
+	ieee80211_tx_status_irqsafe(dev->wl->hw, packet->skb);
 	packet->skb = NULL;
 
 	free_txpacket(packet, 1);
--- everything.orig/drivers/net/wireless/b43legacy/pio.h	2008-05-11 00:02:06.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/pio.h	2008-05-11 00:05:16.000000000 +0200
@@ -41,7 +41,6 @@ struct b43legacy_xmitstatus;
 struct b43legacy_pio_txpacket {
 	struct b43legacy_pioqueue *queue;
 	struct sk_buff *skb;
-	struct ieee80211_tx_status txstat;
 	struct list_head list;
 };
 
@@ -104,8 +103,7 @@ int b43legacy_pio_init(struct b43legacy_
 void b43legacy_pio_free(struct b43legacy_wldev *dev);
 
 int b43legacy_pio_tx(struct b43legacy_wldev *dev,
-		   struct sk_buff *skb,
-		   struct ieee80211_tx_control *ctl);
+		   struct sk_buff *skb);
 void b43legacy_pio_handle_txstatus(struct b43legacy_wldev *dev,
 				 const struct b43legacy_txstatus *status);
 void b43legacy_pio_get_tx_stats(struct b43legacy_wldev *dev,
--- everything.orig/drivers/net/wireless/b43legacy/xmit.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/xmit.c	2008-05-11 00:05:16.000000000 +0200
@@ -188,11 +188,11 @@ static int generate_txhdr_fw3(struct b43
 			       struct b43legacy_txhdr_fw3 *txhdr,
 			       const unsigned char *fragment_data,
 			       unsigned int fragment_len,
-			       const struct ieee80211_tx_control *txctl,
+			       const struct ieee80211_tx_info *info,
 			       u16 cookie)
 {
 	const struct ieee80211_hdr *wlhdr;
-	int use_encryption = (!(txctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT));
+	int use_encryption = (!(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT));
 	u16 fctl;
 	u8 rate;
 	struct ieee80211_rate *rate_fb;
@@ -208,11 +208,11 @@ static int generate_txhdr_fw3(struct b43
 
 	memset(txhdr, 0, sizeof(*txhdr));
 
-	tx_rate = ieee80211_get_tx_rate(dev->wl->hw, txctl);
+	tx_rate = ieee80211_get_tx_rate(dev->wl->hw, info);
 
 	rate = tx_rate->hw_value;
 	rate_ofdm = b43legacy_is_ofdm_rate(rate);
-	rate_fb = ieee80211_get_alt_retry_rate(dev->wl->hw, txctl) ? : tx_rate;
+	rate_fb = ieee80211_get_alt_retry_rate(dev->wl->hw, info) ? : tx_rate;
 	rate_fb_ofdm = b43legacy_is_ofdm_rate(rate_fb->hw_value);
 
 	txhdr->mac_frame_ctl = wlhdr->frame_control;
@@ -228,14 +228,14 @@ static int generate_txhdr_fw3(struct b43
 		txhdr->dur_fb = wlhdr->duration_id;
 	} else {
 		txhdr->dur_fb = ieee80211_generic_frame_duration(dev->wl->hw,
-							 txctl->vif,
+							 info->control.vif,
 							 fragment_len,
 							 rate_fb);
 	}
 
 	plcp_fragment_len = fragment_len + FCS_LEN;
 	if (use_encryption) {
-		u8 key_idx = txctl->hw_key->hw_key_idx;
+		u8 key_idx = info->control.hw_key->hw_key_idx;
 		struct b43legacy_key *key;
 		int wlhdr_len;
 		size_t iv_len;
@@ -245,7 +245,7 @@ static int generate_txhdr_fw3(struct b43
 
 		if (key->enabled) {
 			/* Hardware appends ICV. */
-			plcp_fragment_len += txctl->icv_len;
+			plcp_fragment_len += info->control.icv_len;
 
 			key_idx = b43legacy_kidx_to_fw(dev, key_idx);
 			mac_ctl |= (key_idx << B43legacy_TX4_MAC_KEYIDX_SHIFT) &
@@ -254,7 +254,7 @@ static int generate_txhdr_fw3(struct b43
 				   B43legacy_TX4_MAC_KEYALG_SHIFT) &
 				   B43legacy_TX4_MAC_KEYALG;
 			wlhdr_len = ieee80211_get_hdrlen(fctl);
-			iv_len = min((size_t)txctl->iv_len,
+			iv_len = min((size_t)info->control.iv_len,
 				     ARRAY_SIZE(txhdr->iv));
 			memcpy(txhdr->iv, ((u8 *)wlhdr) + wlhdr_len, iv_len);
 		} else {
@@ -278,7 +278,7 @@ static int generate_txhdr_fw3(struct b43
 		phy_ctl |= B43legacy_TX4_PHY_OFDM;
 	if (dev->short_preamble)
 		phy_ctl |= B43legacy_TX4_PHY_SHORTPRMBL;
-	switch (txctl->antenna_sel_tx) {
+	switch (info->antenna_sel_tx) {
 	case 0:
 		phy_ctl |= B43legacy_TX4_PHY_ANTLAST;
 		break;
@@ -293,21 +293,21 @@ static int generate_txhdr_fw3(struct b43
 	}
 
 	/* MAC control */
-	if (!(txctl->flags & IEEE80211_TXCTL_NO_ACK))
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		mac_ctl |= B43legacy_TX4_MAC_ACK;
 	if (!(((fctl & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
 	      ((fctl & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)))
 		mac_ctl |= B43legacy_TX4_MAC_HWSEQ;
-	if (txctl->flags & IEEE80211_TXCTL_FIRST_FRAGMENT)
+	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 		mac_ctl |= B43legacy_TX4_MAC_STMSDU;
 	if (rate_fb_ofdm)
 		mac_ctl |= B43legacy_TX4_MAC_FALLBACKOFDM;
-	if (txctl->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT)
+	if (info->flags & IEEE80211_TX_CTL_LONG_RETRY_LIMIT)
 		mac_ctl |= B43legacy_TX4_MAC_LONGFRAME;
 
 	/* Generate the RTS or CTS-to-self frame */
-	if ((txctl->flags & IEEE80211_TXCTL_USE_RTS_CTS) ||
-	    (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)) {
+	if ((info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) ||
+	    (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)) {
 		unsigned int len;
 		struct ieee80211_hdr *hdr;
 		int rts_rate;
@@ -315,26 +315,26 @@ static int generate_txhdr_fw3(struct b43
 		int rts_rate_ofdm;
 		int rts_rate_fb_ofdm;
 
-		rts_rate = ieee80211_get_rts_cts_rate(dev->wl->hw, txctl)->hw_value;
+		rts_rate = ieee80211_get_rts_cts_rate(dev->wl->hw, info)->hw_value;
 		rts_rate_ofdm = b43legacy_is_ofdm_rate(rts_rate);
 		rts_rate_fb = b43legacy_calc_fallback_rate(rts_rate);
 		rts_rate_fb_ofdm = b43legacy_is_ofdm_rate(rts_rate_fb);
 		if (rts_rate_fb_ofdm)
 			mac_ctl |= B43legacy_TX4_MAC_CTSFALLBACKOFDM;
 
-		if (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
+		if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT) {
 			ieee80211_ctstoself_get(dev->wl->hw,
-						txctl->vif,
+						info->control.vif,
 						fragment_data,
-						fragment_len, txctl,
+						fragment_len, info,
 						(struct ieee80211_cts *)
 						(txhdr->rts_frame));
 			mac_ctl |= B43legacy_TX4_MAC_SENDCTS;
 			len = sizeof(struct ieee80211_cts);
 		} else {
 			ieee80211_rts_get(dev->wl->hw,
-					  txctl->vif,
-					  fragment_data, fragment_len, txctl,
+					  info->control.vif,
+					  fragment_data, fragment_len, info,
 					  (struct ieee80211_rts *)
 					  (txhdr->rts_frame));
 			mac_ctl |= B43legacy_TX4_MAC_SENDRTS;
@@ -365,12 +365,12 @@ int b43legacy_generate_txhdr(struct b43l
 			      u8 *txhdr,
 			      const unsigned char *fragment_data,
 			      unsigned int fragment_len,
-			      const struct ieee80211_tx_control *txctl,
+			      const struct ieee80211_tx_info *info,
 			      u16 cookie)
 {
 	return generate_txhdr_fw3(dev, (struct b43legacy_txhdr_fw3 *)txhdr,
 			   fragment_data, fragment_len,
-			   txctl, cookie);
+			   info, cookie);
 }
 
 static s8 b43legacy_rssi_postprocess(struct b43legacy_wldev *dev,
--- everything.orig/drivers/net/wireless/b43legacy/xmit.h	2008-05-11 00:02:06.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/xmit.h	2008-05-11 00:05:16.000000000 +0200
@@ -80,7 +80,7 @@ int b43legacy_generate_txhdr(struct b43l
 			      u8 *txhdr,
 			      const unsigned char *fragment_data,
 			      unsigned int fragment_len,
-			      const struct ieee80211_tx_control *txctl,
+			      const struct ieee80211_tx_info *info,
 			      u16 cookie);
 
 
--- everything.orig/drivers/net/wireless/p54/p54common.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54common.c	2008-05-11 00:05:16.000000000 +0200
@@ -394,7 +394,7 @@ static void p54_rx_frame_sent(struct iee
 	while (entry != (struct sk_buff *)&priv->tx_queue) {
 		range = (struct memrecord *)&entry->cb;
 		if (range->start_addr == addr) {
-			struct ieee80211_tx_status status;
+			struct ieee80211_tx_info *info = (void *)entry->cb;
 			struct p54_control_hdr *entry_hdr;
 			struct p54_tx_control_allocdata *entry_data;
 			int pad = 0;
@@ -406,30 +406,23 @@ static void p54_rx_frame_sent(struct iee
 
 			last_addr = range->end_addr;
 			__skb_unlink(entry, &priv->tx_queue);
-			if (!range->control) {
-				kfree_skb(entry);
-				break;
-			}
-			memset(&status, 0, sizeof(status));
-			memcpy(&status.control, range->control,
-			       sizeof(status.control));
-			kfree(range->control);
-			priv->tx_stats[status.control.queue].len--;
+			memset(&info->status, 0, sizeof(info->status));
+			priv->tx_stats[info->queue].len--;
 			entry_hdr = (struct p54_control_hdr *) entry->data;
 			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
 			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
 				pad = entry_data->align[0];
 
-			if (!(status.control.flags & IEEE80211_TXCTL_NO_ACK)) {
+			if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 				if (!(payload->status & 0x01))
-					status.flags |= IEEE80211_TX_STATUS_ACK;
+					info->flags |= IEEE80211_TX_STAT_ACK;
 				else
-					status.excessive_retries = 1;
+					info->status.excessive_retries = 1;
 			}
-			status.retry_count = payload->retries - 1;
-			status.ack_signal = le16_to_cpu(payload->ack_rssi);
+			info->status.retry_count = payload->retries - 1;
+			info->status.ack_signal = le16_to_cpu(payload->ack_rssi);
 			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
-			ieee80211_tx_status_irqsafe(dev, entry, &status);
+			ieee80211_tx_status_irqsafe(dev, entry);
 			break;
 		} else
 			last_addr = range->end_addr;
@@ -494,13 +487,11 @@ EXPORT_SYMBOL_GPL(p54_rx);
  * allocated areas.
  */
 static void p54_assign_address(struct ieee80211_hw *dev, struct sk_buff *skb,
-			       struct p54_control_hdr *data, u32 len,
-			       struct ieee80211_tx_control *control)
+			       struct p54_control_hdr *data, u32 len)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *entry = priv->tx_queue.next;
 	struct sk_buff *target_skb = NULL;
-	struct memrecord *range;
 	u32 last_addr = priv->rx_start;
 	u32 largest_hole = 0;
 	u32 target_addr = priv->rx_start;
@@ -512,7 +503,8 @@ static void p54_assign_address(struct ie
 	left = skb_queue_len(&priv->tx_queue);
 	while (left--) {
 		u32 hole_size;
-		range = (struct memrecord *)&entry->cb;
+		struct ieee80211_tx_info *info = (void *)entry->cb;
+		struct memrecord *range = (void *)info->driver_data;
 		hole_size = range->start_addr - last_addr;
 		if (!target_skb && hole_size >= len) {
 			target_skb = entry->prev;
@@ -527,17 +519,18 @@ static void p54_assign_address(struct ie
 		target_skb = priv->tx_queue.prev;
 		largest_hole = max(largest_hole, priv->rx_end - last_addr - len);
 		if (!skb_queue_empty(&priv->tx_queue)) {
-			range = (struct memrecord *)&target_skb->cb;
+			struct ieee80211_tx_info *info = (void *)target_skb->cb;
+			struct memrecord *range = (void *)info->driver_data;
 			target_addr = range->end_addr;
 		}
 	} else
 		largest_hole = max(largest_hole, priv->rx_end - last_addr);
 
 	if (skb) {
-		range = (struct memrecord *)&skb->cb;
+		struct ieee80211_tx_info *info = (void *)skb->cb;
+		struct memrecord *range = (void *)info->driver_data;
 		range->start_addr = target_addr;
 		range->end_addr = target_addr + len;
-		range->control = control;
 		__skb_queue_after(&priv->tx_queue, target_skb, skb);
 		if (largest_hole < IEEE80211_MAX_RTS_THRESHOLD + 0x170 +
 				   sizeof(struct p54_control_hdr))
@@ -548,32 +541,27 @@ static void p54_assign_address(struct ie
 	data->req_id = cpu_to_le32(target_addr + 0x70);
 }
 
-static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
-		  struct ieee80211_tx_control *control)
+static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	struct ieee80211_tx_queue_stats *current_queue;
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_allocdata *txhdr;
-	struct ieee80211_tx_control *control_copy;
 	size_t padding, len;
 	u8 rate;
 
-	current_queue = &priv->tx_stats[control->queue];
+	current_queue = &priv->tx_stats[info->queue];
 	if (unlikely(current_queue->len > current_queue->limit))
 		return NETDEV_TX_BUSY;
 	current_queue->len++;
 	current_queue->count++;
 	if (current_queue->len == current_queue->limit)
-		ieee80211_stop_queue(dev, control->queue);
+		ieee80211_stop_queue(dev, info->queue);
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
 
-	control_copy = kmalloc(sizeof(*control), GFP_ATOMIC);
-	if (control_copy)
-		memcpy(control_copy, control, sizeof(*control));
-
 	txhdr = (struct p54_tx_control_allocdata *)
 			skb_push(skb, sizeof(*txhdr) + padding);
 	hdr = (struct p54_control_hdr *) skb_push(skb, sizeof(*hdr));
@@ -583,35 +571,37 @@ static int p54_tx(struct ieee80211_hw *d
 	else
 		hdr->magic1 = cpu_to_le16(0x0010);
 	hdr->len = cpu_to_le16(len);
-	hdr->type = (control->flags & IEEE80211_TXCTL_NO_ACK) ? 0 : cpu_to_le16(1);
-	hdr->retry1 = hdr->retry2 = control->retry_limit;
-	p54_assign_address(dev, skb, hdr, skb->len, control_copy);
+	hdr->type = (info->flags & IEEE80211_TX_CTL_NO_ACK) ? 0 : cpu_to_le16(1);
+	hdr->retry1 = hdr->retry2 = info->control.retry_limit;
 
 	memset(txhdr->wep_key, 0x0, 16);
 	txhdr->padding = 0;
 	txhdr->padding2 = 0;
 
 	/* TODO: add support for alternate retry TX rates */
-	rate = ieee80211_get_tx_rate(dev, control)->hw_value;
-	if (control->flags & IEEE80211_TXCTL_SHORT_PREAMBLE)
+	rate = ieee80211_get_tx_rate(dev, info)->hw_value;
+	if (info->flags & IEEE80211_TX_CTL_SHORT_PREAMBLE)
 		rate |= 0x10;
-	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
+	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS)
 		rate |= 0x40;
-	else if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
+	else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
 		rate |= 0x20;
 	memset(txhdr->rateset, rate, 8);
 	txhdr->wep_key_present = 0;
 	txhdr->wep_key_len = 0;
-	txhdr->frame_type = cpu_to_le32(control->queue + 4);
+	txhdr->frame_type = cpu_to_le32(info->queue + 4);
 	txhdr->magic4 = 0;
-	txhdr->antenna = (control->antenna_sel_tx == 0) ?
-		2 : control->antenna_sel_tx - 1;
+	txhdr->antenna = (info->antenna_sel_tx == 0) ?
+		2 : info->antenna_sel_tx - 1;
 	txhdr->output_power = 0x7f; // HW Maximum
-	txhdr->magic5 = (control->flags & IEEE80211_TXCTL_NO_ACK) ?
+	txhdr->magic5 = (info->flags & IEEE80211_TX_CTL_NO_ACK) ?
 		0 : ((rate > 0x3) ? cpu_to_le32(0x33) : cpu_to_le32(0x23));
 	if (padding)
 		txhdr->align[0] = padding;
 
+	/* modifies skb->cb and with it info, so must be last! */
+	p54_assign_address(dev, skb, hdr, skb->len);
+
 	priv->tx(dev, hdr, skb->len, 0);
 	return 0;
 }
@@ -634,7 +624,7 @@ static int p54_set_filter(struct ieee802
 	filter = (struct p54_tx_control_filter *) hdr->data;
 	hdr->magic1 = cpu_to_le16(0x8001);
 	hdr->len = cpu_to_le16(sizeof(*filter));
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*filter), NULL);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*filter));
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_FILTER_SET);
 
 	filter->filter_type = cpu_to_le16(filter_type);
@@ -678,7 +668,7 @@ static int p54_set_freq(struct ieee80211
 	hdr->magic1 = cpu_to_le16(0x8001);
 	hdr->len = cpu_to_le16(sizeof(*chan));
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_CHANNEL_CHANGE);
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + payload_len, NULL);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + payload_len);
 
 	chan->magic1 = cpu_to_le16(0x1);
 	chan->magic2 = cpu_to_le16(0x0);
@@ -751,7 +741,7 @@ static int p54_set_leds(struct ieee80211
 	hdr->magic1 = cpu_to_le16(0x8001);
 	hdr->len = cpu_to_le16(sizeof(*led));
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_LED);
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*led), NULL);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*led));
 
 	led = (struct p54_tx_control_led *) hdr->data;
 	led->mode = cpu_to_le16(mode);
@@ -801,7 +791,7 @@ static void p54_set_vdcf(struct ieee8021
 
 	hdr = (void *)priv->cached_vdcf + priv->tx_hdr_len;
 
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*vdcf), NULL);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*vdcf));
 
 	vdcf = (struct p54_tx_control_vdcf *) hdr->data;
 
@@ -837,12 +827,8 @@ static void p54_stop(struct ieee80211_hw
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
-	while ((skb = skb_dequeue(&priv->tx_queue))) {
-		struct memrecord *range = (struct memrecord *)&skb->cb;
-		if (range->control)
-			kfree(range->control);
+	while ((skb = skb_dequeue(&priv->tx_queue)))
 		kfree_skb(skb);
-	}
 	priv->stop(dev);
 	priv->mode = IEEE80211_IF_TYPE_INVALID;
 }
--- everything.orig/drivers/net/wireless/p54/p54common.h	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54common.h	2008-05-11 00:05:16.000000000 +0200
@@ -152,7 +152,6 @@ struct pda_pa_curve_data {
 struct memrecord {
 	u32 start_addr;
 	u32 end_addr;
-	struct ieee80211_tx_control *control;
 };
 
 struct p54_eeprom_lm86 {
--- everything.orig/drivers/net/wireless/rtl8187.h	2008-05-11 00:02:06.000000000 +0200
+++ everything/drivers/net/wireless/rtl8187.h	2008-05-11 00:05:16.000000000 +0200
@@ -44,12 +44,6 @@ struct rtl8187_rx_hdr {
 	__le64 mac_time;
 } __attribute__((packed));
 
-struct rtl8187_tx_info {
-	struct ieee80211_tx_control *control;
-	struct urb *urb;
-	struct ieee80211_hw *dev;
-};
-
 struct rtl8187_tx_hdr {
 	__le32 flags;
 #define RTL8187_TX_FLAG_NO_ENCRYPT	(1 << 15)
--- everything.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/zd1211rw/zd_mac.c	2008-05-11 00:05:16.000000000 +0200
@@ -224,36 +224,6 @@ out:
 	return r;
 }
 
-/**
- * clear_tx_skb_control_block - clears the control block of tx skbuffs
- * @skb: a &struct sk_buff pointer
- *
- * This clears the control block of skbuff buffers, which were transmitted to
- * the device. Notify that the function is not thread-safe, so prevent
- * multiple calls.
- */
-static void clear_tx_skb_control_block(struct sk_buff *skb)
-{
-	struct zd_tx_skb_control_block *cb =
-		(struct zd_tx_skb_control_block *)skb->cb;
-
-	kfree(cb->control);
-	cb->control = NULL;
-}
-
-/**
- * kfree_tx_skb - frees a tx skbuff
- * @skb: a &struct sk_buff pointer
- *
- * Frees the tx skbuff. Frees also the allocated control structure in the
- * control block if necessary.
- */
-static void kfree_tx_skb(struct sk_buff *skb)
-{
-	clear_tx_skb_control_block(skb);
-	dev_kfree_skb_any(skb);
-}
-
 static void zd_op_stop(struct ieee80211_hw *hw)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
@@ -276,40 +246,15 @@ static void zd_op_stop(struct ieee80211_
 
 
 	while ((skb = skb_dequeue(ack_wait_queue)))
-		kfree_tx_skb(skb);
-}
-
-/**
- * init_tx_skb_control_block - initializes skb control block
- * @skb: a &sk_buff pointer
- * @dev: pointer to the mac80221 device
- * @control: mac80211 tx control applying for the frame in @skb
- *
- * Initializes the control block of the skbuff to be transmitted.
- */
-static int init_tx_skb_control_block(struct sk_buff *skb,
-				     struct ieee80211_hw *hw,
-	                             struct ieee80211_tx_control *control)
-{
-	struct zd_tx_skb_control_block *cb =
-		(struct zd_tx_skb_control_block *)skb->cb;
-
-	ZD_ASSERT(sizeof(*cb) <= sizeof(skb->cb));
-	memset(cb, 0, sizeof(*cb));
-	cb->hw= hw;
-	cb->control = kmalloc(sizeof(*control), GFP_ATOMIC);
-	if (cb->control == NULL)
-		return -ENOMEM;
-	memcpy(cb->control, control, sizeof(*control));
-
-	return 0;
+		dev_kfree_skb_any(skb);
 }
 
 /**
  * tx_status - reports tx status of a packet if required
  * @hw - a &struct ieee80211_hw pointer
  * @skb - a sk-buffer
- * @status - the tx status of the packet without control information
+ * @flags: extra flags to set in the TX status info
+ * @ackssi: ACK signal strength
  * @success - True for successfull transmission of the frame
  *
  * This information calls ieee80211_tx_status_irqsafe() if required by the
@@ -319,18 +264,17 @@ static int init_tx_skb_control_block(str
  * If no status information has been requested, the skb is freed.
  */
 static void tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
-	              struct ieee80211_tx_status *status,
-		      bool success)
+		      u32 flags, int ackssi, bool success)
 {
-	struct zd_tx_skb_control_block *cb = (struct zd_tx_skb_control_block *)
-		skb->cb;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
+
+	memset(&info->status, 0, sizeof(info->status));
 
-	ZD_ASSERT(cb->control != NULL);
-	memcpy(&status->control, cb->control, sizeof(status->control));
 	if (!success)
-		status->excessive_retries = 1;
-	clear_tx_skb_control_block(skb);
-	ieee80211_tx_status_irqsafe(hw, skb, status);
+		info->status.excessive_retries = 1;
+	info->flags |= flags;
+	info->status.ack_signal = ackssi;
+	ieee80211_tx_status_irqsafe(hw, skb);
 }
 
 /**
@@ -345,15 +289,12 @@ void zd_mac_tx_failed(struct ieee80211_h
 {
 	struct sk_buff_head *q = &zd_hw_mac(hw)->ack_wait_queue;
 	struct sk_buff *skb;
-	struct ieee80211_tx_status status;
 
 	skb = skb_dequeue(q);
 	if (skb == NULL)
 		return;
 
-	memset(&status, 0, sizeof(status));
-
-	tx_status(hw, skb, &status, 0);
+	tx_status(hw, skb, 0, 0, 0);
 }
 
 /**
@@ -368,28 +309,20 @@ void zd_mac_tx_failed(struct ieee80211_h
  */
 void zd_mac_tx_to_dev(struct sk_buff *skb, int error)
 {
-	struct zd_tx_skb_control_block *cb =
-		(struct zd_tx_skb_control_block *)skb->cb;
-	struct ieee80211_hw *hw = cb->hw;
-
-	if (likely(cb->control)) {
-		skb_pull(skb, sizeof(struct zd_ctrlset));
-		if (unlikely(error ||
-		    (cb->control->flags & IEEE80211_TXCTL_NO_ACK)))
-		{
-			struct ieee80211_tx_status status;
-			memset(&status, 0, sizeof(status));
-			tx_status(hw, skb, &status, !error);
-		} else {
-			struct sk_buff_head *q =
-				&zd_hw_mac(hw)->ack_wait_queue;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
+	struct ieee80211_hw *hw = info->driver_data[0];
 
-			skb_queue_tail(q, skb);
-			while (skb_queue_len(q) > ZD_MAC_MAX_ACK_WAITERS)
-				zd_mac_tx_failed(hw);
-		}
+	skb_pull(skb, sizeof(struct zd_ctrlset));
+	if (unlikely(error ||
+	    (info->flags & IEEE80211_TX_CTL_NO_ACK))) {
+		tx_status(hw, skb, 0, 0, !error);
 	} else {
-		kfree_tx_skb(skb);
+		struct sk_buff_head *q =
+			&zd_hw_mac(hw)->ack_wait_queue;
+
+		skb_queue_tail(q, skb);
+		while (skb_queue_len(q) > ZD_MAC_MAX_ACK_WAITERS)
+			zd_mac_tx_failed(hw);
 	}
 }
 
@@ -454,7 +387,7 @@ static void cs_set_control(struct zd_mac
 	cs->control = 0;
 
 	/* First fragment */
-	if (flags & IEEE80211_TXCTL_FIRST_FRAGMENT)
+	if (flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 		cs->control |= ZD_CS_NEED_RANDOM_BACKOFF;
 
 	/* Multicast */
@@ -466,10 +399,10 @@ static void cs_set_control(struct zd_mac
 	    (IEEE80211_FTYPE_CTL|IEEE80211_STYPE_PSPOLL))
 		cs->control |= ZD_CS_PS_POLL_FRAME;
 
-	if (flags & IEEE80211_TXCTL_USE_RTS_CTS)
+	if (flags & IEEE80211_TX_CTL_USE_RTS_CTS)
 		cs->control |= ZD_CS_RTS;
 
-	if (flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
+	if (flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
 		cs->control |= ZD_CS_SELF_CTS;
 
 	/* FIXME: Management frame? */
@@ -516,8 +449,7 @@ void zd_mac_config_beacon(struct ieee802
 }
 
 static int fill_ctrlset(struct zd_mac *mac,
-			struct sk_buff *skb,
-			struct ieee80211_tx_control *control)
+			struct sk_buff *skb)
 {
 	int r;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -526,18 +458,19 @@ static int fill_ctrlset(struct zd_mac *m
 	struct ieee80211_rate *txrate;
 	struct zd_ctrlset *cs = (struct zd_ctrlset *)
 		skb_push(skb, sizeof(struct zd_ctrlset));
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 
 	ZD_ASSERT(frag_len <= 0xffff);
 
-	txrate = ieee80211_get_tx_rate(mac->hw, control);
+	txrate = ieee80211_get_tx_rate(mac->hw, info);
 
 	cs->modulation = txrate->hw_value;
-	if (control->flags & IEEE80211_TXCTL_SHORT_PREAMBLE)
+	if (info->flags & IEEE80211_TX_CTL_SHORT_PREAMBLE)
 		cs->modulation = txrate->hw_value_short;
 
 	cs->tx_length = cpu_to_le16(frag_len);
 
-	cs_set_control(mac, cs, hdr, control->flags);
+	cs_set_control(mac, cs, hdr, info->flags);
 
 	packet_length = frag_len + sizeof(struct zd_ctrlset) + 10;
 	ZD_ASSERT(packet_length <= 0xffff);
@@ -582,24 +515,21 @@ static int fill_ctrlset(struct zd_mac *m
  * control block of the skbuff will be initialized. If necessary the incoming
  * mac80211 queues will be stopped.
  */
-static int zd_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-		     struct ieee80211_tx_control *control)
+static int zd_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	int r;
 
-	r = fill_ctrlset(mac, skb, control);
+	r = fill_ctrlset(mac, skb);
 	if (r)
 		return r;
 
-	r = init_tx_skb_control_block(skb, hw, control);
-	if (r)
-		return r;
+	info->driver_data[0] = hw;
+
 	r = zd_usb_tx(&mac->chip.usb, skb);
-	if (r) {
-		clear_tx_skb_control_block(skb);
+	if (r)
 		return r;
-	}
 	return 0;
 }
 
@@ -637,13 +567,8 @@ static int filter_ack(struct ieee80211_h
 		tx_hdr = (struct ieee80211_hdr *)skb->data;
 		if (likely(!compare_ether_addr(tx_hdr->addr2, rx_hdr->addr1)))
 		{
-			struct ieee80211_tx_status status;
-
-			memset(&status, 0, sizeof(status));
-			status.flags = IEEE80211_TX_STATUS_ACK;
-			status.ack_signal = stats->ssi;
 			__skb_unlink(skb, q);
-			tx_status(hw, skb, &status, 1);
+			tx_status(hw, skb, IEEE80211_TX_STAT_ACK, stats->ssi, 1);
 			goto out;
 		}
 	}
--- everything.orig/drivers/net/wireless/zd1211rw/zd_mac.h	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/zd1211rw/zd_mac.h	2008-05-11 00:05:16.000000000 +0200
@@ -149,22 +149,6 @@ struct housekeeping {
 	struct delayed_work link_led_work;
 };
 
-/**
- * struct zd_tx_skb_control_block - control block for tx skbuffs
- * @control: &struct ieee80211_tx_control pointer
- * @context: context pointer
- *
- * This structure is used to fill the cb field in an &sk_buff to transmit.
- * The control field is NULL, if there is no requirement from the mac80211
- * stack to report about the packet ACK. This is the case if the flag
- * IEEE80211_TXCTL_NO_ACK is not set in &struct ieee80211_tx_control.
- */
-struct zd_tx_skb_control_block {
-	struct ieee80211_tx_control *control;
-	struct ieee80211_hw *hw;
-	void *context;
-};
-
 #define ZD_MAC_STATS_BUFFER_SIZE 16
 
 #define ZD_MAC_MAX_ACK_WAITERS 10
--- everything.orig/drivers/net/wireless/zd1211rw/zd_usb.c	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/zd1211rw/zd_usb.c	2008-05-11 00:05:17.000000000 +0200
@@ -869,7 +869,7 @@ static void tx_urb_complete(struct urb *
 {
 	int r;
 	struct sk_buff *skb;
-	struct zd_tx_skb_control_block *cb;
+	struct ieee80211_tx_info *info;
 	struct zd_usb *usb;
 
 	switch (urb->status) {
@@ -893,8 +893,8 @@ free_urb:
 	 * grab 'usb' pointer before handing off the skb (since
 	 * it might be freed by zd_mac_tx_to_dev or mac80211)
 	 */
-	cb = (struct zd_tx_skb_control_block *)skb->cb;
-	usb = &zd_hw_mac(cb->hw)->chip.usb;
+	info = (void *)skb->cb;
+	usb = &zd_hw_mac(info->driver_data[0])->chip.usb;
 	zd_mac_tx_to_dev(skb, urb->status);
 	free_tx_urb(usb, urb);
 	tx_dec_submitted_urbs(usb);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-05-11 00:05:17.000000000 +0200
@@ -445,8 +445,7 @@ static int rs_adjust_next_rate(struct iw
  */
 static void rs_tx_status(void *priv_rate,
 			 struct net_device *dev,
-			 struct sk_buff *skb,
-			 struct ieee80211_tx_status *tx_resp)
+			 struct sk_buff *skb)
 {
 	u8 retries, current_count;
 	int scale_rate_index, first_index, last_index;
@@ -457,14 +456,15 @@ static void rs_tx_status(void *priv_rate
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct iwl3945_rs_sta *rs_sta;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 
 	IWL_DEBUG_RATE("enter\n");
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 
-	retries = tx_resp->retry_count;
-	first_index = sband->bitrates[tx_resp->control.tx_rate_idx].hw_value;
+	retries = info->status.retry_count;
+	first_index = sband->bitrates[info->tx_rate_idx].hw_value;
 	if ((first_index < 0) || (first_index >= IWL_RATE_COUNT)) {
 		IWL_DEBUG_RATE("leave: Rate out of bounds: %d\n", first_index);
 		return;
@@ -525,11 +525,11 @@ static void rs_tx_status(void *priv_rate
 	/* Update the last index window with success/failure based on ACK */
 	IWL_DEBUG_RATE("Update rate %d with %s.\n",
 		       last_index,
-		       (tx_resp->flags & IEEE80211_TX_STATUS_ACK) ?
+		       (info->flags & IEEE80211_TX_STAT_ACK) ?
 		       "success" : "failure");
 	iwl3945_collect_tx_data(rs_sta,
 			    &rs_sta->win[last_index],
-			    tx_resp->flags & IEEE80211_TX_STATUS_ACK, 1);
+			    info->flags & IEEE80211_TX_STAT_ACK, 1);
 
 	/* We updated the rate scale window -- if its been more than
 	 * flush_time since the last run, schedule the flush
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945.c	2008-05-11 00:05:17.000000000 +0200
@@ -283,8 +283,7 @@ static void iwl3945_tx_queue_reclaim(str
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
-		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb[0],
-					    &tx_info->status);
+		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb[0]);
 		tx_info->skb[0] = NULL;
 		iwl3945_hw_txq_free_tfd(priv, txq);
 	}
@@ -306,7 +305,7 @@ static void iwl3945_rx_reply_tx(struct i
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
 	struct iwl3945_tx_queue *txq = &priv->txq[txq_id];
-	struct ieee80211_tx_status *tx_status;
+	struct ieee80211_tx_info *info;
 	struct iwl3945_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->status);
 	int rate_idx;
@@ -319,21 +318,22 @@ static void iwl3945_rx_reply_tx(struct i
 		return;
 	}
 
-	tx_status = &(txq->txb[txq->q.read_ptr].status);
+	info = (void *)txq->txb[txq->q.read_ptr].skb[0]->cb;
+	memset(&info->status, 0, sizeof(info->status));
 
-	tx_status->retry_count = tx_resp->failure_frame;
+	info->status.retry_count = tx_resp->failure_frame;
 	/* tx_status->rts_retry_count = tx_resp->failure_rts; */
-	tx_status->flags = ((status & TX_STATUS_MSK) == TX_STATUS_SUCCESS) ?
-				IEEE80211_TX_STATUS_ACK : 0;
+	info->flags |= ((status & TX_STATUS_MSK) == TX_STATUS_SUCCESS) ?
+				IEEE80211_TX_STAT_ACK : 0;
 
 	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) plcp rate %d retries %d\n",
 			txq_id, iwl3945_get_tx_fail_reason(status), status,
 			tx_resp->rate, tx_resp->failure_frame);
 
 	rate_idx = iwl3945_hwrate_to_plcp_idx(tx_resp->rate);
-	if (tx_status->control.band == IEEE80211_BAND_5GHZ)
+	if (info->band == IEEE80211_BAND_5GHZ)
 		rate_idx -= IWL_FIRST_OFDM_RATE;
-	tx_status->control.tx_rate_idx = rate_idx;
+	info->tx_rate_idx = rate_idx;
 	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
 	iwl3945_tx_queue_reclaim(priv, txq_id, index);
 
@@ -960,11 +960,11 @@ u8 iwl3945_hw_find_station(struct iwl394
 */
 void iwl3945_hw_build_tx_cmd_rate(struct iwl3945_priv *priv,
 			      struct iwl3945_cmd *cmd,
-			      struct ieee80211_tx_control *ctrl,
+			      struct ieee80211_tx_info *info,
 			      struct ieee80211_hdr *hdr, int sta_id, int tx_id)
 {
 	unsigned long flags;
-	u16 hw_value = ieee80211_get_tx_rate(priv->hw, ctrl)->hw_value;
+	u16 hw_value = ieee80211_get_tx_rate(priv->hw, info)->hw_value;
 	u16 rate_index = min(hw_value & 0xffff, IWL_RATE_COUNT - 1);
 	u16 rate_mask;
 	int rate;
@@ -977,7 +977,7 @@ void iwl3945_hw_build_tx_cmd_rate(struct
 	tx_flags = cmd->cmd.tx.tx_flags;
 
 	/* We need to figure out how to get the sta->supp_rates while
-	 * in this running context; perhaps encoding into ctrl->tx_rate? */
+	 * in this running context */
 	rate_mask = IWL_RATES_MASK;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2008-05-11 00:02:04.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945.h	2008-05-11 00:05:17.000000000 +0200
@@ -124,7 +124,6 @@ int iwl3945_x2_queue_used(const struct i
 
 /* One for each TFD */
 struct iwl3945_tx_info {
-	struct ieee80211_tx_status status;
 	struct sk_buff *skb[MAX_NUM_OF_TBS];
 };
 
@@ -645,7 +644,7 @@ extern unsigned int iwl3945_hw_get_beaco
 extern int iwl3945_hw_get_rx_read(struct iwl3945_priv *priv);
 extern void iwl3945_hw_build_tx_cmd_rate(struct iwl3945_priv *priv,
 				     struct iwl3945_cmd *cmd,
-				     struct ieee80211_tx_control *ctrl,
+				     struct ieee80211_tx_info *info,
 				     struct ieee80211_hdr *hdr,
 				     int sta_id, int tx_id);
 extern int iwl3945_hw_reg_send_txpower(struct iwl3945_priv *priv);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2008-05-11 00:05:17.000000000 +0200
@@ -777,8 +777,7 @@ out:
  * mac80211 sends us Tx status
  */
 static void rs_tx_status(void *priv_rate, struct net_device *dev,
-			 struct sk_buff *skb,
-			 struct ieee80211_tx_status *tx_resp)
+			 struct sk_buff *skb)
 {
 	int status;
 	u8 retries;
@@ -790,6 +789,7 @@ static void rs_tx_status(void *priv_rate
 	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = local_to_hw(local);
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	struct iwl4965_rate_scale_data *window = NULL;
 	struct iwl4965_rate_scale_data *search_win = NULL;
 	u32 tx_rate;
@@ -805,11 +805,11 @@ static void rs_tx_status(void *priv_rate
 		return;
 
 	/* This packet was aggregated but doesn't carry rate scale info */
-	if ((tx_resp->control.flags & IEEE80211_TXCTL_AMPDU) &&
-	    !(tx_resp->flags & IEEE80211_TX_STATUS_AMPDU))
+	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
+	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
 		return;
 
-	retries = tx_resp->retry_count;
+	retries = info->status.retry_count;
 
 	if (retries > 15)
 		retries = 15;
@@ -854,20 +854,20 @@ static void rs_tx_status(void *priv_rate
 	if (priv->band == IEEE80211_BAND_5GHZ)
 		rs_index -= IWL_FIRST_OFDM_RATE;
 
-	if ((tx_resp->control.tx_rate_idx < 0) ||
+	if ((info->tx_rate_idx < 0) ||
 	    (tbl_type.is_SGI ^
-		!!(tx_resp->control.flags & IEEE80211_TXCTL_SHORT_GI)) ||
+		!!(info->flags & IEEE80211_TX_CTL_SHORT_GI)) ||
 	    (tbl_type.is_fat ^
-		!!(tx_resp->control.flags & IEEE80211_TXCTL_40_MHZ_WIDTH)) ||
+		!!(info->flags & IEEE80211_TX_CTL_40_MHZ_WIDTH)) ||
 	    (tbl_type.is_dup ^
-		!!(tx_resp->control.flags & IEEE80211_TXCTL_DUP_DATA)) ||
-	    (tbl_type.ant_type ^ tx_resp->control.antenna_sel_tx) ||
+		!!(info->flags & IEEE80211_TX_CTL_DUP_DATA)) ||
+	    (tbl_type.ant_type ^ info->antenna_sel_tx) ||
 	    (!!(tx_rate & RATE_MCS_HT_MSK) ^
-		!!(tx_resp->control.flags & IEEE80211_TXCTL_OFDM_HT)) ||
+		!!(info->flags & IEEE80211_TX_CTL_OFDM_HT)) ||
 	    (!!(tx_rate & RATE_MCS_GF_MSK) ^
-		!!(tx_resp->control.flags & IEEE80211_TXCTL_GREEN_FIELD)) ||
+		!!(info->flags & IEEE80211_TX_CTL_GREEN_FIELD)) ||
 	    (hw->wiphy->bands[priv->band]->bitrates[rs_index].bitrate !=
-	     hw->wiphy->bands[tx_resp->control.band]->bitrates[tx_resp->control.tx_rate_idx].bitrate)) {
+	     hw->wiphy->bands[info->band]->bitrates[info->tx_rate_idx].bitrate)) {
 		IWL_DEBUG_RATE("initial rate does not match 0x%x\n", tx_rate);
 		goto out;
 	}
@@ -921,10 +921,7 @@ static void rs_tx_status(void *priv_rate
 	rs_get_tbl_info_from_mcs(tx_rate, priv->band, &tbl_type, &rs_index);
 
 	/* Update frame history window with "success" if Tx got ACKed ... */
-	if (tx_resp->flags & IEEE80211_TX_STATUS_ACK)
-		status = 1;
-	else
-		status = 0;
+	status = !!(info->flags & IEEE80211_TX_STAT_ACK);
 
 	/* If type matches "search" table,
 	 * add final tx status to "search" history */
@@ -935,10 +932,10 @@ static void rs_tx_status(void *priv_rate
 			tpt = search_tbl->expected_tpt[rs_index];
 		else
 			tpt = 0;
-		if (tx_resp->control.flags & IEEE80211_TXCTL_AMPDU)
+		if (info->flags & IEEE80211_TX_CTL_AMPDU)
 			rs_collect_tx_data(search_win, rs_index, tpt,
-					   tx_resp->ampdu_ack_len,
-					   tx_resp->ampdu_ack_map);
+					   info->status.ampdu_ack_len,
+					   info->status.ampdu_ack_map);
 		else
 			rs_collect_tx_data(search_win, rs_index, tpt,
 					   1, status);
@@ -951,10 +948,10 @@ static void rs_tx_status(void *priv_rate
 			tpt = curr_tbl->expected_tpt[rs_index];
 		else
 			tpt = 0;
-		if (tx_resp->control.flags & IEEE80211_TXCTL_AMPDU)
+		if (info->flags & IEEE80211_TX_CTL_AMPDU)
 			rs_collect_tx_data(window, rs_index, tpt,
-					   tx_resp->ampdu_ack_len,
-					   tx_resp->ampdu_ack_map);
+					   info->status.ampdu_ack_len,
+					   info->status.ampdu_ack_map);
 		else
 			rs_collect_tx_data(window, rs_index, tpt,
 					   1, status);
@@ -963,10 +960,10 @@ static void rs_tx_status(void *priv_rate
 	/* If not searching for new mode, increment success/failed counter
 	 * ... these help determine when to start searching again */
 	if (lq_sta->stay_in_tbl) {
-		if (tx_resp->control.flags & IEEE80211_TXCTL_AMPDU) {
-			lq_sta->total_success += tx_resp->ampdu_ack_map;
+		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+			lq_sta->total_success += info->status.ampdu_ack_map;
 			lq_sta->total_failed +=
-			     (tx_resp->ampdu_ack_len - tx_resp->ampdu_ack_map);
+			     (info->status.ampdu_ack_len - info->status.ampdu_ack_map);
 		} else {
 			if (status)
 				lq_sta->total_success++;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965.c	2008-05-11 00:05:17.000000000 +0200
@@ -262,22 +262,22 @@ int iwl4965_hwrate_to_plcp_idx(u32 rate_
  * translate ucode response to mac80211 tx status control values
  */
 void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
-				  struct ieee80211_tx_control *control)
+				  struct ieee80211_tx_info *control)
 {
 	int rate_index;
 
 	control->antenna_sel_tx =
 		((rate_n_flags & RATE_MCS_ANT_ABC_MSK) >> RATE_MCS_ANT_POS);
 	if (rate_n_flags & RATE_MCS_HT_MSK)
-		control->flags |= IEEE80211_TXCTL_OFDM_HT;
+		control->flags |= IEEE80211_TX_CTL_OFDM_HT;
 	if (rate_n_flags & RATE_MCS_GF_MSK)
-		control->flags |= IEEE80211_TXCTL_GREEN_FIELD;
+		control->flags |= IEEE80211_TX_CTL_GREEN_FIELD;
 	if (rate_n_flags & RATE_MCS_FAT_MSK)
-		control->flags |= IEEE80211_TXCTL_40_MHZ_WIDTH;
+		control->flags |= IEEE80211_TX_CTL_40_MHZ_WIDTH;
 	if (rate_n_flags & RATE_MCS_DUP_MSK)
-		control->flags |= IEEE80211_TXCTL_DUP_DATA;
+		control->flags |= IEEE80211_TX_CTL_DUP_DATA;
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
-		control->flags |= IEEE80211_TXCTL_SHORT_GI;
+		control->flags |= IEEE80211_TX_CTL_SHORT_GI;
 	rate_index = iwl4965_hwrate_to_plcp_idx(rate_n_flags);
 	if (control->band == IEEE80211_BAND_5GHZ)
 		rate_index -= IWL_FIRST_OFDM_RATE;
@@ -2117,7 +2117,7 @@ int iwl4965_hw_channel_switch(struct iwl
 
 void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 			      struct iwl_cmd *cmd,
-			      struct ieee80211_tx_control *ctrl,
+			      struct ieee80211_tx_info *info,
 			      struct ieee80211_hdr *hdr, int sta_id,
 			      int is_hcca)
 {
@@ -2127,7 +2127,7 @@ void iwl4965_hw_build_tx_cmd_rate(struct
 	u16 fc = le16_to_cpu(hdr->frame_control);
 	u8 rate_plcp;
 	u16 rate_flags = 0;
-	u16 hw_value = ieee80211_get_tx_rate(priv->hw, ctrl)->hw_value;
+	u16 hw_value = ieee80211_get_tx_rate(priv->hw, info)->hw_value;
 	int rate_idx = min(hw_value & 0xffff, IWL_RATE_COUNT - 1);
 
 	rate_plcp = iwl4965_rates[rate_idx].plcp;
@@ -3339,7 +3339,7 @@ static int iwl4965_tx_status_reply_compr
 	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
 	u64 bitmap;
 	int successes = 0;
-	struct ieee80211_tx_status *tx_status;
+	struct ieee80211_tx_info *info;
 
 	if (unlikely(!agg->wait_for_ba))  {
 		IWL_ERROR("Received BA when not expected\n");
@@ -3377,13 +3377,13 @@ static int iwl4965_tx_status_reply_compr
 			agg->start_idx + i);
 	}
 
-	tx_status = &priv->txq[scd_flow].txb[agg->start_idx].status;
-	tx_status->flags = IEEE80211_TX_STATUS_ACK;
-	tx_status->flags |= IEEE80211_TX_STATUS_AMPDU;
-	tx_status->ampdu_ack_map = successes;
-	tx_status->ampdu_ack_len = agg->frame_count;
-	iwl4965_hwrate_to_tx_control(priv, agg->rate_n_flags,
-				     &tx_status->control);
+	info = (void *)priv->txq[scd_flow].txb[agg->start_idx].skb[0]->cb;
+	memset(&info->status, 0, sizeof(info->status));
+	info->flags = IEEE80211_TX_STAT_ACK;
+	info->flags |= IEEE80211_TX_STAT_AMPDU;
+	info->status.ampdu_ack_map = successes;
+	info->status.ampdu_ack_len = agg->frame_count;
+	iwl4965_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
 
 	IWL_DEBUG_TX_REPLY("Bitmap %llx\n", (unsigned long long)bitmap);
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-05-11 00:02:04.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-05-11 00:05:17.000000000 +0200
@@ -119,7 +119,6 @@ struct iwl4965_queue {
 
 /* One for each TFD */
 struct iwl4965_tx_info {
-	struct ieee80211_tx_status status;
 	struct sk_buff *skb[MAX_NUM_OF_TBS];
 };
 
@@ -716,7 +715,7 @@ extern unsigned int iwl4965_hw_get_beaco
 extern int iwl4965_hw_get_rx_read(struct iwl_priv *priv);
 extern void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 				     struct iwl_cmd *cmd,
-				     struct ieee80211_tx_control *ctrl,
+				     struct ieee80211_tx_info *info,
 				     struct ieee80211_hdr *hdr,
 				     int sta_id, int tx_id);
 extern int iwl4965_hw_reg_send_txpower(struct iwl_priv *priv);
@@ -755,7 +754,7 @@ extern void iwl4965_update_rate_scaling(
 extern void iwl4965_rf_kill_ct_config(struct iwl_priv *priv);
 extern void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv,
 					 u32 rate_n_flags,
-					 struct ieee80211_tx_control *control);
+					 struct ieee80211_tx_info *info);
 
 #ifdef CONFIG_IWL4965_HT
 extern void iwl4965_init_ht_hw_capab(const struct iwl_priv *priv,
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-05-11 00:05:17.000000000 +0200
@@ -2386,13 +2386,13 @@ static int iwl3945_set_mode(struct iwl39
 }
 
 static void iwl3945_build_tx_cmd_hwcrypto(struct iwl3945_priv *priv,
-				      struct ieee80211_tx_control *ctl,
+				      struct ieee80211_tx_info *info,
 				      struct iwl3945_cmd *cmd,
 				      struct sk_buff *skb_frag,
 				      int last_frag)
 {
 	struct iwl3945_hw_key *keyinfo =
-	    &priv->stations[ctl->hw_key->hw_key_idx].keyinfo;
+	    &priv->stations[info->control.hw_key->hw_key_idx].keyinfo;
 
 	switch (keyinfo->alg) {
 	case ALG_CCMP:
@@ -2415,7 +2415,7 @@ static void iwl3945_build_tx_cmd_hwcrypt
 
 	case ALG_WEP:
 		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_WEP |
-		    (ctl->hw_key->hw_key_idx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT;
+		    (info->control.hw_key->hw_key_idx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT;
 
 		if (keyinfo->keylen == 13)
 			cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
@@ -2423,7 +2423,7 @@ static void iwl3945_build_tx_cmd_hwcrypt
 		memcpy(&cmd->cmd.tx.key[3], keyinfo->key, keyinfo->keylen);
 
 		IWL_DEBUG_TX("Configuring packet for WEP encryption "
-			     "with key %d\n", ctl->hw_key->hw_key_idx);
+			     "with key %d\n", info->control.hw_key->hw_key_idx);
 		break;
 
 	default:
@@ -2437,7 +2437,7 @@ static void iwl3945_build_tx_cmd_hwcrypt
  */
 static void iwl3945_build_tx_cmd_basic(struct iwl3945_priv *priv,
 				  struct iwl3945_cmd *cmd,
-				  struct ieee80211_tx_control *ctrl,
+				  struct ieee80211_tx_info *info,
 				  struct ieee80211_hdr *hdr,
 				  int is_unicast, u8 std_id)
 {
@@ -2446,7 +2446,7 @@ static void iwl3945_build_tx_cmd_basic(s
 	__le32 tx_flags = cmd->cmd.tx.tx_flags;
 
 	cmd->cmd.tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
-	if (!(ctrl->flags & IEEE80211_TXCTL_NO_ACK)) {
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		tx_flags |= TX_CMD_FLG_ACK_MSK;
 		if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)
 			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
@@ -2469,10 +2469,10 @@ static void iwl3945_build_tx_cmd_basic(s
 	} else
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 
-	if (ctrl->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
+	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {
 		tx_flags |= TX_CMD_FLG_RTS_MSK;
 		tx_flags &= ~TX_CMD_FLG_CTS_MSK;
-	} else if (ctrl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
+	} else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT) {
 		tx_flags &= ~TX_CMD_FLG_RTS_MSK;
 		tx_flags |= TX_CMD_FLG_CTS_MSK;
 	}
@@ -2556,13 +2556,13 @@ static int iwl3945_get_sta_id(struct iwl
 /*
  * start REPLY_TX command process
  */
-static int iwl3945_tx_skb(struct iwl3945_priv *priv,
-		      struct sk_buff *skb, struct ieee80211_tx_control *ctl)
+static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	struct iwl3945_tfd_frame *tfd;
 	u32 *control_flags;
-	int txq_id = ctl->queue;
+	int txq_id = info->queue;
 	struct iwl3945_tx_queue *txq = NULL;
 	struct iwl3945_queue *q = NULL;
 	dma_addr_t phys_addr;
@@ -2589,7 +2589,7 @@ static int iwl3945_tx_skb(struct iwl3945
 		goto drop_unlock;
 	}
 
-	if ((ieee80211_get_tx_rate(priv->hw, ctl)->hw_value & 0xFF) == IWL_INVALID_RATE) {
+	if ((ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xFF) == IWL_INVALID_RATE) {
 		IWL_ERROR("ERROR: No TX rate available.\n");
 		goto drop_unlock;
 	}
@@ -2658,8 +2658,6 @@ static int iwl3945_tx_skb(struct iwl3945
 	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl3945_tx_info));
 	txq->txb[q->write_ptr].skb[0] = skb;
-	memcpy(&(txq->txb[q->write_ptr].status.control),
-	       ctl, sizeof(struct ieee80211_tx_control));
 
 	/* Init first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = &txq->cmd[idx];
@@ -2708,8 +2706,8 @@ static int iwl3945_tx_skb(struct iwl3945
 	 * first entry */
 	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
 
-	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
-		iwl3945_build_tx_cmd_hwcrypto(priv, ctl, out_cmd, skb, 0);
+	if (!(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT))
+		iwl3945_build_tx_cmd_hwcrypto(priv, info, out_cmd, skb, 0);
 
 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
 	 * if any (802.11 null frames have no payload). */
@@ -2734,10 +2732,10 @@ static int iwl3945_tx_skb(struct iwl3945
 	out_cmd->cmd.tx.len = cpu_to_le16(len);
 
 	/* TODO need this for burst mode later on */
-	iwl3945_build_tx_cmd_basic(priv, out_cmd, ctl, hdr, unicast, sta_id);
+	iwl3945_build_tx_cmd_basic(priv, out_cmd, info, hdr, unicast, sta_id);
 
 	/* set is_hcca to 0; it probably will never be implemented */
-	iwl3945_hw_build_tx_cmd_rate(priv, out_cmd, ctl, hdr, sta_id, 0);
+	iwl3945_hw_build_tx_cmd_rate(priv, out_cmd, info, hdr, sta_id, 0);
 
 	out_cmd->cmd.tx.tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
 	out_cmd->cmd.tx.tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
@@ -2776,7 +2774,7 @@ static int iwl3945_tx_skb(struct iwl3945
 			spin_unlock_irqrestore(&priv->lock, flags);
 		}
 
-		ieee80211_stop_queue(priv->hw, ctl->queue);
+		ieee80211_stop_queue(priv->hw, info->queue);
 	}
 
 	return 0;
@@ -3239,7 +3237,7 @@ static void iwl3945_bg_beacon_update(str
 	struct sk_buff *beacon;
 
 	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
-	beacon = ieee80211_beacon_get(priv->hw, priv->vif, NULL);
+	beacon = ieee80211_beacon_get(priv->hw, priv->vif);
 
 	if (!beacon) {
 		IWL_ERROR("update beacon failed\n");
@@ -6672,8 +6670,7 @@ static void iwl3945_mac_stop(struct ieee
 	IWL_DEBUG_MAC80211("leave\n");
 }
 
-static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-		      struct ieee80211_tx_control *ctl)
+static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl3945_priv *priv = hw->priv;
 
@@ -6685,9 +6682,9 @@ static int iwl3945_mac_tx(struct ieee802
 	}
 
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
-		     ieee80211_get_tx_rate(hw, ctl)->bitrate);
+		     ieee80211_get_tx_rate(hw, (void *)skb->cb)->bitrate);
 
-	if (iwl3945_tx_skb(priv, skb, ctl))
+	if (iwl3945_tx_skb(priv, skb))
 		dev_kfree_skb_any(skb);
 
 	IWL_DEBUG_MAC80211("leave\n");
@@ -7308,8 +7305,7 @@ static void iwl3945_mac_reset_tsf(struct
 
 }
 
-static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-				 struct ieee80211_tx_control *control)
+static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl3945_priv *priv = hw->priv;
 	unsigned long flags;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-05-11 00:05:17.000000000 +0200
@@ -1778,7 +1778,7 @@ static int iwl4965_set_mode(struct iwl_p
 }
 
 static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
-				      struct ieee80211_tx_control *ctl,
+				      struct ieee80211_tx_info *info,
 				      struct iwl_cmd *cmd,
 				      struct sk_buff *skb_frag,
 				      int sta_id)
@@ -1787,13 +1787,13 @@ static void iwl4965_build_tx_cmd_hwcrypt
 	struct iwl_wep_key *wepkey;
 	int keyidx = 0;
 
-	BUG_ON(ctl->hw_key->hw_key_idx > 3);
+	BUG_ON(info->control.hw_key->hw_key_idx > 3);
 
 	switch (keyinfo->alg) {
 	case ALG_CCMP:
 		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_CCM;
 		memcpy(cmd->cmd.tx.key, keyinfo->key, keyinfo->keylen);
-		if (ctl->flags & IEEE80211_TXCTL_AMPDU)
+		if (info->flags & IEEE80211_TX_CTL_AMPDU)
 			cmd->cmd.tx.tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
 		IWL_DEBUG_TX("tx_cmd with aes hwcrypto\n");
 		break;
@@ -1806,11 +1806,11 @@ static void iwl4965_build_tx_cmd_hwcrypt
 		break;
 
 	case ALG_WEP:
-		wepkey = &priv->wep_keys[ctl->hw_key->hw_key_idx];
+		wepkey = &priv->wep_keys[info->control.hw_key->hw_key_idx];
 		cmd->cmd.tx.sec_ctl = 0;
 		if (priv->default_wep_key) {
 			/* the WEP key was sent as static */
-			keyidx = ctl->hw_key->hw_key_idx;
+			keyidx = info->control.hw_key->hw_key_idx;
 			memcpy(&cmd->cmd.tx.key[3], wepkey->key,
 							wepkey->key_size);
 			if (wepkey->key_size == WEP_KEY_LEN_128)
@@ -1842,7 +1842,7 @@ static void iwl4965_build_tx_cmd_hwcrypt
  */
 static void iwl4965_build_tx_cmd_basic(struct iwl_priv *priv,
 				  struct iwl_cmd *cmd,
-				  struct ieee80211_tx_control *ctrl,
+				  struct ieee80211_tx_info *info,
 				  struct ieee80211_hdr *hdr,
 				  int is_unicast, u8 std_id)
 {
@@ -1851,7 +1851,7 @@ static void iwl4965_build_tx_cmd_basic(s
 	__le32 tx_flags = cmd->cmd.tx.tx_flags;
 
 	cmd->cmd.tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
-	if (!(ctrl->flags & IEEE80211_TXCTL_NO_ACK)) {
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		tx_flags |= TX_CMD_FLG_ACK_MSK;
 		if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)
 			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
@@ -1878,10 +1878,10 @@ static void iwl4965_build_tx_cmd_basic(s
 	} else
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 
-	if (ctrl->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
+	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {
 		tx_flags |= TX_CMD_FLG_RTS_MSK;
 		tx_flags &= ~TX_CMD_FLG_CTS_MSK;
-	} else if (ctrl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
+	} else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT) {
 		tx_flags &= ~TX_CMD_FLG_RTS_MSK;
 		tx_flags |= TX_CMD_FLG_CTS_MSK;
 	}
@@ -1971,13 +1971,13 @@ static int iwl4965_get_sta_id(struct iwl
 /*
  * start REPLY_TX command process
  */
-static int iwl4965_tx_skb(struct iwl_priv *priv,
-		      struct sk_buff *skb, struct ieee80211_tx_control *ctl)
+static int iwl4965_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = (void *)skb->cb;
 	struct iwl4965_tfd_frame *tfd;
 	u32 *control_flags;
-	int txq_id = ctl->queue;
+	int txq_id = info->queue;
 	struct iwl4965_tx_queue *txq = NULL;
 	struct iwl4965_queue *q = NULL;
 	dma_addr_t phys_addr;
@@ -2005,7 +2005,7 @@ static int iwl4965_tx_skb(struct iwl_pri
 		goto drop_unlock;
 	}
 
-	if ((ieee80211_get_tx_rate(priv->hw, ctl)->hw_value & 0xFF) == IWL_INVALID_RATE) {
+	if ((ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xFF) == IWL_INVALID_RATE) {
 		IWL_ERROR("ERROR: No TX rate available.\n");
 		goto drop_unlock;
 	}
@@ -2060,7 +2060,7 @@ static int iwl4965_tx_skb(struct iwl_pri
 		seq_number += 0x10;
 #ifdef CONFIG_IWL4965_HT
 		/* aggregation is on for this <sta,tid> */
-		if (ctl->flags & IEEE80211_TXCTL_AMPDU)
+		if (info->flags & IEEE80211_TX_CTL_AMPDU)
 			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
 		priv->stations[sta_id].tid[tid].tfds_in_queue++;
 #endif /* CONFIG_IWL4965_HT */
@@ -2081,8 +2081,6 @@ static int iwl4965_tx_skb(struct iwl_pri
 	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl4965_tx_info));
 	txq->txb[q->write_ptr].skb[0] = skb;
-	memcpy(&(txq->txb[q->write_ptr].status.control),
-	       ctl, sizeof(struct ieee80211_tx_control));
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = &txq->cmd[idx];
@@ -2131,8 +2129,8 @@ static int iwl4965_tx_skb(struct iwl_pri
 	 * first entry */
 	iwl4965_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
 
-	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
-		iwl4965_build_tx_cmd_hwcrypto(priv, ctl, out_cmd, skb, sta_id);
+	if (!(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT))
+		iwl4965_build_tx_cmd_hwcrypto(priv, info, out_cmd, skb, sta_id);
 
 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
 	 * if any (802.11 null frames have no payload). */
@@ -2152,10 +2150,10 @@ static int iwl4965_tx_skb(struct iwl_pri
 	out_cmd->cmd.tx.len = cpu_to_le16(len);
 
 	/* TODO need this for burst mode later on */
-	iwl4965_build_tx_cmd_basic(priv, out_cmd, ctl, hdr, unicast, sta_id);
+	iwl4965_build_tx_cmd_basic(priv, out_cmd, info, hdr, unicast, sta_id);
 
 	/* set is_hcca to 0; it probably will never be implemented */
-	iwl4965_hw_build_tx_cmd_rate(priv, out_cmd, ctl, hdr, sta_id, 0);
+	iwl4965_hw_build_tx_cmd_rate(priv, out_cmd, info, hdr, sta_id, 0);
 
 	iwl_update_tx_stats(priv, fc, len);
 
@@ -2201,7 +2199,7 @@ static int iwl4965_tx_skb(struct iwl_pri
 			spin_unlock_irqrestore(&priv->lock, flags);
 		}
 
-		ieee80211_stop_queue(priv->hw, ctl->queue);
+		ieee80211_stop_queue(priv->hw, info->queue);
 	}
 
 	return 0;
@@ -2519,17 +2517,7 @@ static int iwl4965_get_measurement(struc
 static void iwl4965_txstatus_to_ieee(struct iwl_priv *priv,
 				 struct iwl4965_tx_info *tx_sta)
 {
-
-	tx_sta->status.ack_signal = 0;
-	tx_sta->status.excessive_retries = 0;
-
-	if (in_interrupt())
-		ieee80211_tx_status_irqsafe(priv->hw,
-					    tx_sta->skb[0], &(tx_sta->status));
-	else
-		ieee80211_tx_status(priv->hw,
-				    tx_sta->skb[0], &(tx_sta->status));
-
+	ieee80211_tx_status_irqsafe(priv->hw, tx_sta->skb[0]);
 	tx_sta->skb[0] = NULL;
 }
 
@@ -2629,7 +2617,7 @@ static int iwl4965_tx_status_reply_tx(st
 {
 	u16 status;
 	struct agg_tx_status *frame_status = &tx_resp->status;
-	struct ieee80211_tx_status *tx_status = NULL;
+	struct ieee80211_tx_info *info = NULL;
 	struct ieee80211_hdr *hdr = NULL;
 	int i, sh;
 	int txq_id, idx;
@@ -2655,14 +2643,14 @@ static int iwl4965_tx_status_reply_tx(st
 		IWL_DEBUG_TX_REPLY("FrameCnt = %d, StartIdx=%d idx=%d\n",
 				   agg->frame_count, agg->start_idx, idx);
 
-		tx_status = &(priv->txq[txq_id].txb[idx].status);
-		tx_status->retry_count = tx_resp->failure_frame;
-		tx_status->control.flags &= ~IEEE80211_TXCTL_AMPDU;
-		tx_status->flags = iwl4965_is_tx_success(status)?
-			IEEE80211_TX_STATUS_ACK : 0;
+		info = (void *)priv->txq[txq_id].txb[idx].skb[0]->cb;
+		info->status.retry_count = tx_resp->failure_frame;
+		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
+		info->flags |= iwl4965_is_tx_success(status)?
+			IEEE80211_TX_STAT_ACK : 0;
 		iwl4965_hwrate_to_tx_control(priv,
 					     le32_to_cpu(tx_resp->rate_n_flags),
-					     &tx_status->control);
+					     info);
 		/* FIXME: code repetition end */
 
 		IWL_DEBUG_TX_REPLY("1 Frame 0x%x failure :%d\n",
@@ -2749,7 +2737,7 @@ static void iwl4965_rx_reply_tx(struct i
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
 	struct iwl4965_tx_queue *txq = &priv->txq[txq_id];
-	struct ieee80211_tx_status *tx_status;
+	struct ieee80211_tx_info *info;
 	struct iwl4965_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->status);
 #ifdef CONFIG_IWL4965_HT
@@ -2766,6 +2754,9 @@ static void iwl4965_rx_reply_tx(struct i
 		return;
 	}
 
+	info = (void *)txq->txb[txq->q.read_ptr].skb[0]->cb;
+	memset(&info->status, 0, sizeof(info->status));
+
 #ifdef CONFIG_IWL4965_HT
 	hdr = iwl4965_tx_queue_get_hdr(priv, txq_id, index);
 	qc = ieee80211_get_qos_ctrl(hdr);
@@ -2813,13 +2804,12 @@ static void iwl4965_rx_reply_tx(struct i
 		}
 	} else {
 #endif /* CONFIG_IWL4965_HT */
-	tx_status = &(txq->txb[txq->q.read_ptr].status);
 
-	tx_status->retry_count = tx_resp->failure_frame;
-	tx_status->flags =
-	    iwl4965_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
+	info->status.retry_count = tx_resp->failure_frame;
+	info->flags |=
+	    iwl4965_is_tx_success(status) ? IEEE80211_TX_STAT_ACK : 0;
 	iwl4965_hwrate_to_tx_control(priv, le32_to_cpu(tx_resp->rate_n_flags),
-				     &tx_status->control);
+				     info);
 
 	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) rate_n_flags 0x%x "
 		     "retries %d\n", txq_id, iwl4965_get_tx_fail_reason(status),
@@ -2967,7 +2957,7 @@ static void iwl4965_bg_beacon_update(str
 	struct sk_buff *beacon;
 
 	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
-	beacon = ieee80211_beacon_get(priv->hw, priv->vif, NULL);
+	beacon = ieee80211_beacon_get(priv->hw, priv->vif);
 
 	if (!beacon) {
 		IWL_ERROR("update beacon failed\n");
@@ -5736,8 +5726,7 @@ static void iwl4965_mac_stop(struct ieee
 	IWL_DEBUG_MAC80211("leave\n");
 }
 
-static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-		      struct ieee80211_tx_control *ctl)
+static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -5749,9 +5738,9 @@ static int iwl4965_mac_tx(struct ieee802
 	}
 
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
-		     ieee80211_get_tx_rate(hw, ctl)->bitrate);
+		     ieee80211_get_tx_rate(hw, (void *)skb->cb)->bitrate);
 
-	if (iwl4965_tx_skb(priv, skb, ctl))
+	if (iwl4965_tx_skb(priv, skb))
 		dev_kfree_skb_any(skb);
 
 	IWL_DEBUG_MAC80211("leave\n");
@@ -6511,8 +6500,7 @@ static void iwl4965_mac_reset_tsf(struct
 	IWL_DEBUG_MAC80211("leave\n");
 }
 
-static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-				 struct ieee80211_tx_control *control)
+static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
--- everything.orig/net/mac80211/wep.c	2008-05-11 00:02:03.000000000 +0200
+++ everything/net/mac80211/wep.c	2008-05-11 00:05:17.000000000 +0200
@@ -329,11 +329,16 @@ ieee80211_crypto_wep_decrypt(struct ieee
 
 static int wep_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 {
+	struct ieee80211_tx_info *info = (void *)skb->cb;
+
+	info->control.iv_len = WEP_IV_LEN;
+	info->control.icv_len = WEP_ICV_LEN;
+
 	if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
+		info->control.hw_key = &tx->key->conf;
 		if (ieee80211_wep_encrypt(tx->local, skb, tx->key))
 			return -1;
 	} else {
-		tx->control->hw_key = &tx->key->conf;
 		if (tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) {
 			if (!ieee80211_wep_add_iv(tx->local, skb, tx->key))
 				return -1;
@@ -345,8 +350,6 @@ static int wep_encrypt_skb(struct ieee80
 ieee80211_tx_result
 ieee80211_crypto_wep_encrypt(struct ieee80211_tx_data *tx)
 {
-	tx->control->iv_len = WEP_IV_LEN;
-	tx->control->icv_len = WEP_ICV_LEN;
 	ieee80211_tx_set_protected(tx);
 
 	if (wep_encrypt_skb(tx, tx->skb) < 0) {
--- everything.orig/drivers/net/wireless/ath5k/base.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/base.c	2008-05-11 00:05:17.000000000 +0200
@@ -167,8 +167,7 @@ static struct pci_driver ath5k_pci_drive
 /*
  * Prototypes - MAC 802.11 stack related functions
  */
-static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-		struct ieee80211_tx_control *ctl);
+static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 static int ath5k_reset(struct ieee80211_hw *hw);
 static int ath5k_start(struct ieee80211_hw *hw);
 static void ath5k_stop(struct ieee80211_hw *hw);
@@ -196,8 +195,7 @@ static int ath5k_get_tx_stats(struct iee
 static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
 static void ath5k_reset_tsf(struct ieee80211_hw *hw);
 static int ath5k_beacon_update(struct ieee80211_hw *hw,
-		struct sk_buff *skb,
-		struct ieee80211_tx_control *ctl);
+		struct sk_buff *skb);
 
 static struct ieee80211_ops ath5k_hw_ops = {
 	.tx 		= ath5k_tx,
@@ -251,9 +249,7 @@ static void	ath5k_desc_free(struct ath5k
 static int 	ath5k_rxbuf_setup(struct ath5k_softc *sc,
 				struct ath5k_buf *bf);
 static int 	ath5k_txbuf_setup(struct ath5k_softc *sc,
-				struct ath5k_buf *bf,
-				struct ieee80211_tx_control *ctl);
-
+				struct ath5k_buf *bf);
 static inline void ath5k_txbuf_free(struct ath5k_softc *sc,
 				struct ath5k_buf *bf)
 {
@@ -289,8 +285,7 @@ static void 	ath5k_tx_processq(struct at
 static void 	ath5k_tasklet_tx(unsigned long data);
 /* Beacon handling */
 static int 	ath5k_beacon_setup(struct ath5k_softc *sc,
-				struct ath5k_buf *bf,
-				struct ieee80211_tx_control *ctl);
+					struct ath5k_buf *bf);
 static void 	ath5k_beacon_send(struct ath5k_softc *sc);
 static void 	ath5k_beacon_config(struct ath5k_softc *sc);
 static void	ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf);
@@ -1297,37 +1292,36 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc
 }
 
 static int
-ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
-		struct ieee80211_tx_control *ctl)
+ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 {
 	struct ath5k_hw *ah = sc->ah;
 	struct ath5k_txq *txq = sc->txq;
 	struct ath5k_desc *ds = bf->desc;
 	struct sk_buff *skb = bf->skb;
+	struct ieee80211_tx_info *info = (void*) skb->cb;
 	unsigned int pktlen, flags, keyidx = AR5K_TXKEYIX_INVALID;
 	int ret;
 
 	flags = AR5K_TXDESC_INTREQ | AR5K_TXDESC_CLRDMASK;
-	bf->ctl = *ctl;
+
 	/* XXX endianness */
 	bf->skbaddr = pci_map_single(sc->pdev, skb->data, skb->len,
 			PCI_DMA_TODEVICE);
 
-	if (ctl->flags & IEEE80211_TXCTL_NO_ACK)
+	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
 		flags |= AR5K_TXDESC_NOACK;
 
 	pktlen = skb->len;
 
-	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT)) {
-		keyidx = ctl->hw_key->hw_key_idx;
-		pktlen += ctl->icv_len;
+	if (!(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT)) {
+		keyidx = info->control.hw_key->hw_key_idx;
+		pktlen += info->control.icv_len;
 	}
-
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
 		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
 		(sc->power_level * 2),
-		ieee80211_get_tx_rate(sc->hw, ctl)->hw_value,
-		ctl->retry_limit, keyidx, 0, flags, 0, 0);
+		ieee80211_get_tx_rate(sc->hw, info)->hw_value,
+		info->control.retry_limit, keyidx, 0, flags, 0, 0);
 	if (ret)
 		goto err_unmap;
 
@@ -1938,11 +1932,11 @@ next:
 static void
 ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 {
-	struct ieee80211_tx_status txs = {};
 	struct ath5k_tx_status ts = {};
 	struct ath5k_buf *bf, *bf0;
 	struct ath5k_desc *ds;
 	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
 	int ret;
 
 	spin_lock(&txq->lock);
@@ -1962,24 +1956,25 @@ ath5k_tx_processq(struct ath5k_softc *sc
 		}
 
 		skb = bf->skb;
+		info = (void*) skb->cb;
 		bf->skb = NULL;
+
 		pci_unmap_single(sc->pdev, bf->skbaddr, skb->len,
 				PCI_DMA_TODEVICE);
 
-		txs.control = bf->ctl;
-		txs.retry_count = ts.ts_shortretry + ts.ts_longretry / 6;
+		info->status.retry_count = ts.ts_shortretry + ts.ts_longretry / 6;
 		if (unlikely(ts.ts_status)) {
 			sc->ll_stats.dot11ACKFailureCount++;
 			if (ts.ts_status & AR5K_TXERR_XRETRY)
-				txs.excessive_retries = 1;
+				info->status.excessive_retries = 1;
 			else if (ts.ts_status & AR5K_TXERR_FILT)
-				txs.flags |= IEEE80211_TX_STATUS_TX_FILTERED;
+				info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 		} else {
-			txs.flags |= IEEE80211_TX_STATUS_ACK;
-			txs.ack_signal = ts.ts_rssi;
+			info->flags |= IEEE80211_TX_STAT_ACK;
+			info->status.ack_signal = ts.ts_rssi;
 		}
 
-		ieee80211_tx_status(sc->hw, skb, &txs);
+		ieee80211_tx_status(sc->hw, skb);
 		sc->tx_stats[txq->qnum].count++;
 
 		spin_lock(&sc->txbuflock);
@@ -2016,10 +2011,10 @@ ath5k_tasklet_tx(unsigned long data)
  * Setup the beacon frame for transmit.
  */
 static int
-ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
-		struct ieee80211_tx_control *ctl)
+ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 {
 	struct sk_buff *skb = bf->skb;
+	struct	ieee80211_tx_info *info = (void*) skb->cb;
 	struct ath5k_hw *ah = sc->ah;
 	struct ath5k_desc *ds;
 	int ret, antenna = 0;
@@ -2058,7 +2053,7 @@ ath5k_beacon_setup(struct ath5k_softc *s
 	ret = ah->ah_setup_tx_desc(ah, ds, skb->len,
 			ieee80211_get_hdrlen_from_skb(skb),
 			AR5K_PKT_TYPE_BEACON, (sc->power_level * 2),
-			ieee80211_get_tx_rate(sc->hw, ctl)->hw_value,
+			ieee80211_get_tx_rate(sc->hw, info)->hw_value,
 			1, AR5K_TXKEYIX_INVALID,
 			antenna, flags, 0, 0);
 	if (ret)
@@ -2637,11 +2632,11 @@ ath5k_led_event(struct ath5k_softc *sc, 
 \********************/
 
 static int
-ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-			struct ieee80211_tx_control *ctl)
+ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_buf *bf;
+	struct ieee80211_tx_info *info = (void*) skb->cb;
 	unsigned long flags;
 	int hdrlen;
 	int pad;
@@ -2667,13 +2662,13 @@ ath5k_tx(struct ieee80211_hw *hw, struct
 		memmove(skb->data, skb->data+pad, hdrlen);
 	}
 
-	sc->led_txrate = ieee80211_get_tx_rate(hw, ctl)->hw_value;
+	sc->led_txrate = ieee80211_get_tx_rate(hw, info)->hw_value;
 
 	spin_lock_irqsave(&sc->txbuflock, flags);
 	if (list_empty(&sc->txbuf)) {
 		ATH5K_ERR(sc, "no further txbuf available, dropping packet\n");
 		spin_unlock_irqrestore(&sc->txbuflock, flags);
-		ieee80211_stop_queue(hw, ctl->queue);
+		ieee80211_stop_queue(hw, info->queue);
 		return -1;
 	}
 	bf = list_first_entry(&sc->txbuf, struct ath5k_buf, list);
@@ -2685,7 +2680,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct
 
 	bf->skb = skb;
 
-	if (ath5k_txbuf_setup(sc, bf, ctl)) {
+	if (ath5k_txbuf_setup(sc, bf)) {
 		bf->skb = NULL;
 		spin_lock_irqsave(&sc->txbuflock, flags);
 		list_add_tail(&bf->list, &sc->txbuf);
@@ -3063,8 +3058,7 @@ ath5k_reset_tsf(struct ieee80211_hw *hw)
 }
 
 static int
-ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-			struct ieee80211_tx_control *ctl)
+ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ath5k_softc *sc = hw->priv;
 	int ret;
@@ -3080,7 +3074,7 @@ ath5k_beacon_update(struct ieee80211_hw 
 
 	ath5k_txbuf_free(sc, sc->bbuf);
 	sc->bbuf->skb = skb;
-	ret = ath5k_beacon_setup(sc, sc->bbuf, ctl);
+	ret = ath5k_beacon_setup(sc, sc->bbuf);
 	if (ret)
 		sc->bbuf->skb = NULL;
 	else
--- everything.orig/drivers/net/wireless/ath5k/base.h	2008-05-11 00:02:06.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/base.h	2008-05-11 00:05:17.000000000 +0200
@@ -60,7 +60,6 @@ struct ath5k_buf {
 	dma_addr_t		daddr;	/* physical addr of desc */
 	struct sk_buff		*skb;	/* skbuff for buf */
 	dma_addr_t		skbaddr;/* physical addr of skb data */
-	struct ieee80211_tx_control ctl;
 };
 
 /*
--- everything.orig/drivers/net/wireless/rt2x00/rt2400pci.c	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2400pci.c	2008-05-11 00:05:17.000000000 +0200
@@ -1485,11 +1485,11 @@ static u64 rt2400pci_get_tsf(struct ieee
 	return tsf;
 }
 
-static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-				   struct ieee80211_tx_control *control)
+static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_intf *intf = vif_to_intf(control->vif);
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(skb);
+	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct queue_entry_priv_pci *entry_priv;
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
@@ -1505,14 +1505,18 @@ static int rt2400pci_beacon_update(struc
 	 * for our information.
 	 */
 	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
+
+	/*
+	 * Don't automatically kick the beacon queue.
+	 */
+	tx_info->flags &= ~IEEE80211_TX_CTL_READY_FOR_TX;
 
 	/*
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
 	skbdesc->desc = entry_priv->desc;
--- everything.orig/drivers/net/wireless/rt2x00/rt2500pci.c	2008-05-11 00:02:04.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2500pci.c	2008-05-11 00:05:17.000000000 +0200
@@ -1799,11 +1799,11 @@ static u64 rt2500pci_get_tsf(struct ieee
 	return tsf;
 }
 
-static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-				   struct ieee80211_tx_control *control)
+static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_intf *intf = vif_to_intf(control->vif);
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(skb);
+	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct queue_entry_priv_pci *entry_priv;
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
@@ -1820,14 +1820,18 @@ static int rt2500pci_beacon_update(struc
 	 * for our information.
 	 */
 	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
+
+	/*
+	 * Don't automatically kick the beacon queue.
+	 */
+	tx_info->flags &= ~IEEE80211_TX_CTL_READY_FOR_TX;
 
 	/*
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
 	skbdesc->desc = entry_priv->desc;
--- everything.orig/drivers/net/wireless/rt2x00/rt2500usb.c	2008-05-11 00:02:04.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2500usb.c	2008-05-11 00:05:17.000000000 +0200
@@ -1666,13 +1666,12 @@ static int rt2500usb_probe_hw(struct rt2
 /*
  * IEEE80211 stack callback functions.
  */
-static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
-				   struct sk_buff *skb,
-				   struct ieee80211_tx_control *control)
+static int rt2500usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct usb_device *usb_dev = rt2x00dev_usb_dev(rt2x00dev);
-	struct rt2x00_intf *intf = vif_to_intf(control->vif);
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(skb);
+	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct queue_entry_priv_usb_bcn *bcn_priv;
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
@@ -1691,7 +1690,12 @@ static int rt2500usb_beacon_update(struc
 	 * for our information.
 	 */
 	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
+
+	/*
+	 * Don't automatically kick the beacon queue.
+	 */
+	tx_info->flags &= ~IEEE80211_TX_CTL_READY_FOR_TX;
 
 	/*
 	 * Add the descriptor in front of the skb.
@@ -1704,7 +1708,6 @@ static int rt2500usb_beacon_update(struc
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data + intf->beacon->queue->desc_size;
 	skbdesc->data_len = skb->len - intf->beacon->queue->desc_size;
 	skbdesc->desc = skb->data;
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00.h	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00.h	2008-05-11 00:05:17.000000000 +0200
@@ -542,8 +542,7 @@ struct rt2x00lib_ops {
 			       struct sk_buff *skb,
 			       struct txentry_desc *txdesc);
 	int (*write_tx_data) (struct rt2x00_dev *rt2x00dev,
-			      struct data_queue *queue, struct sk_buff *skb,
-			      struct ieee80211_tx_control *control);
+			      struct data_queue *queue, struct sk_buff *skb);
 	int (*get_tx_data_len) (struct rt2x00_dev *rt2x00dev,
 				struct sk_buff *skb);
 	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev,
@@ -930,7 +929,6 @@ static inline u16 get_duration_res(const
  * rt2x00queue_create_tx_descriptor - Create TX descriptor from mac80211 input
  * @entry: The entry which will be used to transfer the TX frame.
  * @txdesc: rt2x00 TX descriptor which will be initialized by this function.
- * @control: mac80211 TX control structure from where we read the information.
  *
  * This function will initialize the &struct txentry_desc based on information
  * from mac80211. This descriptor can then be used by rt2x00lib and the drivers
@@ -943,8 +941,7 @@ static inline u16 get_duration_res(const
  * the &struct txentry_desc structure.
  */
 void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
-				      struct txentry_desc *txdesc,
-				      struct ieee80211_tx_control *control);
+				      struct txentry_desc *txdesc);
 
 /**
  * rt2x00queue_write_tx_descriptor - Write TX descriptor to hardware
@@ -1001,8 +998,7 @@ void rt2x00lib_rxdone(struct queue_entry
 /*
  * mac80211 handlers.
  */
-int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-		 struct ieee80211_tx_control *control);
+int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 int rt2x00mac_start(struct ieee80211_hw *hw);
 void rt2x00mac_stop(struct ieee80211_hw *hw);
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00dev.c	2008-05-11 00:02:04.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00dev.c	2008-05-11 00:05:17.000000000 +0200
@@ -415,7 +415,6 @@ static void rt2x00lib_intf_scheduled_ite
 	struct rt2x00_dev *rt2x00dev = data;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
 	struct sk_buff *skb;
-	struct ieee80211_tx_control control;
 	struct ieee80211_bss_conf conf;
 	int delayed_flags;
 
@@ -433,9 +432,9 @@ static void rt2x00lib_intf_scheduled_ite
 	spin_unlock(&intf->lock);
 
 	if (delayed_flags & DELAYED_UPDATE_BEACON) {
-		skb = ieee80211_beacon_get(rt2x00dev->hw, vif, &control);
-		if (skb && rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw,
-							     skb, &control))
+		skb = ieee80211_beacon_get(rt2x00dev->hw, vif);
+		if (skb &&
+		    rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw, skb))
 			dev_kfree_skb(skb);
 	}
 
@@ -494,8 +493,13 @@ void rt2x00lib_txdone(struct queue_entry
 		      struct txdone_entry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct skb_frame_desc *skbdesc;
-	struct ieee80211_tx_status tx_status;
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(entry->skb);
+
+	/*
+	 * Send frame to debugfs immediately, after this call is completed
+	 * we are going to overwrite the skb->cb array.
+	 */
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TXDONE, entry->skb);
 
 	/*
 	 * Update TX statistics.
@@ -508,21 +512,20 @@ void rt2x00lib_txdone(struct queue_entry
 	/*
 	 * Initialize TX status
 	 */
-	tx_status.flags = 0;
-	tx_status.ack_signal = 0;
-	tx_status.excessive_retries =
+	memset(&tx_info->status, 0, sizeof(tx_info->status));
+	tx_info->status.ack_signal = 0;
+	tx_info->status.excessive_retries =
 	    test_bit(TXDONE_EXCESSIVE_RETRY, &txdesc->flags);
-	tx_status.retry_count = txdesc->retry;
-	memcpy(&tx_status.control, txdesc->control, sizeof(*txdesc->control));
+	tx_info->status.retry_count = txdesc->retry;
 
-	if (!(tx_status.control.flags & IEEE80211_TXCTL_NO_ACK)) {
+	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		if (test_bit(TXDONE_SUCCESS, &txdesc->flags))
-			tx_status.flags |= IEEE80211_TX_STATUS_ACK;
+			tx_info->flags |= IEEE80211_TX_STAT_ACK;
 		else if (test_bit(TXDONE_FAILURE, &txdesc->flags))
 			rt2x00dev->low_level_stats.dot11ACKFailureCount++;
 	}
 
-	if (tx_status.control.flags & IEEE80211_TXCTL_USE_RTS_CTS) {
+	if (tx_info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {
 		if (test_bit(TXDONE_SUCCESS, &txdesc->flags))
 			rt2x00dev->low_level_stats.dot11RTSSuccessCount++;
 		else if (test_bit(TXDONE_FAILURE, &txdesc->flags))
@@ -530,19 +533,13 @@ void rt2x00lib_txdone(struct queue_entry
 	}
 
 	/*
-	 * Send the tx_status to debugfs. Only send the status report
-	 * to mac80211 when the frame originated from there. If this was
-	 * a extra frame coming through a mac80211 library call (RTS/CTS)
-	 * then we should not send the status report back.
-	 * If send to mac80211, mac80211 will clean up the skb structure,
-	 * otherwise we have to do it ourself.
+	 * Only send the status report to mac80211 when the frame
+	 * originated from there. If this was a extra frame coming through
+	 * a mac80211 library call (RTS/CTS) then we should not send the
+	 * status report back.
 	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TXDONE, entry->skb);
-
-	skbdesc = get_skb_frame_desc(entry->skb);
-	if (!(skbdesc->flags & FRAME_DESC_DRIVER_GENERATED))
-		ieee80211_tx_status_irqsafe(rt2x00dev->hw,
-					    entry->skb, &tx_status);
+	if (tx_info->flags & IEEE80211_TX_CTL_READY_FOR_TX)
+		ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb);
 	else
 		dev_kfree_skb_irq(entry->skb);
 	entry->skb = NULL;
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-05-11 00:02:04.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-05-11 00:05:17.000000000 +0200
@@ -31,14 +31,14 @@
 
 static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 				struct data_queue *queue,
-				struct sk_buff *frag_skb,
-				struct ieee80211_tx_control *control)
+				struct sk_buff *frag_skb)
 {
-	struct skb_frame_desc *skbdesc;
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(frag_skb);
+	struct ieee80211_tx_info *rts_info;
 	struct sk_buff *skb;
 	int size;
 
-	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
+	if (tx_info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
 		size = sizeof(struct ieee80211_cts);
 	else
 		size = sizeof(struct ieee80211_rts);
@@ -52,23 +52,36 @@ static int rt2x00mac_tx_rts_cts(struct r
 	skb_reserve(skb, rt2x00dev->hw->extra_tx_headroom);
 	skb_put(skb, size);
 
-	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
-		ieee80211_ctstoself_get(rt2x00dev->hw, control->vif,
-					frag_skb->data, frag_skb->len, control,
+	/*
+	 * Copy TX information over from original frame to
+	 * RTS/CTS frame. Note that we set the no encryption flag
+	 * since we don't want this frame to be encrypted.
+	 * RTS frames should be acked, while CTS-to-self frames
+	 * should not. The ready for TX flag is cleared to prevent
+	 * it being automatically send when the descriptor is
+	 * written to the hardware.
+	 */
+	memcpy(skb->cb, frag_skb->cb, sizeof(skb->cb));
+	rts_info = get_skb_tx_info(skb);
+	rts_info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
+	rts_info->flags &= ~IEEE80211_TX_CTL_USE_CTS_PROTECT;
+	rts_info->flags &= ~IEEE80211_TX_CTL_READY_FOR_TX;
+
+	if (tx_info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
+		rts_info->flags |= IEEE80211_TX_CTL_NO_ACK;
+	else
+		rts_info->flags &= ~IEEE80211_TX_CTL_NO_ACK;
+
+	if (tx_info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
+		ieee80211_ctstoself_get(rt2x00dev->hw, tx_info->control.vif,
+					frag_skb->data, size, tx_info,
 					(struct ieee80211_cts *)(skb->data));
 	else
-		ieee80211_rts_get(rt2x00dev->hw, control->vif,
-				  frag_skb->data, frag_skb->len, control,
+		ieee80211_rts_get(rt2x00dev->hw, tx_info->control.vif,
+				  frag_skb->data, size, tx_info,
 				  (struct ieee80211_rts *)(skb->data));
 
-	/*
-	 * Initialize skb descriptor
-	 */
-	skbdesc = get_skb_frame_desc(skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
-
-	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb, control)) {
+	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb)) {
 		WARNING(rt2x00dev, "Failed to send RTS/CTS frame.\n");
 		return NETDEV_TX_BUSY;
 	}
@@ -76,14 +89,13 @@ static int rt2x00mac_tx_rts_cts(struct r
 	return NETDEV_TX_OK;
 }
 
-int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-		 struct ieee80211_tx_control *control)
+int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(skb);
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
-	enum data_queue_qid qid = mac80211_queue_to_qid(control->queue);
+	enum data_queue_qid qid = mac80211_queue_to_qid(tx_info->queue);
 	struct data_queue *queue;
-	struct skb_frame_desc *skbdesc;
 	u16 frame_control;
 
 	/*
@@ -100,7 +112,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw
 	/*
 	 * Determine which queue to put packet on.
 	 */
-	if (control->flags & IEEE80211_TXCTL_SEND_AFTER_DTIM &&
+	if (tx_info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM &&
 	    test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags))
 		queue = rt2x00queue_get_queue(rt2x00dev, QID_ATIM);
 	else
@@ -125,33 +137,27 @@ int rt2x00mac_tx(struct ieee80211_hw *hw
 	 */
 	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
 	if (!is_rts_frame(frame_control) && !is_cts_frame(frame_control) &&
-	    (control->flags & (IEEE80211_TXCTL_USE_RTS_CTS |
-			       IEEE80211_TXCTL_USE_CTS_PROTECT)) &&
+	    (tx_info->flags & (IEEE80211_TX_CTL_USE_RTS_CTS |
+			       IEEE80211_TX_CTL_USE_CTS_PROTECT)) &&
 	    !rt2x00dev->ops->hw->set_rts_threshold) {
 		if (rt2x00queue_available(queue) <= 1) {
-			ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+			ieee80211_stop_queue(rt2x00dev->hw, tx_info->queue);
 			return NETDEV_TX_BUSY;
 		}
 
-		if (rt2x00mac_tx_rts_cts(rt2x00dev, queue, skb, control)) {
-			ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+		if (rt2x00mac_tx_rts_cts(rt2x00dev, queue, skb)) {
+			ieee80211_stop_queue(rt2x00dev->hw, tx_info->queue);
 			return NETDEV_TX_BUSY;
 		}
 	}
 
-	/*
-	 * Initialize skb descriptor
-	 */
-	skbdesc = get_skb_frame_desc(skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
-
-	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb, control)) {
-		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb)) {
+		ieee80211_stop_queue(rt2x00dev->hw, tx_info->queue);
 		return NETDEV_TX_BUSY;
 	}
 
 	if (rt2x00queue_full(queue))
-		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+		ieee80211_stop_queue(rt2x00dev->hw, tx_info->queue);
 
 	if (rt2x00dev->ops->lib->kick_tx_queue)
 		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, qid);
@@ -380,9 +386,7 @@ int rt2x00mac_config_interface(struct ie
 	if (conf->type != IEEE80211_IF_TYPE_AP || !conf->beacon)
 		return 0;
 
-	status = rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw,
-						   conf->beacon,
-						   conf->beacon_control);
+	status = rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw, conf->beacon);
 	if (status)
 		dev_kfree_skb(conf->beacon);
 
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00pci.c	2008-05-11 00:02:04.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00pci.c	2008-05-11 00:05:17.000000000 +0200
@@ -35,8 +35,7 @@
  * TX data handlers.
  */
 int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
-			    struct data_queue *queue, struct sk_buff *skb,
-			    struct ieee80211_tx_control *control)
+			    struct data_queue *queue, struct sk_buff *skb)
 {
 	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
@@ -64,19 +63,19 @@ int rt2x00pci_write_tx_data(struct rt2x0
 	 * for our information.
 	 */
 	entry->skb = skb;
-	rt2x00queue_create_tx_descriptor(entry, &txdesc, control);
+	rt2x00queue_create_tx_descriptor(entry, &txdesc);
 
 	/*
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_frame_desc(skb);
+	memset(skbdesc, 0, sizeof(*skbdesc));
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
 	skbdesc->desc = entry_priv->desc;
 	skbdesc->desc_len = queue->desc_size;
 	skbdesc->entry = entry;
 
-	memcpy(&entry_priv->control, control, sizeof(entry_priv->control));
 	memcpy(entry_priv->data, skb->data, skb->len);
 
 	rt2x00queue_write_tx_descriptor(entry, &txdesc);
@@ -164,9 +163,9 @@ void rt2x00pci_txdone(struct rt2x00_dev 
 		      struct txdone_entry_desc *txdesc)
 {
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
 	u32 word;
 
-	txdesc->control = &entry_priv->control;
 	rt2x00lib_txdone(entry, txdesc);
 
 	/*
@@ -187,7 +186,7 @@ void rt2x00pci_txdone(struct rt2x00_dev 
 	 * is reenabled when the txdone handler has finished.
 	 */
 	if (!rt2x00queue_full(entry->queue))
-		ieee80211_wake_queue(rt2x00dev->hw, entry_priv->control.queue);
+		ieee80211_wake_queue(rt2x00dev->hw, qid);
 
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_txdone);
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00pci.h	2008-05-11 00:02:04.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00pci.h	2008-05-11 00:05:17.000000000 +0200
@@ -91,8 +91,7 @@ rt2x00pci_register_multiwrite(struct rt2
  * TX data handlers.
  */
 int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
-			    struct data_queue *queue, struct sk_buff *skb,
-			    struct ieee80211_tx_control *control);
+			    struct data_queue *queue, struct sk_buff *skb);
 
 /**
  * struct queue_entry_priv_pci: Per entry PCI specific information
@@ -101,7 +100,6 @@ int rt2x00pci_write_tx_data(struct rt2x0
  * @desc_dma: DMA pointer to &desc.
  * @data: Pointer to device's entry memory.
  * @data_dma: DMA pointer to &data.
- * @control: mac80211 control structure used to transmit data.
  */
 struct queue_entry_priv_pci {
 	__le32 *desc;
@@ -109,8 +107,6 @@ struct queue_entry_priv_pci {
 
 	void *data;
 	dma_addr_t data_dma;
-
-	struct ieee80211_tx_control control;
 };
 
 /**
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00queue.c	2008-05-11 00:05:13.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00queue.c	2008-05-11 00:05:17.000000000 +0200
@@ -30,13 +30,13 @@
 #include "rt2x00lib.h"
 
 void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
-				      struct txentry_desc *txdesc,
-				      struct ieee80211_tx_control *control)
+				      struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(entry->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
 	struct ieee80211_rate *rate =
-	    ieee80211_get_tx_rate(rt2x00dev->hw, control);
+	    ieee80211_get_tx_rate(rt2x00dev->hw, tx_info);
 	const struct rt2x00_rate *hwrate;
 	unsigned int data_length;
 	unsigned int duration;
@@ -64,7 +64,7 @@ void rt2x00queue_create_tx_descriptor(st
 	/*
 	 * Check whether this frame is to be acked.
 	 */
-	if (!(control->flags & IEEE80211_TXCTL_NO_ACK))
+	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK))
 		__set_bit(ENTRY_TXD_ACK, &txdesc->flags);
 
 	/*
@@ -72,23 +72,20 @@ void rt2x00queue_create_tx_descriptor(st
 	 */
 	if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
 		__set_bit(ENTRY_TXD_BURST, &txdesc->flags);
-		if (is_rts_frame(frame_control)) {
+		if (is_rts_frame(frame_control))
 			__set_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags);
-			__set_bit(ENTRY_TXD_ACK, &txdesc->flags);
-		} else {
+		else
 			__set_bit(ENTRY_TXD_CTS_FRAME, &txdesc->flags);
-			__clear_bit(ENTRY_TXD_ACK, &txdesc->flags);
-		}
-		if (control->rts_cts_rate_idx >= 0)
+		if (tx_info->control.rts_cts_rate_idx >= 0)
 			rate =
-			    ieee80211_get_rts_cts_rate(rt2x00dev->hw, control);
+			    ieee80211_get_rts_cts_rate(rt2x00dev->hw, tx_info);
 	}
 
 	/*
 	 * Determine retry information.
 	 */
-	txdesc->retry_limit = control->retry_limit;
-	if (control->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT)
+	txdesc->retry_limit = tx_info->control.retry_limit;
+	if (tx_info->flags & IEEE80211_TX_CTL_LONG_RETRY_LIMIT)
 		__set_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags);
 
 	/*
@@ -113,7 +110,7 @@ void rt2x00queue_create_tx_descriptor(st
 	 */
 	if (test_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags)) {
 		txdesc->ifs = IFS_SIFS;
-	} else if (control->flags & IEEE80211_TXCTL_FIRST_FRAGMENT) {
+	} else if (tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT) {
 		__set_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags);
 		txdesc->ifs = IFS_BACKOFF;
 	} else {
@@ -167,7 +164,7 @@ void rt2x00queue_write_tx_descriptor(str
 				     struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(entry->skb);
 
 	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, entry->skb, txdesc);
 
@@ -179,11 +176,13 @@ void rt2x00queue_write_tx_descriptor(str
 
 	/*
 	 * We are done writing the frame to the queue entry,
-	 * if this entry is a RTS of CTS-to-self frame we are done,
-	 * otherwise we need to kick the queue.
+	 * also kick the queue in case the correct flags are set,
+	 * note that this will automatically filter beacons and
+	 * RTS/CTS frames since those frames don't have this flag
+	 * set.
 	 */
 	if (rt2x00dev->ops->lib->kick_tx_queue &&
-	    !(skbdesc->flags & FRAME_DESC_DRIVER_GENERATED))
+	    (tx_info->flags & IEEE80211_TX_CTL_READY_FOR_TX))
 		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev,
 						   entry->queue->qid);
 }
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00queue.h	2008-05-11 00:02:04.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00queue.h	2008-05-11 00:05:17.000000000 +0200
@@ -95,18 +95,19 @@ static inline enum data_queue_qid mac802
 /**
  * enum skb_frame_desc_flags: Flags for &struct skb_frame_desc
  *
- * @FRAME_DESC_DRIVER_GENERATED: Frame was generated inside driver
- *	and should not be reported back to mac80211 during txdone.
+ * No flags at this time
  */
+/*
 enum skb_frame_desc_flags {
-	FRAME_DESC_DRIVER_GENERATED = 1 << 0,
+
 };
+*/
 
 /**
  * struct skb_frame_desc: Descriptor information for the skb buffer
  *
- * This structure is placed over the skb->cb array, this means that
- * this structure should not exceed the size of that array (48 bytes).
+ * This structure is placed over the driver_data array, this means that
+ * this structure should not exceed the size of that array (40 bytes).
  *
  * @flags: Frame flags, see &enum skb_frame_desc_flags.
  * @data: Pointer to data part of frame (Start of ieee80211 header).
@@ -129,10 +130,24 @@ struct skb_frame_desc {
 	struct queue_entry *entry;
 };
 
+/**
+ * get_skb_tx_info - Obtain the mac80211 TX info from a sk_buff.
+ * @skb: &struct sk_buff from where we obtain the &struct ieee80211_tx_info
+ */
+static inline struct ieee80211_tx_info* get_skb_tx_info(struct sk_buff *skb)
+{
+	return (struct ieee80211_tx_info *)skb->cb;
+}
+
+/**
+ * get_skb_frame_desc - Obtain the rt2x00 frame descriptor from a sk_buff.
+ * @skb: &struct sk_buff from where we obtain the &struct skb_frame_desc
+ */
 static inline struct skb_frame_desc* get_skb_frame_desc(struct sk_buff *skb)
 {
-	BUILD_BUG_ON(sizeof(struct skb_frame_desc) > sizeof(skb->cb));
-	return (struct skb_frame_desc *)&skb->cb[0];
+	BUILD_BUG_ON(sizeof(struct skb_frame_desc) >
+		     IEEE80211_TX_INFO_DRIVER_DATA_SIZE);
+	return (struct skb_frame_desc *)&get_skb_tx_info(skb)->driver_data;
 }
 
 /**
@@ -189,12 +204,10 @@ enum txdone_entry_desc_flags {
  * Summary of information that has been read from the TX frame descriptor
  * after the device is done with transmission.
  *
- * @control: Control structure which was used to transmit the frame.
  * @flags: TX done flags (See &enum txdone_entry_desc_flags).
  * @retry: Retry count.
  */
 struct txdone_entry_desc {
-	struct ieee80211_tx_control *control;
 	unsigned long flags;
 	int retry;
 };
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00usb.c	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00usb.c	2008-05-11 00:05:17.000000000 +0200
@@ -129,9 +129,9 @@ static void rt2x00usb_interrupt_txdone(s
 {
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	struct txdone_entry_desc txdesc;
 	__le32 *txd = (__le32 *)entry->skb->data;
+	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
 	u32 word;
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
@@ -159,7 +159,6 @@ static void rt2x00usb_interrupt_txdone(s
 	else
 		__set_bit(TXDONE_FAILURE, &txdesc.flags);
 	txdesc.retry = 0;
-	txdesc.control = &entry_priv->control;
 
 	rt2x00lib_txdone(entry, &txdesc);
 
@@ -175,12 +174,11 @@ static void rt2x00usb_interrupt_txdone(s
 	 * is reenabled when the txdone handler has finished.
 	 */
 	if (!rt2x00queue_full(entry->queue))
-		ieee80211_wake_queue(rt2x00dev->hw, entry_priv->control.queue);
+		ieee80211_wake_queue(rt2x00dev->hw, qid);
 }
 
 int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
-			    struct data_queue *queue, struct sk_buff *skb,
-			    struct ieee80211_tx_control *control)
+			    struct data_queue *queue, struct sk_buff *skb)
 {
 	struct usb_device *usb_dev = rt2x00dev_usb_dev(rt2x00dev);
 	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
@@ -206,7 +204,7 @@ int rt2x00usb_write_tx_data(struct rt2x0
 	 * for our information.
 	 */
 	entry->skb = skb;
-	rt2x00queue_create_tx_descriptor(entry, &txdesc, control);
+	rt2x00queue_create_tx_descriptor(entry, &txdesc);
 
 	/*
 	 * Add the descriptor in front of the skb.
@@ -218,13 +216,13 @@ int rt2x00usb_write_tx_data(struct rt2x0
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_frame_desc(skb);
+	memset(skbdesc, 0, sizeof(*skbdesc));
 	skbdesc->data = skb->data + queue->desc_size;
 	skbdesc->data_len = skb->len - queue->desc_size;
 	skbdesc->desc = skb->data;
 	skbdesc->desc_len = queue->desc_size;
 	skbdesc->entry = entry;
 
-	memcpy(&entry_priv->control, control, sizeof(entry_priv->control));
 	rt2x00queue_write_tx_descriptor(entry, &txdesc);
 
 	/*
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00usb.h	2008-05-11 00:02:04.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00usb.h	2008-05-11 00:05:17.000000000 +0200
@@ -216,19 +216,15 @@ void rt2x00usb_disable_radio(struct rt2x
  * TX data handlers.
  */
 int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
-			    struct data_queue *queue, struct sk_buff *skb,
-			    struct ieee80211_tx_control *control);
+			    struct data_queue *queue, struct sk_buff *skb);
 
 /**
  * struct queue_entry_priv_usb: Per entry USB specific information
  *
  * @urb: Urb structure used for device communication.
- * @control: mac80211 control structure used to transmit data.
  */
 struct queue_entry_priv_usb {
 	struct urb *urb;
-
-	struct ieee80211_tx_control control;
 };
 
 /**
@@ -239,15 +235,12 @@ struct queue_entry_priv_usb {
  * with beacons.
  *
  * @urb: Urb structure used for device communication.
- * @control: mac80211 control structure used to transmit data.
  * @guardian_data: Set to 0, used for sending the guardian data.
  * @guardian_urb: Urb structure used to send the guardian data.
  */
 struct queue_entry_priv_usb_bcn {
 	struct urb *urb;
 
-	struct ieee80211_tx_control control;
-
 	unsigned int guardian_data;
 	struct urb *guardian_urb;
 };
--- everything.orig/drivers/net/wireless/rt2x00/rt61pci.c	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt61pci.c	2008-05-11 00:05:17.000000000 +0200
@@ -2358,11 +2358,11 @@ static u64 rt61pci_get_tsf(struct ieee80
 	return tsf;
 }
 
-static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-				 struct ieee80211_tx_control *control)
+static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_intf *intf = vif_to_intf(control->vif);
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(skb);
+	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct queue_entry_priv_pci *entry_priv;
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
@@ -2378,7 +2378,12 @@ static int rt61pci_beacon_update(struct 
 	 * for our information.
 	 */
 	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
+
+	/*
+	 * Don't automatically kick the beacon queue.
+	 */
+	tx_info->flags &= ~IEEE80211_TX_CTL_READY_FOR_TX;
 
 	entry_priv = intf->beacon->priv_data;
 	memset(entry_priv->desc, 0, intf->beacon->queue->desc_size);
@@ -2388,7 +2393,6 @@ static int rt61pci_beacon_update(struct 
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
 	skbdesc->desc = entry_priv->desc;
--- everything.orig/drivers/net/wireless/rt2x00/rt73usb.c	2008-05-11 00:02:05.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt73usb.c	2008-05-11 00:05:17.000000000 +0200
@@ -1949,11 +1949,11 @@ static u64 rt73usb_get_tsf(struct ieee80
 #define rt73usb_get_tsf	NULL
 #endif
 
-static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-				 struct ieee80211_tx_control *control)
+static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_intf *intf = vif_to_intf(control->vif);
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(skb);
+	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
 	unsigned int beacon_base;
@@ -1968,7 +1968,12 @@ static int rt73usb_beacon_update(struct 
 	 * for our information.
 	 */
 	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
+
+	/*
+	 * Don't automatically kick the beacon queue.
+	 */
+	tx_info->flags &= ~IEEE80211_TX_CTL_READY_FOR_TX;
 
 	/*
 	 * Add the descriptor in front of the skb.
@@ -1981,7 +1986,6 @@ static int rt73usb_beacon_update(struct 
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data + intf->beacon->queue->desc_size;
 	skbdesc->data_len = skb->len - intf->beacon->queue->desc_size;
 	skbdesc->desc = skb->data;

-- 

