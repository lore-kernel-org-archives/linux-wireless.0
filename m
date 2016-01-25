Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41091 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbcAYHnw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 02:43:52 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 17/26] staging: wilc1000: ignore power save
Date: Mon, 25 Jan 2016 16:35:21 +0900
Message-ID: <1453707330-13526-18-git-send-email-glen.lee@atmel.com> (sfid-20160125_090653_967661_18FEF147)
In-Reply-To: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If two interfaces are connected and it is required to enable power save then
ignore the request.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index bc8357d..a0603f0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4342,6 +4342,9 @@ s32 wilc_set_power_mgmt(struct wilc_vif *vif, bool bIsEnabled, u32 u32Timeout)
 		return -EFAULT;
 	}
 
+	if (wilc_wlan_get_num_conn_ifcs(vif->wilc) == 2 && bIsEnabled)
+		return 0;
+
 	PRINT_D(HOSTINF_DBG, "Setting Power management message queue params\n");
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-- 
1.9.1

