Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:5812 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbXI3SjA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:39:00 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 03/26] at76_usb: Avoid dubious use of '\0'
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:38:58 -0400
Message-ID: <20070930183858.23921.63171.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 99b120a..9044f3d 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -463,7 +463,7 @@ static inline void at76_iwevent_bss_disconnect(struct net_device *netdev)
 	union iwreq_data wrqu;
 	wrqu.data.length = 0;
 	wrqu.data.flags = 0;
-	memset(wrqu.ap_addr.sa_data, '\0', ETH_ALEN);
+	memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event(netdev, SIOCGIWAP, &wrqu, NULL);
 	at76_dbg(DBG_WE_EVENTS, "%s: %s: SIOCGIWAP sent", netdev->name,
