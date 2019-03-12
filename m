Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA59CC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2EC5206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfCLXKr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:10:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:27628 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727258AbfCLXIQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 19:08:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 16:08:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,472,1544515200"; 
   d="scan'208";a="326744221"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga006.fm.intel.com with ESMTP; 12 Mar 2019 16:08:13 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H Peter Anvin" <hpa@zytor.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Michael Chan" <michael.chan@broadcom.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v5 03/18] wlcore: simplify/fix/optimize reg_ch_conf_pending operations
Date:   Tue, 12 Mar 2019 16:00:21 -0700
Message-Id: <1552431636-31511-4-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
References: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Bitmaps are defined on unsigned longs, so the usage of u32[2] in the
wlcore driver is incorrect.  As noted by Peter Zijlstra, casting arrays
to a bitmap is incorrect for big-endian architectures.

When looking at it I observed that:

- operations on reg_ch_conf_pending is always under the wl_lock mutex,
so set_bit is overkill

- the only case where reg_ch_conf_pending is accessed a u32 at a time is
unnecessary too.

This patch cleans up everything in this area, and changes tmp_ch_bitmap
to have the proper alignment.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c    | 15 ++++++---------
 drivers/net/wireless/ti/wlcore/wlcore.h |  4 ++--
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 348be0aed97e..3b9266989afe 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1700,14 +1700,14 @@ void wlcore_set_pending_regdomain_ch(struct wl1271 *wl, u16 channel,
 	ch_bit_idx = wlcore_get_reg_conf_ch_idx(band, channel);
 
 	if (ch_bit_idx >= 0 && ch_bit_idx <= WL1271_MAX_CHANNELS)
-		set_bit(ch_bit_idx, (long *)wl->reg_ch_conf_pending);
+		__set_bit_le(ch_bit_idx, (long *)wl->reg_ch_conf_pending);
 }
 
 int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
 {
 	struct wl12xx_cmd_regdomain_dfs_config *cmd = NULL;
 	int ret = 0, i, b, ch_bit_idx;
-	u32 tmp_ch_bitmap[2];
+	u32 tmp_ch_bitmap[2] __aligned(sizeof(unsigned long));
 	struct wiphy *wiphy = wl->hw->wiphy;
 	struct ieee80211_supported_band *band;
 	bool timeout = false;
@@ -1717,7 +1717,7 @@ int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_CMD, "cmd reg domain config");
 
-	memset(tmp_ch_bitmap, 0, sizeof(tmp_ch_bitmap));
+	memcpy(tmp_ch_bitmap, wl->reg_ch_conf_pending, sizeof(tmp_ch_bitmap));
 
 	for (b = NL80211_BAND_2GHZ; b <= NL80211_BAND_5GHZ; b++) {
 		band = wiphy->bands[b];
@@ -1738,13 +1738,10 @@ int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
 			if (ch_bit_idx < 0)
 				continue;
 
-			set_bit(ch_bit_idx, (long *)tmp_ch_bitmap);
+			__set_bit_le(ch_bit_idx, (long *)tmp_ch_bitmap);
 		}
 	}
 
-	tmp_ch_bitmap[0] |= wl->reg_ch_conf_pending[0];
-	tmp_ch_bitmap[1] |= wl->reg_ch_conf_pending[1];
-
 	if (!memcmp(tmp_ch_bitmap, wl->reg_ch_conf_last, sizeof(tmp_ch_bitmap)))
 		goto out;
 
@@ -1754,8 +1751,8 @@ int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
 		goto out;
 	}
 
-	cmd->ch_bit_map1 = cpu_to_le32(tmp_ch_bitmap[0]);
-	cmd->ch_bit_map2 = cpu_to_le32(tmp_ch_bitmap[1]);
+	cmd->ch_bit_map1 = tmp_ch_bitmap[0];
+	cmd->ch_bit_map2 = tmp_ch_bitmap[1];
 	cmd->dfs_region = wl->dfs_region;
 
 	wl1271_debug(DEBUG_CMD,
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index dd14850b0603..870eea3e7a27 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -320,9 +320,9 @@ struct wl1271 {
 	bool watchdog_recovery;
 
 	/* Reg domain last configuration */
-	u32 reg_ch_conf_last[2]  __aligned(8);
+	DECLARE_BITMAP(reg_ch_conf_last, 64);
 	/* Reg domain pending configuration */
-	u32 reg_ch_conf_pending[2];
+	DECLARE_BITMAP(reg_ch_conf_pending, 64);
 
 	/* Pointer that holds DMA-friendly block for the mailbox */
 	void *mbox;
-- 
2.19.1

