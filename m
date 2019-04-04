Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4496AC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 18:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BBD6206DD
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 18:29:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W1Y4Rg/k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbfDDS3n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 14:29:43 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36029 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbfDDS3n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 14:29:43 -0400
Received: by mail-ot1-f67.google.com with SMTP id o74so3271332ota.3
        for <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2019 11:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DXjgDsQrDQ4x8a+yFMd3v4vW2/5WQu5mScrzHiIaNdI=;
        b=W1Y4Rg/kBjv14IY89T7fe8onsg0MspJzvxp2TZFYh214qXt+2ctw3xwWGXWW1Xfb5P
         +IhQiAhE7SpGoOAjXRF5x0FRD5nP7QzZB7MkOpOVfi+2Ppqxn5097OqxaAQ4V3lfZJRo
         9A3DQ5jxnLJYckDb4Cs2uqFAXKO52rPYG7VZFf39QvDIayuHta5jsoemDEt1g1neBXff
         oFcz3wQNYXK1RLq00vZdKvWueAAuMzlm4fIoSDco/3/I4nn14s/atLPYxW+LsEFSf2Ji
         t+qhG5+RLdACovFSnDbBSI1xdQW5Hr9+iDoPqoEqKD1yhqffbV0pTLZ/et2n3D+1AgoQ
         7A+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=DXjgDsQrDQ4x8a+yFMd3v4vW2/5WQu5mScrzHiIaNdI=;
        b=NJKMPU6FLlJAOkoxeAZG07YbHt9nV7iPMA0yM/ShbhD5r508OJh7UGKUbPseeFG58B
         jiERK889Y8jb6wwSIHTgWBcnINWMir6u4GgphKzY4/a85z7sCxiWR34UixlyAllava5d
         aiB04APKlxWaApF7hC+Qe5q/Qz6AMKfrUwx4kWGtvu46SxhqUeTJoQZrNO1Nlg2lbB7/
         BTtIeu5SinaAoHiror4nObJIg9rLuntvJlM0s6bfbuSNcW9RYdQAqo+niOo7eDRaWx9Q
         uyS/v/OF2F94LybpWQ7LVLyIRsAUqQjbtc90/SNTLmFfG35tcTY6dqAiHCJTkoLymX2X
         ezhg==
X-Gm-Message-State: APjAAAWDDkLBCOB6QeHdacK8XVQEf5zXREdsRdSmXzrWKDFt3PwxVMVZ
        r+/BkKeNdkguOfTevenVaA4=
X-Google-Smtp-Source: APXvYqza0OK5h4VX7xyFfjsH+nAQR3kmf9VPRvORDY1jeYUQMDTLTCd3G6qkUX72wLqQo3jbdYcZ+Q==
X-Received: by 2002:a05:6830:46:: with SMTP id d6mr5178370otp.125.1554402582478;
        Thu, 04 Apr 2019 11:29:42 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id a16sm7787996otl.4.2019.04.04.11.29.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Apr 2019 11:29:41 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v2 1/2] rtlwifi: Fix duplicate tests of one of the RX descriptors
Date:   Thu,  4 Apr 2019 13:29:30 -0500
Message-Id: <20190404182931.9477-2-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190404182931.9477-1-Larry.Finger@lwfinger.net>
References: <20190404182931.9477-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In drivers rtl8188ee, rtl8821ae, rtl8723be, and rtl8192ee, the reason
for a wake-up is returned in the fourth RX descriptor in bits 29-31. Due
to typographical errors, all but rtl8821ae test bit 31 twice and fail to
test bit 29.

This error causes no problems as the tests are only used to set bits in
the output of an optional debugging statement.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - Fixed Merge problem
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index 106011a24827..2dd01696c014 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -399,7 +399,7 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 	status->is_cck = RTL8188_RX_HAL_IS_CCK_RATE(status->rate);
 
 	status->macid = GET_RX_DESC_MACID(pdesc);
-	if (GET_RX_STATUS_DESC_MAGIC_MATCH(pdesc))
+	if (GET_RX_STATUS_DESC_PATTERN_MATCH(pdesc))
 		status->wake_match = BIT(2);
 	else if (GET_RX_STATUS_DESC_MAGIC_MATCH(pdesc))
 		status->wake_match = BIT(1);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index 09cf8180e4ff..49a4c84d193a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
@@ -350,7 +350,7 @@ bool rtl92ee_rx_query_desc(struct ieee80211_hw *hw,
 	status->is_cck = RTL92EE_RX_HAL_IS_CCK_RATE(status->rate);
 
 	status->macid = GET_RX_DESC_MACID(pdesc);
-	if (GET_RX_STATUS_DESC_MAGIC_MATCH(pdesc))
+	if (GET_RX_STATUS_DESC_PATTERN_MATCH(pdesc))
 		status->wake_match = BIT(2);
 	else if (GET_RX_STATUS_DESC_MAGIC_MATCH(pdesc))
 		status->wake_match = BIT(1);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
index 9ada9a06c6ea..a382cdc668ed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
@@ -329,7 +329,7 @@ bool rtl8723be_rx_query_desc(struct ieee80211_hw *hw,
 		status->packet_report_type = NORMAL_RX;
 
 
-	if (GET_RX_STATUS_DESC_MAGIC_MATCH(pdesc))
+	if (GET_RX_STATUS_DESC_PATTERN_MATCH(pdesc))
 		status->wake_match = BIT(2);
 	else if (GET_RX_STATUS_DESC_MAGIC_MATCH(pdesc))
 		status->wake_match = BIT(1);
-- 
2.21.0

