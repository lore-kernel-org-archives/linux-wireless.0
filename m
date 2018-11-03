Return-Path: <SRS0=FZ/1=NO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04FCECDE44
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 10:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 655BA2082E
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 10:07:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="X3+VT7mE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 655BA2082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbeKCTSc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 15:18:32 -0400
Received: from plaes.org ([188.166.43.21]:34704 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726888AbeKCTSc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 15:18:32 -0400
Received: from localhost (85.253.196.132.cable.starman.ee [85.253.196.132])
        by plaes.org (Postfix) with ESMTPSA id 14A6D40DE5;
        Sat,  3 Nov 2018 09:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1541239190; bh=UieHoKBSWdElS/GElBDqUdWosll32Wo4YEzqLiNJCjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3+VT7mEwOrn3MDuY2VgczuRn7NhF73M6JqkqhB98xMDDlhCAifvJVumqaBd+TSYU
         ROkQswvsGYy1ggODC5+0fFZyWO75NFFez3nVNQuE71NX7OvV5gtHVtQcV7MFMmnrVr
         zQ0WtbpFEoYPkUyP5e6h0arq2XgvaCZ/BcyMr3bpbyxy92YLF6+Nfq5RfbHXVgE586
         sgX9NPlwm7qfizB+YH4xV1wxJyeyy1AxQcT+IQyY19KnFzH7uS4Gw7wHjzwXRj1TOX
         HEVJGXzsdH9vvM+ztz8Rqo9yrQR8Q/GZujvWgayyyzXMiwClhl7ObdGq/Cp2MweeaJ
         mr+OEZH8DtQ5A==
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
Subject: [PATCH 2/5] brcmfmac: Use common CORDIC_FLOAT macro from lib
Date:   Sat,  3 Nov 2018 11:59:41 +0200
Message-Id: <4bd6e7758bc0d88b33cdb09448633bb5b97aba7c.1541238842.git-series.plaes@plaes.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
References: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Now that cordic library has the CORDIC_FLOAT macro, use that

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

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
