Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_DKIM_INVALID,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A804DC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 05:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 440DF2145D
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 05:39:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jV9csJoM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dPygQPWD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 440DF2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbeIYLou (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 07:44:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50568 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbeIYLot (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 07:44:49 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0BE686078C; Tue, 25 Sep 2018 05:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1537853940;
        bh=SpM43Razkr/UM2ArAnemncpVQHRpG7FSMYLANvEoznY=;
        h=From:To:Cc:Subject:Date:From;
        b=jV9csJoMFqqIqbRKrprfJh22OtNM3V0I382cqK/g9dTOnuh8w2rTdBmx6eNyIK8hi
         SpLb7Zuz8QFFCjmLzBdBFQCYwUx7X6HK6WJmPS18wjqglqvqdG8ZA1JbxmHo1HQjlG
         LvDVNvCLKow1Mjrf+VbX//ope7t1XptKaYLp9aeI=
Received: from checstp253621-lin.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: srirrama@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 13F08606DC;
        Tue, 25 Sep 2018 05:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1537853939;
        bh=SpM43Razkr/UM2ArAnemncpVQHRpG7FSMYLANvEoznY=;
        h=From:To:Cc:Subject:Date:From;
        b=dPygQPWDrDSZDu92J0w9Dzr8wl9FJ/vhYQdoDeNpCne9lR1EsOO20+GncDUJeANer
         qo8uXiF+2AtRUWp+Ul4+/u0CnZ3yWmqiMLoXB8ve1jt+E56klLh8JjfM/9YwfgpB0t
         JVNC/P0HHKxtRebc+MrW/fxzDciWdbol0P+yngRI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 13F08606DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=srirrama@codeaurora.org
From:   Sriram R <srirrama@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [PATCH v2] ath10k: Add support for configuring management packet rate
Date:   Tue, 25 Sep 2018 11:08:18 +0530
Message-Id: <1537853898-3793-1-git-send-email-srirrama@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

By default the firmware uses 1Mbps and 6Mbps rate for management packets
in 2G and 5G bands respectively. But when the user selects different
basic rates from the userspace, we need to send the management
packets at the lowest basic rate selected by the user.

This change makes use of WMI_VDEV_PARAM_MGMT_RATE param for configuring the
management packets rate to the firmware.

Chipsets Tested : QCA988X, QCA9887, QCA9984
FW Tested 	: 10.2.4-1.0-41, 10.4-3.6.104

Signed-off-by: Sriram R <srirrama@codeaurora.org>
---
 v2:
     * Correction to ath10k_rates array indexing.
     * Usage of appropriate indent.

 drivers/net/wireless/ath/ath10k/mac.c | 45 +++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 97548f9..c0cde94 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -157,6 +157,22 @@ u8 ath10k_mac_bitrate_to_idx(const struct ieee80211_supported_band *sband,
 	return 0;
 }
 
+static int ath10k_mac_get_rate_hw_value(int bitrate)
+{
+	int i;
+	u8 hw_value_prefix = 0;
+
+	if (ath10k_mac_bitrate_is_cck(bitrate))
+		hw_value_prefix = WMI_RATE_PREAMBLE_CCK << 6;
+
+	for (i = 0; i < ARRAY_SIZE(ath10k_rates); i++) {
+		if (ath10k_rates[i].bitrate == bitrate)
+			return hw_value_prefix | ath10k_rates[i].hw_value;
+	}
+
+	return -EINVAL;
+}
+
 static int ath10k_mac_get_max_vht_mcs_map(u16 mcs_map, int nss)
 {
 	switch ((mcs_map >> (2 * nss)) & 0x3) {
@@ -5452,9 +5468,10 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	struct cfg80211_chan_def def;
 	u32 vdev_param, pdev_param, slottime, preamble;
 	u16 bitrate, hw_value;
-	u8 rate;
-	int rateidx, ret = 0;
+	u8 rate, basic_rate_idx;
+	int rateidx, ret = 0, hw_rate_code;
 	enum nl80211_band band;
+	const struct ieee80211_supported_band *sband;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -5660,6 +5677,30 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 				    arvif->vdev_id,  ret);
 	}
 
+	if (changed & BSS_CHANGED_BASIC_RATES) {
+		if (WARN_ON(ath10k_mac_vif_chan(vif, &def))) {
+			mutex_unlock(&ar->conf_mutex);
+			return;
+		}
+
+		sband = ar->hw->wiphy->bands[def.chan->band];
+		basic_rate_idx = ffs(vif->bss_conf.basic_rates) - 1;
+		bitrate = sband->bitrates[basic_rate_idx].bitrate;
+
+		hw_rate_code = ath10k_mac_get_rate_hw_value(bitrate);
+		if (hw_rate_code < 0) {
+			ath10k_warn(ar, "bitrate not supported %d\n", bitrate);
+			mutex_unlock(&ar->conf_mutex);
+			return;
+		}
+
+		vdev_param = ar->wmi.vdev_param->mgmt_rate;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
+						hw_rate_code);
+		if (ret)
+			ath10k_warn(ar, "failed to set mgmt tx rate %d\n", ret);
+	}
+
 	mutex_unlock(&ar->conf_mutex);
 }
 
-- 
2.7.4

