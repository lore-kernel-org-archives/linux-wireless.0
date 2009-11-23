Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:50603 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754858AbZKWHQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 02:16:32 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3/6] rt2x00: Clean up use of rt2x00_intf_is_pci.
Date: Mon, 23 Nov 2009 08:16:02 +0100
Message-Id: <1258960565-26736-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1258960565-26736-3-git-send-email-gwingerde@gmail.com>
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com>
 <1258960565-26736-2-git-send-email-gwingerde@gmail.com>
 <1258960565-26736-3-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RT chipsets are unique across both PCI and USB busses, and don't overlap.
Therefore there is no need to test for bus type when only checking for
chipset type. Remove the redundant checks.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index ac393c3..b809c49 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -217,14 +217,12 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	if (rt2x00_intf_is_pci(rt2x00dev)) {
-		/*
-		* RT2880 and RT3052 don't support MCU requests.
-		*/
-		if (rt2x00_rt(&rt2x00dev->chip, RT2880) ||
-		    rt2x00_rt(&rt2x00dev->chip, RT3052))
-			return;
-	}
+	/*
+	 * RT2880 and RT3052 don't support MCU requests.
+	 */
+	if (rt2x00_rt(&rt2x00dev->chip, RT2880) ||
+	    rt2x00_rt(&rt2x00dev->chip, RT3052))
+		return;
 
 	mutex_lock(&rt2x00dev->csr_mutex);
 
@@ -1482,8 +1480,7 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 105, 0x05);
 	}
 
-	if (rt2x00_intf_is_pci(rt2x00dev) &&
-	    rt2x00_rt(&rt2x00dev->chip, RT3052)) {
+	if (rt2x00_rt(&rt2x00dev->chip, RT3052)) {
 		rt2800_bbp_write(rt2x00dev, 31, 0x08);
 		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
 		rt2800_bbp_write(rt2x00dev, 80, 0x08);
-- 
1.6.5.3

