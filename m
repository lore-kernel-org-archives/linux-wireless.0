Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:2297 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbeISLlx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:41:53 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/29] staging: wilc1000: change return type to 'void' for wilc_frame_register()
Date: Wed, 19 Sep 2018 11:34:51 +0530
Message-ID: <1537337119-14952-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080535_517380_FA868266)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to use 'void' return type for wilc_frame_register(), as
its return value is not used.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5388be9..7729f83 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3641,14 +3641,14 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 	return result;
 }
 
-int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
+void wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 {
 	int result;
 	struct host_if_msg *msg;
 
 	msg = wilc_alloc_work(vif, handle_register_frame, false);
 	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+		return;
 
 	switch (frame_type) {
 	case ACTION:
@@ -3670,8 +3670,6 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
-
-	return result;
 }
 
 int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index a48818f..15ffaeb 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -348,7 +348,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   wilc_remain_on_chan_ready ready,
 			   void *user_arg);
 int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id);
-int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
+void wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
 			     u8 ifc_id);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
-- 
2.7.4
