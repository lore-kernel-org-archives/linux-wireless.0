Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46313 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab1HYJnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 05:43:24 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so1509667wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 02:43:23 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/6] wl12xx: AP mode - don't regulate FW blocks for non-active STAs
Date: Thu, 25 Aug 2011 12:43:13 +0300
Message-Id: <1314265397-19873-2-git-send-email-arik@wizery.com> (sfid-20110825_114327_779596_2BCFCFEC)
In-Reply-To: <1314265397-19873-1-git-send-email-arik@wizery.com>
References: <1314265397-19873-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check a STA is associated before regulating its PS-status in mac80211.
Should never happen, so warn as a precaution.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index eb98832..572c6e6 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -30,6 +30,7 @@
 #include "reg.h"
 #include "ps.h"
 #include "tx.h"
+#include "event.h"
 
 static int wl1271_set_default_wep_key(struct wl1271 *wl, u8 id)
 {
@@ -132,6 +133,11 @@ static void wl1271_tx_regulate_link(struct wl1271 *wl, u8 hlid)
 	if (hlid < WL1271_AP_STA_HLID_START)
 		return;
 
+	if (!wl1271_is_active_sta(wl, hlid)) {
+		WARN_ON(1);
+		return;
+	}
+
 	fw_ps = test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 	tx_pkts = wl->links[hlid].allocated_pkts;
 
-- 
1.7.4.1

