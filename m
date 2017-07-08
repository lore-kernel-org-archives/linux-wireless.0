Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38407 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750883AbdGHWp1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Jul 2017 18:45:27 -0400
From: Dmitriy Cherkasov <dmitriy@oss-tech.org>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Dmitriy Cherkasov <dmitriy@oss-tech.org>
Subject: [PATCH] staging: wilc1000: add parameter name to function definition
Date: Sat,  8 Jul 2017 15:44:47 -0700
Message-Id: <1499553887-22945-1-git-send-email-dmitriy@oss-tech.org> (sfid-20170709_004605_556744_A37FA77F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add missing parameter name to fix the following checkpatch.pl warning:

WARNING: function definition argument 'struct device *' should also have
an identifier name

Signed-off-by: Dmitriy Cherkasov <dmitriy@oss-tech.org>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index c89bf43..7a36561 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -227,8 +227,8 @@ struct WILC_WFI_mon_priv {
 void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void wilc_mac_indicate(struct wilc *wilc, int flag);
 void wilc_netdev_cleanup(struct wilc *wilc);
-int wilc_netdev_init(struct wilc **wilc, struct device *, int io_type, int gpio,
-		     const struct wilc_hif_func *ops);
+int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
+		     int gpio, const struct wilc_hif_func *ops);
 void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
 int wilc_wlan_get_firmware(struct net_device *dev);
-- 
1.9.1
