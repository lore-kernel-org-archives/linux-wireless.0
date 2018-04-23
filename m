Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:53124 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932169AbeDWQgI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:36:08 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RESEND 32/33] staging: wilc1000: remove the use of goto label in wilc_spi_clear_int_ext()
Date: Mon, 23 Apr 2018 22:03:34 +0530
Message-ID: <1524501215-4963-33-git-send-email-ajay.kathat@microchip.com> (sfid-20180423_183613_858281_190B6D27)
In-Reply-To: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
References: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove goto label '_fail_' used in wilc_spi_clear_int_ext(), to avoid
the label name starting with '_'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 1db2814..2cb9f4e 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1013,7 +1013,7 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 			dev_err(&spi->dev,
 				"Failed wilc_spi_write_reg, set reg %x ...\n",
 				0x10c8 + i * 4);
-			goto _fail_;
+			return ret;
 		}
 		for (i = g_spi.nint; i < MAX_NUM_INT; i++) {
 			if (flags & 1)
@@ -1035,7 +1035,7 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 	ret = wilc_spi_write_reg(wilc, WILC_VMM_TBL_CTL, tbl_ctl);
 	if (!ret) {
 		dev_err(&spi->dev, "fail write reg vmm_tbl_ctl...\n");
-		goto _fail_;
+		return ret;
 	}
 
 	if ((val & EN_VMM) == EN_VMM) {
@@ -1045,10 +1045,10 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 		ret = wilc_spi_write_reg(wilc, WILC_VMM_CORE_CTL, 1);
 		if (!ret) {
 			dev_err(&spi->dev, "fail write reg vmm_core_ctl...\n");
-			goto _fail_;
+			return ret;
 		}
 	}
-_fail_:
+
 	return ret;
 }
 
-- 
2.7.4
