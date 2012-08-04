Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog028.obsmtp.com ([74.125.150.102]:43864 "EHLO
	na6sys009bog028.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab2HDBTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:19:44 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 08/16] mwifiex: separate file for handling AP events
Date: Fri,  3 Aug 2012 18:06:06 -0700
Message-Id: <1344042374-6892-9-git-send-email-bzhao@marvell.com> (sfid-20120804_031947_444130_1DDE1E9D)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Route AP events handling to separate function defined in
uap_event.c.
AP specific event handling is removed from sta_event.c.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/Makefile    |    1 +
 drivers/net/wireless/mwifiex/cmdevt.c    |    5 +-
 drivers/net/wireless/mwifiex/main.h      |    1 +
 drivers/net/wireless/mwifiex/sta_event.c |   49 +--------------
 drivers/net/wireless/mwifiex/uap_event.c |  100 ++++++++++++++++++++++++++++++
 5 files changed, 107 insertions(+), 49 deletions(-)
 create mode 100644 drivers/net/wireless/mwifiex/uap_event.c

diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index 3f66ebb..20932f2 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -33,6 +33,7 @@ mwifiex-y += uap_cmd.o
 mwifiex-y += ie.o
 mwifiex-y += sta_cmdresp.o
 mwifiex-y += sta_event.o
+mwifiex-y += uap_event.o
 mwifiex-y += sta_tx.o
 mwifiex-y += sta_rx.o
 mwifiex-y += cfg80211.o
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index c68adec..c229ddd 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -447,7 +447,10 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 			priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	}
 
-	ret = mwifiex_process_sta_event(priv);
+	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
+		ret = mwifiex_process_uap_event(priv);
+	else
+		ret = mwifiex_process_sta_event(priv);
 
 	adapter->event_cause = 0;
 	adapter->event_skb = NULL;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 5eeb17c..cac0c2d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -785,6 +785,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *, u16 cmdresp_no,
 int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *,
 				  struct sk_buff *skb);
 int mwifiex_process_sta_event(struct mwifiex_private *);
+int mwifiex_process_uap_event(struct mwifiex_private *);
 void *mwifiex_process_sta_txpd(struct mwifiex_private *, struct sk_buff *skb);
 int mwifiex_sta_init_cmd(struct mwifiex_private *, u8 first_sta);
 int mwifiex_cmd_802_11_scan(struct host_cmd_ds_command *cmd,
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index b8614a8..2aad148 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -184,10 +184,8 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 int mwifiex_process_sta_event(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	int len, ret = 0;
+	int ret = 0;
 	u32 eventcause = adapter->event_cause;
-	struct station_info sinfo;
-	struct mwifiex_assoc_event *event;
 
 	switch (eventcause) {
 	case EVENT_DUMMY_HOST_WAKEUP_SIGNAL:
@@ -405,51 +403,6 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		dev_dbg(adapter->dev, "event: HOSTWAKE_STAIE %d\n", eventcause);
 		break;
 
-	case EVENT_UAP_STA_ASSOC:
-		memset(&sinfo, 0, sizeof(sinfo));
-		event = (struct mwifiex_assoc_event *)
-			(adapter->event_body + MWIFIEX_UAP_EVENT_EXTRA_HEADER);
-		if (le16_to_cpu(event->type) == TLV_TYPE_UAP_MGMT_FRAME) {
-			len = -1;
-
-			if (ieee80211_is_assoc_req(event->frame_control))
-				len = 0;
-			else if (ieee80211_is_reassoc_req(event->frame_control))
-				/* There will be ETH_ALEN bytes of
-				 * current_ap_addr before the re-assoc ies.
-				 */
-				len = ETH_ALEN;
-
-			if (len != -1) {
-				sinfo.filled = STATION_INFO_ASSOC_REQ_IES;
-				sinfo.assoc_req_ies = &event->data[len];
-				len = (u8 *)sinfo.assoc_req_ies -
-				      (u8 *)&event->frame_control;
-				sinfo.assoc_req_ies_len =
-					le16_to_cpu(event->len) - (u16)len;
-			}
-		}
-		cfg80211_new_sta(priv->netdev, event->sta_addr, &sinfo,
-				 GFP_KERNEL);
-		break;
-	case EVENT_UAP_STA_DEAUTH:
-		cfg80211_del_sta(priv->netdev, adapter->event_body +
-				 MWIFIEX_UAP_EVENT_EXTRA_HEADER, GFP_KERNEL);
-		break;
-	case EVENT_UAP_BSS_IDLE:
-		priv->media_connected = false;
-		break;
-	case EVENT_UAP_BSS_ACTIVE:
-		priv->media_connected = true;
-		break;
-	case EVENT_UAP_BSS_START:
-		dev_dbg(adapter->dev, "AP EVENT: event id: %#x\n", eventcause);
-		memcpy(priv->netdev->dev_addr, adapter->event_body+2, ETH_ALEN);
-		break;
-	case EVENT_UAP_MIC_COUNTERMEASURES:
-		/* For future development */
-		dev_dbg(adapter->dev, "AP EVENT: event id: %#x\n", eventcause);
-		break;
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
 			eventcause);
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
new file mode 100644
index 0000000..5af60d8
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -0,0 +1,100 @@
+/*
+ * Marvell Wireless LAN device driver: AP event handling
+ *
+ * Copyright (C) 2012, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "main.h"
+
+/*
+ * This function handles AP interface specific events generated by firmware.
+ *
+ * Event specific routines are called by this function based
+ * upon the generated event cause.
+ *
+ *
+ * Events supported for AP -
+ *      - EVENT_UAP_STA_ASSOC
+ *      - EVENT_UAP_STA_DEAUTH
+ *      - EVENT_UAP_BSS_ACTIVE
+ *      - EVENT_UAP_BSS_START
+ *      - EVENT_UAP_BSS_IDLE
+ *      - EVENT_UAP_MIC_COUNTERMEASURES:
+ */
+int mwifiex_process_uap_event(struct mwifiex_private *priv)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	int len;
+	u32 eventcause = adapter->event_cause;
+	struct station_info sinfo;
+	struct mwifiex_assoc_event *event;
+
+	switch (eventcause) {
+	case EVENT_UAP_STA_ASSOC:
+		memset(&sinfo, 0, sizeof(sinfo));
+		event = (struct mwifiex_assoc_event *)
+			(adapter->event_body + MWIFIEX_UAP_EVENT_EXTRA_HEADER);
+		if (le16_to_cpu(event->type) == TLV_TYPE_UAP_MGMT_FRAME) {
+			len = -1;
+
+			if (ieee80211_is_assoc_req(event->frame_control))
+				len = 0;
+			else if (ieee80211_is_reassoc_req(event->frame_control))
+				/* There will be ETH_ALEN bytes of
+				 * current_ap_addr before the re-assoc ies.
+				 */
+				len = ETH_ALEN;
+
+			if (len != -1) {
+				sinfo.filled = STATION_INFO_ASSOC_REQ_IES;
+				sinfo.assoc_req_ies = &event->data[len];
+				len = (u8 *)sinfo.assoc_req_ies -
+				      (u8 *)&event->frame_control;
+				sinfo.assoc_req_ies_len =
+					le16_to_cpu(event->len) - (u16)len;
+			}
+		}
+		cfg80211_new_sta(priv->netdev, event->sta_addr, &sinfo,
+				 GFP_KERNEL);
+		break;
+	case EVENT_UAP_STA_DEAUTH:
+		cfg80211_del_sta(priv->netdev, adapter->event_body +
+				 MWIFIEX_UAP_EVENT_EXTRA_HEADER, GFP_KERNEL);
+		break;
+	case EVENT_UAP_BSS_IDLE:
+		priv->media_connected = false;
+		break;
+	case EVENT_UAP_BSS_ACTIVE:
+		priv->media_connected = true;
+		break;
+	case EVENT_UAP_BSS_START:
+		dev_dbg(adapter->dev, "AP EVENT: event id: %#x\n", eventcause);
+		memcpy(priv->netdev->dev_addr, adapter->event_body + 2,
+		       ETH_ALEN);
+		break;
+	case EVENT_UAP_MIC_COUNTERMEASURES:
+		/* For future development */
+		dev_dbg(adapter->dev, "AP EVENT: event id: %#x\n", eventcause);
+		break;
+	default:
+		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
+			eventcause);
+		break;
+	}
+
+	return 0;
+}
-- 
1.7.0.2

