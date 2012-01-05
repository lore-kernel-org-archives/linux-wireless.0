Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sfca-50.vyatta.com ([76.74.103.50]:38169 "EHLO fiji.vyatta.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab2AEStf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 13:49:35 -0500
Message-Id: <20120105184000.346920961@vyatta.com> (sfid-20120105_194940_576115_1C1CAD51)
Date: Thu, 05 Jan 2012 10:39:48 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] ath6kl: make net_device_ops const
References: <20120105183947.295358582@vyatta.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/drivers/net/wireless/ath/ath6kl/main.c	2012-01-05 09:50:35.716589669 -0800
+++ b/drivers/net/wireless/ath/ath6kl/main.c	2012-01-05 09:52:58.906118317 -0800
@@ -1456,7 +1456,7 @@ static struct net_device_stats *ath6kl_g
 	return &ar->net_stats;
 }
 
-static struct net_device_ops ath6kl_netdev_ops = {
+static const struct net_device_ops ath6kl_netdev_ops = {
 	.ndo_open               = ath6kl_open,
 	.ndo_stop               = ath6kl_close,
 	.ndo_start_xmit         = ath6kl_data_tx,


