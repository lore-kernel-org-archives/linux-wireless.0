Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B594C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 18:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9623620684
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 18:03:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JgRWZdCh";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JgRWZdCh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9623620684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbeJCAsB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 20:48:01 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56574 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbeJCAsA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 20:48:00 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EBFC260C4F; Tue,  2 Oct 2018 18:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538503404;
        bh=OOzWkRV0IvTKUIAGjKatQzjCfbwMCDuGEWcq+Be2cPg=;
        h=From:To:Cc:Subject:Date:From;
        b=JgRWZdCh6EVUhoin/zCjezdWa6CliCnVYH4ipB2QIoVThqc2ooYOeoV36yK8H51CW
         YELQxg1mKQiHpq3wN9spxbIUuNg6SyilBcd65QJqA3q3/IqrIKHYeZfZMhvAaYCRaQ
         FCGAR7O0XcTnCMsL2/r3dFmVSEYwWB1MwWq0v7LY=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0B8376031A;
        Tue,  2 Oct 2018 18:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538503404;
        bh=OOzWkRV0IvTKUIAGjKatQzjCfbwMCDuGEWcq+Be2cPg=;
        h=From:To:Cc:Subject:Date:From;
        b=JgRWZdCh6EVUhoin/zCjezdWa6CliCnVYH4ipB2QIoVThqc2ooYOeoV36yK8H51CW
         YELQxg1mKQiHpq3wN9spxbIUuNg6SyilBcd65QJqA3q3/IqrIKHYeZfZMhvAaYCRaQ
         FCGAR7O0XcTnCMsL2/r3dFmVSEYwWB1MwWq0v7LY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0B8376031A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] ath10k: Set probe request oui during driver start
Date:   Tue,  2 Oct 2018 23:33:13 +0530
Message-Id: <1538503393-17543-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently the wmi command for setting probe request
oui, needed for mac randomization, is sent during
the mac register. At this time, during the driver
init the wmi has already been detached. This can
cause unexpected behavior since the firmware is
already down and the wmi has been detached.

Send the wmi command for setting probe request
oui during the driver start. This will make sure
that the firmware is started and wmi is initialized
before we send this command.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Fixes: 60e1d0fb290197fe505dff6e4e3b7e4d258dbf60
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 97548f9..5e2f14b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4682,6 +4682,14 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto err_core_stop;
 	}
 
+	if (test_bit(WMI_SERVICE_SPOOF_MAC_SUPPORT, ar->wmi.svc_map)) {
+		ret = ath10k_wmi_scan_prob_req_oui(ar, ar->mac_addr);
+		if (ret) {
+			ath10k_err(ar, "failed to set prob req oui: %i\n", ret);
+			goto err_core_stop;
+		}
+	}
+
 	if (test_bit(WMI_SERVICE_ADAPTIVE_OCS, ar->wmi.svc_map)) {
 		ret = ath10k_wmi_adaptive_qcs(ar, true);
 		if (ret) {
@@ -8565,12 +8573,6 @@ int ath10k_mac_register(struct ath10k *ar)
 	}
 
 	if (test_bit(WMI_SERVICE_SPOOF_MAC_SUPPORT, ar->wmi.svc_map)) {
-		ret = ath10k_wmi_scan_prob_req_oui(ar, ar->mac_addr);
-		if (ret) {
-			ath10k_err(ar, "failed to set prob req oui: %i\n", ret);
-			goto err_dfs_detector_exit;
-		}
-
 		ar->hw->wiphy->features |=
 			NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 	}
-- 
2.7.4

