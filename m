Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1-priv.urz.unibas.ch ([131.152.226.164]:43203 "EHLO
        mx1-priv.urz.unibas.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752600AbdGIVrd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Jul 2017 17:47:33 -0400
From: Ilia Sergachev <ilia.sergachev@unibas.ch>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ilia Sergachev <ilia.sergachev@unibas.ch>
Subject: [PATCH] staging: wilc1000: fix variable signedness
Date: Sun,  9 Jul 2017 23:36:35 +0200
Message-Id: <20170709213635.18692-1-ilia.sergachev@unibas.ch> (sfid-20170709_234756_220986_5B579925)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

txq_count receives a value from wilc_wlan_handle_txq()
and therefore should be u32

found using sparse:
drivers/staging/wilc1000/linux_wlan.c:306:58: warning:
 incorrect type in argument 2 (different signedness)

Signed-off-by: Ilia Sergachev <ilia.sergachev@unibas.ch>
---
 drivers/staging/wilc1000/linux_wlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 308708450830..0b097aca597e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -283,7 +283,8 @@ int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc)
 
 static int linux_wlan_txq_task(void *vp)
 {
-	int ret, txq_count;
+	int ret;
+	u32 txq_count;
 	struct wilc_vif *vif;
 	struct wilc *wl;
 	struct net_device *dev = vp;
-- 
2.11.0
