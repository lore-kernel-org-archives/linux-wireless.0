Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24814 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbJDHXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 03:23:52 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 05/10] wil6210: treat broadcast bssid as "disconnect all"
Date: Sun,  4 Oct 2015 10:23:22 +0300
Message-Id: <1443943407-6663-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151004_092357_043078_2796A4B0)
In-Reply-To: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hostapd request disconnect for broadcast bssid when it
wants to disconnect all stations from the AP.

Detect this and really disconnect all connected stations.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 2fb04c5..de6e3c2 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -203,11 +203,13 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 	 * - disconnect single STA, already disconnected
 	 * - disconnect all
 	 *
-	 * For "disconnect all", there are 2 options:
+	 * For "disconnect all", there are 3 options:
 	 * - bssid == NULL
+	 * - bssid is broadcast address (ff:ff:ff:ff:ff:ff)
 	 * - bssid is our MAC address
 	 */
-	if (bssid && memcmp(ndev->dev_addr, bssid, ETH_ALEN)) {
+	if (bssid && !is_broadcast_ether_addr(bssid) &&
+	    !ether_addr_equal_unaligned(ndev->dev_addr, bssid)) {
 		cid = wil_find_cid(wil, bssid);
 		wil_dbg_misc(wil, "Disconnect %pM, CID=%d, reason=%d\n",
 			     bssid, cid, reason_code);
-- 
2.1.4

