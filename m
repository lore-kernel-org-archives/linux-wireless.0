Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:46185 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753669Ab2BBEmn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 23:42:43 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.3] mwifiex: handle association failure case correctly
Date: Wed,  1 Feb 2012 20:41:43 -0800
Message-Id: <1328157705-21564-1-git-send-email-bzhao@marvell.com> (sfid-20120202_054311_941777_BA78FE92)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently even if association is failed "iw link" shows some
information about connected BSS and "Tx timeout" error is seen in
dmesg log.

This patch fixes below issues in the code to handle assoc failure
case correctly.
1) "status" variable in mwifiex_wait_queue_complete() is not
correctly updated. Hence driver doesn't inform cfg80211 stack
about association failure.
2) During association network queues are stopped but carrier is
not cleared, which gives Tx timeout error in failure case

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 470ca75..b0fbf5d 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -54,7 +54,7 @@ int mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
 int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 {
 	bool cancel_flag = false;
-	int status = adapter->cmd_wait_q.status;
+	int status;
 	struct cmd_ctrl_node *cmd_queued;
 
 	if (!adapter->cmd_queued)
@@ -79,6 +79,8 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 		mwifiex_cancel_pending_ioctl(adapter);
 		dev_dbg(adapter->dev, "cmd cancel\n");
 	}
+
+	status = adapter->cmd_wait_q.status;
 	adapter->cmd_wait_q.status = 0;
 
 	return status;
@@ -240,6 +242,8 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 
 		if (!netif_queue_stopped(priv->netdev))
 			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
+		if (netif_carrier_ok(priv->netdev))
+			netif_carrier_off(priv->netdev);
 
 		/* Clear any past association response stored for
 		 * application retrieval */
@@ -271,6 +275,8 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 
 		if (!netif_queue_stopped(priv->netdev))
 			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
+		if (netif_carrier_ok(priv->netdev))
+			netif_carrier_off(priv->netdev);
 
 		if (!ret) {
 			dev_dbg(adapter->dev, "info: network found in scan"
-- 
1.7.0.2

