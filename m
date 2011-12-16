Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36971 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760646Ab1LPIyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 03:54:54 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>,
	Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>
Subject: [PATCH 2/2] ath6kl: Send own IP addr to the firmware during WOW suspend
Date: Fri, 16 Dec 2011 14:24:24 +0530
Message-ID: <1324025664-4896-2-git-send-email-rmani@qca.qualcomm.com> (sfid-20111216_095500_337219_B36CF6AB)
In-Reply-To: <1324025664-4896-1-git-send-email-rmani@qca.qualcomm.com>
References: <1324025664-4896-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware ARP module requires own IP addr in order to respond
to the outside world when the target is in WOW suspend state.

At present, firmware ARP module has capability to hold 2 IP addr.
So, WOW mode will be disabled if the total IP addr configured in
net_dev for our device is greater than firmware limit (MAX_IP_ADDRS)
which is 2 at this moment.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
Signed-off-by: Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   33 +++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6c59a21..967932b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/moduleparam.h>
+#include <linux/inetdevice.h>
 
 #include "core.h"
 #include "cfg80211.h"
@@ -1730,11 +1731,14 @@ static int ath6kl_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 
 static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 {
+	struct in_device *in_dev;
+	struct in_ifaddr *ifa;
 	struct ath6kl_vif *vif;
 	int ret, pos, left;
 	u32 filter = 0;
 	u16 i;
-	u8 mask[WOW_MASK_SIZE];
+	u8 mask[WOW_MASK_SIZE], index = 0;
+	__be32 ips[MAX_IP_ADDRS];
 
 	vif = ath6kl_vif_first(ar);
 	if (!vif)
@@ -1781,6 +1785,33 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 			return ret;
 	}
 
+	/* Setup own IP addr for ARP agent. */
+	in_dev = __in_dev_get_rtnl(vif->ndev);
+	if (!in_dev)
+		goto skip_arp;
+
+	ifa = in_dev->ifa_list;
+	memset(&ips, 0, sizeof(ips));
+
+	/* Configure IP addr only if IP address count < MAX_IP_ADDRS */
+	while (index < MAX_IP_ADDRS && ifa) {
+		ips[index] = ifa->ifa_local;
+		ifa = ifa->ifa_next;
+		index++;
+	}
+
+	if (ifa) {
+		ath6kl_err("total IP addr count is exceeding fw limit\n");
+		return -EINVAL;
+	}
+
+	ret = ath6kl_wmi_set_ip_cmd(ar->wmi, vif->fw_vif_idx, ips[0], ips[1]);
+	if (ret) {
+		ath6kl_err("fail to setup ip for arp agent\n");
+		return ret;
+	}
+
+skip_arp:
 	if (wow->disconnect)
 		filter |= WOW_FILTER_OPTION_NWK_DISASSOC;
 
-- 
1.7.1

