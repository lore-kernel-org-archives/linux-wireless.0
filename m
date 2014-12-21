Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:45329 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbaLULoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 06:44:08 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 09/10] brcmfmac: signal completion of 802.1x.
Date: Sun, 21 Dec 2014 12:43:52 +0100
Message-ID: <1419162233-19492-10-git-send-email-arend@broadcom.com> (sfid-20141221_124416_792861_724F83F8)
In-Reply-To: <1419162233-19492-1-git-send-email-arend@broadcom.com>
References: <1419162233-19492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Use cfg80211 change_station to signal the completion of 802.1x
to firmware. This allows FW to take appropriate actions.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 30 ++++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/common.c   |  3 +++
 drivers/net/wireless/brcm80211/brcmfmac/common.h   | 20 +++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c |  6 ++---
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |  2 ++
 5 files changed, 57 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/common.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 2471dd5..c896fe2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -38,6 +38,7 @@
 #include "proto.h"
 #include "vendor.h"
 #include "bus.h"
+#include "common.h"
 
 #define BRCMF_SCAN_IE_LEN_MAX		2048
 #define BRCMF_PNO_VERSION		2
@@ -4241,6 +4242,34 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 	return err;
 }
 
+static int
+brcmf_cfg80211_change_station(struct wiphy *wiphy, struct net_device *ndev,
+			      const u8 *mac, struct station_parameters *params)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	s32 err;
+
+	brcmf_dbg(TRACE, "Enter, MAC %pM, mask 0x%04x set 0x%04x\n", mac,
+		  params->sta_flags_mask, params->sta_flags_set);
+
+	/* Ignore all 00 MAC */
+	if (is_zero_ether_addr(mac))
+		return 0;
+
+	if (!(params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED)))
+		return 0;
+
+	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_AUTHORIZED))
+		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SCB_AUTHORIZE,
+					     (void *)mac, ETH_ALEN);
+	else
+		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SCB_DEAUTHORIZE,
+					     (void *)mac, ETH_ALEN);
+	if (err < 0)
+		brcmf_err("Setting SCB (de-)authorize failed, %d\n", err);
+
+	return err;
+}
 
 static void
 brcmf_cfg80211_mgmt_frame_register(struct wiphy *wiphy,
@@ -4515,6 +4544,7 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	.stop_ap = brcmf_cfg80211_stop_ap,
 	.change_beacon = brcmf_cfg80211_change_beacon,
 	.del_station = brcmf_cfg80211_del_station,
+	.change_station = brcmf_cfg80211_change_station,
 	.sched_scan_start = brcmf_cfg80211_sched_scan_start,
 	.sched_scan_stop = brcmf_cfg80211_sched_scan_stop,
 	.mgmt_frame_register = brcmf_cfg80211_mgmt_frame_register,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/common.c b/drivers/net/wireless/brcm80211/brcmfmac/common.c
index 1861a13..ddf05af 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/common.c
@@ -25,6 +25,9 @@
 #include "fwil.h"
 #include "fwil_types.h"
 #include "tracepoint.h"
+#include "common.h"
+
+const u8 ALLFFMAC[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 #define BRCMF_DEFAULT_BCN_TIMEOUT	3
 #define BRCMF_DEFAULT_SCAN_CHANNEL_TIME	40
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/common.h b/drivers/net/wireless/brcm80211/brcmfmac/common.h
new file mode 100644
index 0000000..0d39d80
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/common.h
@@ -0,0 +1,20 @@
+/* Copyright (c) 2014 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef BRCMFMAC_COMMON_H
+#define BRCMFMAC_COMMON_H
+
+extern const u8 ALLFFMAC[ETH_ALEN];
+
+#endif /* BRCMFMAC_COMMON_H */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
index 44f3a84..910fbb5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
@@ -25,6 +25,7 @@
 #include "proto.h"
 #include "flowring.h"
 #include "msgbuf.h"
+#include "common.h"
 
 
 #define BRCMF_FLOWRING_HIGH		1024
@@ -34,9 +35,6 @@
 #define BRCMF_FLOWRING_HASH_AP(da, fifo, ifidx) (da[5] + fifo + ifidx * 16)
 #define BRCMF_FLOWRING_HASH_STA(fifo, ifidx) (fifo + ifidx * 16)
 
-static const u8 ALLZEROMAC[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
-static const u8 ALLFFMAC[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-
 static const u8 brcmf_flowring_prio2fifo[] = {
 	1,
 	0,
@@ -137,7 +135,7 @@ u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 	hash = flow->hash;
 	for (i = 0; i < BRCMF_FLOWRING_HASHSIZE; i++) {
 		if ((hash[hash_idx].ifidx == BRCMF_FLOWRING_INVALID_IFIDX) &&
-		    (memcmp(hash[hash_idx].mac, ALLZEROMAC, ETH_ALEN) == 0)) {
+		    (is_zero_ether_addr(hash[hash_idx].mac))) {
 			found = true;
 			break;
 		}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
index a30be68..3ede91d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
@@ -60,6 +60,8 @@
 #define BRCMF_C_GET_CURR_RATESET		114
 #define BRCMF_C_GET_AP				117
 #define BRCMF_C_SET_AP				118
+#define BRCMF_C_SET_SCB_AUTHORIZE		121
+#define BRCMF_C_SET_SCB_DEAUTHORIZE		122
 #define BRCMF_C_GET_RSSI			127
 #define BRCMF_C_GET_WSEC			133
 #define BRCMF_C_SET_WSEC			134
-- 
1.9.1

