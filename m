Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:45509 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaGKACd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:02:33 -0400
Received: by mail-we0-f178.google.com with SMTP id x48so285837wes.9
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:02:31 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/14] wl18xx: make sure fw_status->priv exists before deref
Date: Fri, 11 Jul 2014 03:01:38 +0300
Message-Id: <1405036899-27396-14-git-send-email-eliad@wizery.com> (sfid-20140711_022953_072945_06F9C098)
In-Reply-To: <1405036899-27396-1-git-send-email-eliad@wizery.com>
References: <1405036899-27396-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some corner cases with specific timings, we might
try dequeueing tx before we got information about
the link status (e.g. due to recovery during tx).

Instead of NULL dereference, assume all
the links in this case have low priorities.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 4422ecf..edc3e4d 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1609,9 +1609,14 @@ static bool wl18xx_lnk_high_prio(struct wl1271 *wl, u8 hlid,
 	u8 thold;
 	struct wl18xx_fw_status_priv *status_priv =
 		(struct wl18xx_fw_status_priv *)wl->fw_status->priv;
-	u32 suspend_bitmap = le32_to_cpu(status_priv->link_suspend_bitmap);
+	u32 suspend_bitmap;
+
+	/* if we don't have the link map yet, assume they all low prio */
+	if (!status_priv)
+		return false;
 
 	/* suspended links are never high priority */
+	suspend_bitmap = le32_to_cpu(status_priv->link_suspend_bitmap);
 	if (test_bit(hlid, (unsigned long *)&suspend_bitmap))
 		return false;
 
@@ -1631,8 +1636,13 @@ static bool wl18xx_lnk_low_prio(struct wl1271 *wl, u8 hlid,
 	u8 thold;
 	struct wl18xx_fw_status_priv *status_priv =
 		(struct wl18xx_fw_status_priv *)wl->fw_status->priv;
-	u32 suspend_bitmap = le32_to_cpu(status_priv->link_suspend_bitmap);
+	u32 suspend_bitmap;
+
+	/* if we don't have the link map yet, assume they all low prio */
+	if (!status_priv)
+		return true;
 
+	suspend_bitmap = le32_to_cpu(status_priv->link_suspend_bitmap);
 	if (test_bit(hlid, (unsigned long *)&suspend_bitmap))
 		thold = status_priv->tx_suspend_threshold;
 	else if (test_bit(hlid, (unsigned long *)&wl->fw_fast_lnk_map) &&
-- 
1.8.5.1.109.g3d252a9

