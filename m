Return-Path: <SRS0=FZ/1=NO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E69AC6786F
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 10:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7B012082E
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 10:07:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="iJZRyFC/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7B012082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbeKCTSc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 15:18:32 -0400
Received: from plaes.org ([188.166.43.21]:34692 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726632AbeKCTSc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 15:18:32 -0400
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Nov 2018 15:18:30 EDT
Received: from localhost (85.253.196.132.cable.starman.ee [85.253.196.132])
        by plaes.org (Postfix) with ESMTPSA id 0011C41B91;
        Sat,  3 Nov 2018 09:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1541239194; bh=+BQq0FqfhoZHlcMg9+0R+bvL/z4OcJyjNExzpCJasys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJZRyFC/R2DmT88pgajAixdHuEYZg6wWie1uMztYHE39vlUMSGtD7WDmll4Hj9cE1
         vJNNfHzkG7qgS/f67k2yVHgRVDUs1fHopfx/Zcp/BSnT2cFNkTrtsjbwgi09lTICf1
         9UsMy3OHf78mfZdqunbWo+Zr7tgZB2JCfAVWATo7CP/PMDCh07X2CUGeeg5prhv361
         LCqvqPXm8KzsbIk0Q2tH5ArAo7DjbrXGaIbh0HOa5rUxCqWbmVeynIVvwSzwueUIKE
         B8w92X/H1Iasm7MGV0gEgZE+VXGOSPV50p7k2UvO29a5M1cpOYvaGjHwIaXZjt0cmY
         A19DOsohEw5CA==
From:   Priit Laes <plaes@plaes.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH 5/5] b43: Drop internal cordic algorithm implementation
Date:   Sat,  3 Nov 2018 11:59:44 +0200
Message-Id: <51f98dbd0efe48c315d8e7876074aeaa22fde580.1541238842.git-series.plaes@plaes.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
References: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/net/wireless/broadcom/b43/phy_common.c | 47 +-------------------
 drivers/net/wireless/broadcom/b43/phy_common.h |  9 +----
 2 files changed, 56 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_common.c b/drivers/net/wireless/broadcom/b43/phy_common.c
index 85f2ca9..98c4fa5 100644
--- a/drivers/net/wireless/broadcom/b43/phy_common.c
+++ b/drivers/net/wireless/broadcom/b43/phy_common.c
@@ -604,50 +604,3 @@ void b43_phy_force_clock(struct b43_wldev *dev, bool force)
 #endif
 	}
 }
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/Cordic */
-struct b43_c32 b43_cordic(int theta)
-{
-	static const u32 arctg[] = {
-		2949120, 1740967, 919879, 466945, 234379, 117304,
-		  58666,   29335,  14668,   7334,   3667,   1833,
-		    917,     458,    229,    115,     57,     29,
-	};
-	u8 i;
-	s32 tmp;
-	s8 signx = 1;
-	u32 angle = 0;
-	struct b43_c32 ret = { .i = 39797, .q = 0, };
-
-	while (theta > (180 << 16))
-		theta -= (360 << 16);
-	while (theta < -(180 << 16))
-		theta += (360 << 16);
-
-	if (theta > (90 << 16)) {
-		theta -= (180 << 16);
-		signx = -1;
-	} else if (theta < -(90 << 16)) {
-		theta += (180 << 16);
-		signx = -1;
-	}
-
-	for (i = 0; i <= 17; i++) {
-		if (theta > angle) {
-			tmp = ret.i - (ret.q >> i);
-			ret.q += ret.i >> i;
-			ret.i = tmp;
-			angle += arctg[i];
-		} else {
-			tmp = ret.i + (ret.q >> i);
-			ret.q -= ret.i >> i;
-			ret.i = tmp;
-			angle -= arctg[i];
-		}
-	}
-
-	ret.i *= signx;
-	ret.q *= signx;
-
-	return ret;
-}
diff --git a/drivers/net/wireless/broadcom/b43/phy_common.h b/drivers/net/wireless/broadcom/b43/phy_common.h
index 57a1ad8..4213cac 100644
--- a/drivers/net/wireless/broadcom/b43/phy_common.h
+++ b/drivers/net/wireless/broadcom/b43/phy_common.h
@@ -7,13 +7,6 @@
 
 struct b43_wldev;
 
-/* Complex number using 2 32-bit signed integers */
-struct b43_c32 { s32 i, q; };
-
-#define CORDIC_CONVERT(value)	(((value) >= 0) ? \
-				 ((((value) >> 15) + 1) >> 1) : \
-				 -((((-(value)) >> 15) + 1) >> 1))
-
 /* PHY register routing bits */
 #define B43_PHYROUTE			0x0C00 /* PHY register routing bits mask */
 #define  B43_PHYROUTE_BASE		0x0000 /* Base registers */
@@ -450,6 +443,4 @@ bool b43_is_40mhz(struct b43_wldev *dev);
 
 void b43_phy_force_clock(struct b43_wldev *dev, bool force);
 
-struct b43_c32 b43_cordic(int theta);
-
 #endif /* LINUX_B43_PHY_COMMON_H_ */
-- 
git-series 0.9.1
