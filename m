Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E708FC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 08:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C57820643
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 08:31:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=narfation.org header.i=@narfation.org header.b="BNms+NR1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfCKIbS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 04:31:18 -0400
Received: from narfation.org ([79.140.41.39]:60802 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbfCKIbR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 04:31:17 -0400
Received: from sven-desktop.home.narfation.org (unknown [IPv6:2001:16b8:55da:29ea::88d])
        by v3-1039.vlinux.de (Postfix) with ESMTPSA id 5586911004F;
        Mon, 11 Mar 2019 09:31:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=narfation.org;
        s=20121; t=1552293074;
        bh=xFb8JiQCiuT5FeNZmcVrnzIZ4O3Vv0GRfziM4IwjuVM=;
        h=From:To:Cc:Subject:Date:From;
        b=BNms+NR1RZg2sbWNflzOdqLu48grHtmk4MvcqO3DQxqT4eMJqOY4xnJzcmSYqtSxf
         KvZoE/DsUGxJa+sVdWWE1VsOWiwtgj6DUNMnQm3MjyxCoYPat8XHOnGPwLBC0tMPv4
         UIrIRmY3p3jtloio5TNusiGoUvv1W740T+KiluGQ=
From:   Sven Eckelmann <sven@narfation.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Sven Eckelmann <seckelmann@datto.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sriram R <srirrama@codeaurora.org>
Subject: [PATCH] ath10k: avoid leaving .bss_info_changed prematurely
Date:   Mon, 11 Mar 2019 09:31:07 +0100
Message-Id: <20190311083107.311-1-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sven Eckelmann <seckelmann@datto.com>

ath10k_bss_info_changed() handles various events from the upper layers. It
parses the changed bitfield and then configures the driver/firmware
accordingly. Each detected event is handled in a separate scope which is
independent of each other - but in the same function.

The commit f279294e9ee2 ("ath10k: add support for configuring management
packet rate") changed this behavior by returning from this function
prematurely when some precondition was not fulfilled. All new event
handlers added after the BSS_CHANGED_BASIC_RATES event handler would then
also be skipped.

Signed-off-by: Sven Eckelmann <seckelmann@datto.com>
---
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Sriram R <srirrama@codeaurora.org>

Only compile tested
---
 drivers/net/wireless/ath/ath10k/mac.c | 64 ++++++++++++++++-----------
 1 file changed, 38 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b73c23d4ce86..b1d0741c7861 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5578,6 +5578,40 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 	mutex_unlock(&ar->conf_mutex);
 }
 
+static void ath10k_recalculate_mgmt_rate(struct ath10k *ar,
+					 struct ieee80211_vif *vif)
+{
+	struct ath10k_vif *arvif = (void *)vif->drv_priv;
+	const struct ieee80211_supported_band *sband;
+	struct cfg80211_chan_def def;
+	u8 basic_rate_idx;
+	int hw_rate_code;
+	u32 vdev_param;
+	u16 bitrate;
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (WARN_ON(ath10k_mac_vif_chan(vif, &def)))
+		return;
+
+	sband = ar->hw->wiphy->bands[def.chan->band];
+	basic_rate_idx = ffs(vif->bss_conf.basic_rates) - 1;
+	bitrate = sband->bitrates[basic_rate_idx].bitrate;
+
+	hw_rate_code = ath10k_mac_get_rate_hw_value(bitrate);
+	if (hw_rate_code < 0) {
+		ath10k_warn(ar, "bitrate not supported %d\n", bitrate);
+		return;
+	}
+
+	vdev_param = ar->wmi.vdev_param->mgmt_rate;
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
+					hw_rate_code);
+	if (ret)
+		ath10k_warn(ar, "failed to set mgmt tx rate %d\n", ret);
+}
+
 static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_bss_conf *info,
@@ -5588,10 +5622,9 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	struct cfg80211_chan_def def;
 	u32 vdev_param, pdev_param, slottime, preamble;
 	u16 bitrate, hw_value;
-	u8 rate, basic_rate_idx;
-	int rateidx, ret = 0, hw_rate_code;
+	u8 rate;
+	int rateidx, ret = 0;
 	enum nl80211_band band;
-	const struct ieee80211_supported_band *sband;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -5811,29 +5844,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 				    arvif->vdev_id,  ret);
 	}
 
-	if (changed & BSS_CHANGED_BASIC_RATES) {
-		if (WARN_ON(ath10k_mac_vif_chan(vif, &def))) {
-			mutex_unlock(&ar->conf_mutex);
-			return;
-		}
-
-		sband = ar->hw->wiphy->bands[def.chan->band];
-		basic_rate_idx = ffs(vif->bss_conf.basic_rates) - 1;
-		bitrate = sband->bitrates[basic_rate_idx].bitrate;
-
-		hw_rate_code = ath10k_mac_get_rate_hw_value(bitrate);
-		if (hw_rate_code < 0) {
-			ath10k_warn(ar, "bitrate not supported %d\n", bitrate);
-			mutex_unlock(&ar->conf_mutex);
-			return;
-		}
-
-		vdev_param = ar->wmi.vdev_param->mgmt_rate;
-		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
-						hw_rate_code);
-		if (ret)
-			ath10k_warn(ar, "failed to set mgmt tx rate %d\n", ret);
-	}
+	if (changed & BSS_CHANGED_BASIC_RATES)
+		ath10k_recalculate_mgmt_rate(ar, vif);
 
 	mutex_unlock(&ar->conf_mutex);
 }
-- 
2.20.1

