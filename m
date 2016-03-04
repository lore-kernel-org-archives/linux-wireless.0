Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35394 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbcCDNnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 08:43:20 -0500
Received: by mail-wm0-f54.google.com with SMTP id l68so35481069wml.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2016 05:43:19 -0800 (PST)
From: Cihangir Akturk <cakturk@gmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Cihangir Akturk <cakturk@gmail.com>
Subject: [PATCH] drivers: staging: rtl8723au: remove unneeded null test
Date: Fri,  4 Mar 2016 15:43:10 +0200
Message-Id: <1457098990-8329-1-git-send-email-cakturk@gmail.com> (sfid-20160304_144334_865155_808BB0EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

null test on pnetwork removed, because the iterator variable
list_for_each_entry_safe cannot be null.

This commit fixes the following error reported by coccinelle:

drivers/staging/rtl8723au/core/rtw_mlme.c:1621:7-15: ERROR: iterator
variable bound on line 1620 cannot be NULL

Signed-off-by: Cihangir Akturk <cakturk@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_mlme.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index 3adda55..a786fc4 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -1617,19 +1617,10 @@ rtw_select_candidate_from_queue(struct mlme_priv *pmlmepriv)
 
 	spin_lock_bh(&pmlmepriv->scanned_queue.lock);
 	phead = get_list_head(queue);
-	list_for_each_entry_safe(pnetwork, ptmp, phead, list) {
-		if (!pnetwork) {
-			RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
-				 "%s: return _FAIL:(pnetwork == NULL)\n",
-				 __func__);
-			goto exit;
-		}
-
+	list_for_each_entry_safe(pnetwork, ptmp, phead, list)
 		rtw_check_join_candidate(pmlmepriv, &candidate, pnetwork);
-	}
-
-exit:
 	spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
+
 	return candidate;
 }
 
-- 
2.1.4

