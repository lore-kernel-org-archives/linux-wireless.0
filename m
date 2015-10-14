Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43539 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520AbbJNLr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:47:27 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/16] staging: wilc1000: remove typedef from the tstrInterfaceInfo
Date: Wed, 14 Oct 2015 20:46:32 +0900
Message-ID: <1444823204-16736-4-git-send-email-tony.cho@atmel.com> (sfid-20151014_134732_079981_E7FF2301)
In-Reply-To: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the tstrInterfaceInfo and renames it to
the wilc_vif.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 2fe0ef0..ca14fd6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -148,12 +148,12 @@ typedef struct {
 
 } struct_frame_reg;
 
-typedef struct {
+struct wilc_vif {
 	u8 aSrcAddress[ETH_ALEN];
 	u8 aBSSID[ETH_ALEN];
 	struct host_if_drv *drvHandler;
 	struct net_device *wilc_netdev;
-} tstrInterfaceInfo;
+};
 
 struct wilc {
 	int mac_status;
@@ -163,7 +163,7 @@ struct wilc {
 	#endif
 	int close;
 	u8 u8NoIfcs;
-	tstrInterfaceInfo strInterfaceInfo[NUM_CONCURRENT_IFC];
+	struct wilc_vif strInterfaceInfo[NUM_CONCURRENT_IFC];
 	u8 open_ifcs;
 
 	struct semaphore txq_add_to_head_cs;
-- 
1.9.1

