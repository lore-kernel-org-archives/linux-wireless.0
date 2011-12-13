Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:50974 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819Ab1LMJjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 04:39:47 -0500
Received: by mail-lpp01m010-f45.google.com with SMTP id s15so2634437lag.4
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2011 01:39:44 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH] wl12xx: don't write out of bounds when hlid > WL12XX_MAX_LINKS
Date: Tue, 13 Dec 2011 11:39:02 +0200
Message-Id: <1323769142-20515-1-git-send-email-coelho@ti.com> (sfid-20111213_103953_056146_03B3476D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should not get an hlid value bigger than WL12XX_MAX_LINKS from
wl1271_rx_handle_data().  We have a WARN_ON in case it happens.  But
despite the warning, we would still go ahead and write the hlid bit
into active_hlids (a stack variable).  This would cause us to
overwrite other data in the stack.

To avoid this problem, we now skip the write when issuing the warning,
so at least we don't corrupt data.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/rx.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 8c277c0..4fbd2a7 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -258,8 +258,12 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 						  wl->aggr_buf + pkt_offset,
 						  pkt_length, unaligned,
 						  &hlid) == 1) {
-				WARN_ON(hlid >= WL12XX_MAX_LINKS);
-				__set_bit(hlid, active_hlids);
+				if (hlid < WL12XX_MAX_LINKS)
+					__set_bit(hlid, active_hlids);
+				else
+					WARN(1,
+					     "hlid exceeded WL12XX_MAX_LINKS "
+					     "(%d)\n", hlid);
 			}
 
 			wl->rx_counter++;
-- 
1.7.4.1

