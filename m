Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D142FC4360F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 21:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D7DA206DD
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 21:59:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bNEjpS40"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbfCDV7t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 16:59:49 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38798 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfCDV7s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 16:59:48 -0500
Received: by mail-oi1-f196.google.com with SMTP id q81so5152121oic.5
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2019 13:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=odB9HWFqgrL31ZJ9DIJ6NGB1uyamF456s0uQNT1Ny98=;
        b=bNEjpS40Y7hTcVCsavNeBxJs5yXSObY1STYlyBkhRbuQcfnDLKYOv8w179cH7BDMou
         u1An5oWzb927lZgv+RxP80FWpjf1LIeJCpvncZgqjsXl0BGSl8HiODYIOykbgxXUiv+R
         DyRRjePg7hBd79ApNN5iTNgUKPerlSAkKAVss9FODeg4+LySJla+b1kImZVonyMPjPzJ
         IGmTW9qPJfbdG9hr6HE2EzmYkWVJNDZg5LyOu+vkeb7UioUJ0S+r/qe2vZqFv9ppWdPl
         9Gk2jX9t0XpWpBMFSAHpTSsIOBSPzt3qwP9xyholaucX6tz72jUDRe0ihFlgulN9Jxow
         InfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=odB9HWFqgrL31ZJ9DIJ6NGB1uyamF456s0uQNT1Ny98=;
        b=AwlCRk+2DXbiXLFIjGBJPTq7UmlxGasXvdPSK1aKvhKm2O8e8o10jrTG2/LsoMU3Ji
         vR+gIgaya5m3HQemqCEZWvfiAPRLwfczGfKL5UyAieeK5NhfmpNoR8x3OM1V4HevGpn0
         7QREXzrQ/yw4U23FeXK0giWmB26rRFUYFUKGZehz2XHG1mV9WfEE5Zr82fHdeQwWLbTe
         9AEbAQhKtFC1igbGyIrRVz68/1dPX3Y9DsDjD7KPKFtjiaKFOcU8etBY250xaZ2D5Mkd
         wqSvjtkWM2/PIC/krqH45DQfqXUUDIP46otaXH3TJ6VY0i7p8cBp69M/1/T1rjjykikR
         DiQQ==
X-Gm-Message-State: APjAAAU3TaJB5pLJ6INlgg+/V6fU99w3AcGDgzDqOEhD7lRURjPWVMFb
        Pn73xeuQjrwZJvXU1EBL3A0=
X-Google-Smtp-Source: APXvYqxVp+GfPv/NGVhHbXUeu/P17i+QMruphmHJPj+Clc9Fw5aS+45b16wAxnLzGN8QvqKh7s+d3A==
X-Received: by 2002:aca:4e06:: with SMTP id c6mr3673oib.71.1551736787643;
        Mon, 04 Mar 2019 13:59:47 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id e125sm2923744oia.18.2019.03.04.13.59.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Mar 2019 13:59:47 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/2] rtlwifi: Fix duplicate tests of one of the RX descriptors
Date:   Mon,  4 Mar 2019 15:59:39 -0600
Message-Id: <20190304215940.2608-2-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190304215940.2608-1-Larry.Finger@lwfinger.net>
References: <20190304215940.2608-1-Larry.Finger@lwfinger.net>
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
a quantity output in an optional debugging statement.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index ae1ac8be3c5b..3a70be92a77c 100644
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

