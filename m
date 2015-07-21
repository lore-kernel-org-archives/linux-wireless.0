Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35053 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373AbbGURcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 13:32:07 -0400
From: Steve Pennington <sgpenn@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Greg Donald <gdonald@gmail.com>, Joe Perches <joe@perches.com>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	Masanari Iida <standby24x7@gmail.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Cc: Steve Pennington <sgpenn@gmail.com>
Subject: [PATCH] staging: rtl8723au: fix incorrect type in assignment warning
Date: Tue, 21 Jul 2015 12:31:35 -0500
Message-Id: <1437499895-18532-1-git-send-email-sgpenn@gmail.com> (sfid-20150721_193222_699245_E731759E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Repaced call to htons with call to cpu_to_be16s to fix the
following sparse warning:
drivers/staging/rtl8723au/core/rtw_recv.c:1557:21: warning: incorrect type in assignment (different base types)
drivers/staging/rtl8723au/core/rtw_recv.c:1557:21:    expected unsigned short [unsigned] [assigned] [usertype] len
drivers/staging/rtl8723au/core/rtw_recv.c:1557:21:    got restricted __be16 [usertype] <noident>

Signed-off-by: Steve Pennington <sgpenn@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 274a4b6..39318ae 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -1554,7 +1554,7 @@ static int wlanhdr_to_ethhdr (struct recv_frame *precvframe)
 	ether_addr_copy(ptr + ETH_ALEN, pattrib->src);
 
 	if (!bsnaphdr) {
-		len = htons(len);
+		cpu_to_be16s(&len);
 		memcpy(ptr + 12, &len, 2);
 	}
 
-- 
2.4.6

