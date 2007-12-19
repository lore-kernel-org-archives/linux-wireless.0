Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:40758 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbXLSQJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:09:55 -0500
Subject: [PATCH 126/48] libertas: submit RSSI command on tx timeout, to check whether module is dead
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50v6-00021M-5D@pmac.infradead.org> (sfid-20071219_160957_999555_4A14F3A9)
Date: Wed, 19 Dec 2007 15:33:16 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 17 Dec 2007 19:22:40 -0500

We don't necessarily want to reset the device on a TX timeout. But more
often than not, the real cause is that the firmware has crapped itself,
not just that the network is busy. So submit any harmless command, and
if _that_ times out, then the error handling code will reset the module,
as appropriate.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/main.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 9677b0d..74353e1 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -476,6 +476,13 @@ static void lbs_tx_timeout(struct net_device *dev)
 	   to kick it somehow? */
 	lbs_host_to_card_done(priv);
 
+	/* More often than not, this actually happens because the
+	   firmware has crapped itself -- rather than just a very
+	   busy medium. So send a harmless command, and if/when
+	   _that_ times out, we'll kick it in the head. */
+	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
+				     0, 0, NULL);
+
 	lbs_deb_leave(LBS_DEB_TX);
 }
 
-- 
1.5.3.4

