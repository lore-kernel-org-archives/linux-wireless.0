Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:35565 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbbDBJiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 05:38:05 -0400
Date: Thu, 2 Apr 2015 11:37:48 +0200
From: Piotr Witoslawski <pwitos@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Yannis Damigos <giannis.damigos@gmail.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: staging: rtl8723au: fix "warning: cast to
 restricted __le16"
Message-ID: <20150402093748.GA24455@pwitoslawski.warsaw.osa> (sfid-20150402_113826_262654_D3EC2DB1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Piotr Witoslawski <pwitos@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723au_xmit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c b/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
index 1759487..256958e 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
@@ -51,7 +51,8 @@ static void rtl8192cu_cal_txdesc_chksum(struct tx_desc	*ptxdesc)
 		ptxdesc->txdw7 &= cpu_to_le32(0xffff0000);
 
 		for (index = 0 ; index < count ; index++)
-			checksum = checksum ^ le16_to_cpu(*(usPtr + index));
+			checksum = checksum ^ le16_to_cpu(
+				*(__le16 *)(usPtr + index));
 
 		ptxdesc->txdw7 |= cpu_to_le32(0x0000ffff&checksum);
 }
-- 
2.0.5

