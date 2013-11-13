Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:50752 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab3KME4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 23:56:25 -0500
Received: by mail-ie0-f181.google.com with SMTP id tp5so4725178ieb.40
        for <linux-wireless@vger.kernel.org>; Tue, 12 Nov 2013 20:56:24 -0800 (PST)
From: Alexandre Demers <alexandre.f.demers@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] staging r8712u: Remove useless netdev_info slowly polluting dmesg
Date: Tue, 12 Nov 2013 23:56:22 -0500
Message-Id: <1384318582-10486-1-git-send-email-alexandre.f.demers@gmail.com> (sfid-20131113_055628_435758_C5946432)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove useless netdev_info slowly flooding dmesg.
Fixes bug https://bugzilla.kernel.org/show_bug.cgi?id=64231

Signed-off-by: Alexandre Demers <alexandre.f.demers@gmail.com>
---
 drivers/staging/rtl8712/rtl871x_mlme.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 6596154..7e29f48 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -1043,9 +1043,6 @@ void r8712_got_addbareq_event_callback(struct _adapter *adapter, u8 *pbuf)
 	struct	sta_priv *pstapriv = &adapter->stapriv;
 	struct	recv_reorder_ctrl *precvreorder_ctrl = NULL;
 
-	netdev_info(adapter->pnetdev, "%s: mac = %pM, seq = %d, tid = %d\n",
-		    __func__, pAddbareq_pram->MacAddress,
-	    pAddbareq_pram->StartSeqNum, pAddbareq_pram->tid);
 	psta = r8712_get_stainfo(pstapriv, pAddbareq_pram->MacAddress);
 	if (psta) {
 		precvreorder_ctrl =
-- 
1.8.4.2

