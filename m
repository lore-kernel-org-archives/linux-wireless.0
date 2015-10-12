Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12838 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbbJLH6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:58:38 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 19/41] staging: wilc1000: remove typedef from tenuHostIFstate
Date: Mon, 12 Oct 2015 16:55:53 +0900
Message-ID: <1444636575-2486-19-git-send-email-tony.cho@atmel.com> (sfid-20151012_095841_346580_A505DDEE)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the enum tenuHostIFstate and
rename it to host_if_state.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 9cf1e99..0460af2 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -72,8 +72,7 @@ typedef struct _tstrStatistics {
 
 } tstrStatistics;
 
-
-typedef enum {
+enum host_if_state {
 	HOST_IF_IDLE			= 0,
 	HOST_IF_SCANNING		= 1,
 	HOST_IF_CONNECTING		= 2,
@@ -81,7 +80,7 @@ typedef enum {
 	HOST_IF_CONNECTED		= 4,
 	HOST_IF_P2P_LISTEN		= 5,
 	HOST_IF_FORCE_32BIT		= 0xFFFFFFFF
-} tenuHostIFstate;
+};
 
 struct host_if_pmkid {
 	u8 bssid[ETH_ALEN];
@@ -313,7 +312,7 @@ struct host_if_drv {
 	u64 u64P2p_MgmtTimeout;
 	u8 u8P2PConnect;
 
-	tenuHostIFstate enuHostIFstate;
+	enum host_if_state enuHostIFstate;
 
 	u8 au8AssociatedBSSID[ETH_ALEN];
 	struct cfg_param_val strCfgValues;
-- 
1.9.1

