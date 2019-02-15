Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3FFC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 15:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB64C21925
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 15:19:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IH/hCjaW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lEjmHl/w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387724AbfBOPTr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 10:19:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42304 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfBOPTr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 10:19:47 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6922F605A0; Fri, 15 Feb 2019 15:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550243986;
        bh=dPpPGaFTanmxmOmTqCS5Oypq/njPkfmPx8rhRaKDsSg=;
        h=From:To:Cc:Subject:Date:From;
        b=IH/hCjaW6dEYJ3dgnvoIaMHMB53Em4Dfe0i/9cXYSlkW4uRFPAdbeMlk6hijNR3K1
         ac7nOVAmLaC43iQWOy5yK/amSnbSLJgF1bJcZqg/UKW2Io+vDdHnomD0z3ITqUzkcG
         0QB3xBmxpWrigOfyF8xzvhF5d1+hmy8ZSvMJG830=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6E2B76020A;
        Fri, 15 Feb 2019 15:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550243984;
        bh=dPpPGaFTanmxmOmTqCS5Oypq/njPkfmPx8rhRaKDsSg=;
        h=From:To:Cc:Subject:Date:From;
        b=lEjmHl/wCBa9NpuerGnQx9wXwAeKRC9Sxl+CDQjhh7Y7c1sxhlvlkxNFvs+CKNQYR
         rVq5fwMEVq5eOs4woP8Mu2Rtq7HwNyJ6pP0a4+S/YBcP6vWe9x7sYp3Y3pK4+lSZN4
         YzilESNETwz2Gd4klydjst+ExWFmV88xH3+nDKhs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6E2B76020A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH] ath10k: Fix length of wmi tlv command for protected mgmt frames
Date:   Fri, 15 Feb 2019 20:49:37 +0530
Message-Id: <1550243977-8612-1-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The length of wmi tlv command for management tx send is calculated
incorrectly in case of protected management frames as there is addition
of IEEE80211_CCMP_MIC_LEN twice. This leads to improper behaviour of
firmware as the wmi tlv mgmt tx send command for protected mgmt frames
is formed wrongly.

Fix the length calculation of wmi tlv command for mgmt tx send in case
of protected management frames by adding the IEEE80211_CCMP_MIC_LEN only
once.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Fixes: 1807da49733e "ath10k: wmi: add management tx by reference support over wmi"
Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 5d05bff..a1c28c1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2764,10 +2764,8 @@ static void *ath10k_wmi_tlv_put_wmm(void *ptr,
 	if ((ieee80211_is_action(hdr->frame_control) ||
 	     ieee80211_is_deauth(hdr->frame_control) ||
 	     ieee80211_is_disassoc(hdr->frame_control)) &&
-	     ieee80211_has_protected(hdr->frame_control)) {
-		len += IEEE80211_CCMP_MIC_LEN;
+	     ieee80211_has_protected(hdr->frame_control))
 		buf_len += IEEE80211_CCMP_MIC_LEN;
-	}
 
 	buf_len = min_t(u32, buf_len, WMI_TLV_MGMT_TX_FRAME_MAX_LEN);
 	buf_len = round_up(buf_len, 4);
-- 
1.9.1

