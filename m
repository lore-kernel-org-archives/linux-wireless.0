Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:59876 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1FME2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 00:28:55 -0400
Date: Mon, 13 Jun 2011 09:49:27 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: Fixing NULL pointer dereference
Message-ID: <20110613041915.GA17715@hertz.marvell.com> (sfid-20110613_062901_677225_8D4B8521)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following OOPS was seen when booting with card inserted

 BUG: unable to handle kernel NULL pointer dereference at 0000004c
 IP: [<f8b7718c>] cfg80211_get_drvinfo+0x21/0x115 [cfg80211]
 *pde = 00000000
 Oops: 0000 [#1] SMP
 Modules linked in: iwl3945 iwl_legacy mwifiex_sdio mac80211 11 sdhci_pci sdhci pl2303

'ethtool' on the mwifiex device returned this OOPS as
wiphy_dev() returned NULL.

Adding missing set_wiphy_dev() call to fix the problem.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 660831c..687c1f2 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1288,6 +1288,8 @@ int mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 
 	*(unsigned long *) wdev_priv = (unsigned long) priv;
 
+	set_wiphy_dev(wdev->wiphy, (struct device *) priv->adapter->dev);
+
 	ret = wiphy_register(wdev->wiphy);
 	if (ret < 0) {
 		dev_err(priv->adapter->dev, "%s: registering cfg80211 device\n",
-- 
1.5.4.1

