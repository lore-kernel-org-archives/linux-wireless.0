Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FFF8C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 11:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FE482054F
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 11:30:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Zb1s1PNu";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jGxziGI4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbfAQLaG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 06:30:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55068 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfAQLaF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 06:30:05 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1967E6084F; Thu, 17 Jan 2019 11:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547724605;
        bh=klBJGSkacXRlfrcnAT3/uwvKK7TrHdnMtRU6XixNqlk=;
        h=From:To:Cc:Subject:Date:From;
        b=Zb1s1PNueICLABhep7SDwTgfAnDVB2ST2VaWjhDtBvDdshm3FracKaRo0R75qpFCX
         bfgVdfKvU6K7xeW8VE88kwjo+494bt+biEKtiDiX6k6gZc05sCZxSy/tUov8LXXfut
         OmxtT7UEJWxPYPgnxnRpps0UKs4E+lk61zm938C4=
Received: from checstex0244823-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bpothuno@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6CD27606E1;
        Thu, 17 Jan 2019 11:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547724603;
        bh=klBJGSkacXRlfrcnAT3/uwvKK7TrHdnMtRU6XixNqlk=;
        h=From:To:Cc:Subject:Date:From;
        b=jGxziGI48infUQuMqhpRhENCbhXGbZcDX4hdzZoYhlan+WdDhkfAYX4VcD6UWbB6c
         yd9dcQolJ3giGvecRfUJqBpAjWdAA4fV4ziwt3hInvZwdwO9rlyzYvGmt7GlOteOMA
         VxcOEnIA+vQ+7VCVmi1JqOfKeGzJj1PIFMZinYgI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6CD27606E1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bpothuno@codeaurora.org
From:   Balaji Pothunoori <bpothuno@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH 3/3] ath10k: add support for controlling tx power to a station
Date:   Thu, 17 Jan 2019 16:59:35 +0530
Message-Id: <1547724575-11666-1-git-send-email-bpothuno@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ashok Raj Nagarajan <arnagara@codeaurora.org>

This patch will add the support to control the transmit power for traffic
to a station associated with the AP. Userspace provide the transmit power
value in mBm units. ath10k firmware expects the value to be in dBm and
hence will convert the value from to dBm before passing down to firmware.

Underlying firmware will enforce that the maximum tx power will be based
on the regulatory requirements. If the user given transmit power is greater
than the allowed tx power in the given channel, then the firmware will use
the maximum tx power in the same channel.

When 0 is sent to the firmware as tx power, it will revert to the default
tx power for the station.

Tested Hardware : QCA9984
Tested Firmware : 10.4-3.9.0.1-00013

Co-developed-by: Balaji Pothunoori <bpothuno@codeaurora.org>
Signed-off-by: Ashok Raj Nagarajan <arnagara@codeaurora.org>
Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/debug.h |  3 +++
 drivers/net/wireless/ath/ath10k/mac.c   | 40 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h   | 18 +++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 5cf16d6..1a01093 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -82,6 +82,9 @@ struct ath10k_pktlog_hdr {
 /* FIXME: How to calculate the buffer size sanely? */
 #define ATH10K_FW_STATS_BUF_SIZE (1024 * 1024)
 
+#define ATH10K_TX_POWER_MAX_VAL 70
+#define ATH10K_TX_POWER_MIN_VAL 0
+
 extern unsigned int ath10k_debug_mask;
 
 __printf(2, 3) void ath10k_info(struct ath10k *ar, const char *fmt, ...);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e49b367..abf3805 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6281,6 +6281,41 @@ static void ath10k_mac_dec_num_stations(struct ath10k_vif *arvif,
 	ar->num_stations--;
 }
 
+static int ath10k_sta_set_txpwr(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_vif *arvif = (void *)vif->drv_priv;
+	int ret = 0;
+	s16 txpwr;
+
+	if (sta->type == NL80211_TX_POWER_AUTOMATIC) {
+		txpwr = 0;
+	} else {
+		txpwr = MBM_TO_DBM(sta->txpwr);
+		if (!txpwr)
+			return -EINVAL;
+	}
+
+	if (txpwr > ATH10K_TX_POWER_MAX_VAL || txpwr < ATH10K_TX_POWER_MIN_VAL)
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+
+	ret = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
+					WMI_PEER_USE_FIXED_PWR, txpwr);
+	if (ret) {
+		ath10k_warn(ar, "failed to set tx power for station ret: %d\n",
+			    ret);
+		goto out;
+	}
+
+out:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
 static int ath10k_sta_state(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta,
@@ -7938,6 +7973,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.set_key			= ath10k_set_key,
 	.set_default_unicast_key        = ath10k_set_default_unicast_key,
 	.sta_state			= ath10k_sta_state,
+	.sta_set_txpwr			= ath10k_sta_set_txpwr,
 	.conf_tx			= ath10k_conf_tx,
 	.remain_on_channel		= ath10k_remain_on_channel,
 	.cancel_remain_on_channel	= ath10k_cancel_remain_on_channel,
@@ -8617,6 +8653,10 @@ int ath10k_mac_register(struct ath10k *ar)
 		wiphy_ext_feature_set(ar->hw->wiphy,
 				      NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT);
 
+	if (test_bit(WMI_SERVICE_TX_PWR_PER_PEER, ar->wmi.svc_map))
+		wiphy_ext_feature_set(ar->hw->wiphy,
+				      NL80211_EXT_FEATURE_STA_TX_PWR);
+
 	/*
 	 * on LL hardware queues are managed entirely by the FW
 	 * so we only advertise to mac we can do the queues thing
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 2034ccc..2c5509a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -208,6 +208,14 @@ enum wmi_service {
 	WMI_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT,
 	WMI_SERVICE_BB_TIMING_CONFIG_SUPPORT,
 	WMI_SERVICE_THERM_THROT,
+	WMI_SERVICE_HTT_ASSERT_TRIGGER_SUPPORT,
+	WMI_SERVICE_VDEV_FILTER_NEIGHBOR_RX_PACKETS,
+	WMI_SERVICE_PEER_CHWIDTH_CHANGE,
+	WMI_SERVICE_RX_FILTER_OUT_COUNT,
+	WMI_SERVICE_RTT_RESPONDER_ROLE,
+	WMI_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT,
+	WMI_SERVICE_REPORT_AIRTIME,
+	WMI_SERVICE_TX_PWR_PER_PEER,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -368,6 +376,12 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_HTT_ASSERT_TRIGGER_SUPPORT,
 	WMI_10_4_SERVICE_VDEV_FILTER_NEIGHBOR_RX_PACKETS,
 	WMI_10_4_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT,
+	WMI_10_4_SERVICE_PEER_CHWIDTH_CHANGE,
+	WMI_10_4_SERVICE_RX_FILTER_OUT_COUNT,
+	WMI_10_4_SERVICE_RTT_RESPONDER_ROLE,
+	WMI_10_4_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT,
+	WMI_10_4_SERVICE_REPORT_AIRTIME,
+	WMI_10_4_SERVICE_TX_PWR_PER_PEER,
 };
 
 static inline char *wmi_service_name(int service_id)
@@ -483,6 +497,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_RESET_CHIP);
 	SVCSTR(WMI_SERVICE_TX_DATA_ACK_RSSI);
 	SVCSTR(WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT);
+	SVCSTR(WMI_SERVICE_TX_PWR_PER_PEER);
 	default:
 		return NULL;
 	}
@@ -799,6 +814,8 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT, len);
 	SVCMAP(WMI_10_4_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT,
 	       WMI_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT, len);
+	SVCMAP(WMI_10_4_SERVICE_TX_PWR_PER_PEER,
+	       WMI_SERVICE_TX_PWR_PER_PEER, len);
 }
 
 #undef SVCMAP
@@ -6210,6 +6227,7 @@ enum wmi_peer_param {
 	WMI_PEER_USE_4ADDR  = 0x6,
 	WMI_PEER_DEBUG      = 0xa,
 	WMI_PEER_PHYMODE    = 0xd,
+	WMI_PEER_USE_FIXED_PWR = 0x8,
 	WMI_PEER_DUMMY_VAR  = 0xff, /* dummy parameter for STA PS workaround */
 };
 
-- 
2.7.4

