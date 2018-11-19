Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF34EC04EBA
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 18:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C24A21104
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 18:01:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="bfknxD+D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C24A21104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732098AbeKTE0T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 23:26:19 -0500
Received: from plaes.org ([188.166.43.21]:48060 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731553AbeKTE0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 23:26:18 -0500
Received: from localhost (85.253.196.132.cable.starman.ee [85.253.196.132])
        by plaes.org (Postfix) with ESMTPSA id B738641C75;
        Mon, 19 Nov 2018 18:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1542650501; bh=JOhlbC/iipzrVhPwavTEA6WgdVX1BU/nIIGP0AUe40E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bfknxD+Duze3An5olwR0lZhBYxYU+RZIDbPeHfvQ5AjauqGVv8uvlMTgdqduVl6sF
         E60FEzCL+GjvTJOnxYto8KiKjwbWaCijff5lfKyoVsq+IJ/vvF41lHqazk446shVZ+
         024WeCJkG3RTLCWNbPBTK+jAMUSAwyOu+v2Xucvk/wey5cCmjUdNBsr2HbV/nUZd3f
         NfKZfzstvmfCYOY6rehZBwImCBgsa/qL/QKDkEuKLgqwSoN5rr+fvkcuR5CW76vRZ2
         7/fj9SuQARxjL9ROewRC+JBbt2JFPMo0HNgSGCtQccDB8HyFkIDcEO8PbPx3SvPxAj
         d7JTBRvv3/3nw==
From:   Priit Laes <plaes@plaes.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Priit Laes <plaes@plaes.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: [PATCH 2/4] brcmsmac: Use cordic-related macros from common cordic library
Date:   Mon, 19 Nov 2018 20:01:23 +0200
Message-Id: <a9227f02e607ab4d516e4dc1d1a17753de854a39.1542649316.git-series.plaes@plaes.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.87f16ede7954f8d9cde4ecae5f050bf8f4008dd8.1542649316.git-series.plaes@plaes.org>
References: <cover.87f16ede7954f8d9cde4ecae5f050bf8f4008dd8.1542649316.git-series.plaes@plaes.org>
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
