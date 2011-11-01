Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33866 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab1KAM4B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 08:56:01 -0400
Received: by mail-gy0-f174.google.com with SMTP id 13so6988330gyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2011 05:56:01 -0700 (PDT)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH v3 3/3] NFC: Check if NCI data flow control is used
Date: Tue,  1 Nov 2011 14:54:57 +0200
Message-Id: <1320152097-2711-4-git-send-email-ilane@ti.com> (sfid-20111101_135605_655148_63B8B4D0)
In-Reply-To: <1320152097-2711-1-git-send-email-ilane@ti.com>
References: <1320152097-2711-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Check if NCI data flow control is used in nci_tx_work.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 net/nfc/nci/core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 9d0b530..056cd37 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -722,7 +722,9 @@ static void nci_tx_work(struct work_struct *work)
 		if (!skb)
 			return;
 
-		atomic_dec(&ndev->credits_cnt);
+		/* Check if data flow control is used */
+		if (atomic_read(&ndev->credits_cnt) != 0xff)
+			atomic_dec(&ndev->credits_cnt);
 
 		nfc_dbg("NCI TX: MT=data, PBF=%d, conn_id=%d, plen=%d",
 				nci_pbf(skb->data),
-- 
1.7.0.4

