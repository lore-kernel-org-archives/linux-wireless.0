Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D78C282E0
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73BCD21871
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:20:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="XGJOQLMJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfDKKUF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 06:20:05 -0400
Received: from vps.xff.cz ([195.181.215.36]:48654 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbfDKKUD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 06:20:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554977998; bh=op3dm3pge3hkv+pHZJvJy03uxi6x4i/4K3sT0Q5NnKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGJOQLMJkpSslkwXm/VvU2qMpf5vs/sEjdq53pbLv8HN7S3nguc0HDTkamrHDeEJN
         g7vsLIAh9igd4Ia8B3vyCEEP1+ST8NLNgZt6xUKTdL61z6YBWDnehLY99k8X7Z7jYA
         5MvQYo4TYYE165L6ACC9fNVLSf4NOlA2oax7Dfig=
From:   megous@megous.com
To:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Ondrej Jirman <megous@megous.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Subject: [PATCH v3 09/11] brcmfmac: Loading the correct firmware for brcm43456
Date:   Thu, 11 Apr 2019 12:19:49 +0200
Message-Id: <20190411101951.30223-10-megous@megous.com>
In-Reply-To: <20190411101951.30223-1-megous@megous.com>
References: <20190411101951.30223-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

SDIO based brcm43456 is currently misdetected as brcm43455 and the wrong
firmware name is used. Correct the detection and load the correct firmware
file. Chiprev for brcm43456 is "9".

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index a06af0cd4a7f..22b73da42822 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -622,6 +622,7 @@ BRCMF_FW_DEF(43430A0, "brcmfmac43430a0-sdio");
 /* Note the names are not postfixed with a1 for backward compatibility */
 BRCMF_FW_DEF(43430A1, "brcmfmac43430-sdio");
 BRCMF_FW_DEF(43455, "brcmfmac43455-sdio");
+BRCMF_FW_DEF(43456, "brcmfmac43456-sdio");
 BRCMF_FW_DEF(4354, "brcmfmac4354-sdio");
 BRCMF_FW_DEF(4356, "brcmfmac4356-sdio");
 BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
@@ -642,7 +643,8 @@ static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_4339_CHIP_ID, 0xFFFFFFFF, 4339),
 	BRCMF_FW_ENTRY(BRCM_CC_43430_CHIP_ID, 0x00000001, 43430A0),
 	BRCMF_FW_ENTRY(BRCM_CC_43430_CHIP_ID, 0xFFFFFFFE, 43430A1),
-	BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID, 0xFFFFFFC0, 43455),
+	BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID, 0x00000200, 43456),
+	BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID, 0xFFFFFDC0, 43455),
 	BRCMF_FW_ENTRY(BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, 4354),
 	BRCMF_FW_ENTRY(BRCM_CC_4356_CHIP_ID, 0xFFFFFFFF, 4356),
 	BRCMF_FW_ENTRY(CY_CC_4373_CHIP_ID, 0xFFFFFFFF, 4373),
-- 
2.21.0

