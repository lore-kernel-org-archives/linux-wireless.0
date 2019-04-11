Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65A5C10F13
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DE5C20818
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:21:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="Qto8jyUL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfDKKT6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 06:19:58 -0400
Received: from vps.xff.cz ([195.181.215.36]:48398 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbfDKKT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 06:19:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554977995; bh=VCU/uAG/CGlp0N/Ie+gLjiEg/N8Z0m54HtEJgdiJHWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qto8jyULfncNvfKKRwPzZP1JB3/oy4HWo/AuWudxJaoV4XRfbiL6QW2mAHqd/xQu/
         ZlQByk2qHZGItuf2QKJutUHdaK5OUA3xlj8ylEZUjHZr4LUEsEedHkPh3+bt3x86Qy
         DSWRXWKxCwJjHfzTsi2ig/zvmIn1HGfGP8ysOz8M=
From:   megous@megous.com
To:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Icenowy Zheng <icenowy@aosc.io>, David Airlie <airlied@linux.ie>,
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
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org,
        Ondrej Jirman <megous@megous.com>
Subject: [PATCH v3 02/11] net: stmmac: sun8i: force select external PHY when no internal one
Date:   Thu, 11 Apr 2019 12:19:42 +0200
Message-Id: <20190411101951.30223-3-megous@megous.com>
In-Reply-To: <20190411101951.30223-1-megous@megous.com>
References: <20190411101951.30223-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.io>

The PHY selection bit also exists on SoCs without an internal PHY; if it's
set to 1 (internal PHY, default value) then the MAC will not make use of
any PHY such SoCs.

This problem appears when adapting for H6, which has no real internal PHY
(the "internal PHY" on H6 is not on-die, but on a co-packaged AC200 chip,
connected via RMII interface at GPIO bank A).

Force the PHY selection bit to 0 when the SOC doesn't have an internal PHY,
to address the problem of a wrong default value.

Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 20c19afb8316..cb7e7f53be7d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -907,6 +907,11 @@ static int sun8i_dwmac_set_syscon(struct stmmac_priv *priv)
 		 * address. No need to mask it again.
 		 */
 		reg |= 1 << H3_EPHY_ADDR_SHIFT;
+	} else {
+		/* For SoCs without internal PHY the PHY selection bit should be
+		 * set to 0 (external PHY).
+		 */
+		reg &= ~H3_EPHY_SELECT;
 	}
 
 	if (!of_property_read_u32(node, "allwinner,tx-delay-ps", &val)) {
-- 
2.21.0

