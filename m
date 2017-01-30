Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750971AbdA3L2h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 06:28:37 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH v2] rt2800: enable rt3290 unconditionally on pci probe
Date: Mon, 30 Jan 2017 12:12:47 +0100
Message-Id: <1485774767-6655-1-git-send-email-sgruszka@redhat.com> (sfid-20170130_122840_902802_F5CE2A5D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we restart system using sysrq RT3290 device do not initalize
properly, hance always enable it via WLAN_FUN_CTRL register on
probe.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=85461
Reported-and-tested-by: Giedrius Statkevičius <edrius.statkevicius@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 560b696..c6e64cc 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -373,9 +373,6 @@ static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
 	int i, count;
 
 	rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
-	if (rt2x00_get_field32(reg, WLAN_EN))
-		return 0;
-
 	rt2x00_set_field32(&reg, WLAN_GPIO_OUT_OE_BIT_ALL, 0xff);
 	rt2x00_set_field32(&reg, FRC_WL_ANT_SET, 1);
 	rt2x00_set_field32(&reg, WLAN_CLK_EN, 0);
-- 
1.8.3.1
