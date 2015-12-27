Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-134.163.com ([123.125.50.134]:56325 "EHLO m50-134.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbbL0Kqo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Dec 2015 05:46:44 -0500
From: Geliang Tang <geliangtang@163.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] ipw2x00: sdhci-pci: use to_pci_dev()
Date: Sun, 27 Dec 2015 18:46:01 +0800
Message-Id: <896b7d080610c5417a2f09a3bf9d0e20636fcc52.1451211133.git.geliangtang@163.com> (sfid-20151227_114923_480106_6E86998D)
In-Reply-To: <baf4e17c993f197cc31f8a0e5736ee8a558ba44c.1451211133.git.geliangtang@163.com>
References: <baf4e17c993f197cc31f8a0e5736ee8a558ba44c.1451211133.git.geliangtang@163.com>
In-Reply-To: <baf4e17c993f197cc31f8a0e5736ee8a558ba44c.1451211133.git.geliangtang@163.com>
References: <baf4e17c993f197cc31f8a0e5736ee8a558ba44c.1451211133.git.geliangtang@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use to_pci_dev() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 36818c7..121294f 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -3514,7 +3514,7 @@ static void ipw2100_msg_free(struct ipw2100_priv *priv)
 static ssize_t show_pci(struct device *d, struct device_attribute *attr,
 			char *buf)
 {
-	struct pci_dev *pci_dev = container_of(d, struct pci_dev, dev);
+	struct pci_dev *pci_dev = to_pci_dev(d);
 	char *out = buf;
 	int i, j;
 	u32 val;
-- 
2.5.0


