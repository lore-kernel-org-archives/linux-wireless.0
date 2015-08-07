Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38709 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbbHGNGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2015 09:06:44 -0400
From: Johannes Postma <jgmpostma@gmail.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org
Cc: Johannes Postma <jgmpostma@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] staging: rtl8723au: rtl8723a_hal_init: Improve code readability
Date: Fri,  7 Aug 2015 14:04:34 +0100
Message-Id: <1438952674-9823-1-git-send-email-jgmpostma@gmail.com> (sfid-20150807_150659_754352_FB10E1EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch improves code readability in the function
rtl8723a_cal_txdesc_chksum.  It improves the readability of the argument
of the function le16_to_cpu.

Signed-off-by: Johannes Postma <jgmpostma@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
index eb76ac4..cf2388f 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
@@ -1847,7 +1847,7 @@ static void rtl8723a_cal_txdesc_chksum(struct tx_desc *ptxdesc)
 	ptxdesc->txdw7 &= cpu_to_le32(0xffff0000);
 
 	for (index = 0; index < count; index++)
-		checksum ^= le16_to_cpu(*(usPtr + index));
+		checksum ^= le16_to_cpu(usPtr[index]);
 
 	ptxdesc->txdw7 |= cpu_to_le32(checksum & 0x0000ffff);
 }
-- 
2.5.0

