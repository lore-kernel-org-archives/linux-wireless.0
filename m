Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033945AbdAFNKE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 08:10:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: [PATCH 6/9] rt2800: fallback from mcs8 to mcs7
Date: Fri,  6 Jan 2017 14:05:15 +0100
Message-Id: <1483707918-31480-7-git-send-email-sgruszka@redhat.com> (sfid-20170106_141117_378554_98E24EE0)
In-Reply-To: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
References: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we do not fallback to lower rate, we are unable to calculate
correctly number of retries in TX status code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 1f4a120..6cac311 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4968,7 +4968,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, HT_FBK_CFG0, reg);
 
 	rt2800_register_read(rt2x00dev, HT_FBK_CFG1, &reg);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS8FBK, 8);
+	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS8FBK, 7);
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS9FBK, 8);
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS10FBK, 9);
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS11FBK, 10);
-- 
2.7.4
