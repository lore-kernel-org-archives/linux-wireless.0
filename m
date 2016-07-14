Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48172 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbcGNKWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2016 06:22:16 -0400
From: Colin King <colin.king@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bhaktipriya Shridhar <bhaktipriya96@gmail.com>,
	Bhumika Goyal <bhumirks@gmail.com>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	Shivani Bhardwaj <shivanib134@gmail.com>,
	Daniil Leshchev <meleodr@gmail.com>,
	Ksenija Stanojevic <ksenija.stanojevic@gmail.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: hal: check BT_Active and BT_State with correct bit pattern
Date: Thu, 14 Jul 2016 11:21:28 +0100
Message-Id: <1468491688-17225-1-git-send-email-colin.king@canonical.com> (sfid-20160714_122336_071093_7414C87E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

BT_Active and BT_State are being masked with 0x00ffffff so it the subsequent
comparisons with 0xffffffff are therefore a buggy check.  Instead, check them
against 0x00ffffff.

Unfortunately I couldn't find a datasheet or hardware to see if 0xffffffff
is an expected invalid bit pattern that should be checked before BT_Active and
BT_State are masked with 0x00ffffff, so for now, this fix seems like the least
risky approach.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
index bfcbd7a..6989580 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
@@ -9824,7 +9824,7 @@ void BTDM_CheckBTIdleChange1Ant(struct rtw_adapter *padapter)
 	BT_Polling = rtl8723au_read32(padapter, regBTPolling);
 	RTPRINT(FBT, BT_TRACE, ("[DM][BT], BT_Polling(0x%x) =%x\n", regBTPolling, BT_Polling));
 
-	if (BT_Active == 0xffffffff && BT_State == 0xffffffff && BT_Polling == 0xffffffff)
+	if (BT_Active == 0x00ffffff && BT_State == 0x00ffffff && BT_Polling == 0xffffffff)
 		return;
 	if (BT_Polling == 0)
 		return;
-- 
2.8.1

