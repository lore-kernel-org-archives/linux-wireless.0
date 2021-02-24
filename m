Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 637F7C433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Feb 2021 05:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21FE464EBB
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Feb 2021 05:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhBXFwp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Feb 2021 00:52:45 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:8934 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbhBXFwn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Feb 2021 00:52:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=ZYC9IQdF3wXzbcLOj7Ji/0m+8iDBvubNR8pDbwfzrRU=;
        b=fcVbi9rKFMhMALltS4LHXvVuYhdsnrHIpEWA7BretPLqi9Da3zdqtqEKYqDLzYFWKFrf
        SAGdY9CBsyWr+0bc2sWkHWeg+iOtvHa44z4xFCe0k6A0VG44g7v1NB757PrlVG0wOnYEqM
        VfvAghs39w4aFLCQe50EiVWvXYmZMZbKo=
Received: by filterdrecv-p3iad2-fdf5ff85d-blwrf with SMTP id filterdrecv-p3iad2-fdf5ff85d-blwrf-19-6035E97C-2F
        2021-02-24 05:51:56.954915777 +0000 UTC m=+1235063.223905088
Received: from pearl.egauge.net (unknown)
        by ismtpd0001p1las1.sendgrid.net (SG) with ESMTP
        id jXXwKammRomwUrHFgj51sg
        Wed, 24 Feb 2021 05:51:56.805 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 51F937001EB; Tue, 23 Feb 2021 22:51:56 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 3/4] wilc1000: Check for errors at end of DMA write
Date:   Wed, 24 Feb 2021 05:51:57 +0000 (UTC)
Message-Id: <20210224055135.1509200-3-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224055135.1509200-1-davidm@egauge.net>
References: <20210224055135.1509200-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvFMz3bzXtgDjSqD3v?=
 =?us-ascii?Q?ZuBFVN6zKv4yYW0iAoqufrSDaE8U6gC3nhPT=2FJA?=
 =?us-ascii?Q?asazQWbtSOC4Ex4MDR3Gu8wGCgsLEjb05Y+LRXa?=
 =?us-ascii?Q?NfqQgARxSgpw65RhffqEyGlR6GFJbXJq1S2bTFs?=
 =?us-ascii?Q?RUHmn616cYO3VwIXMQDPqGgSAxJOBWj0em7X7Ax?=
 =?us-ascii?Q?WNlUUpSkmI8HLfdFukouw=3D=3D?=
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

After a DMA write to the WILC chip, check for and report any errors.

This is based on code from the wilc driver in the linux-at91
repository.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/spi.c | 50 ++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index fca34d1999ec..b0e096a03a28 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -750,6 +750,51 @@ static int wilc_spi_write_reg(struct wilc *wilc, u32 addr, u32 data)
 	return 0;
 }
 
+static int spi_data_rsp(struct wilc *wilc, u8 cmd)
+{
+	struct spi_device *spi = to_spi_device(wilc->dev);
+	int result, i;
+	u8 rsp[4];
+
+	/*
+	 * The response to data packets is two bytes long.  For
+	 * efficiency's sake, wilc_spi_write() wisely ignores the
+	 * responses for all packets but the final one.  The downside
+	 * of that optimization is that when the final data packet is
+	 * short, we may receive (part of) the response to the
+	 * second-to-last packet before the one for the final packet.
+	 * To handle this, we always read 4 bytes and then search for
+	 * the last byte that contains the "Response Start" code (0xc
+	 * in the top 4 bits).  We then know that this byte is the
+	 * first response byte of the final data packet.
+	 */
+	result = wilc_spi_rx(wilc, rsp, sizeof(rsp));
+	if (result) {
+		dev_err(&spi->dev, "Failed bus error...\n");
+		return result;
+	}
+
+	for (i = sizeof(rsp) - 2; i >= 0; --i)
+		if ((rsp[i] & 0xf0) == 0xc0)
+			break;
+
+	if (i < 0) {
+		dev_err(&spi->dev,
+			"Data packet response missing (%02x %02x %02x %02x)\n",
+			rsp[0], rsp[1], rsp[2], rsp[3]);
+		return -1;
+	}
+
+	/* rsp[i] is the last response start byte */
+
+	if (rsp[i] != 0xc3 || rsp[i + 1] != 0x00) {
+		dev_err(&spi->dev, "Data response error (%02x %02x)\n",
+			rsp[i], rsp[i + 1]);
+		return -1;
+	}
+	return 0;
+}
+
 static int wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
@@ -777,7 +822,10 @@ static int wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 		return result;
 	}
 
-	return 0;
+	/*
+	 * Data response
+	 */
+	return spi_data_rsp(wilc, CMD_DMA_EXT_WRITE);
 }
 
 /********************************************
-- 
2.25.1

