Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A67C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 11:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2C5D20989
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 11:04:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="j5qfwaxu";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="i+Q3LQjF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2C5D20989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbeKUViy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 16:38:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:32780 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbeKUViy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 16:38:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7FBDE6081E; Wed, 21 Nov 2018 11:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542798296;
        bh=WYMB2fYkdUWQnylRyLPiJHWlnZx1QgDs3YrtilEajdQ=;
        h=From:To:Cc:Subject:Date:From;
        b=j5qfwaxuq+c568k17Sr94KRL6vWJmOfrnHRtjdlrdUS5kif2O9g2lIDu5M86sL/Un
         YMUsGQ4L0YxmrNunY/+N5YDEdQO0P/Nf1SATX4vNi/NWDz47Iky9fHKfXVHCdvFrjs
         LQHNZMs+ENnFKcd3FWoSiC9Q3Uhvo6bWSawdIW/U=
Received: from vnaralas-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mpubbise@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 500866047C;
        Wed, 21 Nov 2018 11:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542798295;
        bh=WYMB2fYkdUWQnylRyLPiJHWlnZx1QgDs3YrtilEajdQ=;
        h=From:To:Cc:Subject:Date:From;
        b=i+Q3LQjFwM/2jGxtesX6TqsinZnr1HD1x0+mPuUD4BilnRerQd5q+T7JAL2h4q44U
         fQ3P4vsSFQciDaie1wscNjvY4KS1IhO3PMWYrRanlu9hvrvD7LeapONv43NVohaPOp
         LmBKrzfc3jQ9CqJ96jyA94iE9Qld8LsvevBM+Xg0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 500866047C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mpubbise@codeaurora.org
From:   Manikanta Pubbisetty <mpubbise@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: [PATCH v2] ath10k: add dynamic vlan support
Date:   Wed, 21 Nov 2018 16:34:48 +0530
Message-Id: <1542798288-8946-1-git-send-email-mpubbise@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Mutlicast/broadcast traffic destined for a particular vlan group will
always be encrypted in software. To enable dynamic VLANs, it requires
driver support for sending software encrypted packets.

In ath10k, sending sw encrypted frames is allowed only when we insmod
the driver with cryptmode param set to 1, this configuration disables
hardware crypto and enables RAW mode implicitly. Since, enabling raw
mode has performance impact, this cannot be considered as an ideal
solution for supporting VLANs in the driver.

As an alternative take, in this approach, cryptographic keys for
unicast traffic(per peer PTKs) and keys for non-vlan group traffic
will be configured in hardware, allowing hardware encryption for unicast
and non-vlan group traffic. Only vlan group traffic will be encrypted in
software and pushed to the target with encap mode set to RAW in the TX
descriptors.

Not all firmwares can support this type of key configuration(having few
keys installed in hardware and few only in software); for this purpose a
new WMI service flag "WMI_SERVICE_PER_PACKET_SW_ENCRYPT" is introduced to
advertise this support.

Also, adding the logic required to send sw encrypted frames in raw mode.

Hardwares Tested : QCA9984, QCA988X
Firmwares Tested : 10.4-3.5.3-00057, 10.2.4-1.0-00042

Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
---
This patch has dependency on mac80211 change
"{nl,mac}80211: allow 4addr AP operation on crypto controlled devices"

v2:
 Added support for QCA988X hardware

 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 26 ++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h  |  8 ++++++++
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d14a4f9..a26fd5f 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -116,6 +116,7 @@ enum ath10k_skb_flags {
 	ATH10K_SKB_F_DELIVER_CAB = BIT(2),
 	ATH10K_SKB_F_MGMT = BIT(3),
 	ATH10K_SKB_F_QOS = BIT(4),
+	ATH10K_SKB_F_RAW_TX = BIT(5),
 };
 
 struct ath10k_skb_cb {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c5130fa..bb19e50 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3396,6 +3396,7 @@ ath10k_mac_tx_h_get_txmode(struct ath10k *ar,
 			   struct sk_buff *skb)
 {
 	const struct ieee80211_hdr *hdr = (void *)skb->data;
+	const struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 	__le16 fc = hdr->frame_control;
 
 	if (!vif || vif->type == NL80211_IFTYPE_MONITOR)
@@ -3437,7 +3438,8 @@ ath10k_mac_tx_h_get_txmode(struct ath10k *ar,
 	if (ieee80211_is_data_present(fc) && sta && sta->tdls)
 		return ATH10K_HW_TXRX_ETHERNET;
 
-	if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
+	if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags) ||
+	    skb_cb->flags & ATH10K_SKB_F_RAW_TX)
 		return ATH10K_HW_TXRX_RAW;
 
 	return ATH10K_HW_TXRX_NATIVE_WIFI;
@@ -3547,6 +3549,9 @@ static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(skb);
+	const struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	bool is_data = ieee80211_is_data(hdr->frame_control) ||
+			ieee80211_is_data_qos(hdr->frame_control);
 
 	cb->flags = 0;
 	if (!ath10k_tx_h_use_hwcrypto(vif, skb))
@@ -3558,6 +3563,16 @@ static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
 	if (ieee80211_is_data_qos(hdr->frame_control))
 		cb->flags |= ATH10K_SKB_F_QOS;
 
+	/* Data frames encrypted in software will be posted to firmware
+	 * with tx encap mode set to RAW. Ex: Multicast traffic generated
+	 * for a specific VLAN group will always be encrypted in software.
+	 */
+	if (is_data && ieee80211_has_protected(hdr->frame_control) &&
+	    !info->control.hw_key) {
+		cb->flags |= ATH10K_SKB_F_NO_HWCRYPT;
+		cb->flags |= ATH10K_SKB_F_RAW_TX;
+	}
+
 	cb->vif = vif;
 	cb->txq = txq;
 }
@@ -3666,6 +3681,7 @@ static int ath10k_mac_tx(struct ath10k *ar,
 {
 	struct ieee80211_hw *hw = ar->hw;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	const struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 	int ret;
 
 	/* We should disable CCK RATE due to P2P */
@@ -3683,7 +3699,8 @@ static int ath10k_mac_tx(struct ath10k *ar,
 		ath10k_tx_h_8023(skb);
 		break;
 	case ATH10K_HW_TXRX_RAW:
-		if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+		if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags) &&
+		    !(skb_cb->flags & ATH10K_SKB_F_RAW_TX)) {
 			WARN_ON_ONCE(1);
 			ieee80211_free_txskb(hw, skb);
 			return -ENOTSUPP;
@@ -8696,6 +8713,11 @@ int ath10k_mac_register(struct ath10k *ar)
 		goto err_dfs_detector_exit;
 	}
 
+	if (test_bit(WMI_SERVICE_PER_PACKET_SW_ENCRYPT, ar->wmi.svc_map)) {
+		ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
+		ar->hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_AP_VLAN);
+	}
+
 	if (!ath_is_world_regd(&ar->ath_common.regulatory)) {
 		ret = regulatory_hint(ar->hw->wiphy,
 				      ar->ath_common.regulatory.alpha2);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 58e33ab..e054604 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -205,6 +205,7 @@ enum wmi_service {
 	WMI_SERVICE_SPOOF_MAC_SUPPORT,
 	WMI_SERVICE_TX_DATA_ACK_RSSI,
 	WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
+	WMI_SERVICE_PER_PACKET_SW_ENCRYPT,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -244,6 +245,8 @@ enum wmi_10x_service {
 	WMI_10X_SERVICE_PEER_STATS,
 	WMI_10X_SERVICE_RESET_CHIP,
 	WMI_10X_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS,
+	WMI_10X_SERVICE_VDEV_BCN_RATE_CONTROL,
+	WMI_10X_SERVICE_PER_PACKET_SW_ENCRYPT,
 };
 
 enum wmi_main_service {
@@ -474,6 +477,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_RESET_CHIP);
 	SVCSTR(WMI_SERVICE_TX_DATA_ACK_RSSI);
 	SVCSTR(WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT);
+	SVCSTR(WMI_SERVICE_PER_PACKET_SW_ENCRYPT);
 	default:
 		return NULL;
 	}
@@ -568,6 +572,8 @@ static inline void wmi_10x_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_RESET_CHIP, len);
 	SVCMAP(WMI_10X_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS,
 	       WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS, len);
+	SVCMAP(WMI_10X_SERVICE_PER_PACKET_SW_ENCRYPT,
+	       WMI_SERVICE_PER_PACKET_SW_ENCRYPT, len);
 }
 
 static inline void wmi_main_svc_map(const __le32 *in, unsigned long *out,
@@ -786,6 +792,8 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_TX_DATA_ACK_RSSI, len);
 	SVCMAP(WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
 	       WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT, len);
+	SVCMAP(WMI_10_4_SERVICE_PER_PACKET_SW_ENCRYPT,
+	       WMI_SERVICE_PER_PACKET_SW_ENCRYPT, len);
 }
 
 #undef SVCMAP
-- 
2.7.4

