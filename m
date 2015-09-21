Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:50256 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166AbbIUOQG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 10:16:06 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-wireless@vger.kernel.org
Cc: Dan Williams <dcbw@redhat.com>, netdev@vger.kernel.org,
	Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/2] airo: Implement netif_carrier_on/off
Date: Mon, 21 Sep 2015 15:44:25 +0200
Message-Id: <1442843065-30234-2-git-send-email-linux@rainbow-software.org> (sfid-20150921_161610_847229_F29A19B4)
In-Reply-To: <1442843065-30234-1-git-send-email-linux@rainbow-software.org>
References: <1442843065-30234-1-git-send-email-linux@rainbow-software.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add calls to netif_carrier_on and netif_carrier_off

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/wireless/airo.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 67001a8..8ae838d 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -3267,6 +3267,7 @@ static void airo_handle_link(struct airo_info *ai)
 			wake_up_interruptible(&ai->thr_wait);
 		} else
 			airo_send_event(ai->dev);
+		netif_carrier_on(ai->dev);
 	} else if (!scan_forceloss) {
 		if (auto_wep && !ai->expires) {
 			ai->expires = RUN_AT(3*HZ);
@@ -3277,6 +3278,9 @@ static void airo_handle_link(struct airo_info *ai)
 		eth_zero_addr(wrqu.ap_addr.sa_data);
 		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 		wireless_send_event(ai->dev, SIOCGIWAP, &wrqu, NULL);
+		netif_carrier_off(ai->dev);
+	} else {
+		netif_carrier_off(ai->dev);
 	}
 }
 
@@ -3613,6 +3617,7 @@ static void disable_MAC( struct airo_info *ai, int lock ) {
 		return;
 
 	if (test_bit(FLAG_ENABLED, &ai->flags)) {
+		netif_carrier_off(ai->dev);
 		memset(&cmd, 0, sizeof(cmd));
 		cmd.cmd = MAC_DISABLE; // disable in case already enabled
 		issuecommand(ai, &cmd, &rsp);
-- 
Ondrej Zary

