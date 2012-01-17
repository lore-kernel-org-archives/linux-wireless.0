Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55612 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab2AQMJ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 07:09:26 -0500
Received: by yenm6 with SMTP id m6so97095yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2012 04:09:26 -0800 (PST)
From: ilanelias78@gmail.com
To: samuel@sortiz.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH v3 3/3] NFC: Free sk_buff if nfcwilink_send fails
Date: Tue, 17 Jan 2012 14:11:33 +0200
Message-Id: <1326802293-11539-4-git-send-email-ilane@ti.com> (sfid-20120117_130930_016195_1DA995A4)
In-Reply-To: <1326802293-11539-1-git-send-email-ilane@ti.com>
References: <1326802293-11539-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Free sk_buff if nfcwilink_send fails.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 drivers/nfc/nfcwilink.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index 90af28d..1f74a77 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -489,8 +489,10 @@ static int nfcwilink_send(struct sk_buff *skb)
 
 	nfc_dev_dbg(&drv->pdev->dev, "send entry, len %d", skb->len);
 
-	if (!test_bit(NFCWILINK_RUNNING, &drv->flags))
-		return -EBUSY;
+	if (!test_bit(NFCWILINK_RUNNING, &drv->flags)) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	/* add the ST hdr to the start of the buffer */
 	hdr.len = cpu_to_le16(skb->len);
-- 
1.7.0.4

