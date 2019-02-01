Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F57C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 05:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6E3A20863
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 05:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MjTSbjB2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RPQygYe7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbfBAFef (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 00:34:35 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfBAFee (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 00:34:34 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 604AE608C5; Fri,  1 Feb 2019 05:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548999273;
        bh=A2ssXpwHfRoPOu5Es9FccMPqeFHFVqZ4d+pUNDCy6c4=;
        h=From:To:Cc:Subject:Date:From;
        b=MjTSbjB22uDBJE75AR1zCoc2hR2AAJsou+++kCzb8ctuRFz6cAFyjzZXFbsMz3Vnf
         cHHuhfz3DRGcQiDR1UqdfW4rvgVT4+W1K3EwFQfEGtHTRCM+/hSgNw+cA+izloBwoY
         U9NyxO3CNkFbSZ9kKDC8ZcGZVMOZBuxcJiv1DgAs=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 761906043F;
        Fri,  1 Feb 2019 05:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548999272;
        bh=A2ssXpwHfRoPOu5Es9FccMPqeFHFVqZ4d+pUNDCy6c4=;
        h=From:To:Cc:Subject:Date:From;
        b=RPQygYe7LIf244IgfbZrl9KpLBqUPReOt3Pfb/Dk5QV5TFXjO1oDGHpZOlDO19puh
         2vaTaJ6ABXF0fOtQzEFDe8upjwepJkXorLt2IYeEM8k93XA5GMElj1vuKkUAnR8AzC
         ODJlOKE5+qLxTmMxqt7fKGF6yED9tw07dz73zkvo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 761906043F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH] ath10k: Add a condtion to fill the LDPC capability correctly
Date:   Fri,  1 Feb 2019 11:04:22 +0530
Message-Id: <1548999262-25353-1-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The firmware advertises the LDPC support information for HT in
HT capability info in the wmi service ready event. To provide
granularity, firmware now advertises WMI_HT_CAP_RX_LDPC and
WMI_HT_CAP_TX_LDPC separately. To support LDPC, host should
also check for WMI_HT_CAP_RX_LDPC and WMI_HT_CAP_TX_LDPC in HT
capabilities.

Add a condition to existing logic in host to know whether firmware
supports LDPC or not.

Tested HW: WCN3990
Tested SW: WLAN.HL.2.0

Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 ++-
 drivers/net/wireless/ath/ath10k/wmi.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e49b367..1645b1e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4549,7 +4549,8 @@ static struct ieee80211_sta_ht_cap ath10k_get_ht_cap(struct ath10k *ar)
 		ht_cap.cap |= stbc;
 	}
 
-	if (ar->ht_cap_info & WMI_HT_CAP_LDPC)
+	if (ar->ht_cap_info & WMI_HT_CAP_LDPC || (ar->ht_cap_info &
+	    WMI_HT_CAP_RX_LDPC && (ar->ht_cap_info & WMI_HT_CAP_TX_LDPC)))
 		ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
 
 	if (ar->ht_cap_info & WMI_HT_CAP_L_SIG_TXOP_PROT)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 427ca79..0aca84e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2076,6 +2076,8 @@ enum wmi_channel_change_cause {
 #define WMI_HT_CAP_MPDU_DENSITY           0x0700   /* MPDU Density */
 #define WMI_HT_CAP_MPDU_DENSITY_MASK_SHIFT 8
 #define WMI_HT_CAP_HT40_SGI               0x0800
+#define WMI_HT_CAP_RX_LDPC                0x1000   /* LDPC RX support */
+#define WMI_HT_CAP_TX_LDPC                0x2000   /* LDPC TX support */
 
 #define WMI_HT_CAP_DEFAULT_ALL (WMI_HT_CAP_ENABLED       | \
 				WMI_HT_CAP_HT20_SGI      | \
-- 
1.9.1

