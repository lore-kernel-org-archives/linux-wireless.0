Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18467 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbYCECKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 21:10:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 05/11] mac80211: adding mac80211_tx_control_flags and HT flags
Date: Tue,  4 Mar 2008 18:09:26 -0800
Message-Id: <1204682972-26004-6-git-send-email-reinette.chatre@intel.com> (sfid-20080305_021038_546690_48517A50)
In-Reply-To: <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch makes enum from the defines previously dwelled inside
ieee80211_tx_control for better readability.
The patch also addes HT flags, for 802.11n drivers:
- IEEE80211_TXCTL_OFDM_HT: request low-level driver to use HT OFDM rates
- IEEE80211_TXCTL_GREEN_FIELD: use green field protection
- IEEE80211_TXCTL_DUP_DATA: duplicate data on both 20 Mhz channels
- IEEE80211_TXCTL_40_MHZ_WIDTH: send this frame in 40Mhz width
- IEEE80211_TXCTL_SHORT_GI: send this frame with short guard interval

Tx command can be a combination of any of these flags, along with
bitrate represented by ieee80211_rate. this will allow legacy drivers to
switch easily to any 11n rate representation.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
CC: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |   86 ++++++++++++++++++++++++++++++-----------------
 1 files changed, 55 insertions(+), 31 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d002b1c..cde1b49 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -205,6 +205,58 @@ struct ieee80211_bss_conf {
 	bool use_short_preamble;
 };
 
+/**
+ * enum mac80211_tx_control_flags - flags to describe Tx configuration for
+ * 				    the Tx frame
+ *
+ * These flags are used with the @flags member of &ieee80211_tx_control
+ *
+ * @IEEE80211_TXCTL_REQ_TX_STATUS: request TX status callback for this frame.
+ * @IEEE80211_TXCTL_DO_NOT_ENCRYPT: send this frame without encryption;
+ * 				    e.g., for EAPOL frame
+ * @IEEE80211_TXCTL_USE_RTS_CTS: use RTS-CTS before sending frame
+ * @IEEE80211_TXCTL_USE_CTS_PROTECT: use CTS protection for the frame (e.g.,
+ * 				     for combined 802.11g / 802.11b networks)
+ * @IEEE80211_TXCTL_NO_ACK: tell the low level not to wait for an ack
+ * @IEEE80211_TXCTL_RATE_CTRL_PROBE
+ * @EEE80211_TXCTL_CLEAR_PS_FILT: clear powersave filter
+ *                                 for destination station
+ * @IEEE80211_TXCTL_REQUEUE:
+ * @IEEE80211_TXCTL_FIRST_FRAGMENT: this is a first fragment of the frame
+ * @IEEE80211_TXCTL_LONG_RETRY_LIMIT: this frame should be send using the
+ * 				      through set_retry_limit configured long
+ * 				      retry value
+ * @IEEE80211_TXCTL_EAPOL_FRAME: internal to mac80211
+ * @IEEE80211_TXCTL_SEND_AFTER_DTIM: send this frame after DTIM beacon
+ * @IEEE80211_TXCTL_AMPDU: this frame should be sent as part of an A-MPDU
+ * @IEEE80211_TXCTL_OFDM_HT: this frame can be sent in HT OFDM rates
+ * @IEEE80211_TXCTL_GREEN_FIELD: use green field protection for this frame
+ * @IEEE80211_TXCTL_40_MHZ_WIDTH: send this frame using 40 Mhz channel width
+ * @IEEE80211_TXCTL_DUP_DATA: duplicate data frame on both 20 Mhz channels
+ * @IEEE80211_TXCTL_SHORT_GI: send this frame using short guard interval
+ */
+enum mac80211_tx_control_flags {
+	IEEE80211_TXCTL_REQ_TX_STATUS		= (1<<0),
+	IEEE80211_TXCTL_DO_NOT_ENCRYPT		= (1<<1),
+	IEEE80211_TXCTL_USE_RTS_CTS		= (1<<2),
+	IEEE80211_TXCTL_USE_CTS_PROTECT		= (1<<3),
+	IEEE80211_TXCTL_NO_ACK			= (1<<4),
+	IEEE80211_TXCTL_RATE_CTRL_PROBE		= (1<<5),
+	IEEE80211_TXCTL_CLEAR_PS_FILT		= (1<<6),
+	IEEE80211_TXCTL_REQUEUE			= (1<<7),
+	IEEE80211_TXCTL_FIRST_FRAGMENT		= (1<<8),
+	IEEE80211_TXCTL_SHORT_PREAMBLE		= (1<<9),
+	IEEE80211_TXCTL_LONG_RETRY_LIMIT	= (1<<10),
+	IEEE80211_TXCTL_EAPOL_FRAME		= (1<<11),
+	IEEE80211_TXCTL_SEND_AFTER_DTIM		= (1<<12),
+	IEEE80211_TXCTL_AMPDU			= (1<<13),
+	IEEE80211_TXCTL_OFDM_HT			= (1<<14),
+	IEEE80211_TXCTL_GREEN_FIELD		= (1<<15),
+	IEEE80211_TXCTL_40_MHZ_WIDTH		= (1<<16),
+	IEEE80211_TXCTL_DUP_DATA		= (1<<17),
+	IEEE80211_TXCTL_SHORT_GI		= (1<<18),
+};
+
 /* Transmit control fields. This data structure is passed to low-level driver
  * with each TX frame. The low-level driver is responsible for configuring
  * the hardware to use given values (depending on what is supported). */
@@ -219,42 +271,14 @@ struct ieee80211_tx_control {
 	/* retry rate for the last retries */
 	struct ieee80211_rate *alt_retry_rate;
 
-#define IEEE80211_TXCTL_REQ_TX_STATUS	(1<<0)/* request TX status callback for
-						* this frame */
-#define IEEE80211_TXCTL_DO_NOT_ENCRYPT	(1<<1) /* send this frame without
-						* encryption; e.g., for EAPOL
-						* frames */
-#define IEEE80211_TXCTL_USE_RTS_CTS	(1<<2) /* use RTS-CTS before sending
-						* frame */
-#define IEEE80211_TXCTL_USE_CTS_PROTECT	(1<<3) /* use CTS protection for the
-						* frame (e.g., for combined
-						* 802.11g / 802.11b networks) */
-#define IEEE80211_TXCTL_NO_ACK		(1<<4) /* tell the low level not to
-						* wait for an ack */
-#define IEEE80211_TXCTL_RATE_CTRL_PROBE	(1<<5)
-#define IEEE80211_TXCTL_CLEAR_PS_FILT	(1<<6) /* clear powersave filter
-						* for destination station */
-#define IEEE80211_TXCTL_REQUEUE		(1<<7)
-#define IEEE80211_TXCTL_FIRST_FRAGMENT	(1<<8) /* this is a first fragment of
-						* the frame */
-#define IEEE80211_TXCTL_SHORT_PREAMBLE	(1<<9)
-#define IEEE80211_TXCTL_LONG_RETRY_LIMIT (1<<10) /* this frame should be send
-						  * using the through
-						  * set_retry_limit configured
-						  * long retry value */
-#define IEEE80211_TXCTL_EAPOL_FRAME	(1<<11) /* internal to mac80211 */
-#define IEEE80211_TXCTL_SEND_AFTER_DTIM	(1<<12) /* send this frame after DTIM
-						 * beacon */
-#define IEEE80211_TXCTL_AMPDU		(1<<13) /* this frame should be sent
-						 * as part of an A-MPDU */
-	u32 flags;			       /* tx control flags defined
-						* above */
+	u32 flags;		/* tx control flags defined above */
 	u8 key_idx;		/* keyidx from hw->set_key(), undefined if
 				 * IEEE80211_TXCTL_DO_NOT_ENCRYPT is set */
 	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, ..
 				 * This could be used when set_retry_limit
 				 * is not implemented by the driver */
-	u8 antenna_sel_tx; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
+	u8 antenna_sel_tx; 	/* 0 = default/diversity, otherwise bit
+				 * position represents antenna number used */
 	u8 icv_len;		/* length of the ICV/MIC field in octets */
 	u8 iv_len;		/* length of the IV field in octets */
 	u8 queue;		/* hardware queue to use for this frame;
-- 
1.5.3.4

