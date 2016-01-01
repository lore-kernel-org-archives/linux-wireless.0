Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-135.163.com ([123.125.50.135]:58224 "EHLO m50-135.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbcAAMEX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 07:04:23 -0500
From: Geliang Tang <geliangtang@163.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ipw2x00: use to_pci_dev()
Date: Fri,  1 Jan 2016 20:03:43 +0800
Message-Id: <b9596d8ac5e81b9334408de148a810b2931ec4a2.1451649453.git.geliangtang@163.com> (sfid-20160101_130427_431526_707B51D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use to_pci_dev() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
This patch is against net-next tree.

Changes in v2:
 - fix wrong title.
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


