Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56804.mail.re3.yahoo.com ([66.196.97.78]:40116 "HELO
	web56804.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755250Ab0ERLo4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 07:44:56 -0400
Message-ID: <3685.21296.qm@web56804.mail.re3.yahoo.com>
Date: Tue, 18 May 2010 04:44:54 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH v1] wireless: fix several minor description typos
To: Dave <kilroyd@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4BF1B9EA.8060009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave,

Thanks for point my missteps. I did think about leaving the code you quoted intact, so basically I've omitted it with this version. After all, the patch is inessential to the code execution.


Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---
avoid word repetition

--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -715,7 +715,7 @@ ath5k_eeprom_convert_pcal_info_5111(stru
 
 		/* Only one curve for RF5111
 		 * find out which one and place
-		 * in in pd_curves.
+		 * in pd_curves.
 		 * Note: ee_x_gain is reversed here */
 		for (idx = 0; idx < AR5K_EEPROM_N_PD_CURVES; idx++) {
 
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -459,7 +459,7 @@ struct ath9k_hw_version {
 #define AR_GENTMR_BIT(_index)	(1 << (_index))
 
 /*
- * Using de Bruijin sequence to to look up 1's index in a 32 bit number
+ * Using de Bruijin sequence to look up 1's index in a 32 bit number
  * debruijn32 = 0000 0111 0111 1100 1011 0101 0011 0001
  */
 #define debruijn32 0x077CB531U
--- a/drivers/net/wireless/iwmc3200wifi/hal.c
+++ b/drivers/net/wireless/iwmc3200wifi/hal.c
@@ -54,7 +54,7 @@
  *   LMAC. If you look at LMAC commands you'll se that they
  *   are actually regular iwlwifi target commands encapsulated
  *   into a special UMAC command called UMAC passthrough.
- *   This is due to the fact the the host talks exclusively
+ *   This is due to the fact the host talks exclusively
  *   to the UMAC and so there needs to be a special UMAC
  *   command for talking to the LMAC.
  *   This is how a wifi command is layed out:
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -666,7 +666,7 @@ void lbs_scan_worker(struct work_struct 
 /**
  *  @brief Interpret a BSS scan response returned from the firmware
  *
- *  Parse the various fixed fields and IEs passed back for a a BSS probe
+ *  Parse the various fixed fields and IEs passed back for a BSS probe
  *  response or beacon from the scan command.  Record information as needed
  *  in the scan table struct bss_descriptor for that entry.
  *
--- a/drivers/net/wireless/orinoco/hermes_dld.c
+++ b/drivers/net/wireless/orinoco/hermes_dld.c
@@ -68,7 +68,7 @@ struct dblock {
 } __attribute__ ((packed));
 
 /*
- * Plug Data References are located in in the image after the last data
+ * Plug Data References are located in the image after the last data
  * block.  They refer to areas in the adapter memory where the plug data
  * items with matching ID should be written.
  */
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -224,7 +224,7 @@ void rt2x00lib_txdone(struct queue_entry
 	/*
 	 * If the IV/EIV data was stripped from the frame before it was
 	 * passed to the hardware, we should now reinsert it again because
-	 * mac80211 will expect the the same data to be present it the
+	 * mac80211 will expect the same data to be present it the
 	 * frame as it was passed to us.
 	 */
 	if (test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags))
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -855,7 +855,7 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
 	if (skb == NULL)
 		return -ENOMEM;
 	if (need_padding) {
-		/* Make sure the the payload data is 4 byte aligned. */
+		/* Make sure the payload data is 4 byte aligned. */
 		skb_reserve(skb, 2);
 	}
 
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -844,7 +844,7 @@ out:
  * @usb: a &struct zd_usb pointer
  * @urb: URB to be freed
  *
- * Frees the the transmission URB, which means to put it on the free URB
+ * Frees the transmission URB, which means to put it on the free URB
  * list.
  */
 static void free_tx_urb(struct zd_usb *usb, struct urb *urb)

--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -132,7 +132,7 @@
  * 	%NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN and
  * 	%NL80211_ATTR_REG_RULE_POWER_MAX_EIRP.
  * @NL80211_CMD_REQ_SET_REG: ask the wireless core to set the regulatory domain
- * 	to the the specified ISO/IEC 3166-1 alpha2 country code. The core will
+ * 	to the specified ISO/IEC 3166-1 alpha2 country code. The core will
  * 	store this as a valid request and then query userspace for it.
  *
  * @NL80211_CMD_GET_MESH_PARAMS: Get mesh networking properties for the
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -90,7 +90,7 @@ enum ieee80211_channel_flags {
  * @max_power: maximum transmission power (in dBm)
  * @beacon_found: helper to regulatory code to indicate when a beacon
  *	has been found on this channel. Use regulatory_hint_found_beacon()
- *	to enable this, this is is useful only on 5 GHz band.
+ *	to enable this, this is useful only on 5 GHz band.
  * @orig_mag: internal use
  * @orig_mpwr: internal use
  */
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1767,7 +1767,7 @@ static void ieee80211_sta_work(struct wo
 
 	/*
 	 * ieee80211_queue_work() should have picked up most cases,
-	 * here we'll pick the the rest.
+	 * here we'll pick the rest.
 	 */
 	if (WARN(local->suspended, "STA MLME work scheduled while "
 		 "going to suspend\n"))
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -47,7 +47,7 @@ static void ieee80211_handle_filtered_fr
 	/*
 	 * This skb 'survived' a round-trip through the driver, and
 	 * hopefully the driver didn't mangle it too badly. However,
-	 * we can definitely not rely on the the control information
+	 * we can definitely not rely on the control information
 	 * being correct. Clear it so we don't get junk there, and
 	 * indicate that it needs new processing, but must not be
 	 * modified/encrypted again.
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -840,7 +840,7 @@ static void ieee80211_work_work(struct w
 
 	/*
 	 * ieee80211_queue_work() should have picked up most cases,
-	 * here we'll pick the the rest.
+	 * here we'll pick the rest.
 	 */
 	if (WARN(local->suspended, "work scheduled while going to suspend\n"))
 		return;



      
