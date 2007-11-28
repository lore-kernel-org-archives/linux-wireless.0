Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:8541 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbXK1IOV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 03:14:21 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: [PATCH] less eventcause shifts
Date: Wed, 28 Nov 2007 09:15:11 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711280915.11300.hs4233@mail.mn-solutions.de> (sfid-20071128_081426_933298_A16C01BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* only shift eventcause once

* convert mac events to decimal, as this is what the firmware
  manual uses in section 6.1, too

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-2.6/drivers/net/wireless/libertas/cmdresp.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/cmdresp.c	2007-11-28 10:07:27.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/cmdresp.c	2007-11-28 10:15:07.000000000 +0100
@@ -899,12 +899,12 @@ int lbs_process_event(struct lbs_private
 	lbs_deb_enter(LBS_DEB_CMD);
 
 	spin_lock_irq(&adapter->driver_lock);
-	eventcause = adapter->eventcause;
+	eventcause = adapter->eventcause >> SBI_EVENT_CAUSE_SHIFT;
 	spin_unlock_irq(&adapter->driver_lock);
 
-	lbs_deb_cmd("event cause 0x%x\n", eventcause);
+	lbs_deb_cmd("event cause %d\n", eventcause);
 
-	switch (eventcause >> SBI_EVENT_CAUSE_SHIFT) {
+	switch (eventcause) {
 	case MACREG_INT_CODE_LINK_SENSED:
 		lbs_deb_cmd("EVENT: MACREG_INT_CODE_LINK_SENSED\n");
 		break;
@@ -919,7 +919,7 @@ int lbs_process_event(struct lbs_private
 		lbs_mac_event_disconnected(priv);
 		break;
 
-	case MACREG_INT_CODE_LINK_LOSE_NO_SCAN:
+	case MACREG_INT_CODE_LINK_LOST_NO_SCAN:
 		lbs_deb_cmd("EVENT: link lost\n");
 		lbs_mac_event_disconnected(priv);
 		break;
@@ -1013,8 +1013,7 @@ int lbs_process_event(struct lbs_private
 		break;
 
 	default:
-		lbs_pr_alert("EVENT: unknown event id 0x%04x\n",
-		       eventcause >> SBI_EVENT_CAUSE_SHIFT);
+		lbs_pr_alert("EVENT: unknown event id %d\n", eventcause);
 		break;
 	}
 
Index: wireless-2.6/drivers/net/wireless/libertas/host.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/host.h	2007-11-28 10:07:40.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/host.h	2007-11-28 10:15:57.000000000 +0100
@@ -272,27 +272,35 @@ enum cmd_mesh_access_opts {
 };
 
 /** Card Event definition */
-#define MACREG_INT_CODE_TX_PPA_FREE             0x00000000
-#define MACREG_INT_CODE_TX_DMA_DONE             0x00000001
-#define MACREG_INT_CODE_LINK_LOSE_W_SCAN        0x00000002
-#define MACREG_INT_CODE_LINK_LOSE_NO_SCAN       0x00000003
-#define MACREG_INT_CODE_LINK_SENSED             0x00000004
-#define MACREG_INT_CODE_CMD_FINISHED            0x00000005
-#define MACREG_INT_CODE_MIB_CHANGED             0x00000006
-#define MACREG_INT_CODE_INIT_DONE               0x00000007
-#define MACREG_INT_CODE_DEAUTHENTICATED         0x00000008
-#define MACREG_INT_CODE_DISASSOCIATED           0x00000009
-#define MACREG_INT_CODE_PS_AWAKE                0x0000000a
-#define MACREG_INT_CODE_PS_SLEEP                0x0000000b
-#define MACREG_INT_CODE_MIC_ERR_MULTICAST       0x0000000d
-#define MACREG_INT_CODE_MIC_ERR_UNICAST         0x0000000e
-#define MACREG_INT_CODE_WM_AWAKE                0x0000000f
-#define MACREG_INT_CODE_ADHOC_BCN_LOST          0x00000011
-#define MACREG_INT_CODE_RSSI_LOW		0x00000019
-#define MACREG_INT_CODE_SNR_LOW			0x0000001a
-#define MACREG_INT_CODE_MAX_FAIL		0x0000001b
-#define MACREG_INT_CODE_RSSI_HIGH		0x0000001c
-#define MACREG_INT_CODE_SNR_HIGH		0x0000001d
-#define MACREG_INT_CODE_MESH_AUTO_STARTED	0x00000023
+#define MACREG_INT_CODE_TX_PPA_FREE             0
+#define MACREG_INT_CODE_TX_DMA_DONE             1
+#define MACREG_INT_CODE_LINK_LOST_W_SCAN        2
+#define MACREG_INT_CODE_LINK_LOST_NO_SCAN       3
+#define MACREG_INT_CODE_LINK_SENSED             4
+#define MACREG_INT_CODE_CMD_FINISHED            5
+#define MACREG_INT_CODE_MIB_CHANGED             6
+#define MACREG_INT_CODE_INIT_DONE               7
+#define MACREG_INT_CODE_DEAUTHENTICATED         8
+#define MACREG_INT_CODE_DISASSOCIATED           9
+#define MACREG_INT_CODE_PS_AWAKE                10
+#define MACREG_INT_CODE_PS_SLEEP                11
+#define MACREG_INT_CODE_MIC_ERR_MULTICAST       13
+#define MACREG_INT_CODE_MIC_ERR_UNICAST         14
+#define MACREG_INT_CODE_WM_AWAKE                15
+#define MACREG_INT_CODE_DEEP_SLEEP_AWAKE        16
+#define MACREG_INT_CODE_ADHOC_BCN_LOST          17
+#define MACREG_INT_CODE_HOST_AWAKE              18
+#define MACREG_INT_CODE_STOP_TX                 19
+#define MACREG_INT_CODE_START_TX                20
+#define MACREG_INT_CODE_CHANNEL_SWITCH          21
+#define MACREG_INT_CODE_MEASUREMENT_RDY         22
+#define MACREG_INT_CODE_WMM_CHANGE              23
+#define MACREG_INT_CODE_BG_SCAN_REPORT          24
+#define MACREG_INT_CODE_RSSI_LOW                25
+#define MACREG_INT_CODE_SNR_LOW                 26
+#define MACREG_INT_CODE_MAX_FAIL                27
+#define MACREG_INT_CODE_RSSI_HIGH               28
+#define MACREG_INT_CODE_SNR_HIGH                29
+#define MACREG_INT_CODE_MESH_AUTO_STARTED       35
 
 #endif
