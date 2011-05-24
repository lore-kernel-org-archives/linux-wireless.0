Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:37360 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1EXAzb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 20:55:31 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: correct the error check used for dev_alloc_name()
Date: Mon, 23 May 2011 18:00:18 -0700
Message-Id: <1306198818-7423-2-git-send-email-bzhao@marvell.com> (sfid-20110524_025536_925361_EE92B4B8)
In-Reply-To: <1306198818-7423-1-git-send-email-bzhao@marvell.com>
References: <1306198818-7423-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

In failure case dev_alloc_name() returns negative errno code.
This patch corrects the check used for handling error path.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index f6db51c..77c104b 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -684,6 +684,7 @@ static struct mwifiex_private *mwifiex_add_interface(
 	struct net_device *dev;
 	struct mwifiex_private *priv;
 	void *mdev_priv;
+	int ret;
 
 	dev = alloc_netdev_mq(sizeof(struct mwifiex_private *), "mlan%d",
 			      ether_setup, 1);
@@ -691,8 +692,11 @@ static struct mwifiex_private *mwifiex_add_interface(
 		dev_err(adapter->dev, "no memory available for netdevice\n");
 		goto error;
 	}
-	if (dev_alloc_name(dev, dev->name)) {
-		dev_err(adapter->dev, "unable to alloc name for netdevice\n");
+
+	ret = dev_alloc_name(dev, dev->name);
+	if (ret < 0) {
+		dev_err(adapter->dev, "unable to alloc dev name '%s': %d\n",
+					dev->name, ret);
 		goto error;
 	}
 
-- 
1.7.0.2

