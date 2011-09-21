Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:56774 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab1IUHOQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 03:14:16 -0400
Date: Wed, 21 Sep 2011 10:13:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] mwifiex: remove unneeded NULL check
Message-ID: <20110921071356.GG4999@elgon.mountain> (sfid-20110921_091421_277361_1A7901D2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We dereference "rate" on the lines before so the checks here are too
late to help.  This function is only called from
mwifiex_dump_station_info() and "rate" is always a non-NULL pointer
so the check can be removed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 215c65a..1df5ef6 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -868,10 +868,10 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 	ret = mwifiex_rate_ioctl_cfg(priv, rate);
 
 	if (!ret) {
-		if (rate && rate->is_rate_auto)
+		if (rate->is_rate_auto)
 			rate->rate = mwifiex_index_to_data_rate(priv->tx_rate,
 							priv->tx_htinfo);
-		else if (rate)
+		else
 			rate->rate = priv->data_rate;
 	} else {
 		ret = -1;
