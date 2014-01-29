Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbaA2Qnd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 11:43:33 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2800: disable PS by default on USB
Date: Wed, 29 Jan 2014 17:42:37 +0100
Message-Id: <1391013757-13078-1-git-send-email-sgruszka@redhat.com> (sfid-20140129_174339_111753_3F7B8B4C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have disabled it currently on other buses. PS can cause some issues,
not necessarily with our driver but on AP, that are not easy to debug.
Since behaviour differs on rt2800usb and rt2800pci, user usually blame
for malfunction rt2800usb driver, whereas issue is on AP side.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 776aff3..510dde0 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -7453,10 +7453,9 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 
 	/*
-	 * Disable powersaving as default on PCI devices.
+	 * Disable powersaving as default.
 	 */
-	if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
-		rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+	rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	/*
 	 * Initialize all hw fields.
-- 
1.8.3.1

