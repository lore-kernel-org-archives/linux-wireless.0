Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B57DC04AA5
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 17:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFB48214C3
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 17:59:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gNuipzbD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nd1qutyN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFB48214C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbeJPBpQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 21:45:16 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38886 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbeJPBpQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 21:45:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CC3C560B1E; Mon, 15 Oct 2018 17:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539626339;
        bh=iZwgu0FtGDGJfFn6u7NsocVKg55mdq+N/N/cKHHEQSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNuipzbDtgyLlJeWbTaHNtkptArNpJyrRxbQPUA+p2zhOUfCpmcvzoLfwqxynT9TA
         NZGAb1MYsK1A/ulPfa1IMotfr8kC4PWzOwPkVew3w8QMV9JcOkuB3nLxTqSVjf42yl
         bugd2rZQcOheZmcvOTqq/Puhko3uXHA/70N23j7o=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 32B3D6141A;
        Mon, 15 Oct 2018 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539626337;
        bh=iZwgu0FtGDGJfFn6u7NsocVKg55mdq+N/N/cKHHEQSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nd1qutyNyE08vqDkkEOSiKYg7yez7KeLc7SZx+0H8gFKt3Nfg5Xr9Mzopw0mikOjX
         1fF10joweN164pNXKAfsdLHZoRp+nrG+8KIb5DNvWRo5ewzvwq1oJ0FYIUnXVXQyQX
         esjDkpCAnQ4OgQ7p/j+JDNYx+0OTuGvEeidNBzWc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 32B3D6141A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 2/3] mac80211: Implement API to configure station specific rssi threshold
Date:   Mon, 15 Oct 2018 23:27:29 +0530
Message-Id: <1539626250-769-3-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
References: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Implement set_sta_mon_rssi_config API to configure station
specific rssi threshold value to monitor change in connected
station's signal strength.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 net/mac80211/cfg.c      |   91 +++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.c |    1 +
 net/mac80211/sta_info.h |   19 ++++++++++
 3 files changed, 111 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5162233..72d2b07 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3849,6 +3849,96 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	return drv_get_ftm_responder_stats(local, sdata, ftm_stats);
 }
 
+void sta_mon_rssi_config_free(struct sta_info *sta)
+{
+	kfree(sta->rssi_tholds);
+	sta->rssi_tholds = NULL;
+	sta->n_rssi_tholds = 0;
+}
+
+static void ieee80211_update_rssi_config(struct sta_info *sta)
+{
+	s32 last;
+	u32 hyst;
+	int i, n;
+
+	if (!sta->n_rssi_tholds)
+		return;
+
+	if (!sta->last_rssi_event_value)
+		sta->last_rssi_event_value =
+			-ewma_signal_read(&sta->rx_stats_avg.signal);
+
+	last = sta->last_rssi_event_value;
+	hyst = sta->rssi_hyst;
+	n = sta->n_rssi_tholds;
+
+	for (i = 0; i < n; i++)
+		if (last < sta->rssi_tholds[i])
+			break;
+
+	sta->rssi_low = i > 0 ? (sta->rssi_tholds[i - 1] - hyst) : S32_MIN;
+	sta->rssi_high = i < n ? (sta->rssi_tholds[i] + hyst - 1) : S32_MAX;
+}
+
+static int ieee80211_set_sta_mon_rssi_config(struct wiphy *wiphy,
+					     struct net_device *dev,
+					     const u8 *mac_addr,
+					     const s32 *rssi_tholds,
+					     u32 rssi_hyst, int n_rssi_tholds,
+					     bool fixed_thold)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	int ret = 0;
+
+	mutex_lock(&local->sta_mtx);
+
+	if (mac_addr) {
+		sta = sta_info_get_bss(sdata, mac_addr);
+		if (!sta) {
+			ret = -ENOENT;
+			goto out;
+		}
+
+		sta_mon_rssi_config_free(sta);
+		sta->rssi_hyst = rssi_hyst;
+		if (fixed_thold) {
+			if (n_rssi_tholds > 2) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			if (n_rssi_tholds == 1) {
+				sta->rssi_low = rssi_tholds[0];
+				sta->rssi_high = rssi_tholds[0];
+			} else {
+				sta->rssi_low = rssi_tholds[0];
+				sta->rssi_high = rssi_tholds[1];
+			}
+		} else {
+			const s32 *rssi_tholds;
+
+			rssi_tholds = kmemdup(rssi_tholds,
+					      n_rssi_tholds * sizeof(s32),
+					      GFP_KERNEL);
+			if (!rssi_tholds) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			sta->rssi_tholds = rssi_tholds;
+			sta->n_rssi_tholds = n_rssi_tholds;
+			ieee80211_update_rssi_config(sta);
+		}
+	}
+
+out:
+	mutex_unlock(&local->sta_mtx);
+	return ret;
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3944,4 +4034,5 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	.tx_control_port = ieee80211_tx_control_port,
 	.get_txq_stats = ieee80211_get_txq_stats,
 	.get_ftm_responder_stats = ieee80211_get_ftm_responder_stats,
+	.set_sta_mon_rssi_config = ieee80211_set_sta_mon_rssi_config,
 };
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index fb8c225..28e9a6b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1020,6 +1020,7 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
+	sta_mon_rssi_config_free(sta);
 
 	cleanup_single_sta(sta);
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 9a04327..acbad98 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -411,6 +411,9 @@ struct ieee80211_sta_rx_stats {
 	u64 msdu[IEEE80211_NUM_TIDS + 1];
 };
 
+struct sta_mon_rssi_config {
+};
+
 /*
  * The bandwidth threshold below which the per-station CoDel parameters will be
  * scaled to be more lenient (to prevent starvation of slow stations). This
@@ -482,6 +485,14 @@ struct ieee80211_sta_rx_stats {
  * @pcpu_rx_stats: per-CPU RX statistics, assigned only if the driver needs
  *	this (by advertising the USES_RSS hw flag)
  * @status_stats: TX status statistics
+ * @n_rssi_tholds: Number of thresholds passed by user
+ * @rssi_tholds: RSSI threshold limit passed by the user
+ * @rssi_low: RSSI lower threshold for this station, a zero value implies
+ *	disabled
+ * @rssi_high: RSSI upper threshold for this station
+ * @rssi_hyst: RSSI hysteresis for this station
+ * @last_rssi_event_value: Last RSSI value for this station triggered the
+ *	RSSI cross event.
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -583,6 +594,13 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+	int n_rssi_tholds;
+	const s32 *rssi_tholds;
+	s32 rssi_low;
+	s32 rssi_high;
+	u32 rssi_hyst;
+	s32 last_rssi_event_value;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
@@ -720,6 +738,7 @@ int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata,
 			  const u8 *addr);
 int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr);
+void sta_mon_rssi_config_free(struct sta_info *sta);
 
 void sta_info_recalc_tim(struct sta_info *sta);
 
-- 
1.7.9.5

