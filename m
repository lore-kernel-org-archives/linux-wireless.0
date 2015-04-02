Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34417 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbbDBNhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 09:37:46 -0400
Date: Thu, 2 Apr 2015 15:37:30 +0200
From: Piotr Witoslawski <pwitos@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Yannis Damigos <giannis.damigos@gmail.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] drivers: staging: rtl8723au: fix "warning: cast to
 restricted __le16"
Message-ID: <20150402133730.GA28331@pwitoslawski.warsaw.osa> (sfid-20150402_153751_513378_019ECF5F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20150402093748.GA24455@pwitoslawski.warsaw.osa>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the sparse warning: "cast to restricted __le16" reported
for rtl8723au/hal/rtl8723au_xmit.c

Signed-off-by: Piotr Witoslawski <pwitos@gmail.com>
---
v2: Changing pointer type instead of casting, as suggested by Jes Sorensen <jes.sorensen@redhat.com>

 drivers/staging/rtl8723au/hal/rtl8723au_xmit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c b/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
index 1759487..967e7de 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
@@ -42,7 +42,7 @@ static int urb_zero_packet_chk(struct rtw_adapter *padapter, int sz)
 
 static void rtl8192cu_cal_txdesc_chksum(struct tx_desc	*ptxdesc)
 {
-		u16	*usPtr = (u16 *)ptxdesc;
+		__le16	*usPtr = (__le16 *)ptxdesc;
 		u32 count = 16;		/*  (32 bytes / 2 bytes per XOR) => 16 times */
 		u32 index;
 		u16 checksum = 0;
-- 
2.0.5

