Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44513 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbcB2VdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 16:33:18 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 12/15] wil6210: clean ioctl debug message
Date: Mon, 29 Feb 2016 23:32:47 +0200
Message-Id: <1456781570-16552-13-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160229_225949_572319_E45FC492)
In-Reply-To: <1456781570-16552-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1456781570-16552-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Fix a debug message related to IOCTL that was incorrectly logged
with the MISC category, and move it inside wil_ioctl so it will
always be logged even if we call wil_ioctl from other places.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/ioctl.c  | 11 +++++++++--
 drivers/net/wireless/ath/wil6210/netdev.c |  6 +-----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/ioctl.c b/drivers/net/wireless/ath/wil6210/ioctl.c
index f7f9486..6303800 100644
--- a/drivers/net/wireless/ath/wil6210/ioctl.c
+++ b/drivers/net/wireless/ath/wil6210/ioctl.c
@@ -161,13 +161,20 @@ out_free:
 
 int wil_ioctl(struct wil6210_priv *wil, void __user *data, int cmd)
 {
+	int ret;
+
 	switch (cmd) {
 	case WIL_IOCTL_MEMIO:
-		return wil_ioc_memio_dword(wil, data);
+		ret = wil_ioc_memio_dword(wil, data);
+		break;
 	case WIL_IOCTL_MEMIO_BLOCK:
-		return wil_ioc_memio_block(wil, data);
+		ret = wil_ioc_memio_block(wil, data);
+		break;
 	default:
 		wil_dbg_ioctl(wil, "Unsupported IOCTL 0x%04x\n", cmd);
 		return -ENOIOCTLCMD;
 	}
+
+	wil_dbg_ioctl(wil, "ioctl(0x%04x) -> %d\n", cmd, ret);
+	return ret;
 }
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index d4ec5b2..3bc0e26 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -60,11 +60,7 @@ static int wil_do_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
 {
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 
-	int ret = wil_ioctl(wil, ifr->ifr_data, cmd);
-
-	wil_dbg_misc(wil, "ioctl(0x%04x) -> %d\n", cmd, ret);
-
-	return ret;
+	return wil_ioctl(wil, ifr->ifr_data, cmd);
 }
 
 static const struct net_device_ops wil_netdev_ops = {
-- 
1.8.5.2

