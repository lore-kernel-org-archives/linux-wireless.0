Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:15539 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaE0Lqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 07:46:32 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 1/7] wil6210: limit MTU
Date: Tue, 27 May 2014 14:45:44 +0300
Message-ID: <1401191150-29037-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140527_134635_760376_5E2855E8)
In-Reply-To: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Obey 802.11 spec that defines max. data size 7920 bytes

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index fdcaeb8..106b6dc 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -32,12 +32,26 @@ static int wil_stop(struct net_device *ndev)
 	return wil_down(wil);
 }
 
+static int wil_change_mtu(struct net_device *ndev, int new_mtu)
+{
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+
+	if (new_mtu < 68 || new_mtu > IEEE80211_MAX_DATA_LEN_DMG)
+		return -EINVAL;
+
+	wil_dbg_misc(wil, "change MTU %d -> %d\n", ndev->mtu, new_mtu);
+	ndev->mtu = new_mtu;
+
+	return 0;
+}
+
 static const struct net_device_ops wil_netdev_ops = {
 	.ndo_open		= wil_open,
 	.ndo_stop		= wil_stop,
 	.ndo_start_xmit		= wil_start_xmit,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_change_mtu		= wil_change_mtu,
 };
 
 static int wil6210_netdev_poll_rx(struct napi_struct *napi, int budget)
-- 
1.9.1

