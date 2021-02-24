Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4299AC433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Feb 2021 03:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D59CA64E6F
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Feb 2021 03:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbhBXDjb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Feb 2021 22:39:31 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:4490 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhBXDja (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Feb 2021 22:39:30 -0500
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2021 22:39:30 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=HMkSw7IOvssTgDSrtIkerCdgmEF1qqotALIXwHQL8v0=;
        b=Qh+zePS3F/BpZD/n9+9PG00Bf2+uexnrTOM3fgzKfT3sBuYPVo0ATVNE/uRJcHrHe9Yc
        ZBImKnHeUprp9BEV6W+F2fvWUBTEjF7EOwV+wCBMxLfSEphru7+lLZ/nTN2QxjS0hyYyZK
        UJHzj/yWlL4L/pI2GQ+pO5JYAqvhZ18Jk=
Received: by filterdrecv-p3mdw1-7745b6f999-sfwps with SMTP id filterdrecv-p3mdw1-7745b6f999-sfwps-19-6035C903-20
        2021-02-24 03:33:23.522967355 +0000 UTC m=+609418.677037305
Received: from pearl.egauge.net (unknown)
        by ismtpd0023p1las1.sendgrid.net (SG) with ESMTP
        id H1GRjH_-QNuumsdAuJQVLw
        Wed, 24 Feb 2021 03:33:23.307 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 837747001EB; Tue, 23 Feb 2021 20:33:22 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH] wilc1000: Support chip sleep over SPI
Date:   Wed, 24 Feb 2021 03:33:23 +0000 (UTC)
Message-Id: <20210224033317.1507603-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvLqPTrJ6otTC=2F10Oq?=
 =?us-ascii?Q?hiyJh=2FA6EPW7PdArPNCO42mDjyhcLTtJh39J8FF?=
 =?us-ascii?Q?NB59fb+AHNqeeAiiMmiHkiQjkAyDQEsWNoClo7N?=
 =?us-ascii?Q?aKGw3p5UGZIQ6HYAkl+lV6b7EYzxX2mNcqtW6LJ?=
 =?us-ascii?Q?LGriSVnnR3zq7XsHdbYhSFI7bOhB6IGISj0IYlM?=
 =?us-ascii?Q?a76MN5G1YlTtdiqSyU+0Q=3D=3D?=
To:     linux-wireless@vger.kernel.org
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        davidm@egauge.net
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

chip_allow_sleep() only supported wakeup via SDIO, which made the
driver unusable over SPI.  This code is a straight forward port from
the driver in the linux-at91 repository.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 56 +++++++++++++++++--
 .../net/wireless/microchip/wilc1000/wlan.h    |  6 ++
 2 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 31d51385ba93..d4a90c490084 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -552,12 +552,60 @@ static struct rxq_entry_t *wilc_wlan_rxq_remove(struct wilc *wilc)
 void chip_allow_sleep(struct wilc *wilc)
 {
 	u32 reg = 0;
+	const struct wilc_hif_func *hif_func = wilc->hif_func;
+	u32 wakeup_reg, wakeup_bit;
+	u32 to_host_from_fw_reg, to_host_from_fw_bit;
+	u32 from_host_to_fw_reg, from_host_to_fw_bit;
+	u32 trials = 100;
+	int ret;
+
+	if (wilc->io_type == WILC_HIF_SDIO) {
+		wakeup_reg = WILC_SDIO_WAKEUP_REG;
+		wakeup_bit = WILC_SDIO_WAKEUP_BIT;
+		from_host_to_fw_reg = WILC_SDIO_HOST_TO_FW_REG;
+		from_host_to_fw_bit = WILC_SDIO_HOST_TO_FW_BIT;
+		to_host_from_fw_reg = WILC_SDIO_FW_TO_HOST_REG;
+		to_host_from_fw_bit = WILC_SDIO_FW_TO_HOST_BIT;
+	} else {
+		wakeup_reg = WILC_SPI_WAKEUP_REG;
+		wakeup_bit = WILC_SPI_WAKEUP_BIT;
+		from_host_to_fw_reg = WILC_SPI_HOST_TO_FW_REG;
+		from_host_to_fw_bit = WILC_SPI_HOST_TO_FW_BIT;
+		to_host_from_fw_reg = WILC_SPI_FW_TO_HOST_REG;
+		to_host_from_fw_bit = WILC_SPI_FW_TO_HOST_BIT;
+	}
+
+	while (trials--) {
+		ret = hif_func->hif_read_reg(wilc, to_host_from_fw_reg, &reg);
+		if (ret)
+			return;
+		if ((reg & to_host_from_fw_bit) == 0)
+			break;
+	}
+	if (!trials)
+		pr_warn("FW not responding\n");
 
-	wilc->hif_func->hif_read_reg(wilc, WILC_SDIO_WAKEUP_REG, &reg);
+	/* Clear bit 1 */
+	ret = hif_func->hif_read_reg(wilc, wakeup_reg, &reg);
+	if (ret)
+		return;
+	if (reg & wakeup_bit) {
+		reg &= ~wakeup_bit;
+		ret = hif_func->hif_write_reg(wilc, wakeup_reg, reg);
+		if (ret)
+			return;
+	}
 
-	wilc->hif_func->hif_write_reg(wilc, WILC_SDIO_WAKEUP_REG,
-				      reg & ~WILC_SDIO_WAKEUP_BIT);
-	wilc->hif_func->hif_write_reg(wilc, WILC_SDIO_HOST_TO_FW_REG, 0);
+	ret = hif_func->hif_read_reg(wilc, from_host_to_fw_reg, &reg);
+	if (ret)
+		return;
+	if (reg & from_host_to_fw_bit) {
+		reg &= ~from_host_to_fw_bit;
+		ret = hif_func->hif_write_reg(wilc, from_host_to_fw_reg, reg);
+		if (ret)
+			return;
+
+	}
 }
 EXPORT_SYMBOL_GPL(chip_allow_sleep);
 
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.h b/drivers/net/wireless/microchip/wilc1000/wlan.h
index d55eb6b3a12a..6479acc12b95 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.h
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.h
@@ -97,6 +97,12 @@
 #define WILC_SPI_WAKEUP_REG		0x1
 #define WILC_SPI_WAKEUP_BIT		BIT(1)
 
+#define WILC_SPI_HOST_TO_FW_REG		0x0b
+#define WILC_SPI_HOST_TO_FW_BIT		BIT(0)
+
+#define WILC_SPI_FW_TO_HOST_REG		0x10
+#define WILC_SPI_FW_TO_HOST_BIT		BIT(0)
+
 #define WILC_SPI_PROTOCOL_OFFSET	(WILC_SPI_PROTOCOL_CONFIG - \
 					 WILC_SPI_REG_BASE)
 
-- 
2.25.1

