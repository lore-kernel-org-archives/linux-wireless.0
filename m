Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FBCC10F13
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 00:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEED620883
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 00:26:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="iWt6uPWJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfDIAZB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 20:25:01 -0400
Received: from vps.xff.cz ([195.181.215.36]:35960 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbfDIAZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 20:25:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554769497; bh=UC9wB2J233KlPA4rT3KG60p9zim2aCkkBwSknLoN7uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWt6uPWJZf0R+Ily15VN6bwtxIzMwBwdgrlNBMhtyCJGBLMndNK4lQtfwCJHXXI2l
         b9PjwcFctSRBlGjN/x0v8yDPQQH9b3oUfynGWPrAPkqfmvO6BFvqis+ZYO/xCUot0e
         RPW3XMV7y8AmvrV1QvQP/LgQIk5x8l36i4Sb3Hfk=
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
Subject: [PATCH v2 01/13] dt-bindings: sunxi: Add compatible for OrangePi 3 board
Date:   Tue,  9 Apr 2019 02:24:40 +0200
Message-Id: <20190409002452.14551-2-megous@megous.com>
In-Reply-To: <20190409002452.14551-1-megous@megous.com>
References: <20190409002452.14551-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

Add new Xunlong Orange Pi 3 board compatible string to the bindings
documentation.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 Documentation/devicetree/bindings/arm/sunxi.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/sunxi.yaml b/Documentation/devicetree/bindings/arm/sunxi.yaml
index 11563d3f7c65..b82db740125b 100644
--- a/Documentation/devicetree/bindings/arm/sunxi.yaml
+++ b/Documentation/devicetree/bindings/arm/sunxi.yaml
@@ -711,6 +711,11 @@ properties:
           - const: xunlong,orangepi-2
           - const: allwinner,sun8i-h3
 
+      - description: Xunlong OrangePi 3
+        items:
+          - const: xunlong,orangepi-3
+          - const: allwinner,sun50i-h6
+
       - description: Xunlong OrangePi Lite
         items:
           - const: xunlong,orangepi-lite
-- 
2.21.0

