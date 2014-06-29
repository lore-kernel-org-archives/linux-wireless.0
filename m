Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:25135 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbaF2HuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 03:50:25 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] staging: rtl8723au: Another case of unnecessary null test before kfree
Date: Sun, 29 Jun 2014 09:49:05 +0200
Message-Id: <1404028145-4526-1-git-send-email-fabf@skynet.be> (sfid-20140629_095049_762695_03BF696B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/staging/rtl8723au/core/rtw_ap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index c8700b3..8714ae3 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -1270,8 +1270,7 @@ static void update_bcn_wps_ie(struct rtw_adapter *padapter)
 		pnetwork->IELength = wps_offset + (wps_ielen+2) + remainder_ielen;
 	}
 
-	if (pbackup_remainder_ie)
-		kfree(pbackup_remainder_ie);
+	kfree(pbackup_remainder_ie);
 }
 
 static void update_bcn_p2p_ie(struct rtw_adapter *padapter)
-- 
1.8.4.5

