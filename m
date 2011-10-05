Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:47667 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934139Ab1JEJXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:23:21 -0400
Subject: [PATCH 2/6] ath6kl: fix struct host_app_area endian handling
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Oct 2011 12:23:17 +0300
Message-ID: <20111005092317.1095.3909.stgit@localhost6.localdomain6> (sfid-20111005_112324_819731_50653558)
In-Reply-To: <20111005092305.1095.713.stgit@localhost6.localdomain6>
References: <20111005092305.1095.713.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was missing endian annotation.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index c1d2366..8466f3d 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -120,7 +120,7 @@ static int ath6kl_set_host_app_area(struct ath6kl *ar)
 		return -EIO;
 
 	address = TARG_VTOP(ar->target_type, data);
-	host_app_area.wmi_protocol_ver = WMI_PROTOCOL_VERSION;
+	host_app_area.wmi_protocol_ver = cpu_to_le32(WMI_PROTOCOL_VERSION);
 	if (ath6kl_diag_write(ar, address, (u8 *) &host_app_area,
 			      sizeof(struct host_app_area)))
 		return -EIO;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 5166f05..96102c6 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -124,8 +124,8 @@ struct wmi {
 };
 
 struct host_app_area {
-	u32 wmi_protocol_ver;
-};
+	__le32 wmi_protocol_ver;
+} __packed;
 
 enum wmi_msg_type {
 	DATA_MSGTYPE = 0x0,

