Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41912 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757915AbcLSKzD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:55:03 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 03/11] rt2800: set minimum MPDU and PSDU lengths to sane values
Date: Mon, 19 Dec 2016 11:52:49 +0100
Message-Id: <1482144777-16760-4-git-send-email-sgruszka@redhat.com> (sfid-20161219_120332_999566_BD5A7FC4)
In-Reply-To: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
References: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 62bb9a6..ef71722 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4708,8 +4708,8 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
 	else
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 1);
-	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_PSDU, 0);
-	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_MPDU, 0);
+	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_PSDU, 10);
+	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_MPDU, 10);
 	rt2800_register_write(rt2x00dev, MAX_LEN_CFG, reg);
 
 	rt2800_register_read(rt2x00dev, LED_CFG, &reg);
-- 
1.7.1
