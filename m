Return-Path: <SRS0=FZ/1=NO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A2ACC0044C
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 10:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FCC62082E
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 10:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="oZC+dmiE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FCC62082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbeKCTSc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 15:18:32 -0400
Received: from plaes.org ([188.166.43.21]:34702 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbeKCTSb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 15:18:31 -0400
Received: from localhost (85.253.196.132.cable.starman.ee [85.253.196.132])
        by plaes.org (Postfix) with ESMTPSA id 3219840AC7;
        Sat,  3 Nov 2018 09:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1541239191; bh=TNZdPduifoKpgQFmEWBSRhv4J/v31pmijm9ryIdcaR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZC+dmiEz3qL6/gwvAXAlzJGkNLijfs8ZXAfMqaiHrtj5qzCohn4dFIGrNAQ53+xE
         3RJuElm3oywwmbVRwgaQ2kZOLfJyAuZJ3lrPTnTCGRS/qf4NE154NQR2CLAMLymzzl
         zt5tIddqrTa/OlKCuHwgFra1VU5PfixRwwro3HNd/sjQjX1QKGzSg/uH+28V/vdiNT
         ewWGQo/XpI6kqW6K5emWnywJs4Hsg1CZ8w1zrzcK3nOcBjpAr2RvCwcMkoliLszAQk
         xsnDvfVbHnvNNdiNwbpg5cHl5c4P63uH1608Iq7pG6vgm3jAfjvtcTatQ/9VaX9hLZ
         +zcrPPqxtA3NQ==
From:   Priit Laes <plaes@plaes.org>
To:     linux-kernel@vger.kernel.org
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH 3/5] brcmfmac: Drop unused cordic defines and macros
Date:   Sat,  3 Nov 2018 11:59:42 +0200
Message-Id: <7f3dbe604102f7d765149fffef8a4e6b9fa15552.1541238842.git-series.plaes@plaes.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
References: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Now that we use library macros, we can drop internal copies

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_int.h | 7 +-------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_int.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_int.h
index 4960f7d..e9e8337 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_int.h
@@ -220,13 +220,6 @@ enum phy_cal_mode {
 #define BB_MULT_MASK		0x0000ffff
 #define BB_MULT_VALID_MASK	0x80000000
 
-#define CORDIC_AG	39797
-#define	CORDIC_NI	18
-#define	FIXED(X)	((s32)((X) << 16))
-
-#define	FLOAT(X) \
-	(((X) >= 0) ? ((((X) >> 15) + 1) >> 1) : -((((-(X)) >> 15) + 1) >> 1))
-
 #define PHY_CHAIN_TX_DISABLE_TEMP	115
 #define PHY_HYSTERESIS_DELTATEMP	5
 
-- 
git-series 0.9.1
