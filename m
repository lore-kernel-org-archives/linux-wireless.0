Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36034 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbcCRCVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:21:07 -0400
Received: by mail-pf0-f174.google.com with SMTP id u190so146031736pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:21:06 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Geliang Tang <geliangtang@163.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 02/19] ipw2x00: use to_pci_dev()
Date: Fri, 18 Mar 2016 13:20:59 +1100
Message-Id: <e7c973ebdbc2fc49bc7bd9734547ab23bb7ee181.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032111_574353_9C719CAE)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Geliang Tang <geliangtang@163.com>

Use to_pci_dev() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index f93a7f7..717320b 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -3521,7 +3521,7 @@ static void ipw2100_msg_free(struct ipw2100_priv *priv)
 static ssize_t show_pci(struct device *d, struct device_attribute *attr,
 			char *buf)
 {
-	struct pci_dev *pci_dev = container_of(d, struct pci_dev, dev);
+	struct pci_dev *pci_dev = to_pci_dev(d);
 	char *out = buf;
 	int i, j;
 	u32 val;
-- 
2.7.0

