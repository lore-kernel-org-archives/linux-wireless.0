Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14132C282CE
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 23:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D921920700
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 23:52:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="aRRAU1g/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfDEXvq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 19:51:46 -0400
Received: from vps.xff.cz ([195.181.215.36]:53640 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbfDEXvp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 19:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554507923; bh=9sBa/x4rOB2AVivmG3/l1tDMopdUGPQTQlyQMH/xsqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRRAU1g/69ghks7wcLox0q8Evc4sixu9ydhof1nYcgzsUBg7C1kh0Dg4rU8SFM3bQ
         pPwWAQGqgqtTcJMxfaKGZH1ljvHUJ+0uvuGn+AlljbFse0TSxU8qBcu0/Xk7ML5RMa
         TdvnkgDsrlxhkWRG0TS/XtG+xof3we+Skta2Tt1k=
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
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Subject: [PATCH 06/12] net: stmmac: sun8i: force select external PHY when no internal one
Date:   Sat,  6 Apr 2019 01:45:08 +0200
Message-Id: <20190405234514.6183-7-megous@megous.com>
In-Reply-To: <20190405234514.6183-1-megous@megous.com>
References: <20190405234514.6183-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.io>

The PHY selection bit also exists on SoCs without an internal PHY; if
it's set to 1 (internal PHY) then the MAC will not make use of any PHY.

This problem appears when adapting for H6, which has no real internal
PHY (the "internal PHY" on H6 is not on-die, but on a co-packaged AC200
chip, via RMII interface at GPIO bank A), but the PHY selection bit is
set.

Force the PHY selection bit to 0 when no external PHY to select this
problem.

Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index e3e3dc44b33b..bd340e77b2ea 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -908,6 +908,11 @@ static int sun8i_dwmac_set_syscon(struct stmmac_priv *priv)
 		 * address. No need to mask it again.
 		 */
 		reg |= 1 << H3_EPHY_ADDR_SHIFT;
+	} else {
+		/* For SoCs without internal PHY the PHY selection bit should be
+		 * set to 0 (external PHY).
+		 */
+		reg &= ~(H3_EPHY_SELECT);
 	}
 
 	if (!of_property_read_u32(node, "allwinner,tx-delay-ps", &val)) {
-- 
2.21.0

