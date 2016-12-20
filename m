Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:35638 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763858AbcLTQLM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 11:11:12 -0500
Received: by mail-qt0-f169.google.com with SMTP id c47so180971382qtc.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2016 08:11:12 -0800 (PST)
From: Geoff Lansberry <geoff@kuvee.com>
To: linux-wireless@vger.kernel.org
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, robh+dt@kernel.org, mark.rutland@arm.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgreer@animalcreek.com,
        justin@kuvee.com, Geoff Lansberry <glansberry@gmail.com>,
        Geoff Lansberry <geoff@kuvee.com>
Subject: [PATCH 3/3] mod of frequency
Date: Tue, 20 Dec 2016 11:10:48 -0500
Message-Id: <1482250250-4192-5-git-send-email-glansberry@gmail.com> (sfid-20161220_171544_429326_372BF8B9)
In-Reply-To: <1482250250-4192-1-git-send-email-glansberry@gmail.com>
References: <1482250250-4192-1-git-send-email-glansberry@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/nfc/trf7970a.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index e9e93ea..5916737 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -2076,10 +2076,10 @@ static int trf7970a_probe(struct spi_device *spi)
 	of_property_read_u32(np, "clock-frequency", &clk_freq);
 	if ((clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) ||
 		(clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY)) {
-	        dev_err(trf->dev,
-	                "clock-frequency (%u Hz) unsupported\n",
-	                clk_freq);
-	        return -EINVAL;
+		dev_err(trf->dev,
+			"clock-frequency (%u Hz) unsupported\n",
+			clk_freq);
+		return -EINVAL;
 	}
 
 	if (of_property_read_bool(np, "en2-rf-quirk"))
-- 
Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
