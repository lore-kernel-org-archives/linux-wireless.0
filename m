Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2BA3C64EBC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 03:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2D0A2082A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 03:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Lck331Nd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FF2JIuKG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2D0A2082A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbeJCKBL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 06:01:11 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39680 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbeJCKBK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 06:01:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 74E5560C4B; Wed,  3 Oct 2018 03:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538536483;
        bh=Q/epmxPfZWOSXm2yub+nB1Diosj1iyWeC8VD56qhZp0=;
        h=From:To:Cc:Subject:Date:From;
        b=Lck331Nde8gfm4evAXeRByD5WFd/hUxTZEUgpWZtlxVHiFE0EqR2PoFrTndsi1u/0
         dW9CEFLtRH4Gj0nrw+RcpN+9mhOfbJVgnJbpLYGQ/RZSw+wJCizQsccxw0GC8EUuSJ
         zvHIJvKJ0XOs5l2x7OLN9kFZ7n4rWi+RyzAimvn0=
Received: from checstp253621-lin.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: srirrama@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 563AB60818;
        Wed,  3 Oct 2018 03:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538536482;
        bh=Q/epmxPfZWOSXm2yub+nB1Diosj1iyWeC8VD56qhZp0=;
        h=From:To:Cc:Subject:Date:From;
        b=FF2JIuKGfLCUFVGsgGFTU9l6fEHMNlref13/XeLJQx+LlbyU65U48tWDRrFFAV6Oz
         6x6ryYme5ycbRudS+vF3QqcDacGOOPTIHNVKH/vb6IewTJ64wMRNKlT2RuI4V8U6Wi
         j8NMXc/bKe0RIsKCjirAkAp0+HsHEh46PMcRypzs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 563AB60818
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=srirrama@codeaurora.org
From:   Sriram R <srirrama@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [PATCH] ath10k: Fix possible out of bound access of ath10k_rates array
Date:   Wed,  3 Oct 2018 08:43:50 +0530
Message-Id: <1538536430-6555-1-git-send-email-srirrama@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

While using 'ath10k_mac_get_rate_hw_value()' to obtain the hw value
from the passed bitrate, there is a chance of out of bound array access
when wrong bitrate is passed. This is fixed by comparing the bitrates
within the correct size of the ath10k_rates array.

Fixes commit f279294e9ee2 ("ath10k: add support for configuring management
packet rate")
(Also correction made to some indents used in the above commit)

Signed-off-by: Sriram R <srirrama@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3933dd9..1f1c1c7 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -164,7 +164,7 @@ static int ath10k_mac_get_rate_hw_value(int bitrate)
 	if (ath10k_mac_bitrate_is_cck(bitrate))
 		hw_value_prefix = WMI_RATE_PREAMBLE_CCK << 6;
 
-	for (i = 0; i < sizeof(ath10k_rates); i++) {
+	for (i = 0; i < ARRAY_SIZE(ath10k_rates); i++) {
 		if (ath10k_rates[i].bitrate == bitrate)
 			return hw_value_prefix | ath10k_rates[i].hw_value;
 	}
@@ -5682,22 +5682,22 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 			return;
 		}
 
-	sband = ar->hw->wiphy->bands[def.chan->band];
-	basic_rate_idx = ffs(vif->bss_conf.basic_rates) - 1;
-	bitrate = sband->bitrates[basic_rate_idx].bitrate;
+		sband = ar->hw->wiphy->bands[def.chan->band];
+		basic_rate_idx = ffs(vif->bss_conf.basic_rates) - 1;
+		bitrate = sband->bitrates[basic_rate_idx].bitrate;
 
-	hw_rate_code = ath10k_mac_get_rate_hw_value(bitrate);
-	if (hw_rate_code < 0) {
-		ath10k_warn(ar, "bitrate not supported %d\n", bitrate);
-		mutex_unlock(&ar->conf_mutex);
-		return;
-	}
+		hw_rate_code = ath10k_mac_get_rate_hw_value(bitrate);
+		if (hw_rate_code < 0) {
+			ath10k_warn(ar, "bitrate not supported %d\n", bitrate);
+			mutex_unlock(&ar->conf_mutex);
+			return;
+		}
 
-	vdev_param = ar->wmi.vdev_param->mgmt_rate;
-	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
-					hw_rate_code);
-	if (ret)
-		ath10k_warn(ar, "failed to set mgmt tx rate %d\n", ret);
+		vdev_param = ar->wmi.vdev_param->mgmt_rate;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
+						hw_rate_code);
+		if (ret)
+			ath10k_warn(ar, "failed to set mgmt tx rate %d\n", ret);
 	}
 
 	mutex_unlock(&ar->conf_mutex);
-- 
2.7.4

