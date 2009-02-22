Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:40499 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZBVMEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 07:04:40 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH] at76_usb: convert to use linux/ieee80211.h
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jason Andryuk <jandryuk@gmail.com>, linux-wireless@vger.kernel.org
Date: Sun, 22 Feb 2009 14:04:34 +0200
Message-ID: <20090222120434.20821.88974.stgit@tikku> (sfid-20090222_130445_106304_4AFCC7C8)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk noticed that at76_usb won't compile with current
wireless-testing tree. This is because net/ieee80211.h was missing.

net/ieee80211.h will be removed soon and at76_usb won't compile then that
happens. Preprare for that by using instead linux/ieee80211.h and copying
some structures not available.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/staging/at76_usb/at76_usb.c |   18 ++++---
 drivers/staging/at76_usb/at76_usb.h |   87 +++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/at76_usb/at76_usb.c b/drivers/staging/at76_usb/at76_usb.c
index c8e4d31..1d8eaf8 100644
--- a/drivers/staging/at76_usb/at76_usb.c
+++ b/drivers/staging/at76_usb/at76_usb.c
@@ -36,7 +36,7 @@
 #include <net/ieee80211_radiotap.h>
 #include <linux/firmware.h>
 #include <linux/leds.h>
-#include <net/ieee80211.h>
+#include <linux/ieee80211.h>
 
 #include "at76_usb.h"
 
@@ -1727,12 +1727,12 @@ static int at76_assoc_req(struct at76_priv *priv, struct bss_info *bss)
 
 	/* write TLV data elements */
 
-	ie->id = MFIE_TYPE_SSID;
+	ie->id = WLAN_EID_SSID;
 	ie->len = bss->ssid_len;
 	memcpy(ie->data, bss->ssid, bss->ssid_len);
 	next_ie(&ie);
 
-	ie->id = MFIE_TYPE_RATES;
+	ie->id = WLAN_EID_SUPP_RATES;
 	ie->len = sizeof(hw_rates);
 	memcpy(ie->data, hw_rates, sizeof(hw_rates));
 	next_ie(&ie);		/* ie points behind the supp_rates field */
@@ -4397,7 +4397,7 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 
 		switch (ie->id) {
 
-		case MFIE_TYPE_SSID:
+		case WLAN_EID_SSID:
 			if (have_ssid)
 				break;
 
@@ -4420,7 +4420,7 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 			have_ssid = 1;
 			break;
 
-		case MFIE_TYPE_RATES:
+		case WLAN_EID_SUPP_RATES:
 			if (have_rates)
 				break;
 
@@ -4433,7 +4433,7 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 				 hex2str(ie->data, ie->len));
 			break;
 
-		case MFIE_TYPE_DS_SET:
+		case WLAN_EID_DS_PARAMS:
 			if (have_channel)
 				break;
 
@@ -4443,9 +4443,9 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 				 priv->netdev->name, match->channel);
 			break;
 
-		case MFIE_TYPE_CF_SET:
-		case MFIE_TYPE_TIM:
-		case MFIE_TYPE_IBSS_SET:
+		case WLAN_EID_CF_PARAMS:
+		case WLAN_EID_TIM:
+		case WLAN_EID_IBSS_PARAMS:
 		default:
 			at76_dbg(DBG_RX_BEACON, "%s: beacon IE id %d len %d %s",
 				 priv->netdev->name, ie->id, ie->len,
diff --git a/drivers/staging/at76_usb/at76_usb.h b/drivers/staging/at76_usb/at76_usb.h
index b20be9d..6d60c6e 100644
--- a/drivers/staging/at76_usb/at76_usb.h
+++ b/drivers/staging/at76_usb/at76_usb.h
@@ -22,6 +22,93 @@
 #ifndef _AT76_USB_H
 #define _AT76_USB_H
 
+/*
+ * ieee80211 definitions copied from net/ieee80211.h
+ */
+
+#define WEP_KEY_LEN		13
+#define WEP_KEYS		4
+
+#define IEEE80211_DATA_LEN		2304
+/* Maximum size for the MA-UNITDATA primitive, 802.11 standard section
+   6.2.1.1.2.
+
+   The figure in section 7.1.2 suggests a body size of up to 2312
+   bytes is allowed, which is a bit confusing, I suspect this
+   represents the 2304 bytes of real data, plus a possible 8 bytes of
+   WEP IV and ICV. (this interpretation suggested by Ramiro Barreiro) */
+
+#define IEEE80211_1ADDR_LEN 10
+#define IEEE80211_2ADDR_LEN 16
+#define IEEE80211_3ADDR_LEN 24
+#define IEEE80211_4ADDR_LEN 30
+#define IEEE80211_FCS_LEN    4
+#define IEEE80211_HLEN			(IEEE80211_4ADDR_LEN)
+#define IEEE80211_FRAME_LEN		(IEEE80211_DATA_LEN + IEEE80211_HLEN)
+
+#define MIN_FRAG_THRESHOLD     256U
+#define	MAX_FRAG_THRESHOLD     2346U
+
+struct ieee80211_info_element {
+	u8 id;
+	u8 len;
+	u8 data[0];
+} __attribute__ ((packed));
+
+struct ieee80211_hdr_3addr {
+	__le16 frame_ctl;
+	__le16 duration_id;
+	u8 addr1[ETH_ALEN];
+	u8 addr2[ETH_ALEN];
+	u8 addr3[ETH_ALEN];
+	__le16 seq_ctl;
+	u8 payload[0];
+} __attribute__ ((packed));
+
+struct ieee80211_auth {
+	struct ieee80211_hdr_3addr header;
+	__le16 algorithm;
+	__le16 transaction;
+	__le16 status;
+	/* challenge */
+	struct ieee80211_info_element info_element[0];
+} __attribute__ ((packed));
+
+struct ieee80211_assoc_request {
+	struct ieee80211_hdr_3addr header;
+	__le16 capability;
+	__le16 listen_interval;
+	/* SSID, supported rates, RSN */
+	struct ieee80211_info_element info_element[0];
+} __attribute__ ((packed));
+
+struct ieee80211_probe_response {
+	struct ieee80211_hdr_3addr header;
+	__le32 time_stamp[2];
+	__le16 beacon_interval;
+	__le16 capability;
+	/* SSID, supported rates, FH params, DS params,
+	 * CF params, IBSS params, TIM (if beacon), RSN */
+	struct ieee80211_info_element info_element[0];
+} __attribute__ ((packed));
+
+/* Alias beacon for probe_response */
+#define ieee80211_beacon ieee80211_probe_response
+
+struct ieee80211_assoc_response {
+	struct ieee80211_hdr_3addr header;
+	__le16 capability;
+	__le16 status;
+	__le16 aid;
+	/* supported rates */
+	struct ieee80211_info_element info_element[0];
+} __attribute__ ((packed));
+
+struct ieee80211_disassoc {
+	struct ieee80211_hdr_3addr header;
+	__le16 reason;
+} __attribute__ ((packed));
+
 /* Board types */
 enum board_type {
 	BOARD_503_ISL3861 = 1,

