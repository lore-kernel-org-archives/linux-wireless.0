Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24113 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbaHFHcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2014 03:32:39 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 10/13] wil6210: Limit max number of associated stations
Date: Wed, 6 Aug 2014 10:31:58 +0300
Message-ID: <1407310322-22568-11-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140806_095907_798560_6BF695D4)
In-Reply-To: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a module parameter to support setting the maximum
number of stations that can be associated to an AP.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 0beb129..596d6c1 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -14,6 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/moduleparam.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 
@@ -22,6 +23,10 @@
 #include "wmi.h"
 #include "trace.h"
 
+static uint max_assoc_sta = 1;
+module_param(max_assoc_sta, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(max_assoc_sta, " Max number of stations associated to the AP");
+
 /**
  * WMI event receiving - theory of operations
  *
@@ -794,7 +799,7 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan)
 		.network_type = wmi_nettype,
 		.disable_sec_offload = 1,
 		.channel = chan - 1,
-		.pcp_max_assoc_sta = WIL6210_MAX_CID,
+		.pcp_max_assoc_sta = max_assoc_sta,
 	};
 	struct {
 		struct wil6210_mbox_hdr_wmi wmi;
@@ -804,6 +809,14 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan)
 	if (!wil->secure_pcp)
 		cmd.disable_sec = 1;
 
+	if ((cmd.pcp_max_assoc_sta > WIL6210_MAX_CID) ||
+	    (cmd.pcp_max_assoc_sta <= 0)) {
+		wil_info(wil,
+			 "Requested connection limit %u, valid values are 1 - %d. Setting to %d\n",
+			 max_assoc_sta, WIL6210_MAX_CID, WIL6210_MAX_CID);
+		cmd.pcp_max_assoc_sta = WIL6210_MAX_CID;
+	}
+
 	/*
 	 * Processing time may be huge, in case of secure AP it takes about
 	 * 3500ms for FW to start AP
-- 
1.8.5.2

