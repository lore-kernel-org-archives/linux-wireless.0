Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE23C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A235C20880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfA1Pmq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:42:46 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:17286 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726792AbfA1Pmp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:42:45 -0500
X-IronPort-AV: E=Sophos;i="5.56,534,1539640800"; 
   d="scan'208";a="1881349"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 28 Jan 2019 16:36:29 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9150"; a="7037499"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 28 Jan 2019 16:36:28 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH v2 01/12] wil6210: remove rtap_include_phy_info module param
Date:   Mon, 28 Jan 2019 17:36:15 +0200
Message-Id: <1548689786-23288-2-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
References: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

rtap_include_phy_info is not in use, hence can be removed.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 87 +++++----------------------------
 drivers/net/wireless/ath/wil6210/txrx.h |  7 +--
 drivers/net/wireless/ath/wil6210/wmi.c  |  4 +-
 3 files changed, 16 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 3e1c831..9877052 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -30,11 +30,6 @@
 #include "trace.h"
 #include "txrx_edma.h"
 
-static bool rtap_include_phy_info;
-module_param(rtap_include_phy_info, bool, 0444);
-MODULE_PARM_DESC(rtap_include_phy_info,
-		 " Include PHY info in the radiotap header, default - no");
-
 bool rx_align_2;
 module_param(rx_align_2, bool, 0444);
 MODULE_PARM_DESC(rx_align_2, " align Rx buffers on 4*n+2, default - no");
@@ -332,87 +327,31 @@ static void wil_rx_add_radiotap_header(struct wil6210_priv *wil,
 		u8 mcs_flags;
 		u8 mcs_index;
 	} __packed;
-	struct wil6210_rtap_vendor {
-		struct wil6210_rtap rtap;
-		/* vendor */
-		u8 vendor_oui[3] __aligned(2);
-		u8 vendor_ns;
-		__le16 vendor_skip;
-		u8 vendor_data[0];
-	} __packed;
 	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
-	struct wil6210_rtap_vendor *rtap_vendor;
+	struct wil6210_rtap *rtap;
 	int rtap_len = sizeof(struct wil6210_rtap);
-	int phy_length = 0; /* phy info header size, bytes */
-	static char phy_data[128];
 	struct ieee80211_channel *ch = wil->monitor_chandef.chan;
 
-	if (rtap_include_phy_info) {
-		rtap_len = sizeof(*rtap_vendor) + sizeof(*d);
-		/* calculate additional length */
-		if (d->dma.status & RX_DMA_STATUS_PHY_INFO) {
-			/**
-			 * PHY info starts from 8-byte boundary
-			 * there are 8-byte lines, last line may be partially
-			 * written (HW bug), thus FW configures for last line
-			 * to be excessive. Driver skips this last line.
-			 */
-			int len = min_t(int, 8 + sizeof(phy_data),
-					wil_rxdesc_phy_length(d));
-
-			if (len > 8) {
-				void *p = skb_tail_pointer(skb);
-				void *pa = PTR_ALIGN(p, 8);
-
-				if (skb_tailroom(skb) >= len + (pa - p)) {
-					phy_length = len - 8;
-					memcpy(phy_data, pa, phy_length);
-				}
-			}
-		}
-		rtap_len += phy_length;
-	}
-
 	if (skb_headroom(skb) < rtap_len &&
 	    pskb_expand_head(skb, rtap_len, 0, GFP_ATOMIC)) {
 		wil_err(wil, "Unable to expand headroom to %d\n", rtap_len);
 		return;
 	}
 
-	rtap_vendor = skb_push(skb, rtap_len);
-	memset(rtap_vendor, 0, rtap_len);
-
-	rtap_vendor->rtap.rthdr.it_version = PKTHDR_RADIOTAP_VERSION;
-	rtap_vendor->rtap.rthdr.it_len = cpu_to_le16(rtap_len);
-	rtap_vendor->rtap.rthdr.it_present = cpu_to_le32(
-			(1 << IEEE80211_RADIOTAP_FLAGS) |
+	rtap->rthdr.it_version = PKTHDR_RADIOTAP_VERSION;
+	rtap->rthdr.it_len = cpu_to_le16(rtap_len);
+	rtap->rthdr.it_present = cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
 			(1 << IEEE80211_RADIOTAP_CHANNEL) |
 			(1 << IEEE80211_RADIOTAP_MCS));
 	if (d->dma.status & RX_DMA_STATUS_ERROR)
-		rtap_vendor->rtap.flags |= IEEE80211_RADIOTAP_F_BADFCS;
-
-	rtap_vendor->rtap.chnl_freq = cpu_to_le16(ch ? ch->center_freq : 58320);
-	rtap_vendor->rtap.chnl_flags = cpu_to_le16(0);
-
-	rtap_vendor->rtap.mcs_present = IEEE80211_RADIOTAP_MCS_HAVE_MCS;
-	rtap_vendor->rtap.mcs_flags = 0;
-	rtap_vendor->rtap.mcs_index = wil_rxdesc_mcs(d);
-
-	if (rtap_include_phy_info) {
-		rtap_vendor->rtap.rthdr.it_present |= cpu_to_le32(1 <<
-				IEEE80211_RADIOTAP_VENDOR_NAMESPACE);
-		/* OUI for Wilocity 04:ce:14 */
-		rtap_vendor->vendor_oui[0] = 0x04;
-		rtap_vendor->vendor_oui[1] = 0xce;
-		rtap_vendor->vendor_oui[2] = 0x14;
-		rtap_vendor->vendor_ns = 1;
-		/* Rx descriptor + PHY data  */
-		rtap_vendor->vendor_skip = cpu_to_le16(sizeof(*d) +
-						       phy_length);
-		memcpy(rtap_vendor->vendor_data, (void *)d, sizeof(*d));
-		memcpy(rtap_vendor->vendor_data + sizeof(*d), phy_data,
-		       phy_length);
-	}
+		rtap->flags |= IEEE80211_RADIOTAP_F_BADFCS;
+
+	rtap->chnl_freq = cpu_to_le16(ch ? ch->center_freq : 58320);
+	rtap->chnl_flags = cpu_to_le16(0);
+
+	rtap->mcs_present = IEEE80211_RADIOTAP_MCS_HAVE_MCS;
+	rtap->mcs_flags = 0;
+	rtap->mcs_index = wil_rxdesc_mcs(d);
 }
 
 static bool wil_is_rx_idle(struct wil6210_priv *wil)
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index 9d83be4..bc81444 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2016 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -530,11 +530,6 @@ static inline int wil_rxdesc_mcast(struct vring_rx_desc *d)
 	return WIL_GET_BITS(d->mac.d1, 13, 14);
 }
 
-static inline int wil_rxdesc_phy_length(struct vring_rx_desc *d)
-{
-	return WIL_GET_BITS(d->dma.d0, 16, 29);
-}
-
 static inline struct vring_rx_desc *wil_skb_rxdesc(struct sk_buff *skb)
 {
 	return (void *)skb->cb;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 345f059..b1ba519 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -2516,7 +2516,7 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct wil_ring *vring)
 		if (ch)
 			cmd.sniffer_cfg.channel = ch->hw_value - 1;
 		cmd.sniffer_cfg.phy_info_mode =
-			cpu_to_le32(ndev->type == ARPHRD_IEEE80211_RADIOTAP);
+			cpu_to_le32(WMI_SNIFFER_PHY_INFO_DISABLED);
 		cmd.sniffer_cfg.phy_support =
 			cpu_to_le32((wil->monitor_flags & MONITOR_FLAG_CONTROL)
 				    ? WMI_SNIFFER_CP : WMI_SNIFFER_BOTH_PHYS);
-- 
1.9.1

