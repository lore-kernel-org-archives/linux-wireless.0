Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1860 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab3K2Ksf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 05:48:35 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH V2 6/7] brcmfmac: reduce logging noise accessing SDIO
 SleepCSR register
Date: Fri, 29 Nov 2013 11:48:18 +0100
Message-ID: <1385722099-5102-7-git-send-email-arend@broadcom.com> (sfid-20131129_114859_027481_1DDA0269)
In-Reply-To: <1385722099-5102-1-git-send-email-arend@broadcom.com>
References: <1385722099-5102-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SleepCSR register is accessed to wakeup the device from the
host side. Depending on the state of the device this may take
multiple attempts. The failed attempt are not real failures so
reduce the log level specifically for this register. The calling
function will scream when the multiple attempts all failed.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 905704e..009d2a0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -156,10 +156,21 @@ int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 		}
 	}
 
-	if (err_ret)
-		brcmf_err("Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
-			  rw ? "write" : "read", func, regaddr, *byte, err_ret);
-
+	if (err_ret) {
+		/*
+		 * SleepCSR register access can fail when
+		 * waking up the device so reduce this noise
+		 * in the logs.
+		 */
+		if (regaddr != SBSDIO_FUNC1_SLEEPCSR)
+			brcmf_err("Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
+				  rw ? "write" : "read", func, regaddr, *byte,
+				  err_ret);
+		else
+			brcmf_dbg(SDIO, "Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
+				  rw ? "write" : "read", func, regaddr, *byte,
+				  err_ret);
+	}
 	return err_ret;
 }
 
-- 
1.7.10.4


