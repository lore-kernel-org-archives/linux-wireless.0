Return-Path: <SRS0=FZ/1=NO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E54C0044C
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 10:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25A3A2082E
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 10:07:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="lCuUYnH1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25A3A2082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbeKCTSe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 15:18:34 -0400
Received: from plaes.org ([188.166.43.21]:34694 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726795AbeKCTSd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 15:18:33 -0400
Received: from localhost (85.253.196.132.cable.starman.ee [85.253.196.132])
        by plaes.org (Postfix) with ESMTPSA id ADE964181D;
        Sat,  3 Nov 2018 09:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1541239192; bh=qaERkaGaX9K3eMgbFk+T005QS8FY727yLXnAPNLEV/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCuUYnH1dbZJNYbjHjf+soq8iOy2g2NzDqhbRwZ6rrVJPJrQvKiphEZyn2Mv827LN
         QKxZdpGA10+GzaoOotB22ys471QvokbZL50zY5PAKKdqNnZ1YNIGYRXcKNloVXGNWu
         qTMRirWfxIsczODmQ5s1AF6OS7vKryF1GpGMle0H19A1mygSehx2E/qfdKZzRzPskq
         KgGIcSpzTHmMzW8TSk87yfXGrGSy052VmW2TLFkFD+uu7pN/fFFiUWMuzh1SXu7N6P
         nav5BGjXxKsC20GrZWdfid1nbogIF86iBViwkHnJMTimEg0QAnKkLZDzu2gzNw1EYc
         0OkIxM7+rZ4mA==
From:   Priit Laes <plaes@plaes.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH 4/5] b43: Use common cordic algorithm from kernel lib
Date:   Sat,  3 Nov 2018 11:59:43 +0200
Message-Id: <c208360e5cc314ac1ad81f907f4538cf2dcbd196.1541238842.git-series.plaes@plaes.org>
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
 drivers/net/wireless/broadcom/b43/Kconfig  |  1 +
 drivers/net/wireless/broadcom/b43/phy_lp.c | 13 +++++++------
 drivers/net/wireless/broadcom/b43/phy_n.c  | 13 +++++++------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/Kconfig b/drivers/net/wireless/broadcom/b43/Kconfig
index fba8560..3e41457 100644
--- a/drivers/net/wireless/broadcom/b43/Kconfig
+++ b/drivers/net/wireless/broadcom/b43/Kconfig
@@ -4,6 +4,7 @@ config B43
 	select BCMA if B43_BCMA
 	select SSB if B43_SSB
 	select FW_LOADER
+	select CORDIC
 	---help---
 	  b43 is a driver for the Broadcom 43xx series wireless devices.
 
diff --git a/drivers/net/wireless/broadcom/b43/phy_lp.c b/drivers/net/wireless/broadcom/b43/phy_lp.c
index 6922cbb..1718e3b 100644
--- a/drivers/net/wireless/broadcom/b43/phy_lp.c
+++ b/drivers/net/wireless/broadcom/b43/phy_lp.c
@@ -23,6 +23,7 @@
 
 */
 
+#include <linux/cordic.h>
 #include <linux/slab.h>
 
 #include "b43.h"
@@ -1780,9 +1781,9 @@ static void lpphy_start_tx_tone(struct b43_wldev *dev, s32 freq, u16 max)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
 	u16 buf[64];
-	int i, samples = 0, angle = 0;
+	int i, samples = 0, theta = 0;
 	int rotation = (((36 * freq) / 20) << 16) / 100;
-	struct b43_c32 sample;
+	struct cordic_iq sample;
 
 	lpphy->tx_tone_freq = freq;
 
@@ -1798,10 +1799,10 @@ static void lpphy_start_tx_tone(struct b43_wldev *dev, s32 freq, u16 max)
 	}
 
 	for (i = 0; i < samples; i++) {
-		sample = b43_cordic(angle);
-		angle += rotation;
-		buf[i] = CORDIC_CONVERT((sample.i * max) & 0xFF) << 8;
-		buf[i] |= CORDIC_CONVERT((sample.q * max) & 0xFF);
+		sample = cordic_calc_iq(theta);
+		theta += rotation;
+		buf[i] = CORDIC_FLOAT((sample.i * max) & 0xFF) << 8;
+		buf[i] |= CORDIC_FLOAT((sample.q * max) & 0xFF);
 	}
 
 	b43_lptab_write_bulk(dev, B43_LPTAB16(5, 0), samples, buf);
diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index 44ab080..1f9378a 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -23,6 +23,7 @@
 
 */
 
+#include <linux/cordic.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -1513,7 +1514,7 @@ static void b43_radio_init2055(struct b43_wldev *dev)
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/LoadSampleTable */
 static int b43_nphy_load_samples(struct b43_wldev *dev,
-					struct b43_c32 *samples, u16 len) {
+					struct cordic_iq *samples, u16 len) {
 	struct b43_phy_n *nphy = dev->phy.n;
 	u16 i;
 	u32 *data;
@@ -1544,7 +1545,7 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 {
 	int i;
 	u16 bw, len, rot, angle;
-	struct b43_c32 *samples;
+	struct cordic_iq *samples;
 
 	bw = b43_is_40mhz(dev) ? 40 : 20;
 	len = bw << 3;
@@ -1561,7 +1562,7 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 		len = bw << 1;
 	}
 
-	samples = kcalloc(len, sizeof(struct b43_c32), GFP_KERNEL);
+	samples = kcalloc(len, sizeof(struct cordic_iq), GFP_KERNEL);
 	if (!samples) {
 		b43err(dev->wl, "allocation for samples generation failed\n");
 		return 0;
@@ -1570,10 +1571,10 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 	angle = 0;
 
 	for (i = 0; i < len; i++) {
-		samples[i] = b43_cordic(angle);
+		samples[i] = cordic_calc_iq(angle);
 		angle += rot;
-		samples[i].q = CORDIC_CONVERT(samples[i].q * max);
-		samples[i].i = CORDIC_CONVERT(samples[i].i * max);
+		samples[i].q = CORDIC_FLOAT(samples[i].q * max);
+		samples[i].i = CORDIC_FLOAT(samples[i].i * max);
 	}
 
 	i = b43_nphy_load_samples(dev, samples, len);
-- 
git-series 0.9.1
