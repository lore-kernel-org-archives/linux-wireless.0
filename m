Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:41029 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1IUHNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 03:13:51 -0400
Date: Wed, 21 Sep 2011 10:13:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] mwifiex: add a kfree() to an error path
Message-ID: <20110921071329.GF4999@elgon.mountain> (sfid-20110921_091356_102203_6BDA7C43)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're not likely to hit this small memory leak, but lets fix it
anyway to keep the static checkers happy.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index eb569fa..215c65a 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -203,6 +203,7 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 		beacon_ie = kmemdup(bss->information_elements,
 					bss->len_beacon_ies, GFP_KERNEL);
 		if (!beacon_ie) {
+			kfree(bss_desc);
 			dev_err(priv->adapter->dev, " failed to alloc beacon_ie\n");
 			return -ENOMEM;
 		}
