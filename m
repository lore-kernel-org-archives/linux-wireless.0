Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:52743 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbaF2Hlk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 03:41:40 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] staging: rtl8723au: Remove unnecessary null test before kfree
Date: Sun, 29 Jun 2014 09:40:03 +0200
Message-Id: <1404027603-4121-1-git-send-email-fabf@skynet.be> (sfid-20140629_094215_546550_CE03F80B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/staging/rtl8723au/core/rtw_cmd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index 1696cb8..6af2b4a 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -516,9 +516,7 @@ int rtw_joinbss_cmd23a(struct rtw_adapter *padapter,
 
 	psecnetwork = &psecuritypriv->sec_bss;
 	if (!psecnetwork) {
-		if (pcmd)
-			kfree(pcmd);
-
+		kfree(pcmd);
 		res = _FAIL;
 
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-- 
1.8.4.5

