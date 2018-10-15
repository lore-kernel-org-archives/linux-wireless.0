Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E027BC28CF8
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 05:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 847EF2086A
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 05:08:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ToK9G9jr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cbzFAhAn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 847EF2086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbeJOMvq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 08:51:46 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37646 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbeJOMvp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 08:51:45 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1001460C48; Mon, 15 Oct 2018 05:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539580090;
        bh=gLyd0x5nf73ViO8DD6sdvJ86ZplfNLQTBJq1uM2s8u4=;
        h=From:To:Cc:Subject:Date:From;
        b=ToK9G9jr3fV9DdDfsIqWB0YkdNl+iZJauPqLQibMqVewpFzHM+XPWAeIf3gCclCE7
         96yoXIxQW/HIpPfa33Q0ONhP+m8YUlO6tpC742Pv1PIjl1WVd7C8FB5qZbDWCBwjWd
         l7JSXKS+m222CQPY68Zx/AHPQXVom9I0/rzk0diw=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 560436024C;
        Mon, 15 Oct 2018 05:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539580089;
        bh=gLyd0x5nf73ViO8DD6sdvJ86ZplfNLQTBJq1uM2s8u4=;
        h=From:To:Cc:Subject:Date:From;
        b=cbzFAhAnD8Oz7gh8/Yjah2JB22b9Nje5a5ZtCY5mEyNd8YY+UcZuMBWgQC5ecJm98
         mRwNwazrGNlQW63Do7zfFaauq06sLtS52O1ujg6wHjCh0eBl8K1UQTmjGiNKNSuLMB
         UZTdQJ4+15tF4oOjT2u3hPdg+w49+hTohQVAOvZc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 560436024C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH] ath: fix frequent flase radar detection
Date:   Mon, 15 Oct 2018 10:37:27 +0530
Message-Id: <1539580047-22512-1-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Many number of false radar detection occurred in a noisy
environment in QCA4019, QCA9888 devices. By reducing
PRI_TOLERANCE to 6 and flushing out pulse queue by dpd_reset
if timestamp between current and previous pulse is lesser than
100ms helps to avoid/reduce this false radar detection
in the noisy environment.

Tested ath10k hw and fw:
	* QCA9888(10.4-3.5.1-00052)
	* QCA4019(10.4-3.2.1.1-00017)
	* QCA9984(10.4-3.6-00104)
	* QCA988X(10.2.4-1.0-00041)

Tested ath9k hw: AR9300

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 drivers/net/wireless/ath/ath.h                  | 2 ++
 drivers/net/wireless/ath/ath10k/mac.c           | 4 ++++
 drivers/net/wireless/ath/ath9k/init.c           | 1 +
 drivers/net/wireless/ath/dfs_pattern_detector.c | 4 +++-
 drivers/net/wireless/ath/dfs_pattern_detector.h | 2 +-
 5 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 7a364ec..2bf2d0c 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -184,6 +184,8 @@ struct ath_common {
 
 	int last_rssi;
 	struct ieee80211_supported_band sbands[NUM_NL80211_BANDS];
+
+	int dfs_pulse_valid_diff_ts;
 };
 
 static inline const struct ath_ps_ops *ath_ps_ops(struct ath_common *common)
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a1c2801..c93b81c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8275,6 +8275,8 @@ struct ath10k_vif *ath10k_get_arvif(struct ath10k *ar, u32 vdev_id)
 #define WRD_METHOD "WRDD"
 #define WRDD_WIFI  (0x07)
 
+#define ATH10K_DFS_PULSE_VALID_DIFF_TS 100
+
 static u32 ath10k_mac_wrdd_get_mcc(struct ath10k *ar, union acpi_object *wrdd)
 {
 	union acpi_object *mcc_pkg;
@@ -8642,6 +8644,8 @@ int ath10k_mac_register(struct ath10k *ar)
 	if (IS_ENABLED(CONFIG_ATH10K_DFS_CERTIFIED)) {
 		/* Init ath dfs pattern detector */
 		ar->ath_common.debug_mask = ATH_DBG_DFS;
+		ar->ath_common.dfs_pulse_valid_diff_ts =
+					ATH10K_DFS_PULSE_VALID_DIFF_TS;
 		ar->dfs_detector = dfs_pattern_detector_init(&ar->ath_common,
 							     NL80211_DFS_UNSET);
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c070a9e..7ea4460 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -696,6 +696,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	common->debug_mask = ath9k_debug;
 	common->btcoex_enabled = ath9k_btcoex_enable == 1;
 	common->disable_ani = false;
+	common->dfs_pulse_valid_diff_ts = 0;
 
 	/*
 	 * Platform quirks.
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index d52b31b..3dbf0ab 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -273,6 +273,7 @@ static void dpd_exit(struct dfs_pattern_detector *dpd)
 {
 	u32 i;
 	struct channel_detector *cd;
+	int diff_ts;
 
 	/*
 	 * pulses received for a non-supported or un-initialized
@@ -285,8 +286,9 @@ static void dpd_exit(struct dfs_pattern_detector *dpd)
 	if (cd == NULL)
 		return false;
 
+	diff_ts = event->ts - dpd->last_pulse_ts;
 	/* reset detector on time stamp wraparound, caused by TSF reset */
-	if (event->ts < dpd->last_pulse_ts)
+	if (diff_ts < dpd->common->dfs_pulse_valid_diff_ts)
 		dpd_reset(dpd);
 	dpd->last_pulse_ts = event->ts;
 
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.h b/drivers/net/wireless/ath/dfs_pattern_detector.h
index 18db6f4..6f419d4 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.h
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.h
@@ -24,7 +24,7 @@
 /* tolerated deviation of radar time stamp in usecs on both sides
  * TODO: this might need to be HW-dependent
  */
-#define PRI_TOLERANCE	16
+#define PRI_TOLERANCE	6
 
 /**
  * struct ath_dfs_pool_stats - DFS Statistics for global pools
-- 
1.9.1

