Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [220.194.60.87] ([220.194.60.87]:43876 "EHLO
	mail.redflag-linux.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932203AbcHKOTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 10:19:08 -0400
From: Bing Sun <sunbing@redflag-linux.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	sunbing.linux@gmail.com, Bing Sun <sunbing@redflag-linux.com>
Subject: [PATCH] Staging: rtl8723au: os_intfs: fixed case statement is variable issue
Date: Thu, 11 Aug 2016 22:11:35 +0800
Message-Id: <1470924695-14931-1-git-send-email-sunbing@redflag-linux.com> (sfid-20160811_161912_163082_35973C6B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed sparse parse error:
Expected constant expression in case statement.

Signed-off-by: Bing Sun <sunbing@redflag-linux.com>
---
 drivers/staging/rtl8723au/os_dep/os_intfs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
index b8848c2..f30d5d2 100644
--- a/drivers/staging/rtl8723au/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723au/os_dep/os_intfs.c
@@ -283,14 +283,13 @@ static u32 rtw_classify8021d(struct sk_buff *skb)
 	 */
 	if (skb->priority >= 256 && skb->priority <= 263)
 		return skb->priority - 256;
-	switch (skb->protocol) {
-	case htons(ETH_P_IP):
+
+	if (skb->protocol == htons(ETH_P_IP)) {
 		dscp = ip_hdr(skb)->tos & 0xfc;
-		break;
-	default:
-		return 0;
+		return dscp >> 5;
 	}
-	return dscp >> 5;
+
+	return 0;
 }
 
 static u16 rtw_select_queue(struct net_device *dev, struct sk_buff *skb,
-- 
2.1.0

