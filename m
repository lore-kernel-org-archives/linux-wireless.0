Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:40690 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756123Ab1DASJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 14:09:16 -0400
Received: by eyg5 with SMTP id 5so1371859eyg.24
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 11:09:13 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: fix sparse warning about undeclared wl12xx_alloc_dummy_packet
Date: Fri,  1 Apr 2011 21:09:47 +0300
Message-Id: <1301681387-9203-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix sparse warning:

  CHECK   drivers/net/wireless/wl12xx/main.c
drivers/net/wireless/wl12xx/main.c:1246:17: warning: symbol 'wl12xx_alloc_dummy_packet' was not declared. Should it be static?

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 732fd21..866453b 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1243,7 +1243,7 @@ int wl1271_tx_dummy_packet(struct wl1271 *wl)
  */
 #define TOTAL_TX_DUMMY_PACKET_SIZE (ALIGN(1400, 512))
 
-struct sk_buff *wl12xx_alloc_dummy_packet(struct wl1271 *wl)
+static struct sk_buff *wl12xx_alloc_dummy_packet(struct wl1271 *wl)
 {
 	struct sk_buff *skb;
 	struct ieee80211_hdr_3addr *hdr;
-- 
1.7.1

