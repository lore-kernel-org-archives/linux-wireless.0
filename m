Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0085.outbound.protection.outlook.com ([104.47.32.85]:59533
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752217AbdKMK2h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 05:28:37 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 06/10] qtnfmac: fix rssi data passed to wireless core
Date: Mon, 13 Nov 2017 13:28:11 +0300
Message-Id: <20171113102815.11254-7-sergey.matyukevich.os@quantenna.com> (sfid-20171113_112928_111205_965C8322)
In-Reply-To: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix RSSI values passed to wireless core by qtnfmac driver:
- fix RSSI values in scan results:
  driver registers wiphy with CFG80211_SIGNAL_TYPE_MBM signal type,
  so mBm should be passed using DBM_TO_MBM macro
- accompany firmware changes fixing RSSI values in received mgmt frames
  update qlink message format and pass correct signed values to core

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/event.c |  7 +++----
 drivers/net/wireless/quantenna/qtnfmac/qlink.h | 11 ++++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 9843ca36b74b..b3489b5b5d9e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -237,9 +237,8 @@ qtnf_event_handle_mgmt_received(struct qtnf_vif *vif,
 	pr_debug("%s LEN:%u FC:%.4X SA:%pM\n", vif->netdev->name, frame_len,
 		 le16_to_cpu(frame->frame_control), frame->addr2);
 
-	cfg80211_rx_mgmt(&vif->wdev, le32_to_cpu(rxmgmt->freq),
-			 le32_to_cpu(rxmgmt->sig_dbm), rxmgmt->frame_data,
-			 frame_len, flags);
+	cfg80211_rx_mgmt(&vif->wdev, le32_to_cpu(rxmgmt->freq), rxmgmt->sig_dbm,
+			 rxmgmt->frame_data, frame_len, flags);
 
 	return 0;
 }
@@ -324,7 +323,7 @@ qtnf_event_handle_scan_results(struct qtnf_vif *vif,
 				  sr->bssid, get_unaligned_le64(&sr->tsf),
 				  le16_to_cpu(sr->capab),
 				  le16_to_cpu(sr->bintval), ies, ies_len,
-				  sr->signal, GFP_KERNEL);
+				  DBM_TO_MBM(sr->sig_dbm), GFP_KERNEL);
 	if (!bss)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 3e3de4629a53..1f150be98820 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -19,7 +19,7 @@
 
 #include <linux/ieee80211.h>
 
-#define QLINK_PROTO_VER		7
+#define QLINK_PROTO_VER		8
 
 #define QLINK_MACID_RSVD		0xFF
 #define QLINK_VIFID_RSVD		0xFF
@@ -916,15 +916,16 @@ enum qlink_rxmgmt_flags {
  * struct qlink_event_rxmgmt - data for QLINK_EVENT_MGMT_RECEIVED event
  *
  * @freq: Frequency on which the frame was received in MHz.
- * @sig_dbm: signal strength in dBm.
  * @flags: bitmap of &enum qlink_rxmgmt_flags.
+ * @sig_dbm: signal strength in dBm.
  * @frame_data: data of Rx'd frame itself.
  */
 struct qlink_event_rxmgmt {
 	struct qlink_event ehdr;
 	__le32 freq;
-	__le32 sig_dbm;
 	__le32 flags;
+	s8 sig_dbm;
+	u8 rsvd[3];
 	u8 frame_data[0];
 } __packed;
 
@@ -936,7 +937,7 @@ struct qlink_event_rxmgmt {
  *	event was generated was discovered.
  * @capab: capabilities field.
  * @bintval: beacon interval announced by discovered BSS.
- * @signal: signal strength.
+ * @sig_dbm: signal strength in dBm.
  * @bssid: BSSID announced by discovered BSS.
  * @ssid_len: length of SSID announced by BSS.
  * @ssid: SSID announced by discovered BSS.
@@ -948,7 +949,7 @@ struct qlink_event_scan_result {
 	__le16 freq;
 	__le16 capab;
 	__le16 bintval;
-	s8 signal;
+	s8 sig_dbm;
 	u8 ssid_len;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 bssid[ETH_ALEN];
-- 
2.11.0
