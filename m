Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:39181 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbbAaPDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2015 10:03:16 -0500
Received: by mail-we0-f181.google.com with SMTP id k48so31872987wev.12
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2015 07:03:14 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: core: rtw_wlan_util: Removed variables that is never used
Date: Sat, 31 Jan 2015 16:06:35 +0100
Message-Id: <1422716796-5008-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20150131_160329_882801_E9CBD80A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Variable was assigned a value that was never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8723au/core/rtw_wlan_util.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
index 69d9e0f..ee2d024 100644
--- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
@@ -1531,7 +1531,7 @@ void process_addba_req23a(struct rtw_adapter *padapter,
 			  u8 *paddba_req, u8 *addr)
 {
 	struct sta_info *psta;
-	u16 tid, start_seq, param;
+	u16 tid, param;
 	struct recv_reorder_ctrl *preorder_ctrl;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct ADDBA_request *preq = (struct ADDBA_request *)paddba_req;
@@ -1541,8 +1541,6 @@ void process_addba_req23a(struct rtw_adapter *padapter,
 	psta = rtw_get_stainfo23a(pstapriv, addr);
 
 	if (psta) {
-		start_seq = le16_to_cpu(preq->BA_starting_seqctrl) >> 4;
-
 		param = le16_to_cpu(preq->BA_para_set);
 		tid = (param >> 2) & 0x0f;
 
-- 
1.7.10.4

