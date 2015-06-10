Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay110.isp.belgacom.be ([195.238.20.137]:6993 "EHLO
	mailrelay110.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933947AbbFJQcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 12:32:22 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
	Fabian Frederick <fabf@skynet.be>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 1/1 linux-next] staging: rtl8723au: use swap() in WMMOnAssocRsp23a()
Date: Wed, 10 Jun 2015 18:32:17 +0200
Message-Id: <1433953937-23987-1-git-send-email-fabf@skynet.be> (sfid-20150610_183912_919744_3F0C6450)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/staging/rtl8723au/core/rtw_wlan_util.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
index 5280338..3c1315fc 100644
--- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
@@ -573,7 +573,7 @@ void WMMOnAssocRsp23a(struct rtw_adapter *padapter)
 	inx[0] = 0; inx[1] = 1; inx[2] = 2; inx[3] = 3;
 
 	if (pregpriv->wifi_spec == 1) {
-		u32 j, tmp, change_inx = false;
+		u32 j, change_inx = false;
 
 		/* entry indx: 0->vo, 1->vi, 2->be, 3->bk. */
 		for (i = 0; i < 4; i++) {
@@ -589,14 +589,8 @@ void WMMOnAssocRsp23a(struct rtw_adapter *padapter)
 				}
 
 				if (change_inx) {
-					tmp = edca[i];
-					edca[i] = edca[j];
-					edca[j] = tmp;
-
-					tmp = inx[i];
-					inx[i] = inx[j];
-					inx[j] = tmp;
-
+					swap(edca[i], edca[j]);
+					swap(inx[i], inx[j]);
 					change_inx = false;
 				}
 			}
-- 
2.4.2

