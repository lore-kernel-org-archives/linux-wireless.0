Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147AbXHXMcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 08:32:02 -0400
Message-Id: <20070824122904.808327000@sipsolutions.net>
References: <20070824122705.549190000@sipsolutions.net>
Date: Fri, 24 Aug 2007 14:27:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/15] mac80211: some more documentation
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch formats some documentation in mac80211.h into kerneldoc
and also adds some more explanations for hardware crypto.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h |  160 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 109 insertions(+), 51 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-24 13:45:14.449417211 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-24 13:46:02.979417211 +0200
@@ -227,24 +227,56 @@ struct ieee80211_tx_control {
 	int ifindex;	/* internal */
 };
 
-/* Receive status. The low-level driver should provide this information
- * (the subset supported by hardware) to the 802.11 code with each received
- * frame. */
+
+/**
+ * enum mac80211_rx_flags - receive flags
+ *
+ * These flags are used with the @flag member of &struct ieee80211_rx_status.
+ * @RX_FLAG_MMIC_ERROR: Michael MIC error was reported on this frame.
+ *	Use together with %RX_FLAG_MMIC_STRIPPED.
+ * @RX_FLAG_DECRYPTED: This frame was decrypted in hardware.
+ * @RX_FLAG_RADIOTAP: This frame starts with a radiotap header.
+ * @RX_FLAG_MMIC_STRIPPED: the Michael MIC is stripped off this frame,
+ *	verification has been done by the hardware.
+ * @RX_FLAG_IV_STRIPPED: The IV/ICV are stripped from this frame.
+ *	If this flag is set, the stack cannot do any replay detection
+ *	hence the driver or hardware will have to do that.
+ */
+enum mac80211_rx_flags {
+	RX_FLAG_MMIC_ERROR	= 1<<0,
+	RX_FLAG_DECRYPTED	= 1<<1,
+	RX_FLAG_RADIOTAP	= 1<<2,
+	RX_FLAG_MMIC_STRIPPED	= 1<<3,
+	RX_FLAG_IV_STRIPPED	= 1<<4,
+};
+
+/**
+ * struct ieee80211_rx_status - receive status
+ *
+ * The low-level driver should provide this information (the subset
+ * supported by hardware) to the 802.11 code with each received
+ * frame.
+ * @mactime: MAC timestamp as defined by 802.11
+ * @freq: frequency the radio was tuned to when receiving this frame, in MHz
+ * @channel: channel the radio was tuned to
+ * @phymode: active PHY mode
+ * @ssi: signal strength when receiving this frame
+ * @signal: used as 'qual' in statistics reporting
+ * @noise: PHY noise when receiving this frame
+ * @antenna: antenna used
+ * @rate: data rate
+ * @flag: %RX_FLAG_*
+ */
 struct ieee80211_rx_status {
 	u64 mactime;
-	int freq; /* receive frequency in Mhz */
+	int freq;
 	int channel;
 	int phymode;
 	int ssi;
-	int signal; /* used as qual in statistics reporting */
+	int signal;
 	int noise;
 	int antenna;
 	int rate;
-#define RX_FLAG_MMIC_ERROR	(1<<0)
-#define RX_FLAG_DECRYPTED	(1<<1)
-#define RX_FLAG_RADIOTAP	(1<<2)
-#define RX_FLAG_MMIC_STRIPPED	(1<<3)
-#define RX_FLAG_IV_STRIPPED	(1<<4)
 	int flag;
 };
 
@@ -394,68 +426,89 @@ struct ieee80211_if_conf {
 	struct ieee80211_tx_control *beacon_control;
 };
 
-typedef enum {
+/**
+ * enum ieee80211_key_alg - key algorithm
+ * @ALG_NONE: Unset key algorithm, will never be passed to the driver
+ * @ALG_WEP: WEP40 or WEP104
+ * @ALG_TKIP: TKIP
+ * @ALG_CCMP: CCMP (AES)
+ */
+typedef enum ieee80211_key_alg {
 	ALG_NONE,
 	ALG_WEP,
 	ALG_TKIP,
 	ALG_CCMP,
 } ieee80211_key_alg;
 
-/*
- * This flag indiciates that the station this key is being
- * configured for may use QoS. If your hardware cannot handle
- * that situation it should reject that key.
- */
-#define IEEE80211_KEY_FLAG_WMM_STA	(1<<0)
-/*
- * This flag should be set by the driver if it requires
- * IV generation in software for this key.
- */
-#define IEEE80211_KEY_FLAG_GENERATE_IV	(1<<1)
-/*
- * This flag should be set by the driver if it requires
- * MMIC generation in software for this key.
- */
-#define IEEE80211_KEY_FLAG_GENERATE_MMIC (1<<2)
 
+/**
+ * enum ieee80211_key_flags - key flags
+ *
+ * These flags are used for communication about keys between the driver
+ * and mac80211, with the @flags parameter of &struct ieee80211_key_conf.
+ *
+ * @IEEE80211_KEY_FLAG_WMM_STA: Set by mac80211, this flag indicates
+ *	that the STA this key will be used with could be using QoS.
+ * @IEEE80211_KEY_FLAG_GENERATE_IV: This flag should be set by the
+ *	driver to indicate that it requires IV generation for this
+ *	particular key.
+ * @IEEE80211_KEY_FLAG_GENERATE_MMIC: This flag should be set by
+ *	the driver for a TKIP key if it requires Michael MIC
+ *	generation in software.
+ */
+enum ieee80211_key_flags {
+	IEEE80211_KEY_FLAG_WMM_STA	= 1<<0,
+	IEEE80211_KEY_FLAG_GENERATE_IV	= 1<<1,
+	IEEE80211_KEY_FLAG_GENERATE_MMIC= 1<<2,
+};
+
+/**
+ * struct ieee80211_key_conf - key information
+ *
+ * This key information is given by mac80211 to the driver by
+ * the set_key() callback in &struct ieee80211_ops.
+ *
+ * @hw_key_idx: To be set by the driver, this is the key index the driver
+ *	wants to be given when a frame is transmitted and needs to be
+ *	encrypted in hardware. It defaults to %HW_KEY_IDX_INVALID which
+ *	the driver may not use.
+ * @alg: The key algorithm.
+ * @driver_keylist: for use by the driver
+ * @flags: key flags, see &enum ieee80211_key_flags.
+ * @keyidx: the key index (0-3)
+ * @keylen: key material length
+ * @key: key material
+ */
 struct ieee80211_key_conf {
-	/*
-	 * To be set by the driver to the key index it would like to
-	 * get in the ieee80211_tx_control.key_idx which defaults
-	 * to HW_KEY_IDX_INVALID so that shouldn't be used.
-	 */
 	int hw_key_idx;
-
-	/* key algorithm, ALG_NONE should never be seen by the driver */
 	ieee80211_key_alg alg;
-
-	/*
-	 * for use by the driver, named this way to avoid
-	 * accidental use in the stack
-	 */
 	struct list_head driver_keylist;
-
-	/* key flags, see above */
 	u8 flags;
-
-	/* key index: 0-3 */
 	s8 keyidx;
-
-	/* length of key material */
 	u8 keylen;
-
-	/* the key material */
 	u8 key[0];
 };
 
 #define IEEE80211_SEQ_COUNTER_RX	0
 #define IEEE80211_SEQ_COUNTER_TX	1
 
-typedef enum {
+/**
+ * enum set_key_cmd - key command
+ *
+ * Used with the set_key() callback in &struct ieee80211_ops, this
+ * indicates whether a key is being removed or added.
+ *
+ * @SET_KEY: a key is set
+ * @DISABLE_KEY: a key must be disabled
+ */
+typedef enum set_key_cmd {
 	SET_KEY, DISABLE_KEY,
 } set_key_cmd;
 
-/* This is driver-visible part of the per-hw state the stack keeps. */
+/**
+ * struct ieee80211_hw - hardware information and state
+ * TODO: move documentation into kernel-doc format
+ */
 struct ieee80211_hw {
 	/* points to the cfg80211 wiphy for this piece. Note
 	 * that you must fill in the perm_addr and dev fields
@@ -655,6 +708,11 @@ struct ieee80211_ops {
 	 * assigned to something other than HW_KEY_IDX_INVALID. When the cmd
 	 * is DISABLE_KEY then it must succeed.
 	 *
+	 * Note that it is permissible to not decrypt a frame even if a key
+	 * for it has been uploaded to hardware, the stack will not make any
+	 * decision based on whether a key has been uploaded or not but rather
+	 * based on the receive flags.
+	 *
 	 * This callback can sleep, and is only called between add_interface
 	 * and remove_interface calls, i.e. while the interface with the
 	 * given local_address is enabled.
@@ -1062,13 +1120,13 @@ ieee80211_get_mc_list_item(struct ieee80
 /**
  * ieee80211_key_removed - the driver removed a key from hardware accel
  *
- * @keyconf: The key config structure for the key that was removed.
- *
  * Call this function if for some reason you had to remove a key
  * from the hardware acceleration completely.
  * Note that after calling this function you will not get a
  * DISABLE_KEY notification via set_key() any more for this key,
  * it is assumed that you've removed it already.
+ *
+ * @keyconf: The key config structure for the key that was removed.
  */
 void ieee80211_key_removed(struct ieee80211_key_conf *keyconf);
 

-- 

