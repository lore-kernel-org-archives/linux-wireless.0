Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2FBC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 19:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16DB720685
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 19:38:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="lFgVWc+5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16DB720685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388039AbeKFE6i (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 23:58:38 -0500
Received: from plaes.org ([188.166.43.21]:44044 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730003AbeKFE6h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 23:58:37 -0500
Received: from localhost (85.253.196.132.cable.starman.ee [85.253.196.132])
        by plaes.org (Postfix) with ESMTPSA id 0E759403FA;
        Mon,  5 Nov 2018 19:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1541446642; bh=uzSMys5iWgkaYCE8KfQ+2PrBqVQVsRvykesANVuQk3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFgVWc+53i8Rm3E0yugjuIBCarP0NWMgWwxp/+Tr2h6feCllhfjHnBjbskOtg5s86
         rb51CLIT+DV7uaMVziSINlKR9vA+L1Xdz2jqCXOVlr/yqjG6Z2CZS1PnhBPh4ijSgr
         VJ1q0HIGXo/FdI1jZ2cX8hfZ+Z5n98bjD3SMxWTnd60zKN5mbOb2jkYfLdufRRrkY9
         nRe9dnR6pd9CHOdBGxcm0/u/eaJADjuhHXKPsm48E1Ly44RRDCLx7IavhC8cDVqaR9
         6gp8LSCfxiEKA9R+wrzyu9vQjc80yIlEXh3ErEUoWXPT2mahh8SeICSOXv06kxJXlF
         r4XYenALsDEaw==
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
Subject: [PATCH v2 2/3] brcmsmac: Use cordic-related macros from common cordic library
Date:   Mon,  5 Nov 2018 21:37:17 +0200
Message-Id: <21ac814df5e4d338337acb7d40c1ec3304a9135c.1541446422.git-series.plaes@plaes.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.9ec98292c595a111ae78f31383ff8618c9cb04da.1541446422.git-series.plaes@plaes.org>
References: <cover.9ec98292c595a111ae78f31383ff8618c9cb04da.1541446422.git-series.plaes@plaes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Current driver includes macro that is available from general cordic
library. Use that and drop unused duplicate and unneeded internal
definitions.

Signed-off-by: Priit Laes <plaes@plaes.org>

---
v2: Use single patch instead of change/removal patches.
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_int.h | 7 +-------
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c   | 4 ++--
 3 files changed, 4 insertions(+), 11 deletions(-)

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
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
index 9fb0d9f..e78a93a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -3447,8 +3447,8 @@ wlc_lcnphy_start_tx_tone(struct brcms_phy *pi, s32 f_kHz, u16 max_val,
 
 		theta += rot;
 
-		i_samp = (u16) (FLOAT(tone_samp.i * max_val) & 0x3ff);
-		q_samp = (u16) (FLOAT(tone_samp.q * max_val) & 0x3ff);
+		i_samp = (u16)(CORDIC_FLOAT(tone_samp.i * max_val) & 0x3ff);
+		q_samp = (u16)(CORDIC_FLOAT(tone_samp.q * max_val) & 0x3ff);
 		data_buf[t] = (i_samp << 10) | q_samp;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
index a57f271..f4f5e90 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
@@ -23089,8 +23089,8 @@ wlc_phy_gen_load_samples_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
 
 		theta += rot;
 
-		tone_buf[t].q = (s32) FLOAT(tone_buf[t].q * max_val);
-		tone_buf[t].i = (s32) FLOAT(tone_buf[t].i * max_val);
+		tone_buf[t].q = (s32)CORDIC_FLOAT(tone_buf[t].q * max_val);
+		tone_buf[t].i = (s32)CORDIC_FLOAT(tone_buf[t].i * max_val);
 	}
 
 	wlc_phy_loadsampletable_nphy(pi, tone_buf, num_samps);
-- 
git-series 0.9.1
